package com.bjindustries.aeon;

import org.apache.commons.net.telnet.*;

import java.io.*;
import java.lang.reflect.InvocationTargetException;
import java.util.*;

public class Landing {


	public static class ShipData {

		@Expression("ship:altitude")
		private Double _altitude;

		@Expression("ship:airspeed")
		private Double _airSpeed;

		@Expression("ship:apoapsis")
		private Double _apoapsis;

		@Expression("TIME:SECONDS")
		private Double _gameSeconds;

		public Double getAltitude() {
			return _altitude;
		}

		public void setAltitude(Double altitude) {
			_altitude = altitude;
		}

		public Double getAirSpeed() {
			return _airSpeed;
		}

		public void setAirSpeed(Double airSpeed) {
			_airSpeed = airSpeed;
		}

		public Double getApoapsis() {
			return _apoapsis;
		}

		public void setApoapsis(Double apoapsis) {
			_apoapsis = apoapsis;
		}

		public Double getGameSeconds() {
			return _gameSeconds;
		}

		public void setGameSeconds(Double gameSeconds) {
			_gameSeconds = gameSeconds;
		}
	}


	public static class ShipUpdate{

		@Expression("lock steering to $value")
		private String steering;

		@Expression("lock throttle to $value")
		private Double throttle;

		public String getSteering() {
			return steering;
		}

		public void setSteering(String steering) {
			this.steering = steering;
		}

		public Double getThrottle() {
			return throttle;
		}

		public void setThrottle(Double throttle) {
			this.throttle = throttle;
		}
	}


	@Event("stage")
	public static class StageRequest{

	}

	private static final String selectionPrompt =
					"After attaching, you can (D)etach and return to this menu by pressing Control-D\n" +
					"as the first character on a new command line.)\n" +
					"--------------------------------------------------------------------------------";

	private static TelnetClient _client;
	private static BufferedReader _reader;


	public static void main(String[] args) throws IOException, InvalidTelnetOptionException, InterruptedException, IllegalAccessException, InstantiationException, InvocationTargetException, NoSuchMethodException {

		System.out.println("AEON LANDING SYSTEM");
		System.out.println("");
		System.out.println("Connecting to system...");


		_client = new TelnetClient();


		TerminalTypeOptionHandler ttopt = new TerminalTypeOptionHandler("VT100", false, false, true, false);
		EchoOptionHandler echoopt = new EchoOptionHandler(true, false, true, true);
		SuppressGAOptionHandler gaopt = new SuppressGAOptionHandler(true, true, true, true);
		WindowSizeOptionHandler naws_opt = new WindowSizeOptionHandler(90, 30, false, false, true, false);

		_client.addOptionHandler(ttopt);
		_client.addOptionHandler(echoopt);
		_client.addOptionHandler(gaopt);
		_client.addOptionHandler(naws_opt);
		_client.connect("127.0.0.1", 5410);

		Telnet telnet = new Telnet(_client);
		telnet.start();
		KOS k = new KOS(telnet);
		k.selectCpu("charlie");


		ShipData ship = k.fetch(ShipData.class);

		System.out.println("RESPONSE: " + ship.getAirSpeed());


		PID throttle = new PID(1,1,1);

		Runtime.getRuntime().addShutdownHook(new Thread(() -> {
			try {
				telnet.interrupt();
				telnet.join();
				_client.disconnect();
			} catch (IOException e) {
				e.printStackTrace();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		));

		while(true){
			long start = System.currentTimeMillis();

			ShipData data = k.fetch(ShipData.class);
			ShipUpdate update = new ShipUpdate();

			if(data.getAltitude() < 1000){
				update.setThrottle(throttle.tick(data.getGameSeconds(), data.getAirSpeed(), ascentSpeed(data.getAltitude(), data.getApoapsis())));
			}
			else{
				update.setThrottle(1.);
			}
			update.setSteering("heading(90,60)");
			k.doUpates(update);

			System.out.println(System.currentTimeMillis() - start);
		}
	}



	public static Double ascentSpeed(Double altitude, Double apoapsis){
		return 100.;
	}


}
