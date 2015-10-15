package com.bjindustries.aeon;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

public class KOS {

	private final Telnet _telnet;

	public KOS(Telnet telnet) {
		_telnet = telnet;
	}



	public void selectCpu(String cpuName) throws InterruptedException, IOException {
		while(!_telnet.getLines().stream().anyMatch(x -> x.contains("Choose a CPU to attach to by typing a selection"))){
			Thread.sleep(100);
		}
		String cpuLine = _telnet.getLines().stream().filter(x -> x.contains(cpuName)).findFirst().get();
		String number  = cpuLine.split("\\]")[0].replaceAll("\\[", "");
		_telnet.write(number);
	}


	public <T> T fetch(Class<T> data) throws IOException, InstantiationException, IllegalAccessException, InvocationTargetException {
		String lastLine = _telnet.latestLine();
		_telnet.write(new RequestSerializer().createRequest(data));

		String response = null;
		while(response == null){
			String latestLine = _telnet.latestLine();
			if(lastLine != latestLine && latestLine.startsWith("[")){
				response = latestLine;
			}
		}
		return new RequestSerializer().fromRequest(data, response);
	}

	public void doUpates(Object update) throws IllegalAccessException, NoSuchMethodException, InvocationTargetException, IOException {
		String lastLine = _telnet.latestLine();
		_telnet.write(new RequestSerializer().createUpdate(update));

//		String response = null;
//		while(response == null){
//			String latestLine = _telnet.latestLine();
//			if(lastLine != latestLine && latestLine.equals("OK")){
//				response = latestLine;
//			}
//		}
	}

	public void doEvent(Class<?> event) throws IllegalAccessException, NoSuchMethodException, InvocationTargetException, IOException {
		String lastLine = _telnet.latestLine();
		_telnet.write(new RequestSerializer().createEvent(event));

		String response = null;
		while(response == null){
			String latestLine = _telnet.latestLine();
			if(lastLine != latestLine && latestLine.equals("OK")){
				response = latestLine;
			}
		}
	}
}
