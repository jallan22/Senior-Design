% farrow.m

function [z] = farrow(signal,tau)

%% Error Checking
%If tau is a single value make it a vector
signal = signal(:);
nOut = length(signal);
if  numel(tau) == 1
    tau = repmat(tau,[nOut,1]);
    
elseif numel(tau) ~= nOut
    error('Invalid tau');
    
end 

%% INSERT TAU MAPPER

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
signal = [nZeros; signal];

%% Run Filter
z = NaN(nOut,1);
for nIn = 8:length(signal)
    xn = signal(nIn-7:nIn);
    y = C*xn;
    z(nIn-7) = y(1)+tau(nIn-7)*(y(2)+tau(nIn-7)*(y(3)+tau(nIn-7)*(y(4))));
end

    