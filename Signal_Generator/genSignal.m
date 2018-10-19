% genSignal.m
%
% DESCRIPTION: Will generate time domain signals based on user input
%
% EXECUTION:
%   [out1,out2] = filename(in1,in2,in3)
%
% INPUT:
%   Ts      [str]    = Time of sampling interval
%   Fs      [1x1]    = Sampling frequency
%   pulse   [struct] = structure defining pulse
%       pulse.type [str] = String defining function type
%       pulse.freq [1x1] = Center Frequency of waveform
%       pulse.phase [1x1] = Phase of waveform
%       pulse.Amplitude [1x1] = Amplitude of waveform
%       pulse.startTime [1x1] = Start time of waveform
%       pulse.duration [1x1] = duration of waveform
%
% OUTPUT:
%   signal    [Nx1]   = Output signa1 vector
%   sigTime   [Nx1]   = Output time Vector
%
% EDC Systems - ECE 4805: Senior Design
%
% Origional Version [10/19/2018], Peyton McClintock

function [signal,sigTime] = genSignal(Ts,Fs,pulse)

%% Check Input

% Do later

%% Determine Group
sinGroup = strcmpi(pulse.type,{'sin','cos'}); % Sinusoids

%% Generate Waveform

% Sinusoid
if any(sinGroup)
    % Define Waveform
    if sinGroup(1)
        wavType = @sind;
    else
        wavType = @cosd;
    end
    pulseTime = 0:(1/Fs):pulse.duration-(1/Fs);
    waveform = pulse.Amplitude*wavType(2*pi*pulse.freq*pulseTime + pulse.phase);
    
end
   
%% Generate Singal
sigTime  = [0:(1/Fs):Ts-(1/Fs)].';
signal   = zeros(length(sigTime),1);
wavStart = pulse.startTime*Fs+1;
wavEnd   = wavStart + pulse.duration*Fs -1;
signal(wavStart:wavEnd) = waveform;

    
    
    
    
    
    
    
    
    
    
    
    
    
