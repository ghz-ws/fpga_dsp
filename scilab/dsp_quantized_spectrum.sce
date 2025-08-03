clc
clear
clf

Fs=1000;   //sample freq.
L=1000;    //Length of signal
Freq=49;    //Signal freq.
B=8         //Bit resolution

t=0:1/Fs:(L-1)/Fs;    //time vector. 0-1
f=Fs*(0:(L/2))/L; //freq vector. freq res.=Fs/N*n. n=0-N/2
n=length(f) //length of freq vector

pure=sin(2*%pi*Freq*t)*2^B; //pure signal
qzd=round(pure);              //quantized signal
err=pure-qzd;               //quantization error

win=window('hn',L)      //window func.
pure_sp=abs(fft(pure.*win));
qzd_sp=abs(fft(qzd.*win));
err_sp=abs(fft(err.*win));
peak=max(20*log10(pure_sp));    //peak detect

subplot(1,3,1)
plot(f,20*log10(pure_sp(1:n))-peak,"thickness",2)
xgrid()
title("Pure signal spectrum","fontsize",5)
xlabel("Freq [Hz]","fontsize",5)
ylabel("Amplitude [dB]","fontsize",5)
g1=gca();   //get axis object
g1.data_bounds(:,1)=[0;Fs/2];   //y axis scale
g1.data_bounds(:,2)=[-200;0];   //y axis scale
g1.font_size=5

subplot(1,3,2)
plot(f,20*log10(qzd_sp(1:n))-peak,"thickness",2)
xgrid()
title("Quantized signal spectrum","fontsize",5)
xlabel("Freq [Hz]","fontsize",5)
ylabel("Amplitude [dB]","fontsize",5)
g1=gca();   //get axis object
g1.data_bounds(:,1)=[0;Fs/2];   //y axis scale
g1.data_bounds(:,2)=[-200;0];   //y axis scale
g1.font_size=5

subplot(1,3,3)
plot(f,20*log10(err_sp(1:n))-peak,"thickness",2)
xgrid()
title("Quantized noise spectrum","fontsize",5)
xlabel("Freq [Hz]","fontsize",5)
ylabel("Amplitude [dB]","fontsize",5)
g1=gca();   //get axis object
g1.data_bounds(:,1)=[0;Fs/2];   //y axis scale
g1.data_bounds(:,2)=[-200;0];   //y axis scale
g1.font_size=5
