clear
clc
clf

fc=100;     //cutoff freq
order=3;    //filter order
f_start=10; //start freq
f_stop=1000;//stop freq
f_step=10;  //freq step

function TF=but(w,wc,n)     //butterworth
    TF=1/sqrt(1+(w/wc)^(2*n))    //gain func
endfunction

function TF=cheb(w,wc,n,ripple)     //chebyshev
    epsiron2=(10^(ripple/10))-1;
    Tn=chepol(n,"x");   //chebyshev polynominal
    temp=horner(1+epsiron2*(Tn)^2,w/wc);
    TF=1/sqrt(temp); //gain func
endfunction

function A=bes(w,wc,n)  //bessel
    num=0;
    den=0;
    x=poly(0,'x')
    for k=0:n   //gen. inverse bessel polynominal
        num=num+factorial(2*n-k)/(factorial(n-k)*factorial(k))*0^k/2^(n-k);
        den=den+factorial(2*n-k)/(factorial(n-k)*factorial(k))*x^k/2^(n-k);
    end
    TF=num/den;  //gain func
    p=den-num*sqrt(2); //prepare solver
    q=roots(p);
    A=horner(TF,q(length(q))*w/wc);
endfunction

wc=2*%pi*fc;
f=f_start:f_step:f_stop;    //gen. f vector
w=2*%pi*f;
len=length(w);

for i=1:len     //calc. each gain func
    A(1,i)=but(w(i),wc,order);
    B(1,i)=cheb(w(i),wc,order,3);
    C(1,i)=bes(w(i),wc,order);
end

plot(f,20*log10(A),"-o",f,20*log10(B),"-s",f,20*log10(C),"-^")
legend("Butterworth","Chebyshev","Bessel", 1,"in_lower_left")
xgrid()
title("Freq Response","fontsize",5)
xlabel("Freq [Hz]","fontsize",5)
ylabel("Gain [dB]","fontsize",5)
a=gca();    //get axis object
a.log_flags = "ln";
a.data_bounds(:,2)=[-60;10];   //y axis scale
a.font_size=5
b=gce();
b.font_size=5
