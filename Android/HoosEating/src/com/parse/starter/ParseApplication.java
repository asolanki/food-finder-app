package com.parse.starter;

import com.parse.Parse;
import com.parse.ParseACL;
import com.parse.ParseObject;

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

}
