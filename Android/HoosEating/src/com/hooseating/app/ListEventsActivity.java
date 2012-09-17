package com.hooseating.app;

import java.util.ArrayList;
import com.parse.ParseGeoPoint;
import com.parse.ParseObject;
import com.parse.ParseUser;
import com.hooseating.app.R;
import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.Toast;


public class ListEventsActivity extends ListActivity {

	private ArrayList<ParseObject> foodEvents;
	ProgressDialog loader;
	String [] toDisplay;
	ListView listView;
	private Handler doneHandler = new Handler();

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		ParseUser.getCurrentUser().increment("RunCount");
		ParseUser.getCurrentUser().saveInBackground();

		if (HoosEatingApplication.checkConn(ListEventsActivity.this)) {
			loader = ProgressDialog.show(this, "", "Loading food events...", true);
			new Thread(new Runnable() {
				public void run() {
					foodEvents = HoosEatingApplication.getFoodItems();
					doneHandler.post(new Runnable() {
						public void run() {
							setupListView();
						}
					});
				}}).start();
		}
		else {
			foodEvents = new ArrayList<ParseObject> ();
			Toast.makeText(ListEventsActivity.this, "HoosEating needs an internet connection. Please enable wifi/data!", Toast.LENGTH_LONG).show();
			setupListView();
		}
	}

	protected void setupListView() {
		if (loader != null) {
			loader.dismiss();
		}
		setListAdapter(new FoodEventAdapter(this, foodEvents));
		listView = getListView();
		listView.setTextFilterEnabled(true);
		listView.setBackgroundResource(R.drawable.bg);
		listView.setDivider(null);
		listView.setDividerHeight(0);
		listView.setCacheColorHint(0);

		listView.setOnItemClickListener(new OnItemClickListener() {
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {

				Intent myIntent = new Intent(ListEventsActivity.this, ShowEventInfoActivity.class);
				myIntent.putExtra("com.hooseating.app.foodEvent_name", foodEvents.get(position).getString("name"));
				myIntent.putExtra("com.hooseating.app.foodEvent_location", foodEvents.get(position).getString("location"));
				myIntent.putExtra("com.hooseating.app.foodEvent_description", foodEvents.get(position).getString("description"));
				myIntent.putExtra("com.hooseating.app.foodEvent_start", foodEvents.get(position).getString("start_time"));
				myIntent.putExtra("com.hooseating.app.foodEvent_end", foodEvents.get(position).getString("end_time"));
				ParseGeoPoint coords = (ParseGeoPoint) foodEvents.get(position).get("coordinates");
				double lat = coords.getLatitude();
				double lon = coords.getLongitude();
				myIntent.putExtra("com.hooseating.app.foodEvent_lat", lat);
				myIntent.putExtra("com.hooseating.app.foodEvent_lon", lon);
				ListEventsActivity.this.startActivity(myIntent);
			}
		});
	}
}

