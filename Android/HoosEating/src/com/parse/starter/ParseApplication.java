package com.parse.starter;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
		try {
			return (ArrayList) query.find();
		} catch (ParseException e) {
			return new ArrayList<ParseObject>();
		}
	}

	public static String formattedDate(String s) {
		DateFormat m_ISO8601Local = new SimpleDateFormat ("yyyy-mm-dd'T'HH:MM:ss");
		String time_to_display = "";
		try {
			Date d = m_ISO8601Local.parse(s);
			int h = d.getHours();
			int m = d.getMinutes();
			if (h < 13) {
				if (m != 0)
					time_to_display += h+":00"+" AM";
				else
					time_to_display += h+":"+m+" AM";
			}
			else {
				h = h - 12;
				if (m != 0)
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