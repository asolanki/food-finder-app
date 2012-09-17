package com.hooseating.app;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class HoosEatingDatetime {

	private String sourceRep;
	//0 if this datetime is before Today
	//1 if this datetime is Today
	//2 if this datetime is after Today
	private int status;
	private int year, month, day;
	private String time;


	public HoosEatingDatetime(String src, Calendar today) {
		String[] ymd = src.split("-");
		sourceRep = src;
		year = Integer.parseInt(ymd[0]);
		month = Integer.parseInt(ymd[1]);
		day = Integer.parseInt(ymd[2].substring(0,2));
		if (	(today.get(Calendar.YEAR) > year)
				||
				(((today.get(Calendar.MONTH) + 1) > month) &&
						today.get(Calendar.YEAR) == year) 
				||
				((today.get(Calendar.DAY_OF_MONTH) > day) &&
						((today.get(Calendar.MONTH) + 1) == month) &&
						(today.get(Calendar.YEAR) == year))   
				) {
			status = 0;
		}
		else if ((today.get(Calendar.YEAR) == year) &&
				((today.get(Calendar.MONTH) + 1) == month) &&
				(today.get(Calendar.DAY_OF_MONTH) == day)) {
			status = 1;
		}
		else {
			status = 2;
		}

		time = parseTime(src);
	}

	private String parseTime(String src) {
		DateFormat m_ISO8601Local = new SimpleDateFormat ("yyyy'-'MM'-'dd'T'HH':'mm':'ss");
		String time_to_display = "";
		try {
			Date d = m_ISO8601Local.parse(src);
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
	
	public boolean isRelevant() {
		if (status == 0) return false;
		return true;
	}
	
	public String getSource() {
		return sourceRep;
	}
	
	//For multi day events, we want to ignore the normal relevance rules and
	//access the MM/DD format and time directly.
	public String getMonthDay() {
		if (status == 1) {
			return "Today";
		}
		return month+"/"+day;
	}
	
	public String getTime() {
		return time;
	}
	
	public int getStatus() {
		return status;
	}
	
	
	//Wrapper, since this checking logic should only have to happen within
	//this class.
	public String toString() {
		if (status == 1) {
			return getTime();
		}
		else {
			return getMonthDay();
		}
	}
}
