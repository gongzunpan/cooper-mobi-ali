using System;
using System.Collections.Generic;
using System.IO;
using System.IO.IsolatedStorage;
using System.Net;
using System.Runtime.Serialization;
using Cooper.Core;
using Cooper.Services;
using Newtonsoft.Json;
using WP7CordovaClassLib.Cordova;
using WP7CordovaClassLib.Cordova.Commands;
using WP7CordovaClassLib.Cordova.JSON;

namespace Cordova.Extension.Commands
{
    /// <summary>
    /// Cooper-Phonegap插件
    /// </summary>
    public class CooperPlugin : BaseCommand
    {
        #region JSON实例类

        /// <summary>
        /// 结果
        /// </summary>
        public class ResultCode
        {
            [JsonProperty(Required = Required.Default
                , PropertyName = "status")]
            public bool Status;

            [JsonProperty(Required = Required.AllowNull
                , PropertyName = "data"
                , DefaultValueHandling = DefaultValueHandling.IgnoreAndPopulate)]
            public object Data;

            [JsonProperty(Required = Required.AllowNull
                , PropertyName = "message"
                , DefaultValueHandling = DefaultValueHandling.IgnoreAndPopulate)]
            public string Message;
        }
        /// <summary>
        /// 用户信息
        /// </summary>
        public class UserInfo
        {
            [JsonProperty(Required = Required.Default
                , PropertyName = "username")]
            public string Username;
        }

        ///////////////////////////////////////////////////////////////////////////////////////////////

        [DataContract]
        public class SignKeyOptions
        {
            [DataMember(IsRequired = true, Name = "key")]
            public string Key;
        }
        [DataContract]
        public class LoginOptions : SignKeyOptions
        {
            [DataMember(IsRequired = false, Name = "type")]
            public string Type;

            [DataMember(IsRequired = false, Name = "domain")]
            public string Domain;

            [DataMember(IsRequired = false, Name = "username")]
            public string Username;

            [DataMember(IsRequired = false, Name = "password")]
            public string Password;
        }
        [DataContract]
        public class SyncTasklistsOptions : SignKeyOptions
        {
            [DataMember(IsRequired = false, Name = "tasklistId")]
            public string TasklistId;
        }
        #endregion

        //控制台输出
        private DebugConsole _console = new DebugConsole();

        private AccountService _accountService;
        private TasklistService _tasklistService;

        public CooperPlugin()
        {
            this._accountService = new AccountService();
            this._tasklistService = new TasklistService();
        }

        /// <summary>
        /// 刷新，与服务端交互
        /// </summary>
        /// <param name="options">条件</param>
        public void refresh(string options)
        {
            ResultCode resultCode = new ResultCode();

            var keyOptions = JsonHelper.Deserialize<SignKeyOptions>(options);
            if (keyOptions.Key.Equals(Constant.LOGIN))
            {
                var loginOptions = JsonHelper.Deserialize<LoginOptions>(options);
                if (string.IsNullOrEmpty(loginOptions.Type))
                {
                    resultCode.Status = false;
                    resultCode.Message = "type不能为空!";

                    this.DispatchCommandResult(resultCode);
                }
                else if (!loginOptions.Type.Equals(Constant.ANONYMOUS)
                    && !loginOptions.Type.Equals(Constant.NORMAL))
                {
                    resultCode.Status = true;
                    resultCode.Message = "type参数必须为anonymous或normal";

                    this.DispatchCommandResult(resultCode);
                }
                else
                {
                    if (loginOptions.Type.Equals(Constant.ANONYMOUS))
                    {
                        #region 跳过登录
                        IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] = "";
                        IsolatedStorageSettings.ApplicationSettings[Constant.ISGUESTUSER_KEY] = true;

                        resultCode.Status = true;

                        this.DispatchCommandResult(resultCode);
                        #endregion
                    }
                    else
                    {
                        #region 登录
                        string domain = loginOptions.Domain;
                        string username = loginOptions.Username;
                        string password = loginOptions.Password;

                        if (string.IsNullOrEmpty(domain))
                        {
                            this._accountService.Login(username
                                , password
                                , response =>
                                {
                                    if (response.StatusCode == HttpStatusCode.OK)
                                    {
                                        var responseString = this.GetResponseString(response);
                                        this._console.log(string.Format("登录response返回的字符串:{0}"
                                            , responseString));
                                        IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] = username;
                                        IsolatedStorageSettings.ApplicationSettings[Constant.ISGUESTUSER_KEY] = false;
                                        IsolatedStorageSettings.ApplicationSettings.Save();

                                        resultCode.Status = true;
                                        resultCode.Data = true;

                                        this.DispatchCommandResult(resultCode);
                                    }
                                    else
                                    {
                                        this.DispatchCommandResult(response);
                                    }
                                }
                                , exception =>
                                {
                                    this.DispatchCommandResult(exception);
                                });
                        }
                        else
                        {
                            this._accountService.Login(domain
                                , username
                                , password
                                , response =>
                                {
                                    if (response.StatusCode == HttpStatusCode.OK)
                                    {
                                        var responseString = this.GetResponseString(response);
                                        this._console.log(string.Format("登录response返回的字符串:{0}"
                                            , responseString));
                                        if (responseString.IndexOf("window.opener.loginSuccess") >= 0)
                                        {
                                            IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] = username;
                                            IsolatedStorageSettings.ApplicationSettings[Constant.ISGUESTUSER_KEY] = false;
                                            IsolatedStorageSettings.ApplicationSettings.Save();

                                            resultCode.Status = true;
                                            resultCode.Data = true;

                                            this.DispatchCommandResult(resultCode);
                                        }
                                        else
                                        {
                                            this.DispatchCommandResult(response);
                                        }
                                    }
                                    else
                                    {
                                        this.DispatchCommandResult(response);
                                    }
                                }
                                , exception => 
                                {
                                    this.DispatchCommandResult(exception);
                                });
                        }
                        #endregion
                    }
                }
            }
            else if (keyOptions.Key.Equals(Constant.LOGOUT))
            {
                #region 注销
                this._accountService.Logout(response =>
                    {
                        if (response.StatusCode == HttpStatusCode.OK)
                        {
                            IsolatedStorageSettings.ApplicationSettings.Remove(Constant.DOMAIN);
                            IsolatedStorageSettings.ApplicationSettings.Remove(Constant.USERNAME_KEY);
                            IsolatedStorageSettings.ApplicationSettings.Remove(Constant.ISGUESTUSER_KEY);
                        }
                        else
                        {
                            this.DispatchCommandResult(response);
                        }
                    }
                , exception =>
                    {
                        this.DispatchCommandResult(exception);
                    });
                #endregion
            }
            else if (keyOptions.Key.Equals(Constant.SYNCTASKLISTS))
            {
                #region 同步任务列表
                var isGuestUser = (bool)IsolatedStorageSettings.ApplicationSettings[Constant.ISGUESTUSER_KEY];
                if (isGuestUser)
                {
                    resultCode.Status = false;
                    resultCode.Message = "匿名用户不能同步任务";
                }
                else
                {
                    var synctasklistOptions = JsonHelper.Deserialize<SyncTasklistsOptions>(options);
                    if (string.IsNullOrEmpty(synctasklistOptions.TasklistId))
                    {
                        this._tasklistService.GetTasklists(response =>
                            {
                                if (response.StatusCode == HttpStatusCode.OK)
                                {
                                    var responseString = this.GetResponseString(response);
                                    this._console.log(string.Format("GetTasklists response返回的字符串:{0}"
                                        , responseString));
                                }
                                else
                                {
                                    this.DispatchCommandResult(response);
                                }
                            }
                        , exception =>
                            {
                                this.DispatchCommandResult(exception);
                            });
                    }
                }
                #endregion
            }
            
            this._console.log("Native返回的JS端数据：");
        }
        /// <summary>
        /// 获取
        /// </summary>
        /// <param name="options"条件></param>
        public void get(string options)
        {
            ResultCode resultCode = new ResultCode();

            SignKeyOptions keyOptions = JsonHelper.Deserialize<SignKeyOptions>(options);
            if (keyOptions.Key.Equals(Constant.GETNETWORKSTATUS))
            {
                #region 是否连接网络
                bool isOnline = Tools.IsOnline();
                resultCode.Status = true;
                resultCode.Data = isOnline;

                this.DispatchCommandResult(resultCode);
                #endregion
            }
            else if (keyOptions.Key.Equals(Constant.GETCURRENTUSER))
            {
                #region 获取当前用户名  
                string username = "";
                if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
                {
                    username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY].ToString();
                }

                var userInfo = new UserInfo();
                userInfo.Username = username;
                resultCode.Data = userInfo;
                resultCode.Status = true;

                this.DispatchCommandResult(resultCode);
                #endregion
            }
        }
        /// <summary>
        /// 保存
        /// </summary>
        /// <param name="options">条件</param>
        public void save(string options)
        {
            SignKeyOptions keyOptions = JsonHelper.Deserialize<SignKeyOptions>(options);
        }
        /// <summary>
        /// 调试
        /// </summary>
        /// <param name="options">条件</param>
        public void debug(string options)
        {
            this._console.log(options);
        }

        private void DispatchCommandResult(ResultCode resultCode)
        {
            this.DispatchCommandResult(new PluginResult(PluginResult.Status.OK) { Message = resultCode.ToJSONString() });
        }
        private void DispatchCommandResult(HttpWebResponse response)
        {
            ResultCode resultCode = new ResultCode();
            resultCode.Status = false;
            resultCode.Message = string.Format("错误验证码:{0},错误消息:{1}"
                , response.StatusCode
                , response.StatusDescription);
            DispatchCommandResult(new PluginResult(PluginResult.Status.OK, resultCode));
        }
        private void DispatchCommandResult(Exception exception)
        {
            ResultCode resultCode = new ResultCode();
            resultCode.Status = false;
            resultCode.Message = string.Format("异常日志:{0}"
                , exception.ToString());
            DispatchCommandResult(new PluginResult(PluginResult.Status.OK, resultCode));
        }
        private string GetResponseString(HttpWebResponse response)
        {
            using(Stream responseStream = response.GetResponseStream())
                using (StreamReader sr = new StreamReader(responseStream))
                {
                    string responseString = sr.ReadToEnd();
                    Console.WriteLine(responseString);
                    return responseString;
                }
        }
    }
}
