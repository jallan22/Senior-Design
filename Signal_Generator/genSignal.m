% genSignal.m
%
% DESCRIPTION: Short description of script purpose
%
% EXECUTION:
%   [out1,out2] = filename(in1,in2,in3)
%
% INPUT:
%   in1     [str]    = variable description
%   in2     [1x1]    = variable description
%   in3     [struct] = variable description
%       in3.field1 [1x1] = variable description
%       in3.field2 [1x1] = variable description
%
% OUTPUT:
%   out1    [2x2]   = variable description
%   out2    [str]   = variable description (optional)
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
sigTime  = 0:(1/Fs):Ts-(1/Fs);
signal   = zeros(1,length(sigTime));
wavStart = pulse.startTime*Fs+1;
wavEnd   = wavStart + pulse.duration*Fs -1;
signal(wavStart:wavEnd) = waveform;

    
    
    
    
    
    
    
    
    
    
    
    
    
