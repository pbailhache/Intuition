package com.users;

import android.graphics.Color;
import android.util.Log;

public class Tag {
	
	private String name;
	
	private int color;
	
	public Tag(String name, String color){
		this.name = name;
		createColor(color);
	}
	
	private void createColor(String color){
		Log.i("Color", color);
		this.color = Color.argb(255, Integer.valueOf(color.substring(0,2), 16), Integer.valueOf(color.substring(2,4), 16), Integer.valueOf(color.substring(4,6), 16));
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getColor() {
		return color;
	}


}
