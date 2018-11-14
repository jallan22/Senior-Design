% farrowTest.m

clear,clc

% Run Farrow Filter
tau1 = 0;
tau2 = -0.5;
tau3 = 0.5;


% Define Test Singal
nSamps = 10e3;
tau = linspace(-0.5,0.5,nSamps);
t = 0:nSamps-1;
fs = 1;
signal = 1.2*sin(2*pi*t*0.05) + 1.2*sin(2*pi*t*0.2);
signal = signal(:);
%idealSig1 = 1.2*sin(2*pi*0.1*(t-3.5-tau1)) +
%3*sin(2*pi*(t-3.5-tau1)*0.17); % works for varying tau
%idealSig2 = 1.2*sin(2*pi*0.1*(t-3.5-tau2))+ 3*sin(2*pi*(t-3.5-tau2)*0.17);
%idealSig3 = 1.2*sin(2*pi*0.1*(t-3.5-tau3))+ 3*sin(2*pi*(t-3.5-tau3)*0.17);

output1 = farrow(signal,tau);
% output2 = farrow(signal,tau2);
% output3 = farrow(signal,tau3);

%% Plot Output
% figure(1); clf;

% tau = 0
% subplot(3,1,1); hold on; grid on;
% plot(t,signal);
% plot(t,output1,'ro-');
% % plot(t,idealSig1,'gx-');
% % axis([0 1e-3 -0.01 0.01])
% title(['{\tau} = ', num2str(tau1)])
% legend('Original','Filtered')
% 
% % tau = 0.5 
% subplot(3,1,2); hold on; grid on;
% plot(t,signal);
% plot(t,output2,'ro-');
% % plot(t,idealSig2,'gx-');
% % axis([0 1e-3 -0.01 0.01])
% title(['{\tau} = ', num2str(tau2)])
% 
% % tau = -0.5
% subplot(3,1,3); hold on; grid on;
% plot(t,signal);
% plot(t,output3,'ro-');
% % plot(t,idealSig3,'gx-');
% % axis([0 1e-3 -0.01 0.01])
% title(['{\tau} = ', num2str(tau3)])
% xlabel('Time (ms)')
% plot(t,output1);

% Frequency Plotting (Only works for real not imaginary)
nFFT = 2^20;
fRes = fs/nFFT;
fAxis = [0:nFFT-1]*fRes;
window = hanning(length(signal));
midbin = ceil(nFFT/2)+1;
% fAxis(midbin:end) = fAxis(midbin:end)-fs;
fAxis = fAxis(1:midbin);

fftInput = fft(window.*signal,nFFT);
fftInput = 20*log10(abs(fftInput));
fftInput = fftInput(1:midbin);

fftOutput = fft(window.*output1,nFFT);
fftOutput = 20*log10(abs(fftOutput));
fftOutput = fftOutput(1:midbin);

figure(2); clf; hold on;
plot(fAxis,fftInput)
plot(fAxis,fftOutput)
xlabel('Frequency')
title('Frequency Response')
legend('Origional','Filtered')



