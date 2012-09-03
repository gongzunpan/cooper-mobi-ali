using System;
using System.Collections.Generic;
using System.IO.IsolatedStorage;
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
using Cooper.Core;
using Cooper.Core.Models;
using System.Data.Linq;

namespace Cooper.Repositories
{
    public class ChangeLogRepository
    {
        private CooperContext _context;

        public ChangeLogRepository()
        {
            this._context = new CooperContext();
        }

        public List<ChangeLog> GetAllChangeLogByTemp()
        {
            List<ChangeLog> changeLogs = this._context.ChangeLogs
                .Where(o => o.AccountId.Equals(""))
                .ToList();
            return changeLogs;
        }

        public List<ChangeLog> GetAllChangeLog(string tasklistId)
        {
            List<ChangeLog> changeLogs = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                changeLogs = this._context.ChangeLogs
                    .Where(o => o.AccountId.Equals(username)
                        && o.TasklistId.Equals(tasklistId))
                    .ToList();
            }
            else
            {
                changeLogs = this._context.ChangeLogs
                    .Where(o => o.AccountId.Equals("")
                        && o.TasklistId.Equals(tasklistId))
                    .ToList();
            }
            return changeLogs;
        }

        public void UpdateTasklistIdByNewId(string oldId, string newId)
        {
            List<ChangeLog> changeLogs = this.GetAllChangeLog(oldId);
            foreach (var changeLog in changeLogs)
            {
                changeLog.TasklistId = newId;
            }
            if (changeLogs.Count > 0)
            {
                this.DBContextSubmitChanges();
            }
        }

        public void UpdateAllToSend(string tasklistId)
        {
            List<ChangeLog> changeLogs = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                changeLogs = this._context.ChangeLogs
                    .Where(o => o.AccountId.Equals(username)
                        && o.TasklistId.Equals(tasklistId))
                    .ToList();
            }
            else
            {
                changeLogs = this._context.ChangeLogs
                    .Where(o => o.AccountId.Equals("")
                        && o.TasklistId.Equals(tasklistId))
                    .ToList();
            }
            if (changeLogs.Count > 0)
            {
                this._context.ChangeLogs.DeleteAllOnSubmit<ChangeLog>(changeLogs);
                this.DBContextSubmitChanges();
            }
        }

        public void AddChangeLog(string type, string taskId, string name, string value, string tasklistId)
        {
            ChangeLog changeLog = new ChangeLog();
            changeLog.ChangeType = type;
            changeLog.DataId = taskId;
            changeLog.Name = name;
            changeLog.Value = value;
            changeLog.IsSend = false;
            changeLog.TasklistId = tasklistId;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                changeLog.AccountId = username;
            }
            else
            {
                changeLog.AccountId = "";
            }
            this._context.ChangeLogs.InsertOnSubmit(changeLog);
            this.DBContextSubmitChanges();
        }

        public void UpdateChangeLogs(List<ChangeLog> changeLogs)
        {
            this.DBContextSubmitChanges();
        }

        private void DBContextSubmitChanges()
        {
            try
            {
                this._context.SubmitChanges(System.Data.Linq.ConflictMode.ContinueOnConflict);
            }
            catch (System.Data.Linq.ChangeConflictException ex)
            {
                this._context.ChangeConflicts.ResolveAll(RefreshMode.KeepCurrentValues);  //保持当前的值
                this._context.ChangeConflicts.ResolveAll(RefreshMode.OverwriteCurrentValues);//保持原来的更新,放弃了当前的值.
                this._context.ChangeConflicts.ResolveAll(RefreshMode.KeepChanges);//保存原来的值 有冲突的话保存当前版本

                // 注意：解决完冲突后还得 SubmitChanges() 一次，不然一样是没有更新到数据库的
                this._context.SubmitChanges();
            }
        }
    }
}
