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
%       
%       pulse.type [str] = 'cos' or 'sin'
%       pulse.freq [1x1] = Center Frequency of waveform
%       pulse.phase [1x1] = Phase of waveform
%       pulse.amplitude [1x1] = Amplitude of waveform
%       pulse.startTime [1x1] = Start time of waveform
%       pulse.duration [1x1] = Duration of waveform
%
%       pulse.type [str] = 'bit'
%       pulse.bitrate [1x1] = Bits per second 
%       pulse.amplitude [1x2] = Amplitude correspoding to '0' and '1' 
%       pulse.startTime [1x1] = Start time of waveform
%       pulse.bits [Nx1] = Sequence of 0's and 1's to send
%
%       pulse.type [str] = 'qam'
%       pulse.M [1x1] = Order of modulation
%       pulse.bits [Nx1] = Sequence of 0's and 1's to send
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
bitGroup = strcmpi(pulse.type,{'bit'});       % Bits
modGroup = strcmpi(pulse.type,{'qam'});

%% Generate Waveform

if any(sinGroup) % Sinusoid
    % Define Waveform
    if sinGroup(1)
        wavType = @sin;
    else
        wavType = @cos;
    end
    pulseTime = 0:(1/Fs):pulse.duration-(1/Fs);
    waveform = pulse.amplitude*wavType(2*pi*pulse.freq*pulseTime + deg2rad(pulse.phase));

elseif bitGroup % Bits
    nBits = length(pulse.bits);
    pulse.duration = nBits/pulse.bitrate; % add warning and/or cutoff of signal???
    bitLength = Fs/pulse.bitrate; % idx % account for aliasing??? % rounding
    waveform = zeros(nBits*bitLength,1);
    startIdx = 1;
    for bit = 1:nBits % may be a non-for way to do
        if pulse.bits(bit) % bit is 1
            scalar = pulse.amplitude(2);
        else % bit is 0
            scalar = pulse.amplitude(1);
        end
        thisBit = ones(bitLength,1)*scalar;
        endIdx = startIdx+bitLength-1;
        waveform(startIdx:endIdx) = thisBit;
        startIdx = endIdx+1;
    end
    
elseif modGroup
    
    if modGroup(1)
        order = pulse.M;
        bits  = pulse.bits;
        nZPad = mod(length(bits),log2(order));
        if nZPad > 1 % Check to see that nBits match modulation order
            bits = [zeros(1,nZPad); bits];
        end
        bits = bits(:);
        qamSymTx = qammod(bits,order,'InputType','Bit');
        I = real(qamSymTx);
        Q = imag(qamSymTx);
    end
    
    
end
   
%% Generate Singal
sigTime  = [0:(1/Fs):Ts-(1/Fs)].'; % s
if ~any(modGroup)
    signal   = zeros(length(sigTime),1);
    wavStart = pulse.startTime*Fs+1; % idx
    wavEnd   = wavStart + pulse.duration*Fs -1; % idx
    signal(wavStart:wavEnd) = waveform;
else
    signal = qamSymTx;  
end

    
    
    
    
    
    
    
    
    
    
    
    
    
