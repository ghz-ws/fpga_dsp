clc
clear
clf

Fs=20000;   //sample freq.
L=10000;    //Length of signal
Freq=99;    //Signal freq.

t=0:1/Fs:(L-1)/Fs;    //time vector. 0-1
f=Fs*(0:(L/2))/L; //freq vector. freq res.=Fs/N*n. n=0-N/2
n=length(f) //length of freq vector

pure=sin(2*%pi*Freq*t); //pure signal
qzd8=round(pure*2^8);   //8bit quantized signal
qzd16=round(pure*2^16);   //16bit quantized signal
qzd24=round(pure*2^24);   //24bit quantized signal

win=window('hn',L)      //window func.
qzd8_sp=abs(fft(qzd8.*win));
qzd16_sp=abs(fft(qzd16.*win));
qzd24_sp=abs(fft(qzd24.*win));
peak8=max(20*log10(qzd8_sp));   //peak detect
peak16=max(20*log10(qzd16_sp)); //peak detect
peak24=max(20*log10(qzd24_sp)); //peak detect

plot('ln',f,20*log10(qzd8_sp(1:n))-peak8,f,20*log10(qzd16_sp(1:n))-peak16,f,20*log10(qzd24_sp(1:n))-peak24,"thickness",2)
legend("8 bits","16 bits","24 bits",1,"in_upper_right")
xgrid()
title("Quantized signal spectrum","fontsize",5)
xlabel("Freq [Hz]","fontsize",5)
ylabel("Amplitude [dB]","fontsize",5)
g1=gca();   //get axis object
g1.data_bounds(:,1)=[1;Fs/2];   //y axis scale
g1.data_bounds(:,2)=[-200;20];   //y axis scale
g1.font_size=5
e1=gce();
e1.font_size=5
