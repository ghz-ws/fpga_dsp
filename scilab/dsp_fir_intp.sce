clc
clear
clf

Fs=1000;    //sample freq.
L=1000;     //Length of signal
Freq=100;   //signal freq
rate=4;     //interpolate rate
TAP=11
B=10;       //filter bit resolution

fc=Fs/2/(Fs*rate)*0.5;
[h,hm,fr]=wfir('lp',TAP,[fc 0],'hm',[0 0]);   //design FIR filter

//show coefficient
txt="";
for i=1:size(h)(2)-1
    temp=string(int(h(i)*2^B))+",";
    txt=txt+temp;
end
txt=txt+string(int(h(size(h)(2))*2^B));
disp(txt);

//generate original signal
t=0:1/Fs:(L-1)/Fs;  //time vector
f=Fs*(0:(L/2))/L;   //freq vector. freq res.=Fs/L*n. n=0-N/2
n=length(f);        //length of freq
x1(1,:)=sin(2*%pi*Freq*t);  //original signal
y1=fft(x1(1,1:length(t)));

//generate interpolated signal
Fsi=Fs*rate;    //sample freq.
Li=L*rate;      //Length of signal
ti=0:1/Fsi:(Li-1)/Fsi;  //time vector
fi=Fsi*(0:(Li/2))/Li;   //freq vector. freq res.=Fs/L*n. n=0-N/2
ni=length(fi);          //length of freq
x2=zeros(1,Li)
for i=1:L
    x2(1,i*rate-(rate-1))=x1(1,i);  //interpolated signal
end
y2=fft(x2(1,1:length(ti)));

subplot(2,4,1)
plot(t,x1(1,1:length(t)),"o-","thickness",2)
xgrid()
title("Original signal","fontsize",5)
xlabel("Time [s]","fontsize",5)
ylabel("Amplitude","fontsize",5)
g1=gca();   //get axis object
g1.data_bounds(:,1)=[0;2/Freq];    //y axis scale
g1.data_bounds(:,2)=[-1.2;1.2];     //y axis scale
g1.font_size=5

subplot(2,4,2)
plot(ti,x2(1,1:length(ti)),"o-","thickness",2)
xgrid()
title("Interpolated signal","fontsize",5)
xlabel("Time [s]","fontsize",5)
ylabel("Amplitude","fontsize",5)
g2=gca();   //get axis object
g2.data_bounds(:,1)=[0;2/Freq];   //y axis scale
g2.data_bounds(:,2)=[-1.2;1.2];   //y axis scale
g2.font_size=5

subplot(2,4,5)
plot(f,20*log10(abs(y1(1:n))),"thickness",2)
xgrid()
xlabel("Freq [Hz]","fontsize",5)
ylabel("Amplitude [dB]","fontsize",5)
g3=gca();   //get axis object
g3.data_bounds(:,1)=[0;Fs/2];    //x axis scale
g3.data_bounds(:,2)=[-20;60];    //y axis scale
g3.font_size=5

subplot(2,4,6)
plot(fi,20*log10(abs(y2(1:ni))),"thickness",2)
xgrid()
//title("Zero padding","fontsize",5)
xlabel("Freq [Hz]","fontsize",5)
ylabel("Amplitude [dB]","fontsize",5)
g4=gca();   //get axis object
g4.data_bounds(:,1)=[0;Fsi/2];    //x axis scale
g4.data_bounds(:,2)=[-20;60];    //y axis scale
g4.font_size=5

subplot(1,4,4)
plot(fr,20*log10(hm),"o-","thickness",2)  //plot freq response
xgrid()
title("Freq Response","fontsize",5)
xlabel("Normalized Freq","fontsize",5)
ylabel("Gain [dB]","fontsize",5)
gp=gca();   //get axis object
gp.data_bounds(:,1)=[0;0.5];    ///x axis scale
gp.data_bounds(:,2)=[-100;10];   //y axis scale
gp.font_size=5

//process filter
sr=zeros(1,size(h)(2));
for i=1:Li
    sr=cat(2,x2(i),sr(1:size(h)(2)-1))
    out(1,i)=sum(h.*sr)*rate
end
y3=fft(out(1,1:length(ti)));

subplot(2,4,3)
plot(ti,out(1,1:length(ti)),"o-","thickness",2)
xgrid()
title("Filtered signal","fontsize",5)
xlabel("Time [s]","fontsize",5)
ylabel("Amplitude","fontsize",5)
g5=gca();   //get axis object
g5.data_bounds(:,1)=[0;2/Freq];   //y axis scale
g5.data_bounds(:,2)=[-1.2;1.2];   //y axis scale
g5.font_size=5

subplot(2,4,7)
plot(fi,20*log10(abs(y3(1:ni))),"thickness",2)
xgrid()
xlabel("Freq [Hz]","fontsize",5)
ylabel("Amplitude [dB]","fontsize",5)
g6=gca();   //get axis object
g6.data_bounds(:,1)=[0;Fsi/2];    //x axis scale
g6.data_bounds(:,2)=[-20;60];    //y axis scale
g6.font_size=5
