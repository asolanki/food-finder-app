package com.parse.starter;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import com.parse.FindCallback;
import com.parse.GetCallback;
import com.parse.Parse;
import com.parse.ParseACL;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseException;

import com.parse.ParseUser;

import android.app.Application;
import android.util.Log;

public class ParseApplication extends Application {

	@Override
	public void onCreate() {
		super.onCreate();

		// Add your initialization code here
		Parse.initialize(this, "dF4lf8kvjIWL3PqE8ANdS5ancdatrrlYMw0Dm2nM", "jIg3EUugNpG7aMKsSGWiIGrW9jeJPuzTYtUwwnDK");

		/*
		ParseUser.enableAutomaticUser();
		ParseACL defaultACL = new ParseACL();
		// Optionally enable public read access by default.
		// defaultACL.setPublicReadAccess(true);
		ParseACL.setDefaultACL(defaultACL, true);

		ParseObject testObject = new ParseObject("TestObject");
		testObject.put("foo", "bar");
		testObject.saveInBackground();
		 */
	}

	public static ArrayList<ParseObject> getFoodItems() {
		ParseQuery query = new ParseQuery("FoodEvent");
		ArrayList<ParseObject> retval = new ArrayList<ParseObject>();
		try {
			ArrayList<ParseObject> prelim = (ArrayList) query.find();
			Collections.sort(prelim, new ParseObjectComparator());
			for (ParseObject obj : prelim) {
				//Filter based on if it took place before today
				String date = obj.getString("end_time");
				String[] ymd = date.split("-");
				int year = Integer.parseInt(ymd[0]);
				int month = Integer.parseInt(ymd[1]);
				int day = Integer.parseInt(ymd[2].substring(0,2));
				
				GregorianCalendar curr = (GregorianCalendar) Calendar.getInstance();
				
				/*
				Log.i("y",""+year);
				Log.i("m",""+month);
				Log.i("d",""+day);
				
				Log.i("cy",""+curr.get(Calendar.YEAR));
				Log.i("cm",""+(curr.get(Calendar.MONTH)+ 1) );
				Log.i("cd",""+curr.get(Calendar.DAY_OF_MONTH));
				*/
				
				boolean before = (
						(curr.get(Calendar.YEAR) > year)
						||
						(((curr.get(Calendar.MONTH) + 1) > month) && curr.get(Calendar.YEAR) == year) 
						||
						((curr.get(Calendar.DAY_OF_MONTH) > day) && ((curr.get(Calendar.MONTH) + 1) == month) && (curr.get(Calendar.YEAR) == year))   
						);
				
				Log.i("zzz", ""+before);
				if (!before)
					retval.add(obj);
			}
		} catch (ParseException e) {
			
		}
		return retval;
	}

	public static String formattedDate(String s) {
		DateFormat m_ISO8601Local = new SimpleDateFormat ("yyyy'-'MM'-'dd'T'HH':'mm':'ss");
		String time_to_display = "";
		try {
			Date d = m_ISO8601Local.parse(s);
			Calendar c = Calendar.getInstance();
			c.setTime(d);
			
			int h = c.get(Calendar.HOUR_OF_DAY);
			int m = c.get(Calendar.MINUTE);
			if (h < 12) {
				if (h == 0)
					h = 12;
				if (m == 0)
					time_to_display += h+":00"+" AM";
				else
					time_to_display += h+":"+m+" AM";
			}
			else {
				if (h > 12)
					h = h - 12;
				if (m == 0)
					time_to_display += h+":00"+" PM";
				else
					time_to_display += h+":"+m+" PM";
			}
		} catch (java.text.ParseException e) {
			time_to_display = "???";
		}

		return time_to_display;
	}

}