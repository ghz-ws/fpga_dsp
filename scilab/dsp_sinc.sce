clear
clc
clf

function out=sincf(M)   //sinc filter transfer function
    out=syslin('d',(1-%z^(-M))/(1-%z^-1))//discreted time system
endfunction

[frq1,amp1]=repfreq(sincf(2),0,0.5)
[frq2,amp2]=repfreq(sincf(3),0,0.5)
[frq3,amp3]=repfreq(sincf(4),0,0.5)

plot(frq1,20*log10(amp1),"-o",frq2,20*log10(amp2),"-s",frq3,20*log10(amp3),"-^","thickness",2)
legend("M=2","M=3","M=4",1,"in_lower_left")
xgrid()
xlabel("Normalized Freq [Hz]","fontsize",5)
ylabel("Gain [dB]","fontsize",5)
g1=gca();   //get axis object
g1.data_bounds(:,1)=[0;0.5];   //y axis scale
g1.data_bounds(:,2)=[-40;20];   //y axis scale
g1.font_size=5
e1=gce();
e1.font_size=5
