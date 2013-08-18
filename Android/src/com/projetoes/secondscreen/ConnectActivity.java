package com.projetoes.secondscreen;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;

public class ConnectActivity extends Activity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_conect);
		
	}
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.conect_activity, menu);
		return true;
	}

	public void pressButton(View view) {
		
		
		Intent mainIntent = new Intent(ConnectActivity.this, MainActivity.class);
		ConnectActivity.this.startActivity(mainIntent);
		ConnectActivity.this.finish();

	}

}
