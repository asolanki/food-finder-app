package com.parse.starter;

import java.util.ArrayList;
import java.util.List;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapController;
import com.google.android.maps.MapView;
import com.google.android.maps.Overlay;
import com.google.android.maps.OverlayItem;
import com.parse.ParseGeoPoint;
import com.parse.ParseObject;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.Toast;

public class NearMeActivity extends MapActivity {

	private static final long MINIMUM_DISTANCE_CHANGE_FOR_UPDATES = 1; // in Meters
	private static final long MINIMUM_TIME_BETWEEN_UPDATES = 1000; // in Milliseconds
	ProgressDialog loader;
	FoodEventItemizedOverlay itemizedOverlay;
	private boolean locFail = false;
	private MapView theMap;
	private boolean done;
	private boolean gpsEnabled;

	protected LocationManager locationManager;

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		done = false;
		//Location code
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

		if (locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) { 
			locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, MINIMUM_TIME_BETWEEN_UPDATES, MINIMUM_DISTANCE_CHANGE_FOR_UPDATES, locationListener);
			gpsEnabled = true;
		}
		else {
			locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, MINIMUM_TIME_BETWEEN_UPDATES, MINIMUM_DISTANCE_CHANGE_FOR_UPDATES, locationListener);
			Toast.makeText(this, "GPS not enabled. Using rough estimate", Toast.LENGTH_LONG).show();
			gpsEnabled = false;
		}

		setContentView(R.layout.map_overlay);
		theMap = (MapView) findViewById(R.id.map_overlay);
		loader = ProgressDialog.show(this, "", "Loading food events...", true);


		new Thread(new Runnable() {
			public void run() {
				GeoPoint referencePoint;
				Location location;
				if (gpsEnabled)
					location = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
				else
					location = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);

				if (location != null) {
					referencePoint = new GeoPoint((int)(location.getLatitude() * 1000000),(int)(location.getLongitude() * 1000000));
				}

				else {
					//Default to rotunda (could be anywhere) if we fail
					referencePoint = new GeoPoint(38035681, -78503323);
					Log.i("loc fail", "failed");
					locFail = true;
				}


				MapController myMapController = theMap.getController();

				Log.i("loc lat", ""+referencePoint.getLatitudeE6());
				Log.i("loc lon", ""+referencePoint.getLongitudeE6());
				myMapController.setCenter(referencePoint);
				myMapController.setZoom(17);


				List<Overlay> mapOverlays = theMap.getOverlays();
				Drawable drawable = NearMeActivity.this.getResources().getDrawable(R.drawable.map_marker);
				itemizedOverlay = new FoodEventItemizedOverlay(drawable, NearMeActivity.this);


				ArrayList<ParseObject> foodEvents = ParseApplication.getFoodItems();

				for (ParseObject oneEvent : foodEvents) {
					ParseGeoPoint coords = (ParseGeoPoint) oneEvent.get("coordinates");
					double lat = coords.getLatitude();
					double lon = coords.getLongitude();
					GeoPoint point = new GeoPoint((int)(lat * 1000000),(int)(lon * 1000000));
					String title = oneEvent.getString("name");
					String descrip = oneEvent.getString("description");
					FoodEventOverlayItem overlayitem = new FoodEventOverlayItem(point, title, descrip, oneEvent);
					itemizedOverlay.addOverlay(overlayitem);
				}


				mapOverlays.add(itemizedOverlay);

				loader.dismiss();
				done = true;
			}
		}).start();
		while (!done) {}
		if (locFail) {
			Toast.makeText(this, "Could not retrieve your location. Defaulting to The Rotunda", Toast.LENGTH_LONG).show();
		}
		theMap.setBuiltInZoomControls(true);
	}

	protected boolean isRouteDisplayed() {
		return false;
	}

}
