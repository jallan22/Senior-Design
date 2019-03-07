% demodSig.m
%
% DESCRIPTION: 
%
% EXECUTION:
%
% INPUT:
%
% OUTPUT:
%
% EDC Systems - ECE 4805: Senior Design
%
% Origional Version [02/14/2019], Peyton McClintock

function [demodStruct] = demodSig(demodParams,sigStruct)


if strcmpi(sigStruct.type,'qam')
    
    % Define Recieved Signal
    rxSig = demodParams.gain*sigStruct.txSig.qam; % Amplitude (variance) + phase changes (preamble)
    rxNoise = demodParams.noise*(randn(size(rxSig)) + 1j*randn(size(rxSig))); % more zeroes
    rxSig = rxSig + rxNoise;
    
    % Read Input
    M = sigStruct.M;
    rolloff = sigStruct.rolloff;
    symLength = sigStruct.symLength;
    filterSpan = sigStruct.filterSpan;
    
    % Create Filter
    qamDemodulator = comm.RectangularQAMDemodulator(M,'BitOutput',true);
    rxfilter = comm.RaisedCosineReceiveFilter('RolloffFactor',rolloff, ...
    'FilterSpanInSymbols',filterSpan,'InputSamplesPerSymbol',symLength, ...
    'DecimationFactor',symLength);

    % Demodulate
    demodStruct.rxSym = rxfilter(rxSig);
    demodStruct.rxSig = qamDemodulator(rxSig);
    
    % Map Rx Sym to true Symbols
    
    % Format Signal    
    demodStruct.rxSymInfo = demodStruct.rxSym(sigStruct.nSymbTrash+1:end-sigStruct.nSymbTrash);  %demodStruct.rxSym(sigStruct.filterSpan+1:end); % replace by preamble searching
    demodStruct.rxNoise   = rxNoise;        
    
end





















