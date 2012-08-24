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
using Cooper.Core;
using System.IO;
using System.Collections.Generic;

namespace Cooper.Services
{
    public class AccountService : WebRequestWrapper
    {
        /// <summary>
        /// Ark登录
        /// </summary>
        /// <param name="domain"></param>
        /// <param name="username"></param>
        /// <param name="password"></param>
        /// <param name="successCallback"></param>
        /// <param name="failCallback"></param>
        public void Login(string domain
            , string username
            , string password
            , Action<string> successCallback
            , Action<Exception> failCallback)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("cbDomain", domain);
            dict.Add("tbLoginName", username);
            dict.Add("tbPassword", password);
            this.UploadString(Constant.LOGIN_URL, dict, successCallback, failCallback);

            #region 过时
            //var request = HttpWebRequest.CreateHttp(Constant.LOGIN_URL);
            //request.Method = "POST";
            //string resultString = string.Empty;
            //request.BeginGetResponse((IAsyncResult result) =>
            //{
            //    var webRequest = result.AsyncState as HttpWebRequest;
            //    var webResponse = (HttpWebResponse)webRequest.EndGetResponse(result);
            //    using (Stream streamResult = webResponse.GetResponseStream())
            //    {
            //        using (StreamReader reader = new StreamReader(streamResult))
            //        {
            //            //获取的返回值
            //            resultString = reader.ReadToEnd();
            //        }
            //    }
            //}, request);
            //return resultString;
            #endregion
        }
        /// <summary>
        /// 用户注销
        /// </summary>
        /// <param name="successCallback"></param>
        /// <param name="failCallback"></param>
        public void Logout(Action<string> successCallback
            , Action<Exception> failCallback)
        {
            this.UploadString(Constant.LOGOUT_URL, new Dictionary<string, string>(), successCallback, failCallback);
        }
    }
}
