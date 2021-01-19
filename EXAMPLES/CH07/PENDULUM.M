% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 7 - Inverted pendulum on a cart example

clear all
close all

% Extract the linear model
[a,b,c,d] = linmod('Pendulum');
ssplant = ss(a,b,c,d);

set(ssplant, 'InputName', 'Cart Force');
set(ssplant, 'OutputName', {'Pend Angle', 'Pend Vel', 'Cart Pos', 'Cart Vel'});
set(ssplant, 'StateName', {'Pend Angle', 'Cart Pos', 'Pend Vel', 'Cart Vel'});

% Design the controller gain
Q = diag([1 1e6 1 1]);
R = 1;

K = lqr(ssplant.a, ssplant.b, Q, R)

cl_sys = feedback(ssplant, -K*inv(ssplant.c), +1);

t_settle = 1.5;
damp_ratio = 0.7;
plot_poles(cl_sys, t_settle, damp_ratio);

% Design the observer gain
a = ssplant.a; b = ssplant.b;
c = [1 0 0 0; 0 1 0 0]; d = [0; 0];

QN = 0.1^2;
RN = [0.01^2/12 0; 0 0.0044^2/12];

g = b;
h = d;

obs_plant = ss(a, [b g], c, [d h]);

[kest, L] = kalman(obs_plant, QN, RN);

% Create a state space observer-controller
ssobsctrl = ss(a-L*c, [L b-L*d], -K, 0);

% Augment the plant model to pass the inputs as additional outputs
r = size(b, 2); % Number of inputs
n = size(a, 1); % Number of states
ssplant_aug = ss(a, b, [c; zeros(r, n)], [d; eye(r)]);

% Extract the system from the reference input to the cart position
ssplant2 = ss(a, b, c, d);
sys_r_to_x = ssplant2(2,1);

% Compute the feedforward gain
Nxu = inv([sys_r_to_x.a sys_r_to_x.b; sys_r_to_x.c sys_r_to_x.d]) * [zeros(n,1); 1];
Nx = Nxu(1:n);
Nu = Nxu(end);
N = Nu + K*Nx;

% Form the closed loop system with positive feedback
sscl = N*feedback(ssplant_aug, ssobsctrl, +1);
figure
plot_poles(sscl, t_settle, damp_ratio);

% Plot the step response
set(sscl,'InputName','r (m)', 'OutputName', {'theta (rad)', 'x (m)', 'F (N)'});
figure
step(sscl)