using System.Runtime.Serialization;
using WP7CordovaClassLib.Cordova;
using WP7CordovaClassLib.Cordova.Commands;
using WP7CordovaClassLib.Cordova.JSON;


namespace Cordova.Extension.Commands
{
    public class CooperPlugin : BaseCommand
    {
        //控制台输出
        private DebugConsole _console = new DebugConsole();

        /// <summary>
        /// 刷新，与服务端交互
        /// </summary>
        /// <param name="options">条件</param>
        public void refresh(string options)
        {
        }
        /// <summary>
        /// 获取
        /// </summary>
        /// <param name="options"条件></param>
        public void get(string options)
        {
        }
        /// <summary>
        /// 保存
        /// </summary>
        /// <param name="options">条件</param>
        public void save(string options)
        {
        }
        /// <summary>
        /// 调试
        /// </summary>
        /// <param name="options">条件</param>
        public void debug(string options)
        {
            this._console.log(options);
        }
    }
}
