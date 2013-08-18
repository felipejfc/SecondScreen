package com.projetoes.secondscreen;

import android.os.Bundle;
import android.os.Handler;
import android.app.Activity;
import android.content.Intent;
import android.view.Menu;

public class SplashActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.splash_screen);

	    new Handler().postDelayed(new Runnable() {
	        @Override
	        public void run() {
	            Intent mainIntent = new Intent(SplashActivity.this, ConnectActivity.class);
	            SplashActivity.this.startActivity(mainIntent);
	            SplashActivity.this.finish();
	        }
	    }, 3000);// Sua entrada vai durar por 5 segundos
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.splash_, menu);
		return true;
	}

}
