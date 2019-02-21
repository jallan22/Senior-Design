% demodSig.m
%
% DESCRIPTION: 
%
% EXECUTION:
%
% INPUT:
%       demodParams.type [str] = 'qam'
%       demodParams.M [1x1] = Order of modulation
%       demodParams.rolloff [1x1] = Raised cosine rolloff
%       demodParams.symLength [1x1] = length of a symbol in samples
%       demodParams.nSymbols [1x1] = nSymbols;
%
% OUTPUT:
%
% EDC Systems - ECE 4805: Senior Design
%
% Origional Version [02/14/2019], Peyton McClintock

function [signal,demodSym] = demodSig(rxSig,demodParams)


if strcmpi(demodParams.type,'qam')
    
    % Read Input
    M = demodParams.M;
    rolloff = demodParams.rolloff;
    symLength = demodParams.symLength;
%     nSymbols = demodParams.nSymbols;
    filterSpan = demodParams.filterSpan;
    
    % Create Filter
    qamDemodulator = comm.RectangularQAMDemodulator(M,'BitOutput',true);
    rxfilter = comm.RaisedCosineReceiveFilter('RolloffFactor',rolloff, ...
    'FilterSpanInSymbols',filterSpan,'InputSamplesPerSymbol',symLength, ...
    'DecimationFactor',symLength);

    % ********************* Stupid
%     k = log2(M);
%     SNR = 10 + 10*log10(k) - 10*log10(symLength);
%     noisySig = awgn(rxSig,SNR,'measured');

    % Demodulate
    demodSym = rxfilter(rxSig);
    signal = qamDemodulator(rxSig);
%     keyboard
    
end