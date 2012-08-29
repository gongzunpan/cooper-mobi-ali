﻿using System;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Net.Browser;
using System.IO.IsolatedStorage;
using Hammock;
using Hammock.Web;
using HashTable = System.Collections.Generic.Dictionary<object, object>;
using ArrayList = System.Collections.Generic.List<object>;

namespace Cooper.Core
{
    public abstract class WebRequestWrapper
    {
        /// <summary>
        /// 上传数据
        /// </summary>
        /// <param name="url"></param>
        /// <param name="service"></param>
        /// <param name="queries"></param>
        /// <param name="action"></param>
        /// <param name="failed"></param>
        protected void UploadString(string url
            , IDictionary<string, string> queries
            , Action<RestResponse> action
            , Action<Exception> failed)
        {
            bool httpResult = HttpWebRequest.RegisterPrefix("http://", WebRequestCreator.ClientHttp);
            RestClient client = new RestClient();
            client.Method = WebMethod.Post;
            queries.ToList().ForEach(o => client.AddParameter(o.Key, HttpUtility.UrlEncode(o.Value)));
            client.AddHeader("X-Requested-With", "xmlhttp");

            client.Authority = url;
            RestRequest restRequest = new RestRequest();

            CookieContainer cookieContainer = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains("cookies"))
            {
                cookieContainer = IsolatedStorageSettings.ApplicationSettings["cookies"] as CookieContainer;
            }
            else
            {
                cookieContainer = new CookieContainer();
            }

            restRequest.CookieContainer = cookieContainer;
            client.BeginRequest(restRequest, (request, response, userState) =>
                {
                    cookieContainer = response.CookieContainer;
                    IsolatedStorageSettings.ApplicationSettings["cookies"] = cookieContainer;
                    IsolatedStorageSettings.ApplicationSettings.Save();

                    if (response != null)
                        Deployment.Current.Dispatcher.BeginInvoke(action, response);
                    else
                        Deployment.Current.Dispatcher.BeginInvoke(failed, new Exception("response返回为空！"));
                });
        }

        private void BugFix_CookieDomain(CookieContainer cookieContainer)
        {
            System.Type _ContainerType = typeof(CookieContainer);
            HashTable table = (HashTable)_ContainerType.InvokeMember("m_domainTable",
                                       System.Reflection.BindingFlags.NonPublic |
                                       System.Reflection.BindingFlags.GetField |
                                       System.Reflection.BindingFlags.Instance,
                                       null,
                                       cookieContainer,
                                       new object[] { });
            ArrayList keys = new ArrayList(table.Keys);
            foreach (string keyObj in keys)
            {
                string key = (keyObj as string);
                if (key[0] == '.')
                {
                    string newKey = key.Remove(0, 1);
                    table[newKey] = table[keyObj];
                }
            }
        }
    }
}
