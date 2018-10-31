% farrowTest.m

clear,clc

% Define Test Singal
nSamps = 10e3;
t = linspace(0,2,nSamps);
signal = sin(2*pi*t);

% Run Farrow Filter
tau1 = 0;
tau2 = 0.5;
tau3 = -0.5;

output1 = farrow(signal,tau1);
output2 = farrow(signal,tau2);
output3 = farrow(signal,tau3);

%% Plot Output
figure(1); clf;

% tau = 0
subplot(3,1,1); hold on; grid on;
plot(t,signal)
plot(t,output1)
axis([0 1e-3 -0.01 0.01])
title('{\tau} = 0')
legend('Original','Filtered')

% tau = 0.5 
subplot(3,1,2); hold on; grid on;
plot(t,signal)
plot(t,output2)
axis([0 1e-3 -0.01 0.01])
title('{\tau} = 0.5')

% tau = -0.5
subplot(3,1,3); hold on; grid on;
plot(t,signal)
plot(t,output3)
axis([0 1e-3 -0.01 0.01])
title('{\tau} = -0.5')
xlabel('Time (ms)')