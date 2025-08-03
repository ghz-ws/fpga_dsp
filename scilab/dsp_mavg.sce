clear
clc
clf

function out=mavg(M)   //moving average filter transfer function
    total=1;
    for i=1:M
        unit=syslin('d',%z^-i);//discreted time system
        total=total+unit;
    end
    out=total/(M+1);
endfunction

[frq1,amp1]=repfreq(mavg(1),0,0.5)
[frq2,amp2]=repfreq(mavg(7),0,0.5)
[frq3,amp3]=repfreq(mavg(15),0,0.5)

plot(frq1,20*log10(amp1),"-o",frq2,20*log10(amp2),"-s",frq3,20*log10(amp3),"-^","thickness",2)
legend("M=1","M=7","M=15",1,"in_lower_left")
xgrid()
xlabel("Normalized Freq [Hz]","fontsize",5)
ylabel("Gain [dB]","fontsize",5)
g1=gca();   //get axis object
g1.data_bounds(:,1)=[0;0.5];   //y axis scale
g1.data_bounds(:,2)=[-40;0];   //y axis scale
g1.font_size=5
e1=gce();
e1.font_size=5
