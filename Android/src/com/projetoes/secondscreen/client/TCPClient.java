package com.projetoes.secondscreen.client;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.net.Socket;

import android.util.Log;

/**
 * 
 * @author felipe
 *
 */
public class TCPClient{
	protected Socket clientSocket = null;
	protected PrintStream outToServer;
	protected BufferedReader inFromServer;
	protected String ipAddr;
	protected Integer port;
	public TCPClient(String ipAddr, int port) {
		this.ipAddr = ipAddr;
		this.port = port;
	}
	
	/**
	 * Thread that send and receive data
	 * @author felipe
	 *
	 */
	class SendDataThread extends Thread{
		
		String data;
		
		public SendDataThread(String data) {
			this.data = data;
		}
		
		@Override
		public void run() {
			//TODO callback method
			try{
				if(clientSocket == null){
					clientSocket = new Socket(ipAddr, port);
					outToServer = new PrintStream(clientSocket.getOutputStream());
					inFromServer = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
					clientSocket.setKeepAlive(true);
					Log.i("SecoundScreen", "Connected");
				}
			}catch(Exception e){
				Log.e("SecoundScreen", e.getMessage());
			}
			outToServer.println(data);
			String dataRecv = "";
			while(dataRecv.length()<1){
				try {
					sleep(2000);
					System.out.println("Waiting for server response...");
					dataRecv = inFromServer.readLine();
				} catch (Exception e) {
					Log.e("SecoundScreen", e.getMessage());
				}
			}
			Log.i("SecoundScreen", "Response: "+dataRecv);
			try {
				finalize();
			} catch (Throwable e) {
				Log.e("SecoundScreen", e.getMessage());
			}
		}
	}
	
	/**
	 * Method that create the thread and sends the data
	 * @param data
	 */
	public void send(String data){
		Thread sendThread = new SendDataThread(data);
		sendThread.start();
	}	

}

