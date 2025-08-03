clear
clc
clf

fc=0.2;     //cut-off freq
order=2;    //filter order
Type1='lp'; //filter type
Type2='butt';   //filter type

hz=iir(order,Type1,Type2,[fc 0],[0.1 0]);//design IIR filter
[hzm,fr]=frmag(hz,100);     //calc freq response
[del,frq]=group(100,hz);    //calc group delay
disp(hz)

subplot(2,2,1)
plot(fr,20*log10(hzm),"o-","thickness",2)
xgrid()
title("Freq response","fontsize",5)
xlabel("Normalized Freq","fontsize",5)
ylabel("Gain [dB]","fontsize",5)
g1=gca();   //get axis object
g1.data_bounds(:,1)=[0;0.5];    ///x axis scale
g1.data_bounds(:,2)=[-50;10];   //y axis scale
g1.font_size=5

subplot(2,2,2)
plot(frq,del,"o-","thickness",2)
xgrid()
title("Group delay","fontsize",5)
xlabel("Normalized Freq","fontsize",5)
ylabel("Delay [samples]","fontsize",5)
g2=gca();   //get axis object
g2.data_bounds(:,1)=[0;0.5];    ///x axis scale
g2.font_size=5

subplot(2,2,3)
plzr(hz);
xgrid()
title("fontsize",5)
xlabel("fontsize",5)
ylabel("fontsize",5)
g3=gca();   //get axis object
g3.data_bounds(:,1)=[-1.2;1.2];    ///x axis scale
g3.data_bounds(:,2)=[-1.2;1.2];   //y axis scale
g3.font_size=5
e3=gce();
e3.font_size=5

//calc step response
L=1000;  //signal length
t=0:1:L-1;
step=ones(1,L);
y1=flts(step,hz);

subplot(2,2,4)
plot(t,y1,"o-","thickness",2);
xgrid()
title("Step response","fontsize",5)
xlabel("Time [samples]","fontsize",5)
ylabel("Amplitude","fontsize",5)
g4=gca();   //get axis object
g4.data_bounds(:,1)=[0;1/fc*2];    ///x axis scale
g4.font_size=5
