package com.bjindustries.aeon;

import org.apache.commons.net.telnet.TelnetClient;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.ConcurrentLinkedQueue;

public class Telnet extends Thread {


	private SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd 'T' HH:mm:ss'Z'");
	private volatile List<String> _lines = Collections.synchronizedList(new ArrayList<>());

	private final TelnetClient _client;
	private volatile String _latestLine;

	public Telnet(TelnetClient client) {
		_client = client;
	}


	@Override
	public void run() {

		StreamTokenizer s = new StreamTokenizer(new InputStreamReader(_client.getInputStream()));
		s.resetSyntax();


		char[] separators = new char[]{'\n', 25, 0};

		setupSeparators(s, separators);
		s.eolIsSignificant(false);

		boolean running = true;
		while (running) {
			try {
				s.nextToken();
				if(s.ttype == StreamTokenizer.TT_WORD){
					final String line = s.sval.replaceAll("\uE006", "").replaceAll("\uE014", "").replaceAll("\uE002","").trim();
					if(line.length() > 0) {
//						System.out.println(format.format(new Date()) + " - " + line);
						_latestLine = line;
						_lines.add(line);
						if (_lines.size() > 20) {
							_lines.remove(0);
						}
					}
				}
				running = !Thread.interrupted();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		System.err.println("EXIT!!!");
	}

	private void setupSeparators(StreamTokenizer s, char[] separators) {
		Arrays.sort(separators);

		for(int i = 0; i < separators.length; i++){
			if(i == 0 && separators[i] != 0) {
				s.wordChars('\u0000', separators[i] - 1);
			}
			else if(separators[i] != 0){
				s.wordChars(separators[i - 1] + 1, separators[i] - 1);
			}
		}
		s.wordChars(separators[separators.length - 1] + 1, '\uEEEE');
	}


	public void write(String s) throws IOException {
		final OutputStream outputStream = _client.getOutputStream();
		outputStream.write((s + "\n").getBytes());
		outputStream.flush();
	}

	public List<String> getLines() {
		return _lines;
	}

	public void clear() {
		System.out.println("CLEARING!");
		_lines.clear();
		_lines = Collections.synchronizedList(new ArrayList<>());
	}

	public String latestLine(){
		return _latestLine;
	}
}
