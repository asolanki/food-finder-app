package com.hooseating.app;

import java.util.ArrayList;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.Drawable;

import com.google.android.maps.ItemizedOverlay;
import com.parse.ParseGeoPoint;
import com.parse.ParseObject;

public class FoodEventItemizedOverlay extends ItemizedOverlay {

	private ArrayList<FoodEventOverlayItem> overlays = new ArrayList<FoodEventOverlayItem> ();
	private Context myContext;

	public FoodEventItemizedOverlay(Drawable defaultMarker, Context context) {
		super(boundCenterBottom(defaultMarker));
		myContext = context;
	}

	public void addOverlay(FoodEventOverlayItem overlay) {
		overlays.add(overlay);
		populate();
	}

	@Override
	protected FoodEventOverlayItem createItem(int i) {
		return overlays.get(i);
	}

	@Override
	public int size() {
		return overlays.size();
	}

	@Override
	protected boolean onTap(int index) {
		final FoodEventOverlayItem item = overlays.get(index);
		AlertDialog.Builder dialog = new AlertDialog.Builder(myContext);
		dialog.setTitle(item.getTitle());
		dialog.setMessage(item.getSnippet());
		dialog.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int id) {
				dialog.cancel();
			}
		});
		dialog.setPositiveButton("More Info", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int id) {
				Intent myIntent = new Intent(myContext, ShowEventInfoActivity.class);
				ParseObject o = item.getObj();
				myIntent.putExtra("com.hooseating.app.foodEvent_name", o.getString("name"));
				myIntent.putExtra("com.hooseating.app.foodEvent_location", o.getString("location"));
				myIntent.putExtra("com.hooseating.app.foodEvent_description", o.getString("description"));
				myIntent.putExtra("com.hooseating.app.foodEvent_start", o.getString("start_time"));
				myIntent.putExtra("com.hooseating.app.foodEvent_end", o.getString("end_time"));
				ParseGeoPoint coords = (ParseGeoPoint) o.get("coordinates");
				double lat = coords.getLatitude();
				double lon = coords.getLongitude();
				myIntent.putExtra("com.hooseating.app.foodEvent_lat", lat);
				myIntent.putExtra("com.hooseating.app.foodEvent_lon", lon);
				myContext.startActivity(myIntent);	
			}
		});
		dialog.show();
		return true;
	}
}
