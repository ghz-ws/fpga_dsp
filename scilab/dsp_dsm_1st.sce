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
dac=0           //dac value
sigma=0     //sigma register value

for i=1:L
    delta=pure(1,i)-dac;    //means sigma in
    sigma=sigma+delta;      //means comparator in
    if sigma>0 then         //act as comparator
        dac=1;
        comp_out(1,i)=1;            //comparator out value
    else
        dac=-1;
        comp_out(1,i)=-1;           //also zero
    end
end

win=window('hn',L)      //window func.
pure_sp=abs(fft(pure.*win));
pdm_sp=abs(fft(comp_out.*win));

subplot(1,2,1)
plot(t,pure,t,comp_out,"thickness",2)
legend("Pure signal","PDM",1,"in_upper_right")
xgrid()
title("Time domain","fontsize",5)
xlabel("Time [s]","fontsize",5)
ylabel("Amplitude","fontsize",5)
g1=gca();   //get axis object
g1.data_bounds(:,1)=[0;1/Freq];   //y axis scale
g1.data_bounds(:,2)=[-1.5;1.5];   //y axis scale
g1.font_size=3
e1=gce();
e1.font_size=5

subplot(1,2,2)
plot('ln',f,20*log10(pure_sp(1:n)),f,20*log10(pdm_sp(1:n)),"thickness",2)
legend("Pure signal","PDM",1,"in_lower_left")
xgrid()
title("Spectrum","fontsize",5)
xlabel("Freq [Hz]","fontsize",5)
ylabel("Amplitude [dB]","fontsize",5)
g2=gca();   //get axis object
g2.data_bounds(:,1)=[1;Fs/2];   //y axis scale
g2.data_bounds(:,2)=[-80;max(20*log10(pure_sp))];   //y axis scale
g2.font_size=3
e2=gce();
e2.font_size=5
