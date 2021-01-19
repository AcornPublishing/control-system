function [N, ssobsctrl, sscl] = ss_design(ssplant, t_settle, damp_ratio, obs_pole_mult)

%SS_DESIGN  Design a state space observer-controller and feedforward gain for a SISO plant.
%
%   [N, SSOBSCTRL, SSCL] = SS_DESIGN(SSPLANT, T_SETTLE, DAMP_RATIO, OBS_POLE_MULT)
%
%   This function computes the feedforward gain matrix N, the state
%   space observer-controller SSOBSCTRL, and the state space closed loop
%   system SSCL using pole placement techniques for a SISO plant SSPLANT.
%
%   The inputs to this function are the state space plant model SSPLANT,
%   the step response settling time requirement T_SETTLE (in seconds),
%   the minimum closed loop damping ratio DAMP_RATIO (0.7-0.8 is good),
%   and the factor by which to multiply the closed loop pole locations
%   to determine the observer pole locations OBS_POLE_MULT (usually in
%   the range 3-5).
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
p = select_poles(n, t_settle, damp_ratio);
K = place(ssplant.a, ssplant.b, p);

% Design the observer
q = obs_pole_mult * p;
L = place(ssplant.a', ssplant.c', q)';

% Create a state space observer-controller
ssobsctrl = ss(ssplant.a-L*ssplant.c, [L ssplant.b-L*ssplant.d], -K, 0);

% Compute the feedforward gain
Nxu = inv([ssplant.a ssplant.b; ssplant.c ssplant.d]) * [zeros(n,1); 1];
Nx = Nxu(1:n);
Nu = Nxu(end);
N = Nu + K*Nx;

% Augment the plant model to pass the input as an additional output
ssplant_aug = ss(ssplant.a, ssplant.b, [ssplant.c; zeros(1, n)], [ssplant.d; 1]);

% Form the closed loop system with positive feedback
sscl = N * feedback(ssplant_aug, ssobsctrl, +1);
