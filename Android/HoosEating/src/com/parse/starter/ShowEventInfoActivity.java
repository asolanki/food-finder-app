package com.parse.starter;

import com.google.android.maps.GeoPoint;
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
import android.graphics.Typeface;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Bundle;
import android.provider.Contacts.People;
import android.provider.ContactsContract;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageButton;
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

	protected LocationManager locationManager;
	private static final long MINIMUM_DISTANCE_CHANGE_FOR_UPDATES = 1; // in Meters
	private static final long MINIMUM_TIME_BETWEEN_UPDATES = 1000; // in Milliseconds
	private String referenceCoords;
	private boolean locFail;
	private boolean gpsEnabled;

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);


		setContentView(R.layout.show_event);

		Intent intent = getIntent();
		String myName = intent.getStringExtra("com.parse.starter.foodEvent_name");
		String myLocation = intent.getStringExtra("com.parse.starter.foodEvent_location");
		String myDescription = intent.getStringExtra("com.parse.starter.foodEvent_description");
		String start = intent.getStringExtra("com.parse.starter.foodEvent_start");
		String end = intent.getStringExtra("com.parse.starter.foodEvent_end");
		final double lat = intent.getDoubleExtra("com.parse.starter.foodEvent_lat", 0.0);
		final double lon = intent.getDoubleExtra("com.parse.starter.foodEvent_lon", 0.0);


		Typeface tf = Typeface.createFromAsset(getAssets(), "fonts/AlgreSans.ttf");
		Typeface tf2 = Typeface.createFromAsset(getAssets(), "fonts/hitroad.ttf");
		
		TextView event_name = (TextView) findViewById(R.id.event_detail_name);
		event_name.setText(myName);
		event_name.setTypeface(tf);
		
		TextView event_time = (TextView) findViewById(R.id.event_detail_time);
		String formatted_start = ParseApplication.formattedDate(start);
		String formatted_end = ParseApplication.formattedDate(end);
		String[] ymd = start.split("-");
		int month = Integer.parseInt(ymd[1]);
		int day = Integer.parseInt(ymd[2].substring(0,2));
		String[] ymd2 = end.split("-");
		int month2 = Integer.parseInt(ymd2[1]);
		int day2 = Integer.parseInt(ymd2[2].substring(0,2));
		if (month == month2 && day == day2) {
			event_time.setText(month+"/"+day +"  "+formatted_start + " - " + formatted_end);
		}
		else {
			event_time.setText(month+"/"+day +"  "+formatted_start + " - " + month2+"/"+day2 +"  "+formatted_end);
		}
		event_time.setTypeface(tf);
		
		TextView event_loc = (TextView) findViewById(R.id.event_detail_loc);
		event_loc.setText("@" + myLocation);
		event_loc.setTypeface(tf);
		
		TextView event_desc = (TextView) findViewById(R.id.event_detail_desc);
		event_desc.setText(myDescription);
		event_desc.setTypeface(tf2);


		locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);

		LocationListener locationListener = new LocationListener() {
			public void onLocationChanged(Location location) {

			}

			public void onStatusChanged(String s, int i, Bundle b) {

			}

			public void onProviderDisabled(String s) {

			}

			public void onProviderEnabled(String s) {

			}
		};

		Location location;
		if (locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) { 
			locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, MINIMUM_TIME_BETWEEN_UPDATES, MINIMUM_DISTANCE_CHANGE_FOR_UPDATES, locationListener);
			location = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
			gpsEnabled = true;
		}
		else {
			locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, MINIMUM_TIME_BETWEEN_UPDATES, MINIMUM_DISTANCE_CHANGE_FOR_UPDATES, locationListener);
			location = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
			gpsEnabled = false;
		}

		if (location != null) {
			referenceCoords = (location.getLatitude())+","+(location.getLongitude());
		}

		else {
			//Default to rotunda (could be anywhere) if we fail
			referenceCoords ="38.035681,-78.503323";
			locFail = true;
		}

		Button getWalkDir = (Button) findViewById(R.id.get_walk_dir);
		getWalkDir.setOnClickListener(new OnClickListener() {
			public void onClick(View v) {
				if (!gpsEnabled) {
					Toast.makeText(ShowEventInfoActivity.this, "GPS not enabled. Attempting rough estimate", Toast.LENGTH_LONG).show();
				}
				String url = "http://maps.google.com/maps?saddr="+referenceCoords+"&daddr="+lat+","+lon+"&dirflg=w";
				Intent intent = new Intent(android.content.Intent.ACTION_VIEW,  Uri.parse(url));
				startActivity(intent);
				if (locFail) {
					Toast.makeText(ShowEventInfoActivity.this, "Could not retrieve your location. Defaulting to The Rotunda", Toast.LENGTH_LONG).show();
				}
			}
		});

		Button getBusDir = (Button) findViewById(R.id.get_bus_dir);
		getBusDir.setOnClickListener(new OnClickListener() {
			public void onClick(View v) {
				if (!gpsEnabled)
					Toast.makeText(ShowEventInfoActivity.this, "GPS not enabled. Attempting rough estimate", Toast.LENGTH_LONG).show();
				String url = "http://maps.google.com/maps?saddr="+referenceCoords+"&daddr="+lat+","+lon+"&dirflg=r";
				Intent intent = new Intent(android.content.Intent.ACTION_VIEW,  Uri.parse(url));
				startActivity(intent);
				if (locFail) {
					Toast.makeText(ShowEventInfoActivity.this, "Could not retrieve your location. Defaulting to The Rotunda", Toast.LENGTH_LONG).show();
				}
			}
		});

	}
}
