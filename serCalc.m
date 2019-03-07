% serCalc.m
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
% Origional Version [02/28/2019], Peyton McClintock

function [serStruct] = serCalc(sigStruct,demodStruct)

% Map Symbols

% Find SNR
Ps = sum(abs(demodStruct.rxSym).^2)/length(demodStruct.rxSym);    
Pn = sum(abs(demodStruct.rxNoise).^2)/length(demodStruct.rxNoise);
SNR = Ps/Pn;
SNRdB = 10*log10(SNR); 

% Find SER
ser = (3/2)*erfc(sqrt( (2/5)*SNRdB ));

% Define Output Structure
serStruct.SNDdB = SNRdB;
serStruct.ser = ser;

% keyboard