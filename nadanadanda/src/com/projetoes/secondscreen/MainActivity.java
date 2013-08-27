package com.projetoes.secondscreen;

import java.util.LinkedList;
import java.util.List;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Vibrator;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.Toast;

import com.projetoes.secondscreen.client.TCPClient;
import com.projetoes.secondscreen.keyboard.Keyboard;

@SuppressLint("NewApi")
public class MainActivity extends Activity {

	private Keyboard keys;
	private TCPClient tcpClient;
	private Integer port = 1212;
	private Vibrator vibe;
	private final static String err = "Could not establish connection with the IP ";
	private List<View> components;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		vibe = (Vibrator) MainActivity.this.getSystemService(Context.VIBRATOR_SERVICE);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		setupTCPClient();
		setupKeyboard();
		setupComponents();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		// getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	public  void  connectFailureNotify()
	{
		
		Toast.makeText(getApplicationContext(), err+ tcpClient.getIpAddr(), Toast.LENGTH_SHORT).show();
		new Handler().postDelayed(new Runnable() {
			@Override
			public void run() {
				Intent mainIntent = new Intent(MainActivity.this,
				ConnectActivity.class);
				MainActivity.this.startActivity(mainIntent);
				MainActivity.this.finish();
			}
		}, 5000);
		
	}

	public void pressButton(View view) {
		tcpClient.send((String) view.getTag());
//		if (tcpClient.getRetorno().equals("IOException")){
//			connectFailureNotify();
//			Log.e("MainActivity", tcpClient.getRetorno());
//		}
//		else if (tcpClient.getRetorno().equals("key")){
//			
//			Log.i("KeyBoard", tcpClient.getRetorno());
//			keyboardOpen();
//		}
//		Log.i("MainActivity", tcpClient.getRetorno());
		vibe.vibrate(50);
		
	}

	public void keyboardOpen() {
		try {
		this.findViewById(R.id.textToSend).setEnabled(true);
		this.findViewById(R.id.textToSend).setVisibility(View.VISIBLE);
		this.findViewById(R.id.sendText).setEnabled(true);
		this.findViewById(R.id.sendText).setVisibility(View.VISIBLE);
		setButtonsEnabled(false);
		keys.init();
		}catch (Exception e)
	{
			Log.e("OpenKey", e.getMessage());
	}
	}

	private void setupKeyboard() {
		InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
		EditText textEditSend = (EditText) this.findViewById(R.id.textToSend);
		textEditSend.setEnabled(false);
		textEditSend.setVisibility(View.INVISIBLE);
		this.findViewById(R.id.sendText).setEnabled(false);
		this.findViewById(R.id.sendText).setVisibility(View.INVISIBLE);
		this.keys = new Keyboard(textEditSend, imm);
	}

	public void sendButton(View view) {
		try{
		keys.send();
		keys.finish();
		this.findViewById(R.id.sendText).setVisibility(View.INVISIBLE);
		this.findViewById(R.id.textToSend).setVisibility(View.INVISIBLE);
		setButtonsEnabled(true);
		}catch(Exception e){
			Log.e("sendButton", e.getMessage());
		}
	}

	private void setButtonsEnabled(boolean enabled) {
		float alpha = enabled ? 1f :0.15f ;
		for (View component : this.components) {
			component.setEnabled(enabled);
			component.setAlpha(alpha);
		}
	}

	private void setupComponents() {
		this.components = new LinkedList<View>();
		this.components.add(this.findViewById(R.id.bt_0));
		this.components.add(this.findViewById(R.id.bt_1));
		this.components.add(this.findViewById(R.id.bt_2));
		this.components.add(this.findViewById(R.id.bt_3));
		this.components.add(this.findViewById(R.id.bt_4));
		this.components.add(this.findViewById(R.id.bt_5));
		this.components.add(this.findViewById(R.id.bt_6));
		this.components.add(this.findViewById(R.id.bt_7));
		this.components.add(this.findViewById(R.id.bt_8));
		this.components.add(this.findViewById(R.id.bt_9));
		this.components.add(this.findViewById(R.id.bt_100));
		this.components.add(this.findViewById(R.id.bt_less));
		this.components.add(this.findViewById(R.id.bt_back));
		this.components.add(this.findViewById(R.id.bt_blue));
		this.components.add(this.findViewById(R.id.bt_ch_down));
		this.components.add(this.findViewById(R.id.bt_ch_up));
		this.components.add(this.findViewById(R.id.bt_cursor_down));
		this.components.add(this.findViewById(R.id.bt_cursor_left));
		this.components.add(this.findViewById(R.id.bt_cursor_ok));
		this.components.add(this.findViewById(R.id.bt_cursor_right));
		this.components.add(this.findViewById(R.id.bt_cursor_up));
		this.components.add(this.findViewById(R.id.bt_exit));
		this.components.add(this.findViewById(R.id.bt_green));
		this.components.add(this.findViewById(R.id.bt_input));
		this.components.add(this.findViewById(R.id.bt_mute));
		this.components.add(this.findViewById(R.id.bt_red));
		this.components.add(this.findViewById(R.id.bt_vol_down));
		this.components.add(this.findViewById(R.id.bt_vol_up));
		this.components.add(this.findViewById(R.id.bt_yellow));
		this.components.add(this.findViewById(R.id.img_channel));
		this.components.add(this.findViewById(R.id.img_volume));
	}

	private void setupTCPClient() {
		tcpClient = TCPClient.getInstace();
		tcpClient.setPort(port);
	}
}
