package com.parse.starter;

import java.util.Calendar;
import java.util.GregorianCalendar;

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
	protected LocationListener locationListener;
	private static Location myLocation;
	
	private static final long MINIMUM_DISTANCE_CHANGE_FOR_UPDATES = 1; // in Meters
	private static final long MINIMUM_TIME_BETWEEN_UPDATES = 1000; // in Milliseconds
	private static boolean locFail;
	private static boolean gpsEnabled;
	private static boolean networkEnabled;

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
		GregorianCalendar curr = (GregorianCalendar) Calendar.getInstance();
		
		HoosEatingDatetime startDate = new HoosEatingDatetime(start, curr);
		HoosEatingDatetime endDate = new HoosEatingDatetime(end, curr);
		
		/*
		 * TODO: Add handling for "all-day" events (More gracefully than just making
		 * them go from 12:00 AM - 11:59 PM)
		 * 
		 * Cases:
		 * 1 Day event
		 *     -It's happening today, show "Today" + time
		 *     -It's happening after today, show Date + Time
		 * Multi-day Event
		 *     -It started today, ends after today, show "Today" + time - EndDate + time
		 *     -It started before today, ends today, show StartDate + time - "Today" + time
		 *     -It started before today, ends after today, show StartDate + time - EndDate + time
		 */
		
		//One day event.
		if (startDate.getMonthDay().equals(endDate.getMonthDay())) {
			event_time.setText(startDate.getMonthDay() + "  " + startDate.getTime() + " - " + endDate.getTime());
		}
		//Multi day event.
		else {
			event_time.setText(startDate.getMonthDay() + "  " + startDate.getTime() + " - " + endDate.getMonthDay() + "  " + endDate.getTime());
		}
		event_time.setTypeface(tf);
		
		TextView event_loc = (TextView) findViewById(R.id.event_detail_loc);
		event_loc.setText("@" + myLocation);
		event_loc.setTypeface(tf);
		
		TextView event_desc = (TextView) findViewById(R.id.event_detail_desc);
		event_desc.setText(myDescription);
		event_desc.setTypeface(tf2);


		locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);

		locationListener = new LocationListener() {
			public void onLocationChanged(Location location) {
				ShowEventInfoActivity.updateLocation(location);
			}

			public void onStatusChanged(String s, int i, Bundle b) {

			}

			public void onProviderDisabled(String s) {
				if (s.equals(LocationManager.GPS_PROVIDER))
					ShowEventInfoActivity.updateGps(true);
				else if (s.equals(LocationManager.NETWORK_PROVIDER))
					ShowEventInfoActivity.updateNetwork(true);
			}

			public void onProviderEnabled(String s) {
				if (s.equals(LocationManager.GPS_PROVIDER))
					ShowEventInfoActivity.updateGps(false);
				else if (s.equals(LocationManager.NETWORK_PROVIDER))
					ShowEventInfoActivity.updateNetwork(false);
			}
		};

		if (locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) { 
			locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, MINIMUM_TIME_BETWEEN_UPDATES, MINIMUM_DISTANCE_CHANGE_FOR_UPDATES, locationListener);
			gpsEnabled = true;
			if (locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER))
				networkEnabled = true;
		}
		
		else if (locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)) { 
			locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, MINIMUM_TIME_BETWEEN_UPDATES, MINIMUM_DISTANCE_CHANGE_FOR_UPDATES, locationListener);
			networkEnabled = true;
		}

		ImageButton getWalkDir = (ImageButton) findViewById(R.id.get_dir);
		getWalkDir.setOnClickListener(new OnClickListener() {
			public void onClick(View v) {
				if (!gpsEnabled) {
					Toast.makeText(ShowEventInfoActivity.this, "GPS not enabled. Attempting rough estimate", Toast.LENGTH_LONG).show();
				}
				String referenceCoords = getRefCoords();
				String url = "http://maps.google.com/maps?saddr="+referenceCoords+"&daddr="+lat+","+lon+"&dirflg=w";
				Intent intent = new Intent(android.content.Intent.ACTION_VIEW,  Uri.parse(url));
				startActivity(intent);
				if (locFail) {
					Toast.makeText(ShowEventInfoActivity.this, "Could not retrieve your location. Defaulting to The Rotunda", Toast.LENGTH_LONG).show();
				}
			}
		});

	}
	
	public static String getRefCoords() {
		if (myLocation != null) {
			return myLocation.getLatitude()+","+myLocation.getLongitude();
		}
		else {
			locFail = true;
			return "38.035681,-78.503323";
		}
	}
	
	public static void updateLocation(Location location) {
		myLocation = location;
	}
	
	public static void updateGps(boolean set) {
		gpsEnabled = set;
	}
	
	public static void updateNetwork(boolean set) {
		networkEnabled = set;
	}
}
