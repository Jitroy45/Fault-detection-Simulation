clc;
clear all;
close all;


open('faultdetectsimulink2.slx');
sim('faultdetectsimulink2.slx');

%currents
currentA = ans.current1.signals.values;
currentB = ans.current2.signals.values;
currentC = ans.current3.signals.values;


%Wavelet Transform for fault transients
[cA, LA] = wavedec(currentA, 1, 'db4');
[cB, LB] = wavedec(currentB, 1, 'db4');
[cC, LC] = wavedec(currentC, 1, 'db4');


%detail coefficients
coefA = detcoef(cA, LA, 1);
coefB = detcoef(cB, LB, 1);
coefC = detcoef(cC, LC, 1);


%max detail coefficients
m = max(coefA);
n = max(coefB);
p = max(coefC);

sum = 0;
for i=1:length(coefA)
    sum = sum + coefA(i) + coefB(i) + coefC(i);
end


sum_of_all_coefs = int8(abs(sum));
disp("Sum of all Coefs : " + sum_of_all_coefs)

if m>1 && n<1 && p<1
    disp("Fault is between phase A and ground")
elseif m<1 && n>1 && p<1
    disp("Fault is between phase B and ground")
elseif m<1 && n<1 && p>1
    disp("Fault is between phase C and ground")
elseif sum_of_all_coefs>0 && m>1 && n>1 && p<1
    disp("Fault is between phase A, phase B and ground")
elseif sum_of_all_coefs>0 && m<1 && n>1 && p>1
    disp("Fault is between phase B, phase C and ground")
elseif sum_of_all_coefs>0 && m>1 && n<1 && p>1
    disp("Fault is between phase A, phase C and ground")
elseif sum_of_all_coefs>0 && m>1 && n>1 && p>1
    disp("Fault is between phase A, phase B, phase C and ground")
elseif sum_of_all_coefs==0 && m>1 && n>1 && p>1
    disp("Fault is between phase A, phase B, phase C")
elseif sum_of_all_coefs==0 && m>1 && n>1 && p<1
    disp("Fault is between phase A and phase B")
elseif sum_of_all_coefs==0 && m<1 && n>1 && p>1
    disp("Fault is between phase B and phase C")
elseif sum_of_all_coefs==0 && m>1 && n<1 && p>1
    disp("Fault is between phase A and phase C")
else
    disp("No fault is detected")
end

