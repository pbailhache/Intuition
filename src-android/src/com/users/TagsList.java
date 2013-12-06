package com.users;

import java.util.Vector;

public abstract class TagsList {

	private static Vector<String> listTags;
	private static Vector<String> listRefused;
	
	public static void initListTags(){
		listTags = new Vector<String>();
	}
	
	public static void initListRefused(){
		listRefused = new Vector<String>();
	}
	
	public static void addNewTag(String tag){
		listTags.add(tag);
	}
	
	public static void setTagRefused(String tag){
		listTags.remove(tag);
		listRefused.add(tag);
	}
	
	public static String getRandomTag(){
		int random = (int)(Math.random()* listTags.size());
		return listTags.get(random);
	}
	
	
}
