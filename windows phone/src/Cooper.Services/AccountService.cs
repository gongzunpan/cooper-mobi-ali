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
using MyToolkit.Networking;
using System.Text;
using Hammock;
using SBHTTPSClient;

namespace Cooper.Services
{
    public class AccountService : WebRequestWrapper
    {
        /// <summary>
        /// Ark登录
        /// </summary>
        /// <param name="domain">域</param>
        /// <param name="username">用户名</param>
        /// <param name="password">密码</param>
        /// <param name="successCallback"></param>
        /// <param name="failCallback"></param>
        public void Login(string domain
            , string username
            , string password
            , Action<TElHTTPSClient, string, object> successCallback
            , Action<Exception> failCallback
            , object userState)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("cbDomain", domain);
            dict.Add("tbLoginName", username);
            dict.Add("tbPassword", password);
            dict.Add("state", "login");

            RequestManager requestManager = new RequestManager();
            requestManager.Post(Constant.LOGIN_URL, dict, successCallback, failCallback, userState);

            //this.UploadString(Constant.LOGIN_URL, dict, successCallback, failCallback, userState);
        }
        /// <summary>
        /// 普通登录
        /// </summary>
        /// <param name="username">用户名</param>
        /// <param name="password">密码</param>
        /// <param name="successCallback"></param>
        /// <param name="failCallback"></param>
        public void Login(string username
            , string password
            , Action<RestResponse, object> successCallback
            , Action<Exception> failCallback
            , object userState)
        {
            var dict = new Dictionary<string, string>();
            dict.Add("userName", username);
            dict.Add("password", password);

            this.UploadString(Constant.LOGIN_URL, dict, successCallback, failCallback, userState);
        }
        /// <summary>
        /// 用户注销
        /// </summary>
        /// <param name="successCallback"></param>
        /// <param name="failCallback"></param>
        public void Logout(Action<TElHTTPSClient, string, object> successCallback
            , Action<Exception> failCallback)
        {
            RequestManager requestManager = new RequestManager();
            requestManager.Post(Constant.LOGOUT_URL, new Dictionary<string, string>(), successCallback, failCallback, new Dictionary<string, object>());

            //this.UploadString(Constant.LOGOUT_URL
            //    , new Dictionary<string, string>()
            //    , successCallback
            //    , failCallback
            //    , new Dictionary<string, object>());
        }
    }
}
