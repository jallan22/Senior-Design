% signalTest.m
%
% DESCRIPTION: Test file for genSignal.m
%
% EDC Systems - ECE 4805: Senior Design
%
% Origional Version [10/19/2019], Peyton McClintock

clear

%% Define Parameters

% Enviornment
Ts = 2; % s
Fs = 1e3; % Hz
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


%% Generate Signal
[signal1,sigTime1] = genSignal(Ts,Fs,pulse1);
[signal2,sigTime2] = genSignal(Ts,Fs,pulse2);

%% Plot Signal
figure(1); clf; hold on; grid on;
plot(sigTime1,signal1)
plot(sigTime2,signal2)
xlabel('Time (s)')
ylabel('Amplitude')
title('Test Signal')














