using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using SBHTTPSClient;
using SBStringList;
using SBUtils;
using SBX509;
using System.IO.IsolatedStorage;

namespace Cooper.Core
{
    public class RequestManager
    {
        private TElHTTPSClient _client;
        private Byte[] _responseBodyBuffer;

        public RequestManager()
        {
            //设置试用LicenseKey
            SBUtils.Unit.SetLicenseKey("54CE4292A79672E581523B90B205563EBD126DC0988F1464E14967EEEFD1E67D07CCD5296ECA80C16EE887A9F442D856F7AE08FE85FCE27E5AABC8903A09F44FF99C0236E92063522CD282096595197347C0A4E82DF6556A3397C05395361597132ED517794D18ACDB8D4721B1E0AA4EBE35309E230C6794B35ABCE645E0E12BC9D1B27093587F195E475EA114B246181B403278E69676CB31431C1B42AE17F7F772B709E9BCE983BD1FADB600D8514C9927F18BFA081CA7F5A890708BADB5C7DC96D733975B26A0FE2BEFD4C26C04CE5E04F5288D9430C74ADC094C670AD03005B350E54DFCB974FB775BCEFD9004D55A6393E7430A81B14648D10907AB0716");

            SBHTTPCRL.Unit.RegisterHTTPCRLRetrieverFactory();
            SBHTTPOCSPClient.Unit.RegisterHTTPOCSPClientFactory();

            this._client = new SBHTTPSClient.TElHTTPSClient();
            this._client.PreferKeepAlive = true;
            this._client.SendBufferSize = 65535;
            this._client.SSLEnabled = true;
            this._client.UseCompression = false;

            this._client.OnPreparedHeaders += new SBHTTPSClient.TSBHTTPHeadersEvent(this.HTTPSClient_OnPreparedHeaders);
            this._client.OnSendData += new SBSSLCommon.TSBDataEvent(HTTPSClient_OnSendData);
            this._client.OnRedirection += new SBHTTPSClient.TSBHTTPRedirectionEvent(this.HTTPSClient_OnRedirection);
            this._client.OnReceivingHeaders += new SBHTTPSClient.TSBHTTPHeadersEvent(this.HTTPSClient_OnReceivingHeaders);
            this._client.OnDocumentBegin += new SBUtils.TNotifyEvent(this.HTTPSClient_OnDocumentBegin);
            this._client.OnData += new SBSSLCommon.TSBDataEvent(this.HTTPSClient_OnData);
            this._client.OnDocumentEnd += new SBUtils.TNotifyEvent(this.HTTPSClient_OnDocumentEnd);
            this._client.OnCloseConnection += new SBClient.TSBCloseConnectionEvent(this.HTTPSClient_OnCloseConnection);
            this._client.OnCertificateValidate += new SBSSLCommon.TSBCertificateValidateEvent(this.HTTPSClient_OnCertificateValidate);
        }

        public void Post(string url
            , IDictionary<string, string> queries
            , Action<TElHTTPSClient, string, object> action
            , Action<Exception> failed
            , object userState)
        {
            TElStringList list = new TElStringList();
            queries.ToList().ForEach(o => list.Add(o.Key, o.Value));

            if (IsolatedStorageSettings.ApplicationSettings.Contains("coopercookies"))
            {
                this._client.RequestCookies.Text = IsolatedStorageSettings.ApplicationSettings["coopercookies"].ToString();
            }

            try
            {
                this._client.Post(url, list, null, null, null, "application/x-www-form-urlencoded", true);
                Deployment.Current.Dispatcher.BeginInvoke(action, this._client, System.Text.Encoding.UTF8.GetString(this._responseBodyBuffer, 0, this._responseBodyBuffer.Length), userState);
            }
            catch (Exception exception)
            {
                Deployment.Current.Dispatcher.BeginInvoke(failed, exception);
            }
        }

        private void HTTPSClient_OnPreparedHeaders(object Sender, SBStringList.TElStringList Headers)
        {
            //string s = Environment.NewLine + "Sending headers: " + Environment.NewLine + Headers.Text + Environment.NewLine;
        }
        private void HTTPSClient_OnSendData(object Sender, byte[] Buffer)
        {
            //string s = System.Text.Encoding.UTF8.GetString(Buffer, 0, Buffer.Length);
        }
        private void HTTPSClient_OnRedirection(object Sender, string OldURL, string NewURL, ref TSBBoolean AllowRedirection)
        {
            //string s = Environment.NewLine + "Redirected to " + NewURL + Environment.NewLine;
            AllowRedirection = true;
        }
        private void HTTPSClient_OnReceivingHeaders(object Sender, SBStringList.TElStringList Headers)
        {
            //string s = Environment.NewLine + "Received headers: " + Environment.NewLine + Headers.Text + Environment.NewLine;
        }
        private void HTTPSClient_OnDocumentBegin(object Sender)
        {
            //string s = Environment.NewLine + "-- Document started --" + Environment.NewLine;
        }
        void HTTPSClient_OnData(object Sender, byte[] Buffer)
        {
            this._responseBodyBuffer = Buffer;

            //string s = System.Text.Encoding.UTF8.GetString(Buffer, 0, Buffer.Length);
        }
        private void HTTPSClient_OnDocumentEnd(object Sender)
        {
            //string s = Environment.NewLine + "-- Document finished --" + Environment.NewLine;
        }
        private void HTTPSClient_OnCloseConnection(object Sender, SBClient.TSBCloseReason CloseReason)
        {
            //string s = Environment.NewLine + "-- Connection closed --" + Environment.NewLine;
        }
        private void HTTPSClient_OnCertificateValidate(object Sender, TElX509Certificate X509Certificate, ref TSBBoolean Validate)
        {
            Validate = true;
        }
    }
}
