using System;
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

namespace Cooper.Core
{
    public abstract class WebRequestWrapper
    {
        public static CookieContainer cookieContainer;

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
            , Action<HttpWebResponse> action
            , Action<Exception> failed)
        {
            var data = string.Format("_={0}"
                , DateTime.Now.ToString("yyyyMMddHHmmss"));
            queries.ToList().ForEach(o => data += "&" + o.Key + "=" + HttpUtility.UrlEncode(o.Value));
            HttpWebRequest request = HttpWebRequest.Create(new Uri(url)) as HttpWebRequest;
            request.Method = "POST";
            request.ContentType = "application/x-www-form-urlencoded";
            if (cookieContainer == null)
            {
                if (IsolatedStorageSettings.ApplicationSettings.Contains("cookies"))
                {
                    cookieContainer = (CookieContainer)IsolatedStorageSettings.ApplicationSettings["cookies"];
                }
                else
                {
                    cookieContainer = new CookieContainer();
                    IsolatedStorageSettings.ApplicationSettings.Add("cookies", cookieContainer);
                    IsolatedStorageSettings.ApplicationSettings.Save();
                }
            }
            request.CookieContainer = cookieContainer;
            request.Headers["X-Requested-With"] = "xmlhttp";
            //request.AllowReadStreamBuffering = true;

            request.BeginGetRequestStream(result =>
            {
                //var request1 = result.AsyncState as HttpWebRequest;

                using (var postStream = new StreamWriter(request.EndGetRequestStream(result)))
                {
                    postStream.Write(data);
                }
                request.BeginGetResponse(result1 =>
                {
                    try
                    {
                        //var req1 = result.AsyncState as HttpWebRequest;
                        HttpWebResponse response = request.EndGetResponse(result1) as HttpWebResponse;
                        var cookies2 = response.Cookies;
                        var c = response.Headers["Set-Cookie"];
                        IsolatedStorageSettings.ApplicationSettings["cookies"] = request.CookieContainer;
                        IsolatedStorageSettings.ApplicationSettings.Save();

                        var cookies = cookieContainer.GetCookies(request.RequestUri);
                        if (response != null)
                            Deployment.Current.Dispatcher.BeginInvoke(action, response);
                        else
                            Deployment.Current.Dispatcher.BeginInvoke(failed, new Exception("response返回为空！"));
                    }
                    catch (Exception exception)
                    {
                        //异常处理
                        Deployment.Current.Dispatcher.BeginInvoke(failed, exception);
                    }
                }, request);
            }, request);
        }
    }
}
