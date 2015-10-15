package com.bjindustries.aeon;

public class PID {

	double Kp,Ki,Kd,oldI,oldP,lastTime,input;

	public PID(double Kp, double Ki, double Kd)
	{
		this.Kp=Kp;
		this.Ki=Ki;
		this.Kd=Kd;
	}

	public double tick(double now, double currentOutput, double targetOutput)
	{
		if(now == lastTime) return input;
		double dT = now-lastTime;
		double P = targetOutput - currentOutput;
		double D = (P - oldP)/dT;
		double I = (oldI + P)*dT;
		input = Kp*P + Ki*I + Kd*D;
		if(lastTime == 0) input = 0;
		lastTime = now;
		oldP = P;
		oldI = I;
		return input;
	}

}
