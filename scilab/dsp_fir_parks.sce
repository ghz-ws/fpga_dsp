clear
clc
clf

TAP=11
band1=[0 0.2];      //pass band
band2=[0.3 0.5];    //stop band
B=10;    //bit resolution

h=eqfir(TAP,[band1;band2],[1 0],[1 1]);//designe fir filter

//show coefficient
txt="";
for i=1:size(h)(2)-1
    tp=string(int(h(i)*2^B))+", ";
    txt=txt+tp;
end
txt=txt+string(int(h(size(h)(1))*2^B));
disp(txt);

[hm,fr]=frmag(h,200);   //calc freq response
[del,frq]=group(100,h); //calc group delay
del(1)=del(2);

subplot(1,3,1)
plot(h,"o-","thickness",2)    //plot impulse response
xgrid()
title("Impulse Response","fontsize",5)
xlabel("Time","fontsize",5)
ylabel("Amplitude","fontsize",5)
hp=gca();   //get axis object
hp.data_bounds(:,2)=[-0.5;0.5];   //y axis scale
hp.font_size=5

subplot(1,3,2)
plot(fr,20*log10(hm),"o-","thickness",2)  //plot freq response
xgrid()
title("Freq Response","fontsize",5)
xlabel("Normalized Freq","fontsize",5)
ylabel("Gain [dB]","fontsize",5)
gp=gca();   //get axis object
gp.data_bounds(:,1)=[0;0.5];    ///x axis scale
gp.data_bounds(:,2)=[-100;10];   //y axis scale
gp.font_size=5

subplot(1,3,3)
plot(frq,del,"o-","thickness",2)
xgrid()
title("Group Delay","fontsize",5)
xlabel("Normalized Freq","fontsize",5)
ylabel("Delay [samples]","fontsize",5)
gr=gca();   //get axis object
gr.data_bounds(:,1)=[0;0.5];    ///x axis scale
gr.data_bounds(:,2)=[0;TAP];   //y axis scale
gr.font_size=5
