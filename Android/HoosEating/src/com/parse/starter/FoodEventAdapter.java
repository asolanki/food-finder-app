package com.parse.starter;

import java.text.ParseException;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import com.parse.ParseObject;

import android.app.Activity;
import java.text.DateFormat;
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
        String time_to_display = ParseApplication.formattedDate(date);
        feView.time.setText(time_to_display);
        
        feView.loc.setText(obj.getString("location"));
        
 
        return rowView;
    }
 
    protected static class FoodEventView {
        protected TextView name;
        protected TextView time;
        protected TextView loc;
    }
}
