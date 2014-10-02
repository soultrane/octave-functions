% Eric Carmi
% EEE 122
% Exercise 1


%{
					Part A_1.a
	
  A discrete-time electrocardiogram (ECG) signal will be synthesized. 
  An ECG consists of a P-wave, followed by a QRS-complex, and ends with a T-wave.
  The waves will be created in the form of a simple, ideal case consisting of three sine waves.
  All signals will be expressed in terms of millivolts (mV) for amplitude and Hertz (Hz) for frequency. 

%}

% In lines 19:24 the essential variables that will be used are created. 

fs = 200;			% Sample rate of 200 Hz
Ts = 1/fs;			% Sample period of 0.005 seconds
n = linspace(0,1200-1,1200);	% Discrete-time sample vector
Te = 1.5;			% Period of one ECG; 1.5 seconds
Tr = 6;				% Recording length of 6 seconds to make 4 periods of the ECG
t = n*Ts;			% Discrete-time index vector in seconds, to make the code look nicer.

% The ECG is synthesized in lines 28:35			 	 
%								 Ampl  ; Freq
Pwave = 0.2*sin(2*pi*t*5);	% P wave of the ECG: 		0.2 mV ; 5 Hz
QRScomplex = sin(2*pi*t*10);	% QRS-complex of the ECG	1.0 mV ; 10 Hz
Twave = 0.5*sin(2*pi*t*2.5);	% T wave of the ECG		0.5 mV ; 2.5 Hz

s = zeros(size(n));		% Initialize the ECG signal as a zero vector
s(121:140) = Pwave(1:20);	% P wave occurs between 0.6 and 0.7 seconds
s(161:170) = QRScomplex(1:10);	% QRS complex between 0.8 and 0.85 seconds
s(201:240) = Twave(1:40);	% T wave occurs between 1.0 and 1.2 seconds


% The following code in lines x:x concatente the first 300 samples of s(n) to extend the ECG's length.
% A length of 1.5 seconds is equivalent to 300 discrete time values, which is equal to fs*Te. Adding three
% copies of the ECG creates four periods of the ECG, for a total length of 6 seconds.	

s(fs*Te*1+1:fs*Te*2) = s(1:fs*Te); 
s(fs*Te*2+1:fs*Te*3) = s(1:fs*Te);	
s(fs*Te*3+1:fs*Te*4) = s(1:fs*Te);	 


% 					Part A_1.b,c

%{

 The following code in lines 58:59 computes the average value of s(n). Due to the fact that this signal was 
 initially synthesized with values greater than or equal to 0, s(n) has a positive average value. As an analog 
 to physical electronics, a positive average value in a signal comes from a positive DC offset voltage. 
 This DC offset will be removed by calculating the average value of s(n) and then subtracting that value
 from s(n).

%}

s_navg = sum(s(1:300))/length(s(1:300))		# Average value of the ECG: 0.071936.
s_0 = s - s_navg;				# Create the zero-average ECG signal.


%{

  Noise is a common issue that arises when measuring a real ECG. One common type of noise, which can be found in
  in any room that is connected to the power grid, is resemblant of a 60 Hz sine wave.This 60 Hz contamination
  signal comes from anything connected to an electrical outlet, since out power grid operates at a standard 
  frequency of 60 Hz. Another potential source of noise is a slowly varying sine wave, which will be referred to 
  as baseline drift. Baseline drift can occur if there is some motion in the arm of the person who is wearing
  the electrodes that is measuring the ECG. 

%}

%					Part A_1.d,e,f,g

c = 0.35 * sin(2*pi*t*60);	% Create 60 Hz contamination signal, c(n).
d = 0.50 * sin(2*pi*t*0.5);	% Create 0.5 Hz baseline drift signal, d(n).
noise = c + d;			% Create a single vector of "noise".
x = s_0 + noise;		% Noisy ECG signal x(n).


%					Part A_1.h

% Graphical displays of 60 Hz noise (top left), baseline drift (top right), zero-average ECG (bottom left) and 
% the contaminated ECG (bottom right) are computed in lines x:x and can be seen in Appendix A.1.
% Time (horizontal) values range from 0 to 6 seconds; voltage (vertical) values range from -1.7 mV to 1.7 mV

% Plot of the 60 Hz noise
figure(1);
subplot(2,2,1);
plot(t,c);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('60 Hz Contamination');
axis([0 6 -1.7 1.7]);

% Plot of the baseline drift

subplot(2,2,2);
plot(t,d);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('Baseline Drift');
axis([0 6 -1.7 1.7]);

% Plot of the zero-average ECG

subplot(2,2,3);
plot(t,s_0);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('Zero Average Pure ECG Signal');
axis([0 6 -1.7 1.7]);

% Plot of the noisy ECG 

subplot(2,2,4);
plot(t,x);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('Noisy ECG Signal');
axis([0 6 -1.7 1.7]);


%						Part A_2.a,b,c,d						

%{

  In order to analyze the ECG signal, RMS values of the discrete-time signals are calculated in the 
  following x lines. The continuous RMS values were calculated by hand, and can be seen in Appendix B.1

%}

s_0_nrms = sqrt(sum(s_0.^2)/length(s_0))	% DT:0.17173	CT: 

c_nrms = sqrt(sum(c.^2)/length(c)) 		% DT:0.24749	CT:

d_nrms = sqrt(sum(d.^2)/length(d)) 		% DT:0.35355	CT:

noise_nrms = sqrt(sum(noise.^2)/length(noise))	% DT:0.43157	CT:


% 						Part A_3.a

%{

  The percent RMS error in x(n) is the ratio of noise to the pure ECG signal, multiplied by 100. 
  A large value of RMS error in x(n) is not desired, as it implies a strong presence of noise.
  Alternatively, the signal-to-noise ratio (SNR) would ideally be a large number, to imply that the signal is 
  more present than the noise. The decibel (dB) level of the SNR is also calculated. These values can be seen 
  below in linse 161:163.
	
%}

RMSE_x = (noise_nrms/s_0_nrms)*100 	% 251.30 percent error in x(n)
SNR_x = (s_0_nrms.^2)/(noise_nrms.^2)	% Signal to noise ratio: 0.15835
SNR_dB_x = 10*log10(SNR_x) 		% SNR decibel level of -8.0039 dB


% 						Part B_1.a

%{

  Filters can be used to remove unwanted noise or artifacts from a signal. The noisy, zero-average ECG has 
  two sources of noise. Because the frequencies contained in the ECG signal that need to be maintained are 
  above the frequency of the baseline drift, but below the frequency of the 60 Hz noise, a bandpass 
  filter (BPF) will be used. A BPF can be constructed by cascading a lowpass filter (LPF) with a highpass 
  filter (HPF).

  The filters were originally designed as first-order continuous-time filters. The continuous-time 
  differential equations that describe the LPF and HPF were converted to discrete-time difference 
  equations  and the difference equations will be implemented in 'for loops' to compute the output values 
  of the signals after being passed through the filters. The LPF was deisgned to have a cutoff frequency 
  of 30 Hz, and the HPF was designed to have a cutoff frequency of 1 Hz.

%}

% Lines 187:189 calculate the filter coefficient for the HPF's cutoff frequency and initialize the output
% values for the signals that will be used to evaluate the HPF's efficiency.

Ahp = 2*pi;		% Highpass filter coefficient
s_0hp(1) = 0;		% Initial condition
dhp(1) = 0;		% Initial condition: dhp is the output of the baseline
			% drift after going through the HP filter 

% The following for loop calculates the values of s_0(n) and d(n) after applying the HPF.
% The signal s_0hp(n) is what results after passing s_0(n) through the HPF, and dhp(n) is the signal 
% corresponding to the baseline drift after being passed through the HPF.

for k = 2:1200
    s_0hp(k) = (1/(1+Ts*Ahp))*(s_0hp(k-1) + s_0(k) - s_0(k-1));
    dhp(k) = (1/(1+Ts*Ahp))*(dhp(k-1) + d(k) - d(k-1));
end

%						Part B_1.b,c

% In order to evaluate the HPF's efficiency, RMS values of dhp(n) and s_0hp(n) are calculated in lines 206:209
% The percentage expresses the amount of each signal that is still present after the HPF is applied. The 
% baseline drift appears to be reduced by more than half, but the pure ECG signal seems to have been degradated
% by the HPF. 

dhp_nrms = sqrt(sum(dhp.^2)/length(dhp));			
RMSE_dhp = dhp_nrms/d_nrms * 100				# 43.110%
er1 = s_0hp - s_0;
RMSE_s_0hp = (sqrt(sum(er1.^2)/length(er1))) / s_0_nrms * 100 	# 44.288%

%						Part B_1.d

% Plots of the zero average ECG before and after the HPF is applied are produced in lines 215:229, and can be
% seen in Appendix B.2

figure(2);

% Plot of the zero average ECG.
subplot(2,2,1);
plot(t,s_0);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('Zero Average ECG');
axis([0 6 -.4 1]);

% Plot of the zero average ECG after applying the HPF.
subplot(2,2,2);
plot(t,s_0hp);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('Zero average ECG after HPF');
axis([0 6 -.4 1]);

% The HPF causes the end of each component of s(n) to fall after each wave has finished its cycle,
% followed by what appears to be a logarihtmic increase until the next wave begins. There is also a slight 
% descrease in amplitude for the P, QRS and T waves, but the amplitude decrease is more present in the P wave.

% 						Part B_2.a

% Lines 240:242 calculate the filter coefficient for the LPF's cutoff frequency and initialize the output
% values for the signals that will be used to evaluate the LPF's efficiency.

Alp = 2*pi*30;
s_0lp(1)=0;
clp(1)=0;

% The following for loop calculates the values of s_0(n) and c(n) after applying the LPF. The signal s_0lp(n)
% is the signal after passing s_0(n) through the LPF, and clp(n) is the signal corresponding to the 60 Hz 
% contamination, c(n), after being passed through the LPF. 

for k = 2:1200
    s_0lp(k) = (1/(1+Alp*Ts))*(s_0lp(k-1) + Ts*Alp*s_0(k));
    clp(k) = (1/(1+Alp*Ts))*(clp(k-1) + Ts*Alp*c(k));
end 

%						Part B_2.b,c

% In order to evaluate the LPF's efficiency, RMS values of clp(n) and s_0lp(n) are calculated in lines x:x
% The percentage expresses the amount of each signal that is still present after the HPF is applied. The 
% 60 Hz contamination appears to be reduced more than the HPF reduced the baseline drift, but the pure ECG 
% signal was not retained very well after being passed through the LPF.				

clp_nrms = sqrt(sum(clp.^2)/length(clp));
RMSE_clp = clp_nrms/c_nrms * 100				# 38.568%
er2 = s_0lp - s_0; 
RMSE_s_0lp = (sqrt(sum(er2.^2)/length(er2))) / s_0_nrms * 100	# 21.111%

% The low pass filter appears to distort the shape of s_0(n) more than the high pass filter did in terms of the 
% RMS error. However, the graphical representation of s_0lp(n) only appears to reduce the amplitude of the 
% QRS wave as well as causing the end of each individual wave of the ECG to smoothly transition to a steady 
% value, which is different than the initially abrupt end to each wave of the ECG.

%						Part B_2.d			

% Plots of the zero average ECG before and after the low pass filter is applied are produced in lines 266:278 
% and can be viewed in Appendix B.2


subplot(2,2,3);
plot(t,s_0);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('Zero Average ECG');
axis([0 6 -.4 1]);

subplot(2,2,4);
plot(t,s_0lp);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('Zero Average ECG after LPF');
axis([0 6 -.4 1]);

%						Part B_3.a

% The BPF can be applied by cascading the LPF and HPF together. 
% The signal xbp(n) is the noisy ECG after the BPF is applied. 

x1(1) = 0;		% Initial value of the output of the LPF, which will be the input to the HPF.
xbp(1) = 0;		% Initial value of the output of the HPF, the ECG after BPF is applied.

% The following for loop cascades the LPF and HPF to make the BPF.

for k = 2:1200
    x1(k) = (1/(1+Alp*Ts))*(x1(k-1) + Ts*Alp*x(k));
    xbp(k) = (1/(1+Ts*Ahp))*(xbp(k-1) + x1(k) - x1(k-1));
end


% To evaluate the efficiency of the BPF, the error between xbp(n) and s_0(n) is calculated. This error is then
% used to compute the RMS error, SNR, and SNR dB level of xbp(n). 

er3 = xbp - s_0;
xbp_noise_nrms = sqrt(sum(er3.^2)/length(er3))		# 0.19146
RMSE_xbp = xbp_noise_nrms / s_0_nrms * 100		# 111.49%
SNR_xbp = (s_0_nrms.^2)/(xbp_noise_nrms.^2)		# 0.80451
SNR_xbp_dB = 10*log10(SNR_xbp)				# -0.9447 dB

% Compared to the initial values of x(n) before the BPF was applied (shown in lines x:x), the values calculated in 
% lines 292: 296 clearly show improvement in the quality of the noisy ECG signal. 
% Although noise is still present in xbp(n), the noise was greatly reduced by implementing the BPF. 

%						Part B_3.b

% In lines 311:340, four plots are computed, which can be seen in Appendix B.3. The top left graph is the noisy 
% ECG, the top right graph is the noisy ECG after the BPF is applied. The bottom left graph is the zero average
% ECG signal, and the bottom right graph displays the noisy ECG signal before and after the BPF is applied on 
% the same plot. 

figure(3);

subplot(2,2,1);
plot(t,x);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('Noisy ECG');
axis([0 6 -1.7 1.7]);


subplot(2,2,2);
plot(t,xbp);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('Noisy ECG after Band Pass Filter');
axis([0 6 -1.7 1.7]);

subplot(2,2,3);
plot(t,s_0);
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('Pure ECG signal');
axis([0 6 -1.7 1.7]);

subplot(2,2,4);
plot(t,xbp,'r',t,x,'g');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('Noisy ECG signal; Green:before BPF, Red:after BPF');
axis([0 6 -1.7 1.7]);

% 						Part B_4

% Filters reduce the noise we do not want, but they also distort the signal that we want to preserve. 
% This tradeoff is inherent in the filtering process.
