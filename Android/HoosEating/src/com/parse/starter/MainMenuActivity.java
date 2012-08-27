package com.parse.starter;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

public class MainMenuActivity extends Activity {
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main_menu);
		
		ImageButton nearMe = (ImageButton) findViewById(R.id.near_me_btn);
		nearMe.setOnClickListener(new OnClickListener() {
			public void onClick(View v) {
				Intent myIntent = new Intent(MainMenuActivity.this, NearMeActivity.class);
				MainMenuActivity.this.startActivity(myIntent);
			}
		});
		ImageButton comingUp = (ImageButton) findViewById(R.id.coming_up_btn);
		comingUp.setOnClickListener(new OnClickListener() {
			public void onClick(View v) {
				Intent myIntent = new Intent(MainMenuActivity.this, ListEventsActivity.class);
				MainMenuActivity.this.startActivity(myIntent);
			}
		});
	}
}