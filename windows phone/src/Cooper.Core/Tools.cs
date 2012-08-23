using System;
using System.Linq;
using System.Net;
using Microsoft.Phone.Controls;

using System.Windows.Navigation;
using Microsoft.Phone.Net.NetworkInformation;
using System.Threading;
using System.Windows;

namespace Cooper.Core
{
    /// <summary>
    /// 辅助工具类
    /// </summary>
    public class Tools
    {
        /// <summary>
        /// 是否连接网络
        /// </summary>
        /// <returns></returns>
        public static bool IsOnline()
        {
            var interfaceList = new NetworkInterfaceList();
            var interfaceInfo = interfaceList.First();

            bool connected = interfaceInfo.InterfaceState == ConnectState.Connected;
            return connected;
        }
    }
}
