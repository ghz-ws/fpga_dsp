clear
clc
clf

function out=sincf(M)   //sinc filter transfer function
    out=syslin('d',(1-%z^(-M))/(1-%z^-1))//discreted time system
endfunction

[frq,amp]=repfreq(sincf(2)^4*sincf(4)^4*sincf(8)^4,0,0.5,0.0001)

plot(frq,20*log10(amp),"thickness",2)
xgrid()
xlabel("Normalized Freq [Hz]","fontsize",5)
ylabel("Gain [dB]","fontsize",5)
g1=gca();   //get axis object
g1.data_bounds(:,1)=[0;0.5];   //y axis scale
g1.data_bounds(:,2)=[-150;150];   //y axis scale
g1.font_size=5
