% farrowTest2.m
%
% Script to test implementation of farrow filter

clear

%% USER DEFINED INPUTS

% Signal Parameters
freqs = [4e6 2e6 1e6]; % frequency of sinusoids [nSigs x 1] [Hz]
amps  = [1.25 1 3]; % Amplitudes of sinusoids [nSigs x 1]

% Sampling Parameters
Fs   = 10e6; % Sampling frequency [Hz]
tWin = 0.1; % Signal duration [sec]
nSamps = Fs*tWin; % ***NO NEED TO EDIT***

% Doppler
tau = linspace(0,500,nSamps); % Vector of tau (delay) inputs [nSamps x 1] 

%% Construct Input 

% Normalize Frequency
freqs = freqs./Fs;

% Create Time
t = linspace(0,tWin,nSamps); % Real time vector
ts = 0:nSamps-1; % Sampled time indicies

% Create Signals
nSigs       = length(freqs);
if nSigs ~= length(amps), warning('nSigs Invalid'); end
signal      = zeros(1,nSamps);
idealResp = zeros(1,nSamps);
for iSig = 1:nSigs
    idealResp = idealResp + amps(iSig)*sin(2*pi*(ts-3.5-tau)*freqs(iSig));
    signal    = signal + amps(iSig)*sin(2*pi*ts*freqs(iSig));  
end

% Comulmize
signal = signal(:);
idealResp = idealResp(:);
t = t(:);
tau = tau(:);
ts = ts(:);

%% Generate Output 

% Run Farrow Filter
farrowResp = farrow(signal,tau);

% Calculate Frequency Response
nFFT   = 2^22;
fRes   = Fs/nFFT; % 1/nFFT;
fAxis  = (0:nFFT-1)*fRes;
window = hanning(length(signal));
midbin = ceil(nFFT/2)+1;
fAxis  = fAxis(1:midbin);

fftInput = fft(window.*signal,nFFT);
fftInput = 20*log10(abs(fftInput));
fftInput = fftInput(1:midbin);

fftIdeal = fft(window.*idealResp,nFFT);
fftIdeal = 20*log10(abs(fftIdeal));
fftIdeal = fftIdeal(1:midbin);

fftOutput = fft(window.*farrowResp,nFFT);
fftOutput = 20*log10(abs(fftOutput));
fftOutput = fftOutput(1:midbin);

%% Find Peaks 

nFreqs    = nSigs; 
inFreq    = nan(nFreqs,1);
idealFreq = nan(nFreqs,1);
outFreq   = nan(nFreqs,1);
[inPeaks,inLocs]       = findpeaks(fftInput);
[idealPeaks,idealLocs] = findpeaks(fftIdeal);
[outPeaks,outLocs]     = findpeaks(fftOutput);
for iFreq = 1:nFreqs
    [~,inPkLoc]    = max(inPeaks);
    [~,idealPkLoc] = max(idealPeaks);
    [~,outPkLoc]   = max(outPeaks);
    inPeaks(inPkLoc)       = -Inf;
    idealPeaks(idealPkLoc) = -Inf;
    outPeaks(outPkLoc)     = -Inf;
    inFreq(iFreq) = fAxis(inLocs(inPkLoc));
    idealFreq(iFreq) = fAxis(idealLocs(idealPkLoc));
    outFreq(iFreq) = fAxis(outLocs(outPkLoc));
end
inFreq    = sort(inFreq);
idealFreq = sort(idealFreq);
outFreq   = sort(outFreq);
% **Assumes operating frequency will always dominate**

% Get Order
if max(fAxis) < 4.9e3 
    order = 'Hz';
    fac   = 1;
elseif max(fAxis) < 4.9e6
    order = 'kHz';
    fac   = 1e3;
elseif max(fAxis) < 4.9e9
    order = 'MHz';
    fac   = 1e6;
elseif max(fAxis) < 4.9e12
    order = 'GHz';
    fac   = 1e9;
else
    order = 'Hz';
    fac   = 1;
end
fAxis = fAxis/fac;

%% Display Results 

% Display Spectrum
figure(1); clf; hold on; grid on;
plot(fAxis,fftInput)
plot(fAxis,fftOutput)
plot(fAxis,fftIdeal)
xlabel(['Frequency [' order ']'])
title('Frequency Response')
legend('Original','Filtered','Ideal','Location','southeast')

% Pring Peaks
inFreq    = inFreq/fac;
idealFreq = idealFreq/fac;
outFreq   = outFreq/fac;
fprintf('\nPeak Frequency Responses [%s]:\n',order)
fprintf('Frequency\t|\tOrigional\t|\tIdeal\t\t|\tFiltered\n')
fprintf('----------------------------------------------------------\n')
for ff = 1:nFreqs
    fprintf('%d\t\t\t| %9.10f\t| %9.10f\t| %9.10f',ff,inFreq(ff),idealFreq(ff),outFreq(ff))
    fprintf('\n')
end
fprintf('\n')























