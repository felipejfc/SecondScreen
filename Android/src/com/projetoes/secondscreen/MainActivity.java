package com.projetoes.secondscreen;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;

import com.projetoes.secondscreen.client.TCPClient;

public class MainActivity extends Activity {

	//private Keyboard keys;
	private TCPClient tcpClient;
	private String ip = "192.168.122.10";
	private Integer port = 1212;
	//private List<View> components;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		setupTCPClient();
		//setupKeyboard();
		//setupComponents();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		// getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	public void activiEvent(String toSend) {
		//tcpClient.send(toSend);
		//Toast.makeText(getApplicationContext(), toSend, Toast.LENGTH_SHORT).show();
	}

	
	public void pressButton(View view) {
		activiEvent((String) view.getTag());
	}

	/*public void keyboardOpen(View view) {
		setButtonsEnabled(false);
		keys.init();
		Button sendButton = (Button) this.findViewById(R.id.buttonSend);
		sendButton.setVisibility(View.VISIBLE);
	}

	private void setupKeyboard() {
		InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
		EditText textEditSend = (EditText) this.findViewById(R.id.send_edit);
		this.keys = new Keyboard(textEditSend, imm);
	}

	public void sendButton(View view) {
		keys.send();
		keys.finish();
		Button sendButton = (Button) this.findViewById(R.id.buttonSend);
		sendButton.setVisibility(View.INVISIBLE);
		sendButton.setAlpha(1);
		setButtonsEnabled(true);
	}

	private void setButtonsEnabled(boolean enabled) {
		float alpha = enabled ? 1f : 0.15f;
		for (View component : this.components) {
			component.setEnabled(enabled);
			component.setAlpha(alpha);
		}
	}

	private void setupComponents() {
		this.components = new LinkedList<View>();
		this.components.add(this.findViewById(R.id.buttonBack));
		this.components.add(this.findViewById(R.id.buttonExit));
		this.components.add(this.findViewById(R.id.buttonUp));
		this.components.add(this.findViewById(R.id.buttonDown));
		this.components.add(this.findViewById(R.id.buttonRight));
		this.components.add(this.findViewById(R.id.buttonLeft));
		this.components.add(this.findViewById(R.id.buttonEnter));
		this.components.add(this.findViewById(R.id.ch_down));
		this.components.add(this.findViewById(R.id.ch_up));
		this.components.add(this.findViewById(R.id.vol_down));
		this.components.add(this.findViewById(R.id.vol_up));
		this.components.add(this.findViewById(R.id.keyboard));
		this.components.add(this.findViewById(R.id.buttonRed));
		this.components.add(this.findViewById(R.id.buttonGreen));
		this.components.add(this.findViewById(R.id.buttonYellow));
		this.components.add(this.findViewById(R.id.buttonBlue));
	}
*/
	private void setupTCPClient() {
		tcpClient = TCPClient.getInstace();
		tcpClient.setIpAddr(ip);
		tcpClient.setPort(port);
	}
}
