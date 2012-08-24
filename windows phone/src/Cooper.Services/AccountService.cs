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

namespace Cooper.Services
{
    public class AccountService
    {
        /// <summary>
        /// Ark登录
        /// </summary>
        /// <param name="domain"></param>
        /// <param name="username"></param>
        /// <param name="password"></param>
        public string Login(string domain, string username, string password)
        {
            var request = HttpWebRequest.CreateHttp(Constant.LOGIN_URL);
            request.Method = "POST";
            string resultString = string.Empty;
            request.BeginGetResponse((IAsyncResult result) =>
            {
                var webRequest = result.AsyncState as HttpWebRequest;
                var webResponse = (HttpWebResponse)webRequest.EndGetResponse(result);
                using (Stream streamResult = webResponse.GetResponseStream())
                {
                    using (StreamReader reader = new StreamReader(streamResult))
                    {
                        //获取的返回值
                        resultString = reader.ReadToEnd();
                    }
                }
            }, request);
            return resultString;
        }
    }
}
