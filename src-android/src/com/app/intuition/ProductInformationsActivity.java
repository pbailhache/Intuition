package com.app.intuition;

import java.io.IOException;
import java.io.InputStream;
import java.net.URISyntaxException;
import java.net.URL;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.entity.BufferedHttpEntity;
import org.apache.http.impl.client.DefaultHttpClient;

import net.intuition.APIConnection;

import com.users.ProductList;

import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

public class ProductInformationsActivity extends Activity {

	private ProgressDialog pDialog;
	private ImageView img;
	private TextView textViewPrice;
	private Button buttonYes, buttonNo;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_product_informations);
		
		this.overridePendingTransition(R.anim.alpha_open_transition, R.anim.alpha_close_transition);
		
		img = (ImageView) findViewById(R.id.imageViewProduct);
		textViewPrice = (TextView) findViewById(R.id.textViewPrice);
		
		Log.i("blah", ProductList.getProduct(0).getImageURL());
		new GetProduct(ProductList.getProduct(0).getImageURL()).execute();
		
		buttonYes = (Button) findViewById(R.id.buttonYes);
		buttonNo = (Button) findViewById(R.id.buttonNo);


		buttonYes.setOnClickListener(yesAction);
		buttonNo.setOnClickListener(noAction);
	}
	
	private OnClickListener yesAction = new OnClickListener() {
		@Override
		public void onClick(View v) {
			 Intent intent = new Intent( Intent.ACTION_VIEW, Uri.parse(ProductList.getProduct(0).getUrl()) );
			 startActivity(intent);
			 finish();
		}
	};

	private OnClickListener noAction = new OnClickListener() {
		@Override
		public void onClick(View v) {
			ProductList.removeProduct(0);
			if (ProductList.isEmpty()){
				Intent intent = new Intent(getApplicationContext(), ImageActivity.class);

				startActivity(intent);
				finish();
			}
			else {
				new GetProduct(ProductList.getProduct(0).getImageURL()).execute();
			}
		}
	};

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.product_informations, menu);
		return true;
	}

	
	private class GetProduct extends AsyncTask<String, String, String> {
		private boolean success = false;
		private String url;
		private Drawable d;
		Bitmap bitmap;

		public GetProduct(String url){
			this.url = url;
		}
		
		@Override
		protected void onPreExecute() {
			
			super.onPreExecute();
			pDialog = new ProgressDialog(ProductInformationsActivity.this);
			pDialog.setMessage("Chargement en cours ...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();

		}

		@Override
		protected String doInBackground(String... args) {
	
			try {
				URL url = new URL(this.url);
		        //try this url = "http://0.tqn.com/d/webclipart/1/0/5/l/4/floral-icon-5.jpg"
		        HttpGet httpRequest = null;

		        httpRequest = new HttpGet(url.toURI());

		        HttpClient httpclient = new DefaultHttpClient();
		        HttpResponse response = (HttpResponse) httpclient
		                .execute(httpRequest);

		        HttpEntity entity = response.getEntity();
		        BufferedHttpEntity b_entity = new BufferedHttpEntity(entity);
		        InputStream input = b_entity.getContent();

		        bitmap = BitmapFactory.decodeStream(input);

		        
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (URISyntaxException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			

			return null;
		}

		@Override
		protected void onPostExecute(String file_url) {
			if (bitmap!=null){
				img.setImageBitmap(bitmap);
				textViewPrice.setText(ProductList.getProduct(0).getPrice());
			}
			else 
				Toast.makeText(ProductInformationsActivity.this, "Un problème est survenu.", Toast.LENGTH_SHORT).show();
			pDialog.dismiss();
		}

	}
}
