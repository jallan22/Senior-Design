% farrowTest2.m
%
% Script to test implementation of farrow filter

clear

%% USER DEFINED INPUTS

% Signal Parameters
freqs = [1e6 2.5e6]; % frequency of sinusoids [nSigs x 1] [Hz]
amps  = [1.25 3]; % Amplitudes of sinusoids [nSigs x 1]

% Sampling Parameters
Fs   = 10e6; % Sampling frequency [Hz]
tWin = 0.1; % Signal duration [sec]
nSamps = Fs*tWin; % ***NO NEED TO EDIT***

% Doppler
tau = linspace(0,500,ceil(nSamps/2)); % Vector of tau (delay) inputs [nSamps x 1]
tau = [tau fliplr(tau)];
% tau = linspace(0,500,nSamps);

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
% for iSig = 1:nSigs
%     idealResp = idealResp + amps(iSig)*sin(2*pi*(ts-3.5-tau)*normFreqs(iSig));
%     signal    = signal + amps(iSig)*sin(2*pi*ts*normFreqs(iSig));
% end
for iSig = 1:nSigs
    idealResp = idealResp + amps(iSig)*exp(2j*pi*(ts-3.5-tau)*normFreqs(iSig));
    signal    = signal + amps(iSig)*exp(2j*pi*ts*normFreqs(iSig));
end
if ~complexFlag
    idealResp = real(idealResp);
    signal    = real(signal);
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
midBin = ceil(nFFT/2); % + 1???

fftInput = fft(window.*signal,nFFT);
fftInput = 20*log10(abs(fftInput));

fftIdeal = fft(window.*idealResp,nFFT);
fftIdeal = 20*log10(abs(fftIdeal));

fftOutput = fft(window.*farrowResp,nFFT);
fftOutput = 20*log10(abs(fftOutput));

% Shift Freqs
if ~mod(nFFT,2)
    fAxis     = [fliplr(-fAxis(2:midBin)) fAxis(1:midBin+1)].'; % fAxis(1:midbin);
    fftInput  = [fftInput(midBin+2:end); fftInput(1:midBin+1)]; %fftInput(1:midbin);
    fftIdeal  = [fftIdeal(midBin+2:end); fftIdeal(1:midBin+1)]; % fftIdeal(1:midbin);
    fftOutput = [fftOutput(midBin+2:end); fftOutput(1:midBin+1)]; % fftOutput(1:midbin);
else
    fAxis     = [fliplr(-fAxis(2:midBin)) fAxis(1:midBin)].'; % fAxis(1:midbin);
    fftInput  = [fftInput(midBin+1:end); fftInput(1:midBin)]; %fftInput(1:midbin);
    fftIdeal  = [fftIdeal(midBin+1:end); fftIdeal(1:midBin)]; % fftIdeal(1:midbin);
    fftOutput = [fftOutput(midBin+1:end); fftOutput(1:midBin)]; % fftOutput(1:midbin);
end

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
timeFig = figure(1); clf; hold on; grid on;
plot(t,real(signal)) %Plotting Original signal
plot(t,real(farrowResp)) %Plotting filtered signal
plot(t,real(idealResp)) %Plotting ideal response signal
xlabel('Time (Seconds)')
ylabel('Amplitude (Real)')
title('Time Response')
legend('Original','Filtered','Ideal','Location','southeast')

% Display Tau
tauFig = figure(2); clf; hold on; grid on;
plot(tau)
xlabel('Samples')
title('Original Delay Vector')

% Display Tau Bounded
tauBoundedFig = figure(3); clf; hold on; grid on;
plot(tauBounded)
xlabel('Samples')
title('Tau-Bounded')
ylim([-.6 .6])

% Display Spectrum
freqFig = figure(4); clf; hold on; grid on;
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
    
    % Make Directory
    currentTime = now;
    workDir  = pwd;
    saveDate = datestr(currentTime,'mmddyyyy');
    saveTime = datestr(currentTime,'HHMMSS');    
    dirName  = sprintf('sim%s_%s',saveDate,saveTime); 
    zipDir   = [workDir filesep 'Saved_Sims'];
%     saveDir  = [zipDir filesep dirName]; 
%     mkdir(saveDir);
    
    % Make Output Structure
    simStruct = [];
    simStruct.freqs = freqs;
    simStruct.amps = amps;
    simStruct.Fs = Fs;
    simStruct.tWin = tWin;
    simStruct.nSamps = nSamps;
    simStruct.tau = tau;
%     simStruct.signal = signal;
%     simStruct.idealResp = idealResp;
%     simStruct.farrowResp = farrowResp;
    simStruct.tauBounded = tauBounded;
    simStruct.nFFT = nFFT;
    simStruct.window = window;
    simStruct.fAxis = fAxis;
%     simStruct.fftInput = fftInput;
%     simStruct.fftIdeal = fftIdeal;
%     simStruct.fftOutput = fftOutput;
    simStruct.saveDate = saveDate;
    simStruct.saveTime = saveTime;
    simStruct.complexFlag = complexFlag;
    simStruct = orderfields(simStruct);
    
    % Save Structure
    cd(zipDir)
    save('simStruct','simStruct','-v7.3'); % TOO LARGE FOR GITHUB (>100Mb)
    
    % Save Figures
    saveas(timeFig,'timeDomain','png'); % Time Domain
    saveas(tauFig,'tau','png'); % Tau
    saveas(tauBoundedFig,'tauBounded','png'); % Tau Bounded
    saveas(freqFig,'freqDomain','png'); % Frequency Domain
    
    % Zip
    saveFiles = {'simStruct.mat','timeDomain.png','tau.png','tauBounded.png','freqDomain.png'};
    zip([dirName '.zip'],saveFiles);
    delete(saveFiles{:})
    
    % Go Back to Work
    cd(workDir)
    
end




















