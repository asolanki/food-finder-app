package com.parse.starter;

import java.util.List;

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

public class ListEventsActivity extends ListActivity {

	static final String[] FRUITS = new String[] { "Apple", "Avocado", "Banana",
		"Blueberry", "Coconut", "Durian", "Guava", "Kiwifruit",
		"Jackfruit", "Mango", "Olive", "Pear", "Sugar-apple" };

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		// no more this
		// setContentView(R.layout.list_fruit);
		List<ParseObject> foodEvents;
		ParseQuery query = new ParseQuery("FoodEvent");
		query.findInBackground(new FindCallback() {
		    public void done(final List<ParseObject> scoreList, ParseException e) {
		        if (e == null) {
		            Log.d("score", "Retrieved " + scoreList.size() + " scores");
		            
		            String [] toDisplay = new String[scoreList.size()];
		            int g = 0;
		            for (ParseObject x : scoreList) {
		            	toDisplay[g] = x.getString("name");
		            	g++;
		            }
		    		setListAdapter(new ArrayAdapter<String>(getApplicationContext(), R.layout.main,toDisplay));

		    		ListView listView = getListView();
		    		listView.setTextFilterEnabled(true);

		    		listView.setOnItemClickListener(new OnItemClickListener() {
		    			public void onItemClick(AdapterView<?> parent, View view,
		    					int position, long id) {
		    				// When clicked, show a toast with the TextView text
		    				
		    				Intent myIntent = new Intent(ListEventsActivity.this, ShowEventInfoActivity.class);
		    				myIntent.putExtra("com.parse.starter.foodEvent_location", scoreList.get(position).getString("location"));
		    				myIntent.putExtra("com.parse.starter.foodEvent_description", scoreList.get(position).getString("description"));
		    				myIntent.putExtra("com.parse.starter.foodEvent_start", scoreList.get(position).getString("start_time"));
		    				myIntent.putExtra("com.parse.starter.foodEvent_end", scoreList.get(position).getString("end_time"));
		    				ListEventsActivity.this.startActivity(myIntent);
		    			}
		    		});
		        } else {
		            Log.d("score", "Error: " + e.getMessage());
		        }
		    }
		});

	}

}

