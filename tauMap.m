%
%
% -1 = hold
%  0 = run
%  1 = skip

function [tauBounded,rsh] = tauMap(tau)

tauBounded = tau; 
nTau = length(tau);
rsh = zeros(nTau,1);

for tt = 1:nTau % won't work for large sample jumps in tau
    if tau(tt) > 0.5
        tau(tt:end) = tau(tt:end) - 1;
        rsh(tt) = -1;
    elseif tau(tt) < -0.5
        tau(tt:end) = tau(tt:end) + 1;
        rsh(tt) = 1;
    end
end