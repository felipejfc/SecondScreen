package com.projetoes.secondscreen.client;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.net.Socket;
import java.net.UnknownHostException;

/**
 * 
 * @author felipe
 *
 */
class TCPClient{
	protected Socket clientSocket;
	protected PrintStream outToServer;
	protected BufferedReader inFromServer;
	
	public TCPClient(String ipAddr, int port) {
		//TODO Aprender a lidar com as excessões
		try {
			clientSocket = new Socket(ipAddr, port);
			outToServer = new PrintStream(clientSocket.getOutputStream());
			inFromServer = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
		} catch (UnknownHostException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
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
			String dataRecv = "";
			while(dataRecv.length()<1){
				try {
					sleep(2000);
					System.out.println("here");
					dataRecv = inFromServer.readLine();
				} catch (Exception e) {
					//TODO como lidar com os erros?
					e.printStackTrace();
				}
			}
			System.out.println("Got "+dataRecv);
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

