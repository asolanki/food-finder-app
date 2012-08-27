package com.parse.starter;

import java.text.ParseException;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import com.parse.ParseObject;

import android.app.Activity;
import android.graphics.Typeface;

import java.text.DateFormat;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

public class FoodEventAdapter extends ArrayAdapter {
	private final Activity activity;
	private final List foodEvents;

	public FoodEventAdapter(Activity activity, List objects) {
		super(activity, R.layout.list_items, objects);
		this.activity = activity;
		this.foodEvents = objects;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		View rowView = convertView;
		FoodEventView feView = null;

		if(rowView == null)
		{
			// Get a new instance of the row layout view
			LayoutInflater inflater = activity.getLayoutInflater();
			rowView = inflater.inflate(R.layout.list_items, null);

			// Hold the view objects in an object,
			// so they don't need to be re-fetched
			feView = new FoodEventView();
			feView.name = (TextView) rowView.findViewById(R.id.event_name);
			feView.time = (TextView) rowView.findViewById(R.id.event_time);
			feView.loc = (TextView) rowView.findViewById(R.id.event_loc);

			// Cache the view objects in the tag,
			// so they can be re-accessed later
			rowView.setTag(feView);
		} else {
			feView = (FoodEventView) rowView.getTag();
		}

		// Transfer the stock data from the data object
		// to the view objects
		ParseObject obj = (ParseObject) foodEvents.get(position);
		feView.name.setText(obj.getString("name"));

		String date = obj.getString("start_time");
		String[] ymd = date.split("-");
		int year = Integer.parseInt(ymd[0]);
		int month = Integer.parseInt(ymd[1]);
		int day = Integer.parseInt(ymd[2].substring(0,2));

		String time_to_display;
		GregorianCalendar curr = (GregorianCalendar) Calendar.getInstance();
		boolean same = ((curr.get(Calendar.YEAR) == year) &&
				((curr.get(Calendar.MONTH) + 1) == month) &&
				(curr.get(Calendar.DAY_OF_MONTH) == day ));
		
		if (same)
			time_to_display = ParseApplication.formattedDate(date);
		else {
			time_to_display = month+"/"+day;
		}
		
		feView.time.setText(time_to_display);

		feView.loc.setText(obj.getString("location"));
		
		Typeface tf2 = Typeface.createFromAsset(activity.getAssets(), "fonts/hitroad.ttf");
		feView.name.setTypeface(tf2);
		feView.time.setTypeface(tf2);
		feView.loc.setTypeface(tf2);


		return rowView;
	}

	protected static class FoodEventView {
		protected TextView name;
		protected TextView time;
		protected TextView loc;
	}
}
