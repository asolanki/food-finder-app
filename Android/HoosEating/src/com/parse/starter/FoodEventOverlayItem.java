package com.parse.starter;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.OverlayItem;
import com.parse.ParseObject;

public class FoodEventOverlayItem extends OverlayItem {

	private ParseObject myObj;
	public FoodEventOverlayItem(GeoPoint p, String title, String descrip, ParseObject o) {
		super(p, title, descrip);
		myObj = o;
	}
	
	public ParseObject getObj() {
		return myObj;
	}
}
