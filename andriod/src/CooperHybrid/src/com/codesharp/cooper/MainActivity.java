package com.codesharp.cooper;

import android.os.Bundle;
import android.database.sqlite.SQLiteDatabase;
import android.view.Menu;

import org.apache.cordova.DroidGap;
import com.codesharp.cooper.DaoMaster.DevOpenHelper;

public class MainActivity extends DroidGap {

	private SQLiteDatabase db;
	private DaoMaster daoMaster;
    private DaoSession daoSession;
    @Override
    public void onCreate(Bundle savedInstanceState) {
    	super.onCreate(savedInstanceState);
    	
    	DevOpenHelper helper = new DaoMaster.DevOpenHelper(this, "TaskModel.sqlite", null);
        db = helper.getWritableDatabase();
        daoMaster = new DaoMaster(db);
        daoSession = daoMaster.newSession();
        
    	//PhoneGapº”‘ÿ“≥√Ê
    	super.loadUrl("file:///android_asset/Hybrid/index.htm");
    }
    
    public DaoSession getSession()
    {
    	return this.daoSession;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.activity_main, menu);
        return true;
    }
}
