package com.app.intuition;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.Menu;
import android.view.ViewGroup.LayoutParams;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.RelativeLayout;

public class ProductImageActivity extends Activity {

	private ImageView imageViewProduct;

	private AnimationListener al = new Animation.AnimationListener(){
		@Override
		public void onAnimationStart(Animation arg0) {
		}           
		@Override
		public void onAnimationRepeat(Animation arg0) {
		}           
		@Override
		public void onAnimationEnd(Animation arg0) {
			final Intent intent = new Intent(getApplicationContext(), ProductInformationsActivity.class);
			startActivity(intent);
			finish();
		}
	};

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_product_image);

		imageViewProduct = (ImageView) findViewById(R.id.imageViewProduct);

		this.overridePendingTransition(R.anim.alpha_open_transition, R.anim.alpha_close_transition);

		Animation a = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.product_informations_animation);
		a.setAnimationListener(al);
		imageViewProduct.startAnimation(a);

		//imageViewProduct.startAnimation(AnimationUtils.loadAnimation(getApplicationContext(), ));

	}



	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.product_image, menu);
		return true;
	}

}
