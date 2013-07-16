package keyboard;

import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

public class Keyboard {

	private EditText editText;
	private boolean initialized;
	private InputMethodManager imm;

	public Keyboard(EditText editText,InputMethodManager imm) {
		this.editText = editText;
		this.imm = imm;
		this.initialized = false;
	}

	public void init() {
		if (!this.initialized) {
			this.editText.setVisibility(View.VISIBLE);
			this.imm.toggleSoftInput(InputMethodManager.SHOW_FORCED,0);
			this.initialized = true;
		}else{
			throw new IllegalStateException("the keyboard is already initialized");
		}
	}

	public void finish() {
		if (this.initialized) {
			this.editText.setVisibility(View.VISIBLE);
			this.send();
			this.imm.hideSoftInputFromWindow(this.editText.getWindowToken(), 0);
			this.editText.setVisibility(View.INVISIBLE);
			this.initialized = false;
		}else{
			throw new IllegalStateException("the keyboard isn't initialized");
		}
	}

	public void send() {
		if(this.initialized){
			// TODO chamar método de felipe
		}else{
			throw new IllegalStateException("the keyboard is already initialized");
		}
	}
}
