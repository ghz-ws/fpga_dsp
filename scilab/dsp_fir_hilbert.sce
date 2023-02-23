clear
clc
clf

TAP=11
B=16;       //filter bit resolution

h=hilb(TAP);    //design hilbert filter
[hm,fr]=frmag(h,100);   //calc freq response
[del,frq]=group(100,h);     //calc group delay
del(1)=del(2);

//show coefficient
txt="";
for i=1:(size(h)(2)-1)/2
    temp=string(int(h(i+(size(h)(2)-1)/2)*2^B))+",";
    if temp~="0,"
        txt=txt+temp;
    end
end
txt=txt+string(int(h(size(h)(2))*2^B));
disp(txt);

subplot(1,3,1)
plot(h,"o-")    //plot impulse response
xgrid()
title("Impulse Response","fontsize",5)
xlabel("Time","fontsize",5)
ylabel("Amplitude","fontsize",5)
hp=gca();   //get axis object
hp.data_bounds(:,2)=[-1;1];   //y axis scale
hp.font_size=5

subplot(1,3,2)
plot(fr,20*log10(hm),"o-")  //plot freq response
xgrid()
title("Freq Response","fontsize",5)
xlabel("Normalized Freq","fontsize",5)
ylabel("Gain [dB]","fontsize",5)
gp=gca();   //get axis object
gp.data_bounds(:,1)=[0;0.5];    ///x axis scale
gp.data_bounds(:,2)=[-40;10];   //y axis scale
gp.font_size=5

subplot(1,3,3)
plot(frq,del,"o-")
xgrid()
title("Group Delay","fontsize",5)
xlabel("Normalized Freq","fontsize",5)
ylabel("Delay [samples]","fontsize",5)
gr=gca();   //get axis object
gr.data_bounds(:,1)=[0;0.5];    ///x axis scale
gr.data_bounds(:,2)=[0;TAP];   //y axis scale
gr.font_size=5
