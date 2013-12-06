package net.intuition;

import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.graphics.drawable.Drawable;
import android.util.Log;

import com.users.Product;
import com.users.ProductList;
import com.users.Tag;

public abstract class APIConnection {

	private static String ip = "http://developersrift.projets-bx1.fr/api/";

	// USER
	private static String urlGetProducts = ip + "getAvailProducts";
	private static String urlGetNewTag = ip + "getNewTag";
	private static String urlRateTag = ip + "rateTag";
	private static String urlGetUserTags = ip + "getUserTags";

	// - TAGS
	public static final String TAG_IMAGEURL = "imageURL";
	public static final String TAG_ID = "id";
	public static final String TAG_NAME = "name";
	public static final String TAG_COLOR = "color";
	public static final String TAG_RATING = "rating";
	public static final String TAG_TAG = "tag";
	public static final String TAG_IMAGE_URL = "imageURL";
	public static final String TAG_URL = "url";
	public static final String TAG_PRICE = "price";

	// OTHERS

	public static final int BOOLEAN_TRUE = 0;
	public static final int BOOLEAN_FALSE = 1;
	public static final int ERROR_VALUE = -1;

	private static JSONParser jParser;

	private static JSONObject makeHttpRequestToObject(String url, String method, List<NameValuePair> params){
		jParser = new JSONParser();
		return jParser.makeHttpRequest(url, method, params);
	}

	private static JSONArray makeHttpRequestToArray(String url, String method, List<NameValuePair> params){
		jParser = new JSONParser();
		return jParser.makeHttpRequestArray(url, method, params);
	}

	private static boolean makeHttpRequestToBoolean(String url, String method, List<NameValuePair> params){
		jParser = new JSONParser();
		return convertToBoolean(jParser.makeHttpRequestString(url, method, params));
	}

	/**
	 * Vérifie si la chaîne est un booléen. Elle supprime tout les espaces et les \n de la chaine avant la vérification.
	 * @param bool
	 * @return
	 */
	private static boolean convertToBoolean(String bool){
		return Boolean.valueOf(bool.replace(" ", "").replace("\n", ""));
	}

	public static Tag getNewTag(){
		List<NameValuePair> params = new ArrayList<NameValuePair>();

		Tag t = null;
		JSONObject json = makeHttpRequestToObject(urlGetNewTag, "GET", params);

		if (json!=null){
			String name, color;
			try {
				name = json.getString(TAG_NAME);
				color = json.getString(TAG_COLOR);
				t = new Tag(name, color);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}


		}

		return t;
	}
	
	public static boolean rateTag(String tag, int value){
		List<NameValuePair> params = new ArrayList<NameValuePair>();
		params.add(new BasicNameValuePair(TAG_TAG, tag));
		params.add(new BasicNameValuePair(TAG_RATING, String.valueOf(value)));

		
		boolean success = false;
		JSONObject json = makeHttpRequestToObject(urlRateTag, "GET", params);
		
		if (json!=null){
			try {
				success = json.getBoolean("success");
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}

		return success;
	}
	
	public static boolean getProducts(){
		List<NameValuePair> params = new ArrayList<NameValuePair>();
		
		boolean isNotEmpty = false;
		JSONArray json = makeHttpRequestToArray(urlGetProducts, "GET", params);
		
		if (json!=null){
			Log.i("DEBUUUg", json.toString());
			ProductList.initList();
			for (int i=0; i<json.length(); i++){
				try {
					JSONObject j = json.getJSONObject(i);
					ProductList.addProduct(new Product(j.getString(TAG_IMAGE_URL), j.getString(TAG_URL), 
							String.valueOf(j.getDouble(TAG_PRICE)) + " €"));
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
			isNotEmpty = true;

		}

		return isNotEmpty;
	}
	
	public static boolean getUserTags(){
		List<NameValuePair> params = new ArrayList<NameValuePair>();
		
		boolean isNotEmpty = false;
		JSONObject json = makeHttpRequestToObject(urlGetUserTags, "GET", params);
		
		if (json!=null){
			Log.i("[DEBUG]", json.toString());

		}

		return isNotEmpty;
	}
	
	public static Drawable LoadImageFromWebOperations(String url) {
	    try {
	        InputStream is = (InputStream) new URL(url).getContent();
	        Drawable d = Drawable.createFromStream(is, "src name");
	        return d;
	    } catch (Exception e) {
	        return null;
	    }
	}




}
