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
pulse.type      = 'sin'; % Will always assume arguments are degrees
pulse.freq      = 100;
pulse.phase     = 0; % deg
pulse.Amplitude = 1; % ???
pulse.startTime = 1; % s
pulse.duration  = 1; % s


%% Generate Signal
[signal,sigTime] = genSignal(Ts,Fs,pulse);

%% Plot Signal
figure(1); clf; hold on; grid on;
plot(sigTime,signal)
xlabel('Time (s)')
ylabel('Amplitude')
title('Test Signal')














