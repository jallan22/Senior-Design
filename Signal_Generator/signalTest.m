% signalTest.m
%
% DESCRIPTION: Test file for genSignal.m
%
% EDC Systems - ECE 4805: Senior Design
%
% Origional Version [10/19/2019], Peyton McClintock

clear, close all

%% Define Parameters

% Enviornment
Ts = 1; % s
Fs = 100; % Hz
% ADD NOISE ???

% Signal
pulse1.type      = 'sin'; % Will always assume arguments are degrees
pulse1.freq      = 4; % May not be preforming right
pulse1.phase     = 90; % deg
pulse1.amplitude = 1; % ???
pulse1.startTime = 0.5; % s
pulse1.duration  = 1; % s

pulse2.type      = 'bit';
pulse2.bitrate   = 4;
pulse2.amplitude = [-1 1];
pulse2.startTime = 0.5;
pulse2.bits      = [1 0 1 1];

pulse3.type = 'qam';
pulse3.M    = 16;
pulse3.bits = randi([0,1],40,1); [1 0 1 1 0 1 1 1 1 0 1 0 0 0 0 0 1 1 1 1];
pulse3.rolloff = 0.25;

%% Generate Signal
% [signal1,sigTime1] = genSignal(Ts,Fs,pulse1);
% [signal2,sigTime2] = genSignal(Ts,Fs,pulse2);
[signal3,sigTime3,demodStruct] = genSignal(Ts,Fs,pulse3);

% Graph Help
nSymbols = (length(pulse3.bits)./log2(pulse3.M));
% linePeriod  = Ts./nSymbols;
% tLines = linePeriod:linePeriod:Ts-linePeriod;
% tCarrier = linspace(0,tLines(1),Fs./nSymbols); % may find rounding errors
% carrier = pulse3.Ac*cos(2*pi*pulse3.Fc*tCarrier);
% carrier = repmat(carrier,[1,nSymbols]);

%% Demodulate Signal
addpath('/home/peyton11/Documents/EDC_Systems/Senior-Design-master/Signal_Demod');
[rxSig,rxSym] = demodSig(signal3,demodStruct);
scatterplot(rxSym)
% axis([-3 3 -3 3]*1e-3)
rmpath('/home/peyton11/Documents/EDC_Systems/Senior-Design-master/Signal_Demod');
b = reshape(pulse3.bits,[log2(pulse3.M),length(pulse3.bits)./log2(pulse3.M)]);
keyboard

%% Plot Signal
figure(1); clf; hold on;
% plot(sigTime1,signal1)
% plot(sigTime2,signal2)
plot(sigTime3,20*log(signal3))
% plot(sigTime3,signal3)
% plot(sigTime3,carrier,'r--');
% xlabel('Time (s)')
% ylabel('Amplitude')
% title('Test Signal')
% yLim = ylim;
% bits = reshape(pulse3.bits,[log2(pulse3.M),nSymbols]);
% for sym = 1:nSymbols-1
%    
%     plot([tLines(sym) tLines(sym)],yLim,'k')
%     thisBit = num2str(bits(:,sym));
%     text(tLines(sym)-0.5*tLines(1),yLim(2)*0.9,thisBit)
%     
% end
% text(tLines(end)+0.5*tLines(1),yLim(2)*0.9,num2str(bits(:,end)))
% legend('QAM Signal','Carrier Signal','Location','southeast')














