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
%       pulse.rolloff [1x1] = Raised cosine rolloff
%
% OUTPUT:
%   signal    [Nx1]   = Output signa1 vector
%   sigTime   [Nx1]   = Output time Vector
%
% EDC Systems - ECE 4805: Senior Design
%
% Origional Version [10/19/2018], Peyton McClintock
%           Updated [02/14/2019], Baseband QAM

function [signal,sigTime,outStruct] = genSignal(tWin,Fs,pulse)

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
        % Verify Waveform Parameters
        M     = pulse.M; % modulation order
        bits  = pulse.bits(:); % info to send
        rolloff = pulse.rolloff;
        nBits = length(bits);
        nZPad = mod(nBits,log2(M));
        if nZPad > 1 % Check to see that nBits match modulation order
            bits  = [zeros(1,nZPad); bits]; % Could also pad end???
            nBits = length(bits);
            warning('nBits does not match modulation order, zero padding...');
        end
        
        % Allocate Output
        nSymbols  = nBits./log2(M); 
        nSamps    = tWin*Fs;
        symLength = floor(nSamps/nSymbols); % index length of one symbol, floored
        filterSpan = 1; % ???
%         keyboard
        
        % Pulse Shape
        keyboard
        qamModulator = comm.RectangularQAMModulator(M,'BitInput',true);
        txfilter = comm.RaisedCosineTransmitFilter('RolloffFactor',rolloff, ...
            'FilterSpanInSymbols',filterSpan,'OutputSamplesPerSymbol',symLength);
        modSig = qamModulator(bits);
        txSig = txfilter(modSig);
        waveform = txSig;
%         keyboard
        fvtool(txfilter,'impulse')
        eyediagram(waveform,symLength)
        keyboard
        % https://www.mathworks.com/help/comm/ug/pulse-shaping-using-a-raised-cosine-filter.html
        %
        % https://www.mathworks.com/help/signal/ref/rcosdesign.html
        
        outStruct.type = pulse.type;
        outStruct.M = M;
        outStruct.rolloff = rolloff;
        outStruct.symLength = symLength;
        outStruct.nSymbols = nSymbols;
        outStruct.filterSpan = filterSpan;
        outStruct.symbols = modSig;

    end
    
    
end
   
%% Generate Singal
sigTime  = [0:(1/Fs):tWin-(1/Fs)].'; % s
if ~any(modGroup)
    signal   = zeros(length(sigTime),1);
    wavStart = pulse.startTime*Fs+1; % idx
    wavEnd   = wavStart + pulse.duration*Fs -1; % idx
    signal(wavStart:wavEnd) = waveform;
else
    signal = waveform;  
end

% keyboard
    
    
    
    
    
    
    
    
    
    
    
    
    
