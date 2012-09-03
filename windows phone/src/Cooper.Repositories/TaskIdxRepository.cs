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
using System.Collections;
using Newtonsoft.Json.Linq;
using System.Data.Linq;

namespace Cooper.Repositories
{
    public class TaskIdxRepository
    {
        private CooperContext _context;

        public TaskIdxRepository()
        {
            this._context = new CooperContext();
        }

        public List<TaskIdx> GetAllTaskIdxByTemp()
        {
            List<TaskIdx> taskIdxs = this._context.TaskIdxs
                .Where(o => o.AccountId.Equals(""))
                .ToList();
            return taskIdxs;
        }

        public List<TaskIdx> GetAllTaskIdx(string tasklistId)
        {
            List<TaskIdx> taskIdxs = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                taskIdxs = this._context.TaskIdxs
                    .Where(o => o.AccountId.Equals(username)
                        && o.TasklistId.Equals(tasklistId))
                    .ToList();
            }
            else
            {
                taskIdxs = this._context.TaskIdxs
                    .Where(o => o.AccountId.Equals("")
                        && o.TasklistId.Equals(tasklistId))
                    .ToList();
            }
            return taskIdxs;
        }

        public void UpdateTaskIdxByNewId(string oldId, string newId, string tasklistId)
        {
            List<TaskIdx> taskIdxs = this.GetAllTaskIdx(tasklistId);
            foreach (var taskIdx in taskIdxs)
            {
                JArray sIndexesArray = (JArray)taskIdx.Indexes.ToJSONObject();
                int i = 0;
                for (int index = 0; index < sIndexesArray.Count; index++)
                {
                    string taskId = sIndexesArray[index].Value<string>();
                    if (taskId == oldId)
                    {
                        sIndexesArray[i] = newId;
                        break;
                    }
                    i++;
                }
                taskIdx.Indexes = sIndexesArray.ToJSONString();
            }
            this.DBContextSubmitChanges();
        }

        public void DeleteAll(string tasklistId)
        {
            List<TaskIdx> taskIdxs = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                taskIdxs = this._context.TaskIdxs
                    .Where(o => o.AccountId.Equals(username)
                        && o.TasklistId.Equals(tasklistId))
                        .ToList();
            }
            else
            {
                taskIdxs = this._context.TaskIdxs
                    .Where(o => o.AccountId.Equals("")
                        && o.TasklistId.Equals(tasklistId))
                        .ToList();
            }
            this._context.TaskIdxs.DeleteAllOnSubmit(taskIdxs);
            this.DBContextSubmitChanges();
        }

        public void UpdateTasklistIdByNewId(string oldId, string newId)
        {
            List<TaskIdx> taskIdxs = this.GetAllTaskIdx(oldId);
            foreach (var taskIdx in taskIdxs)
            {
                taskIdx.TasklistId = newId;
            }
            if (taskIdxs.Count > 0)
            {
                this.DBContextSubmitChanges();
            }
        }

        public void AddTaskIdxs(List<TaskIdx> taskIdxs)
        {
            this._context.TaskIdxs.InsertAllOnSubmit<TaskIdx>(taskIdxs);
            this.DBContextSubmitChanges();
        }

        public void AddTaskIdx(string taskId, string key, string tasklistId)
        {
            List<TaskIdx> taskIdxs = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                taskIdxs = this._context.TaskIdxs
                    .Where(o => o.Key.Equals(key)
                        && o.TasklistId.Equals(tasklistId)
                        && o.AccountId.Equals(username))
                    .ToList();
            }
            else
            {
                taskIdxs = this._context.TaskIdxs
                    .Where(o => o.Key.Equals(key)
                        && o.TasklistId.Equals(tasklistId)
                        && o.AccountId.Equals(""))
                    .ToList();
            }

            TaskIdx taskIdx = null;
            JArray indexesArray = null;
            if (taskIdxs == null || (taskIdxs != null && taskIdxs.Count == 0))
            {
                taskIdx = new TaskIdx();
                taskIdx.By = "priority";
                taskIdx.Key = key;
                taskIdx.Name = key == "0" ? Constant.PRIORITY_TITLE_1 : (key == "1"
                    ? Constant.PRIORITY_TITLE_2 : Constant.PRIORITY_TITLE_3);
                if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
                {
                    string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                    taskIdx.AccountId = username;
                }
                else
                {
                    taskIdx.AccountId = "";
                }
                indexesArray = new JArray();
            }
            else
            {
                taskIdx = taskIdxs[0];
                if (string.IsNullOrEmpty(taskIdx.Indexes))
                {
                    indexesArray = new JArray();
                }
                else
                {
                    indexesArray = (JArray)taskIdx.Indexes.ToJSONObject();
                }
            }
            indexesArray.Add(taskId);
            taskIdx.Indexes = indexesArray.ToJSONString();
            taskIdx.TasklistId = tasklistId;

            if (taskIdxs == null || (taskIdxs != null && taskIdxs.Count == 0))
            {
                this._context.TaskIdxs.InsertOnSubmit(taskIdx);
            }
            this.DBContextSubmitChanges();
        }

        public void UpdateTaskIdx(string taskId, string key, string tasklistId)
        {
            List<TaskIdx> taskIdxs = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                taskIdxs = this._context.TaskIdxs
                    .Where(o => o.TasklistId.Equals(tasklistId)
                        && o.AccountId.Equals(username))
                    .ToList();
            }
            else
            {
                taskIdxs = this._context.TaskIdxs
                    .Where(o => o.TasklistId.Equals(tasklistId)
                        && o.AccountId.Equals(""))
                    .ToList();
            }

            if (taskIdxs != null)
            {
                foreach (var taskIdx in taskIdxs)
                {
                    JArray indexesArray = null;
                    JArray newIndexesArray = null;
                    indexesArray = (JArray)taskIdx.Indexes.ToJSONObject();
                    newIndexesArray = new JArray();
                    for (int i = 0; i < indexesArray.Count; i++)
                    {
                        string currentTaskId = indexesArray[i].Value<string>();
                        if (!currentTaskId.Equals(taskId))
                        {
                            newIndexesArray.Add(currentTaskId);
                        }
                    }
                    if (taskIdx.Key.Equals(key))
                    {
                        newIndexesArray.Add(taskId);
                    }
                    taskIdx.Indexes = newIndexesArray.ToJSONString();
                }

                if (taskIdxs.Count > 0)
                {
                    this.DBContextSubmitChanges();
                }
            }
        }

        public void DeleteTaskIndexesByTaskId(string taskId, string tasklistId)
        {
            List<TaskIdx> taskIdxs = null;
            if (IsolatedStorageSettings.ApplicationSettings.Contains(Constant.USERNAME_KEY))
            {
                string username = IsolatedStorageSettings.ApplicationSettings[Constant.USERNAME_KEY] as string;
                taskIdxs = this._context.TaskIdxs
                    .Where(o => o.TasklistId.Equals(tasklistId)
                        && o.AccountId.Equals(username))
                    .ToList();
            }
            else
            {
                taskIdxs = this._context.TaskIdxs
                    .Where(o => o.TasklistId.Equals(tasklistId)
                        && o.AccountId.Equals(""))
                    .ToList();
            }

            if (taskIdxs != null)
            {
                foreach (var taskIdx in taskIdxs)
                {
                    JArray indexesArray = null;
                    JArray newIndexesArray = null;
                    indexesArray = (JArray)taskIdx.Indexes.ToJSONObject();
                    newIndexesArray = new JArray();
                    for (int i = 0; i < indexesArray.Count; i++)
                    {
                        string currentTaskId = indexesArray[i].Value<string>();
                        if (!currentTaskId.Equals(taskId))
                        {
                            newIndexesArray.Add(currentTaskId);
                        }
                    }

                    if (newIndexesArray != null)
                    {
                        taskIdx.Indexes = newIndexesArray.ToJSONString();
                    }
                }

                if (taskIdxs.Count > 0)
                {
                    this.DBContextSubmitChanges();
                }
            }
        }

        public void UpdateTaskIdxs(List<TaskIdx> taskIdxs)
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
