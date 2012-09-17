package com.hooseating.app;

import java.util.Comparator;

import com.parse.ParseObject;

public class ParseObjectComparator implements Comparator<ParseObject> {
	
	public int compare(ParseObject o1, ParseObject o2) {
		return o1.getString("start_time").compareTo(o2.getString("start_time"));
	}

}
