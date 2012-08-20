package com.codesharp.cooper;

import android.database.sqlite.SQLiteDatabase;

import java.util.Map;

import de.greenrobot.dao.AbstractDao;
import de.greenrobot.dao.DaoConfig;
import de.greenrobot.dao.AbstractDaoSession;
import de.greenrobot.dao.IdentityScopeType;

import com.codesharp.cooper.Tasklist;
import com.codesharp.cooper.Task;
import com.codesharp.cooper.TaskIdx;
import com.codesharp.cooper.ChangeLog;

import com.codesharp.cooper.TasklistDao;
import com.codesharp.cooper.TaskDao;
import com.codesharp.cooper.TaskIdxDao;
import com.codesharp.cooper.ChangeLogDao;

// THIS CODE IS GENERATED BY greenDAO, DO NOT EDIT.

/**
 * {@inheritDoc}
 * 
 * @see de.greenrobot.dao.AbstractDaoSession
 */
public class DaoSession extends AbstractDaoSession {

    private final DaoConfig tasklistDaoConfig;
    private final DaoConfig taskDaoConfig;
    private final DaoConfig taskIdxDaoConfig;
    private final DaoConfig changeLogDaoConfig;

    private final TasklistDao tasklistDao;
    private final TaskDao taskDao;
    private final TaskIdxDao taskIdxDao;
    private final ChangeLogDao changeLogDao;

    public DaoSession(SQLiteDatabase db, IdentityScopeType type, Map<Class<? extends AbstractDao<?, ?>>, DaoConfig>
            daoConfigMap) {
        super(db);

        tasklistDaoConfig = daoConfigMap.get(TasklistDao.class).clone();
        tasklistDaoConfig.initIdentityScope(type);

        taskDaoConfig = daoConfigMap.get(TaskDao.class).clone();
        taskDaoConfig.initIdentityScope(type);

        taskIdxDaoConfig = daoConfigMap.get(TaskIdxDao.class).clone();
        taskIdxDaoConfig.initIdentityScope(type);

        changeLogDaoConfig = daoConfigMap.get(ChangeLogDao.class).clone();
        changeLogDaoConfig.initIdentityScope(type);

        tasklistDao = new TasklistDao(tasklistDaoConfig, this);
        taskDao = new TaskDao(taskDaoConfig, this);
        taskIdxDao = new TaskIdxDao(taskIdxDaoConfig, this);
        changeLogDao = new ChangeLogDao(changeLogDaoConfig, this);

        registerDao(Tasklist.class, tasklistDao);
        registerDao(Task.class, taskDao);
        registerDao(TaskIdx.class, taskIdxDao);
        registerDao(ChangeLog.class, changeLogDao);
    }
    
    public void clear() {
        tasklistDaoConfig.getIdentityScope().clear();
        taskDaoConfig.getIdentityScope().clear();
        taskIdxDaoConfig.getIdentityScope().clear();
        changeLogDaoConfig.getIdentityScope().clear();
    }

    public TasklistDao getTasklistDao() {
        return tasklistDao;
    }

    public TaskDao getTaskDao() {
        return taskDao;
    }

    public TaskIdxDao getTaskIdxDao() {
        return taskIdxDao;
    }

    public ChangeLogDao getChangeLogDao() {
        return changeLogDao;
    }

}
