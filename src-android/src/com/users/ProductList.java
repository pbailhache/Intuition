package com.users;

import java.util.Vector;

public abstract class ProductList {

	private static Vector<Product> list;
	
	public static void initList(){
		list = new Vector<Product>();
	}
	
	public static void addProduct(Product p){
		list.add(p);
	}
	
	public static boolean isEmpty(){
		return list.isEmpty();
	}
	
	public static Product getProduct(int i){
		return list.get(i);
	}
	
	public static void removeProduct(int i){
		list.remove(i);
	}
	
}
