package com.projetoes.secondscreen.client;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.net.Socket;

import android.util.Log;

/**
 * @author Felipe Jose
 */
public class TCPClient {
	protected Socket clientSocket = null;
	protected PrintStream outToServer;
	protected BufferedReader inFromServer;
	protected String ipAddr;
	protected Integer port;
	private static TCPClient instance;

	private TCPClient() {
	}
	
	public static TCPClient getInstace(){
		if(instance == null){
			instance = new TCPClient();
		}
		return instance;
	}

	public String getIpAddr() {
		return ipAddr;
	}

	public void setIpAddr(String ipAddr) {
		this.ipAddr = ipAddr;
	}

	public Integer getPort() {
		return port;
	}

	public void setPort(Integer port) {
		this.port = port;
	}

	/**
	 * Method that create the thread and sends the data
	 * 
	 * @param data
	 */
	public void send(String data) {
		Thread sendThread = new SendDataThread(data);
		sendThread.start();
	}

	/**
	 * Thread that send and receive data
	 * 
	 * @author Felipe Jose
	 */
	class SendDataThread extends Thread {

		String data;

		public SendDataThread(String data) {
			this.data = data;
		}

		@Override
		public void run() {
			// TODO callback method
			try {
				if (clientSocket == null) {
					clientSocket = new Socket(ipAddr, port);
					outToServer = new PrintStream(
							clientSocket.getOutputStream());
					inFromServer = new BufferedReader(new InputStreamReader(
							clientSocket.getInputStream()));
					clientSocket.setKeepAlive(true);
					Log.i("SecoundScreen", "Connected");
				}
			} catch (Exception e) {
				Log.e("SecoundScreen", e.getMessage());
			}
			outToServer.println(data);
			String dataRecv = "";
			while (dataRecv == null || dataRecv.length() < 1) {
				try {
					sleep(2000);
					System.out.println("Waiting for server response...");
					dataRecv = inFromServer.readLine();
				} catch (Exception e) {
					Log.e("SecoundScreen", e.getMessage());
				}
			}
			Log.i("SecoundScreen", "Response: " + dataRecv);
			try {
				finalize();
			} catch (Throwable e) {
				Log.e("SecoundScreen", e.getMessage());
			}
		}
	}
}