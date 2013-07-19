package com.projetoes.secondscreen;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.projetoes.secondscreen.client.TCPClient;
import com.projetoes.secondscreen.keyboard.Keyboard;
import com.projetoes.secondscreen.keyboard.OnKeyClickListener;
import com.projetoes.secondscreen.keyboard.OnSendListener;

public class MainActivity extends Activity {

	private Keyboard keys;
	private TCPClient tcpClient;
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
		this.keys.send();
		this.keys.finish();
		Button buttonSend = (Button) this.findViewById(R.id.buttonSend);
		buttonSend.setVisibility(View.INVISIBLE);
		
		Button buttonAppear = (Button) this.findViewById(R.id.buttonAppear);
		buttonAppear.setEnabled(true);
		Log.w("aviso", "funcionando");
	}
	
	public void appearAction(View view) {
		if(this.keys == null){
			InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
			EditText textEditSend = (EditText) this.findViewById(R.id.editSend);
			this.keys = new Keyboard(textEditSend, imm);
			this.keys.addOnSendListener(new OnSendListener() {
				@Override
				public void warns(String text) {
					Log.w("funcionando", "============================");
					Log.w("funcionando", text);
					Log.w("funcionando", "============================");
				}
			});
			this.keys.addOnKeyClickListener(new OnKeyClickListener() {
				
				@Override
				public void warns(int keyCode) {
					Log.w("funcionando", "============================");
					Log.w("funcionando", Integer.toString(keyCode));
					Log.w("funcionando", "============================");
				}
			});
		}
		keys.init();

		Button buttonSend = (Button) this.findViewById(R.id.buttonSend);
		buttonSend.setVisibility(View.VISIBLE);
		
		Button buttonAppear = (Button) this.findViewById(R.id.buttonAppear);
		buttonAppear.setEnabled(false);
	}
	

	public void send2Action(View view){
		EditText ipPortBox = (EditText) findViewById(R.id.editIpPort);
		String ip = ipPortBox.getText().toString().split(":")[0];
		Integer port = Integer.parseInt(ipPortBox.getText().toString().split(":")[1]);
		tcpClient = new TCPClient(ip, port);

		String toSend = ((EditText)findViewById(R.id.editSend2)).getText().toString();
		tcpClient.send(toSend);
		Toast.makeText(getApplicationContext(), "Sent!", Toast.LENGTH_SHORT).show();
	}
	
}
