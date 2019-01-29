% tauMap.m
%
% DESCRIPTION: Will bound a given tau delay vector to -0.5 -> 0.5. This is
% done by subtracting or adding to the data while mapping this skip or hold
% to a vector tracking its progress. This is written to work aside farrow.m
%
% EXECUTION:
%   [tauBounded,rsh] = tauMap(tau)
%
% INPUT:
%   in1 [Nx1] = Vector of sample delays
%
% OUTPUT:
%   tauBounded  [2x2]   = variable description
%   rsh         [str]   = Run-Skip-Hold, vector tracking the buffer delays
%       -X = Hold of X samples
%        0 = Run as normal
%       +X = Skip of X samples
%
% EDC Systems - ECE 4805: Senior Design
%
% Origional Version [11/12/2018], EDC Systems
% [11/22/2018], Peyton McClintock, Fixed the allocation of output tau

function [tauBounded,rsh] = tauMap(tau)

tauBounded = tau; 
nTau = length(tau);
rsh = zeros(nTau,1);

% OLD CODE CAUSE I SUCK AT GIT
% for tt = 1:nTau
%     thisTau = tau(tt);
%     if thisTau > 0.5
%         tau(tt:end) = tau(tt:end) - 1;
%         rsh(tt) = rsh(tt)-1;
%     elseif thisTau < -0.5
%         tau(tt:end) = tau(tt:end) + 1;
%         rsh(tt) = rsh(tt)+1;
%     end
% end

% New code cause old code makes no sense
for tt = 1:nTau 
    if tauBounded(tt) > 0.5
        tauBounded(tt:end) = tauBounded(tt:end) - 1;
        rsh(tt) = rsh(tt)-1;
    elseif tauBounded(tt) < -0.5
        tauBounded(tt:end) = tauBounded(tt:end) + 1;
        rsh(tt) = rsh(tt)+1;
    end
end
% keyboard
% % DEBUG PLOT
% figure(1); clf; hold on; grid on;
% plot(tau)
% ylabel('Delay [s]')
% xlabel('Sample')
% title('Original Tau Vector')
% axis([1 10000 tau(10000) tau(1)])
% 
% figure(2); clf; hold on; grid on;
% plot(tauBounded)
% ylabel('Delay [s]')
% xlabel('Sample')
% title('Original Tau Vector')
% axis([1 10000 -0.5 0.5])










