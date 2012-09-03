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
using Cooper.Core;
using Cooper.Core.Models;
using System.IO.IsolatedStorage;
using System.Data.Linq;

namespace Cooper.Repositories
{
    public class TasklistRepository
    {
        private CooperContext _context;

        public TasklistRepository()
        {
            this._context = new CooperContext();
        }

        public List<Tasklist> GetAllTasklistByUserAndTemp()
        {
            List<Tasklist> tasklists = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                tasklists = this._context.Tasklists.Where(o => o.TasklistId.IndexOf("temp_") >= 0
                    && o.AccountId.Equals(username))
                    .OrderBy(o => o.TasklistId)
                    .ToList();
            }
            else
            {
                tasklists = this._context.Tasklists.Where(o => o.TasklistId.IndexOf("temp_") >= 0
                    && string.IsNullOrEmpty(o.AccountId))
                    .OrderBy(o => o.TasklistId)
                    .ToList();
            }
            return tasklists;
        }

        public List<Tasklist> GetAllTasklistByTemp()
        {
            List<Tasklist> tasklists = this._context.Tasklists
                .Where(o => o.TasklistId.IndexOf("temp_") >= 0
                    && o.AccountId.Equals(""))
                    .ToList();
            return tasklists;
        }

        public List<Tasklist> GetAllTasklist()
        {
            List<Tasklist> tasklists = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                tasklists = this._context.Tasklists.Where(o => o.AccountId.Equals(username))
                    .OrderBy(o => o.TasklistId)
                    .ToList();
            }
            else
            {
                tasklists = this._context.Tasklists.Where(o => o.AccountId.Equals(""))
                    .OrderBy(o => o.TasklistId)
                    .ToList();
            }
            return tasklists;
        }

        public Tasklist GetTasklistById(string tasklistId)
        {
            Tasklist tasklist = null;
            List<Tasklist> tasklists = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                tasklists = this._context.Tasklists.Where(o => o.AccountId.Equals(username)
                    && o.TasklistId.Equals(tasklistId))
                    .ToList();
            }
            else
            {
                tasklists = this._context.Tasklists.Where(o => o.AccountId.Equals("")
                   && o.TasklistId.Equals(tasklistId))
                   .ToList();
            }
            if (tasklists != null && tasklists.Count > 0)
            {
                tasklist = tasklists[0];
            }
            return tasklist;
        }

        public void UpdateTasklistByNewId(string oldId, string newId)
        {
            Tasklist tasklist = this.GetTasklistById(oldId);
            if (tasklist != null)
            {
                tasklist.TasklistId = newId;
                this.DBContextSubmitChanges();
            }
        }

        public void DeleteAll()
        {
            List<Tasklist> tasklists = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                tasklists = this._context.Tasklists.Where(o => o.AccountId.Equals(username)).ToList();
            }
            else
            {
                tasklists = this._context.Tasklists.Where(o => o.AccountId.Equals("")).ToList();
            }
            if (tasklists != null && tasklists.Count > 0)
            {
                this._context.Tasklists.DeleteAllOnSubmit<Tasklist>(tasklists);

                this.DBContextSubmitChanges();
            }   
        }

        public void AddTasklist(Tasklist tasklist)
        {
            this._context.Tasklists.InsertOnSubmit(tasklist);
            this.DBContextSubmitChanges();
        }

        public void AddTasklists(List<Tasklist> tasklists)
        {
            this._context.Tasklists.InsertAllOnSubmit<Tasklist>(tasklists);
            this.DBContextSubmitChanges();
        }

        public void UpdateEditable(int editable, string tasklistId)
        {
            Tasklist tasklist = this.GetTasklistById(tasklistId);
            if (tasklist != null)
            {
                tasklist.Editable = editable == 1;
            }
            this.DBContextSubmitChanges();
        }

        public void UpdateEditable(Tasklist tasklist)
        {
            this.DBContextSubmitChanges();
        }

        public void UpdateTasklists(List<Tasklist> tasklists)
        {
            this.DBContextSubmitChanges();
        }

        public void AdjustWithNewId(string oldId, string newId)
        {
            Tasklist tasklist = null;
            List<Tasklist> tasklists = this._context.Tasklists.Where(o => o.TasklistId.Equals(oldId)).ToList();
            if (tasklists.Count > 0)
            {
                tasklist = tasklists[0];
                tasklist.TasklistId = newId;
            }
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
