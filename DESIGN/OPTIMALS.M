function [N, ssobsctrl, sscl] = optimal_siso(ssplant, Q, R, G, H, QN, RN)

%OPTIMAL_SISO  Design an optimal SISO state space observer-controller and feedforward gain.
%
%   [N, SSOBSCTRL, SSCL] = OPTIMAL_SISO(SSPLANT, Q, R, G, H, QN, RN)
%
%   This function computes the feedforward gain N, the state space
%   observer-controller SSOBSCTRL, and the state space closed loop
%   system SSCL using optimal controller and estimator design techniques.
%
%   The inputs to this function are the state space plant model SSPLANT,
%   the weighting matrix Q for the states, the weight R for the control
%   input, the process noise model matrices G and H, the process noise
%   variance QN, and the measurement noise variance RN.
%
%   The input to SSOBSCTRL is the vector [Y; U] where Y is the plant
%   output and U is the plant input.
%
%   The plant input U is computed by summing the output of SSOBSCTRL
%   with N*R where R is the reference input.

%   By Jim Ledin, 2002.

% Verify the plant is SISO
if ~issiso(ssplant)
    error('Plant must be SISO');
end

n = size(ssplant.a, 1); % Number of states

% Check controllability
if rank(ctrb(ssplant)) ~= n
    error('Plant is not controllable');
end

% Check observability
if rank(obsv(ssplant)) ~= n
    error('Plant is not observable');
end

% Design the controller gain
K = lqr(ssplant, Q, R);

% Design the observer gain
obs_plant = ss(ssplant.a, [ssplant.b G], ssplant.c, [ssplant.d H]);
[kest, L] = kalman(obs_plant, QN, RN);

% Create a state space observer-controller
ssobsctrl = ss(ssplant.a-L*ssplant.c, [L ssplant.b-L*ssplant.d], -K, 0);
set(ssobsctrl, 'InputName', {'y', 'u'});

% Compute the feedforward gain
Nxu = inv([ssplant.a ssplant.b; ssplant.c ssplant.d]) * [zeros(n,1); 1];
Nx = Nxu(1:n, :);
Nu = Nxu(n+1:end, :);
N = Nu + K*Nx;

% Augment the plant model to pass the inputs as additional outputs
ssplant_aug = ss(ssplant.a, ssplant.b, [ssplant.c; zeros(1, n)], [ssplant.d; 1]);

% Form the closed loop system using positive feedback
sscl = N * feedback(ssplant_aug, ssobsctrl, +1);
set(sscl, 'InputName', 'r', 'OutputName', {'y', 'u'});
