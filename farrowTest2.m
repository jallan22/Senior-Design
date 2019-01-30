% farrowTest2.m
%
% Script to test implementation of farrow filter

clear

%% USER DEFINED INPUTS

% Signal Parameters
freqs = [4e6]; % frequency of sinusoids [nSigs x 1] [Hz]
amps  = [1.25]; % Amplitudes of sinusoids [nSigs x 1]

% Sampling Parameters
Fs   = 10e6; % Sampling frequency [Hz]
tWin = 0.1; % Signal duration [sec]
nSamps = Fs*tWin; % ***NO NEED TO EDIT***

% Doppler
% tau = linspace(0,500,ceil(nSamps/2)); % Vector of tau (delay) inputs [nSamps x 1]
% tau = [tau fliplr(tau)];
tau = linspace(0,500,nSamps);

% Flags
complexFlag = 1;
saveFlag    = 1;

%% Construct Input

% Normalize Frequency
normFreqs = freqs./Fs;

% Create Time
t = linspace(0,tWin,nSamps); % Real time vector
ts = 0:nSamps-1; % Sampled time indicies

% Create Signals
nSigs     = length(normFreqs);
if nSigs ~= length(amps), warning('nSigs Invalid'); end
signal    = zeros(1,nSamps);
idealResp = zeros(1,nSamps);
for iSig = 1:nSigs
    idealResp = idealResp + amps(iSig)*sin(2*pi*(ts-3.5-tau)*normFreqs(iSig));
    signal    = signal + amps(iSig)*sin(2*pi*ts*normFreqs(iSig));  
end

% Comulmize
signal = signal(:);
idealResp = idealResp(:);
t = t(:);
tau = tau(:);
ts = ts(:);

%% Generate Output 

% Bound Tau
[tauBounded,rsh] = tauMap(tau); % rsh = run-skip-hold

% Run Farrow Filter
farrowResp = farrow(signal,tauBounded,rsh);

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

% Display Time 
figure(1); clf; hold on; grid on;

% Display Tau
figure(2); clf; hold on; grid on;

% Display Tau Bounded
figure(3); clf; hold on; grid on;
plot(tauBounded)
xlabel('Samples')
ylabel('tau-bounded')

% Display Spectrum
figure(4); clf; hold on; grid on;
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

%% Save Results

if saveFlag
    currentTime = now;
    saveDate = datestr(currentTime,'mmddyyyy');
    saveTime = datestr(currentTime,'HHMMSS');
    
    dirName = sprintf('sim%s_%s',saveDate,saveTime);
    
    mkdir([pwd filesep 'Saved_Sims' filesep dirName]);
    
    simStruct = [];
    simStruct.freqs = freqs;
    simStruct.amps = amps;
    simStruct.Fs = Fs;
    simStruct.tWin = tWin;
    simStruct.nSamps = nSamps;
    simStruct.tau = tau;
    simStruct.signal = signal;
    simStruct.idealResp = idealResp;
    simStruct.farrowResp = farrowResp;
    simStruct.tauBounded = tauBounded;
    simStruct.nFFT = nFFT;
    simStruct.window = window;
    simStruct.fAxis = fAxis;
    simStruct.fftInput = fftInput;
    simStruct.fftIdeal = fftIdeal;
    simStruct.fftOutput = fftOutput;
    simStruct = orderfields(simStruct);
    
end 






















