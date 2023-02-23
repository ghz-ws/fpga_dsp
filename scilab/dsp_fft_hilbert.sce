clear
clc
clf

Fs=1000     //Sampling frequency
L=1000;     //Length of signal
Freq=100;   //signal freq

//gen. time vector and waves
t=0:1/Fs:L/Fs;  //time vector. 0-1
x=sin(2*%pi*Freq*t+%pi);

//hilbert transfer
re1=real(hilbert(x))
im1=imag(hilbert(x))

//fft and ifft transfer
f=Fs*(0:(L/2))/L; //freq vector. freq res.=Fs/N*n. n=0-N/2
n=length(f) //length of freq
y=fft(x);
y1=fft(re1);
y2=fft(im1);
comp=ifft(y(1:n));  //extract (1:n) means 1+sign(f)
re2=real(comp);
im2=imag(comp);
for i=1:L/2
    td(1,i)=t(i*2);    //decimated time vector
end

subplot(2,2,1)
plot(t,re1,"o-",t,im1,"o-")
xgrid()
legend("Re", "Im", 1)
title("Hilbert transform","fontsize",5)
xlabel("Time [s]","fontsize",5)
ylabel("Amplitude","fontsize",5)
g2=gca();   //get axis object
g2.data_bounds(:,1)=[0;5/Freq];    //x axis scale
g2.data_bounds(:,2)=[-1.2;1.2];   //y axis scale
g2.font_size=5
e2=gce();
e2.font_size=5

subplot(2,2,2)
plot(td,re2(1:length(td)),"o-",td,im2(1:length(td)),"o-")
xgrid()
legend("Re", "Im", 1)
title("FFT/IFFT Hilbert transform","fontsize",5)
xlabel("Time [s]","fontsize",5)
ylabel("Amplitude","fontsize",5)
g3=gca();   //get axis object
g3.data_bounds(:,1)=[0;5/Freq];    //x axis scale
g3.data_bounds(:,2)=[-1.2;1.2];   //y axis scale
g3.font_size=5
e3=gce();
e3.font_size=5

subplot(2,2,3)
plot(f,20*log10(abs(y1(1:n))),f,20*log10(abs(y2(1:n))))
xgrid()
legend("Re", "Im", 1)
title("Amplitude spectrum","fontsize",5)
xlabel("Freq [Hz]","fontsize",5)
ylabel("Amplitude [dB]","fontsize",5)
g5=gca();   //get axis object
g5.data_bounds(:,1)=[0;Fs/2];    //x axis scale
g5.data_bounds(:,2)=[-50;50];   //y axis scale
g5.font_size=5
e5=gce();
e5.font_size=5

subplot(2,2,4)
plot(f,atan(imag(y1(1:n)),real(y1(1:n)))*180/%pi,f,atan(imag(y2(1:n)),real(y2(1:n)))*180/%pi)
xgrid()
legend("Re", "Im", 1)
title("Phase spectrum","fontsize",5)
xlabel("Freq [Hz]","fontsize",5)
ylabel("Phase [degree]","fontsize",5)
g6=gca();   //get axis object
g6.data_bounds(:,1)=[0;Fs/2];    //x axis scale
g6.data_bounds(:,2)=[-180;180];   //y axis scale
g6.font_size=5
e6=gce();
e6.font_size=5
