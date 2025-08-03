clear
clc
clf

function out=ds(M)   //delta-sigma modulator. noise transfer function
    out=syslin('d',(1-%z^-1)^M)//discreted time system
endfunction

[frq1,amp1]=repfreq(ds(1),0,0.5)
[frq2,amp2]=repfreq(ds(2),0,0.5)
[frq3,amp3]=repfreq(ds(3),0,0.5)

subplot(1,3,1)
plot(frq1,20*log10(abs(amp1)),"-o",frq2,20*log10(abs(amp2)),"-s",frq3,20*log10(abs(amp3)),"-^","thickness",2)
legend("1st","2nd","3rd",1,"in_lower_right")
xgrid()
xlabel("Normalized Freq [Hz]","fontsize",5)
ylabel("Gain [dB]","fontsize",5)
g1=gca();   //get axis object
g1.data_bounds(:,1)=[0;0.5];   //y axis scale
g1.data_bounds(:,2)=[-60;20];   //y axis scale
g1.font_size=5
e1=gce();
e1.font_size=5

subplot(1,3,2)
plot('ln',frq1,20*log10(abs(amp1)),"-o",frq2,20*log10(abs(amp2)),"-s",frq3,20*log10(abs(amp3)),"-^","thickness",2)
legend("1st","2nd","3rd",1,"in_lower_right")
xgrid()
xlabel("Normalized Freq [Hz]","fontsize",5)
ylabel("Gain [dB]","fontsize",5)
g2=gca();   //get axis object
g2.data_bounds(:,1)=[10^-4;0.5];   //y axis scale
g2.data_bounds(:,2)=[-60;20];   //y axis scale
g2.font_size=5
e2=gce();
e2.font_size=5

subplot(1,3,3)
plot(frq1,abs(amp1)^2,"-o",frq2,abs(amp2^2),"-s",frq3,abs(amp3)^2,"-^","thickness",2)
legend("1st","2nd","3rd",1,"in_lower_right")
xgrid()
xlabel("Normalized Freq [Hz]","fontsize",5)
ylabel("Noise Energy [a.u.]","fontsize",5)
g3=gca();   //get axis object
g3.data_bounds(:,1)=[0;0.5];   //y axis scale
g3.data_bounds(:,2)=[0;4];   //y axis scale
g3.font_size=5
e3=gce();
e3.font_size=5
