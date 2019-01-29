% farrow.m
%
% DESCRIPTION: MATLAB implementation of a CVDD Farrow using coefficients
% found in research. The filter will use a set of sample delays to simulate
% the doppler effect on a given signal burst.
%
% EXECUTION:
%   [z] = farrow(signal,tau)
%
% INPUT:
%   signal  [Nx1] = Input signal pulse
%   tau     [Nx1] = Vector of sample delays
%   rsh     [Nx1] = Vector of runs, skips, and holds
%
% OUTPUT:
%   z       [Nx1] = Filtered output signal
%
% RESOURCES: 
%   INSERT PAPER REFERANCE
%
% EDC Systems - ECE 4805: Senior Design
%
% Origional Version [11/05/2018], EDC SYSTEMS
% [11/22/2018], Peyton McClintock, Add comments and fix lag

function [z] = farrow(signal,tau,rsh)

%% Error Checking
%If tau is a single value make it a vector
signal = signal(:);
nOut = length(signal);
if  numel(tau) == 1
    tau = repmat(tau,[nOut,1]);
elseif numel(tau) ~= nOut
    error('Invalid tau');
end 

%% Map Tau

% [tau2,rsh] = tauMap(tau); % rsk = run-skip-hold

%% Define Farrow Parameters

% Define Coefficients
C0= [-.013824 .054062 -.157959 .616394 .616394 -.157959 .054062 -.013824];
C1= [.003143 -.019287 .1008 -1.226364 1.226364 -.1008 .019287 -.003143];
C2= [.055298 -.216248 .631836 -.465576 -.465576 .631836 -.216248 .055298];
C3= [-.012573 .077148 -.403198 .905457 -.905457 .403198 -.077148 .012573];
C=[C0; C1; C2; C3];
C=fliplr(C);

%% Zero Pad
nZeros = zeros(7,1);
skipZeros = zeros(100,1);
% signal = [nZeros; signal];
signal = [nZeros; signal; skipZeros];

%% Run Filter
z = NaN(nOut,1);

% OLD CODE I THINK IS BROKE
% for idx = 1:nOut
%     xn = signal(idx+rsh(idx):idx+rsh(idx)+7);
%     y = C*xn;
%     z(idx) = y(1)+tau2(idx)*(y(2)+tau2(idx)*(y(3)+tau2(idx)*(y(4))));    
% end
lag = cumsum(rsh).';
for idx = 1:nOut
    xn = signal(idx+lag(idx):idx+lag(idx)+7);
    y = C*xn;
    z(idx) = y(1)+tau(idx)*(y(2)+tau(idx)*(y(3)+tau(idx)*(y(4))));    
end
% Before, the "lag" was happening to only one sample, then indexing would 
% catch everything back up, basically undoing any doppler. Now, the sum of
% delays is the new "lag", meaning the delay could build up and get slower, 
% or speed back up and catch up the buffer or even pass

% % Faster...?
% A = repmat((0:7).',[1,nOut]); 
% idx2 = bsxfun(@plus,A,(1:nOut)+lag);
% xn2 = signal(idx2);
% for i = 1:nOut
%    y = C*xn2(:,i); 
%    z2(i) = y(1)+tau2(i)*(y(2)+tau2(i)*(y(3)+tau2(i)*(y(4))));
% end













