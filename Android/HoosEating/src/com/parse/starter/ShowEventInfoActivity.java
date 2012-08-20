package com.parse.starter;

import com.parse.FindCallback;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseException;

import android.app.Activity;
import android.app.ListActivity;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.os.Bundle;
import android.provider.Contacts.People;
import android.provider.ContactsContract;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;
import android.support.v4.app.*;
import android.support.v4.content.CursorLoader;
import android.support.v4.content.Loader;
import android.support.v4.widget.SimpleCursorAdapter;

public class ShowEventInfoActivity extends Activity {

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		
		Intent intent = getIntent();
		String myLocation = intent.getStringExtra("com.parse.starter.foodEvent_location");
		String myDescription = intent.getStringExtra("com.parse.starter.foodEvent_description");
		String start = intent.getStringExtra("com.parse.starter.foodEvent_start");
		String end = intent.getStringExtra("com.parse.starter.foodEvent_end");
		
		TextView derp = new TextView(this);
		derp.append(myLocation + "\n" + myDescription + "\n" + start + "\n" + end);
		
		ScrollView theView = new ScrollView(this);
		LinearLayout ll = new LinearLayout(this);
		ll.setOrientation(LinearLayout.VERTICAL);
		ll.addView(derp);
		theView.addView(ll);
		setContentView(theView);
		
	}
}
