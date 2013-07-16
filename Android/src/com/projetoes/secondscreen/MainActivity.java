package com.projetoes.secondscreen;

import keyboard.Keyboard;
import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;

public class MainActivity extends Activity {

	private Keyboard keys;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	public void sendAction(View view){
		this.keys.finish();
		Button buttonSend = (Button) this.findViewById(R.id.buttonSend);
		buttonSend.setVisibility(View.INVISIBLE);
	}
	
	public void appearAction(View view) {
		InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);

		EditText textEditSend = (EditText) this.findViewById(R.id.editSend);
		this.keys = new Keyboard(textEditSend, imm);
		keys.init();

		Button buttonSend = (Button) this.findViewById(R.id.buttonSend);
		buttonSend.setVisibility(View.VISIBLE);
		Log.w("avisando", "===========================");
		Log.w("avisando", "FUNCIONANDO");
		Log.w("avisando", "===========================");
	}

}
