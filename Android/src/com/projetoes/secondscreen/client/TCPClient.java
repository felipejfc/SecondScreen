package com.projetoes.secondscreen.client;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.net.UnknownHostException;

class TCPClient {
	
	protected Socket clientSocket;
	protected PrintWriter outToServer;
	protected BufferedReader inFromServer;
	
	public TCPClient(String ipAddr, int port) {
		//TODO Aprender a lidar com as excessões
		try {
			this.clientSocket = new Socket(ipAddr, port);
			outToServer = new PrintWriter(clientSocket.getOutputStream(),true);
			inFromServer = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
		} catch (UnknownHostException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	class SendDataThread extends Thread{
		
		String data;
		
		public SendDataThread(String data) {
			this.data = data;
		}
		
		@Override
		public void run() {
			outToServer.print(data);
		}
	}
	
	public void send(String data){
		Thread sendThread = new SendDataThread(data);
		sendThread.start();
	}	

}
