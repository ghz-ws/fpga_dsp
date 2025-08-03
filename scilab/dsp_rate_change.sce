clc
clear
clf

Fs=1000;    //sample freq.
L=1000;     //Length of signal
Freq=100;   //signal freq
rate=2;     //decimate/interpolate rate

t=0:1/Fs:(L-1)/Fs;  //time vector
f=Fs*(0:(L/2))/L;   //freq vector. freq res.=Fs/L*n. n=0-N/2
n=length(f);        //length of freq

x1(1,:)=sin(2*%pi*Freq*t);  //generate original signal
y1=fft(x1(1,1:length(t)));

for i=1:L/rate
    x2(1,i*rate:i*rate+rate-1)=x1(1,i*rate-(rate-1));  //gen. decimated signal
end
y2=fft(x2(1,1:length(t)));

Fsi=Fs*rate;    //upsampled freq.
Li=L*rate;
ti=0:1/Fsi:(Li-1)/Fsi;
fi=Fsi*(0:(Li/2))/Li;
ni=length(fi); //length of freq
x3=zeros(1,Li)
for i=1:L
    x3(1,i*rate-(rate-1))=x1(1,i);  //gen. interpolated signal
end
y3=fft(x3(1,1:length(ti)));

subplot(2,3,1)
plot(t,x1(1,1:length(t)),"o-","thickness",2)
xgrid()
title("Original signal","fontsize",5)
xlabel("Time [s]","fontsize",5)
ylabel("Amplitude","fontsize",5)
g1=gca();   //get axis object
g1.data_bounds(:,1)=[0;2/Freq];   //y axis scale
g1.data_bounds(:,2)=[-1.2;1.2];   //y axis scale
g1.font_size=5

subplot(2,3,2)
plot(t,x2(1,1:length(t)),"o-","thickness",2)
xgrid()
title("Decimated signal","fontsize",5)
xlabel("Time [s]","fontsize",5)
ylabel("Amplitude","fontsize",5)
g2=gca();   //get axis object
g2.data_bounds(:,1)=[0;2/Freq];   //y axis scale
g2.data_bounds(:,2)=[-1.2;1.2];   //y axis scale
g2.font_size=5

subplot(2,3,3)
plot(ti,x3(1,1:length(ti)),"o-","thickness",2)
xgrid()
title("Interpolated signal","fontsize",5)
xlabel("Time [s]","fontsize",5)
ylabel("Amplitude","fontsize",5)
g3=gca();   //get axis object
g3.data_bounds(:,1)=[0;2/Freq];   //y axis scale
g3.data_bounds(:,2)=[-1.2;1.2];   //y axis scale
g3.font_size=5

subplot(2,3,4)
plot(f,20*log10(abs(y1(1:n))),"thickness",2)
xgrid()
xlabel("Freq [Hz]","fontsize",5)
ylabel("Amplitude [dB]","fontsize",5)
g4=gca();   //get axis object
g4.data_bounds(:,2)=[0;60];    //y axis scale
g4.font_size=5

subplot(2,3,5)
plot(f,20*log10(abs(y2(1:n))),"thickness",2)
xgrid()
xlabel("Freq [Hz]","fontsize",5)
ylabel("Amplitude [dB]","fontsize",5)
g5=gca();   //get axis object
g5.data_bounds(:,2)=[0;60];    //y axis scale
g5.font_size=5

subplot(2,3,6)
plot(fi,20*log10(abs(y3(1:ni))),"thickness",2)
xgrid()
xlabel("Freq [Hz]","fontsize",5)
ylabel("Amplitude [dB]","fontsize",5)
g6=gca();   //get axis object
g6.data_bounds(:,2)=[0;60];    //y axis scale
g6.font_size=5
