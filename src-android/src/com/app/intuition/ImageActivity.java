package com.app.intuition;

import com.users.Tag;

import net.intuition.APIConnection;
import android.os.AsyncTask;
import android.os.Bundle;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

public class ImageActivity extends Activity {

	private ProgressDialog pDialog;
	private TextView tagView;
	private Button buttonYes, buttonNo, buttonSkip;
	private boolean init = true;


	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_image);
		tagView = (TextView) findViewById(R.id.textViewTag);

		buttonYes = (Button) findViewById(R.id.buttonYes);
		buttonNo = (Button) findViewById(R.id.buttonNo);
		buttonSkip = (Button) findViewById(R.id.buttonSkip);


		buttonYes.setOnClickListener(yesAction);
		buttonNo.setOnClickListener(noAction);
		buttonSkip.setOnClickListener(skipAction);

		this.overridePendingTransition(R.anim.alpha_open_transition, R.anim.alpha_close_transition);

		if(init){
			new GetNewTag().execute();
			init = false;
		}
	}

	private OnClickListener yesAction = new OnClickListener() {
		@Override
		public void onClick(View v) {
			new RateTag(tagView.getText().toString(), 1).execute();
		}
	};

	private OnClickListener noAction = new OnClickListener() {
		@Override
		public void onClick(View v) {
			new RateTag(tagView.getText().toString(), 0).execute();
		}
	};

	private OnClickListener skipAction = new OnClickListener() {
		@Override
		public void onClick(View v) {
			new RateTag(tagView.getText().toString(), -1).execute();
		}
	};


	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.image, menu);
		return true;
	}

	private class GetNewTag extends AsyncTask<String, String, String> {
		private Tag t;

		@Override
		protected void onPreExecute() {
			super.onPreExecute();
			pDialog = new ProgressDialog(ImageActivity.this);
			pDialog.setMessage("Chargement en cours ...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();

		}

		@Override
		protected String doInBackground(String... args) {
			t = APIConnection.getNewTag();

			return null;
		}

		@Override
		protected void onPostExecute(String file_url) {

			Typeface titleFont = Typeface.createFromAsset(getAssets(),"fonts/font.ttf");
			tagView.setTypeface(titleFont);
			tagView.setText(t.getName());

			RelativeLayout layout = (RelativeLayout)findViewById(R.id.layoutImage);
			layout.setBackgroundColor(t.getColor());
			pDialog.dismiss();
		}

	}

	private class RateTag extends AsyncTask<String, String, String> {
		private String tag;
		private int value;
		private boolean success = false;

		public RateTag(String tag, int value){
			this.tag = tag;
			this.value = value;
		}

		@Override
		protected void onPreExecute() {
			super.onPreExecute();
			pDialog = new ProgressDialog(ImageActivity.this);
			pDialog.setMessage("Chargement en cours ...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();

		}

		@Override
		protected String doInBackground(String... args) {
			success = APIConnection.rateTag(tag, value);

			return null;
		}

		@Override
		protected void onPostExecute(String file_url) {
			if (!success)
				Toast.makeText(ImageActivity.this, "Un problème est survenu.", Toast.LENGTH_SHORT).show();


			new GetProducts().execute();
		}

	}

	private class GetProducts extends AsyncTask<String, String, String> {
		private boolean success = false;

		@Override
		protected void onPreExecute() {
			super.onPreExecute();

		}

		@Override
		protected String doInBackground(String... args) {
			success = APIConnection.getProducts();
			APIConnection.getUserTags();
			return null;
		}

		@Override
		protected void onPostExecute(String file_url) {
			pDialog.dismiss();
			if (!success){
				new GetNewTag().execute();
			}
			else {
				Intent intent = new Intent(getApplicationContext(), ProductInformationsActivity.class);

				startActivity(intent);
				finish();
			}
		}

	}

}
