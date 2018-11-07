% farrowTest.m

clear,clc

% fAxis = (0:2^20-1)/(2^20)*1;
% plot(fAxis,20*log10(abs(fft(output2,2^20))))
% plot(fAxis,20*log10(abs(fft(output2.*hanning(length(output2)),2^20))))

% Run Farrow Filter
tau1 = 0;
tau2 = -0.5;
tau3 = 0.5;

% Define Test Singal
nSamps = 10e3;
t = 0:nSamps-1;
signal = 1.2*sin(2*pi*t*0.1) + 3*sin(2*pi*t*0.17);
idealSig1 = 1.2*sin(2*pi*0.1*(t-3.5-tau1)) + 3*sin(2*pi*(t-3.5-tau1)*0.17);
idealSig2 = 1.2*sin(2*pi*0.1*(t-3.5-tau2))+ 3*sin(2*pi*(t-3.5-tau2)*0.17);
idealSig3 = 1.2*sin(2*pi*0.1*(t-3.5-tau3))+ 3*sin(2*pi*(t-3.5-tau3)*0.17);

output1 = farrow(signal,tau1);
output2 = farrow(signal,tau2);
output3 = farrow(signal,tau3);

%% Plot Output
figure(1); clf;

% tau = 0
subplot(3,1,1); hold on; grid on;
plot(t,signal)
plot(t,output1,'ro-')
plot(t,idealSig1,'gx-')
% axis([0 1e-3 -0.01 0.01])
title(['{\tau} = ', num2str(tau1)])
legend('Original','Filtered')

% tau = 0.5 
subplot(3,1,2); hold on; grid on;
plot(t,signal)
plot(t,output2,'ro-')
plot(t,idealSig2,'gx-')
% axis([0 1e-3 -0.01 0.01])
title(['{\tau} = ', num2str(tau2)])

% tau = -0.5
subplot(3,1,3); hold on; grid on;
plot(t,signal)
plot(t,output3,'ro-')
plot(t,idealSig3,'gx-')
% axis([0 1e-3 -0.01 0.01])
title(['{\tau} = ', num2str(tau3)])
xlabel('Time (ms)')