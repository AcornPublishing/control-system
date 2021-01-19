% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 7 - Answers to Self-Test questions

clear all
close all

% Question 1
a = [0 0 1 0; 0 0 0 1; 90.55 0 0 0; -2.26 0 0 0];
b = [0; 0; -23.08; 3.08];
c = [1 0 0 0; 0 0 1 0; 0 1 0 0; 0 0 0 1];
d = 0;

ssplant = ss(a, b, c, d)

% Question 2
Q = eye(4);
R = 1;
K = lqr(ssplant, Q, R)
cl_sys = feedback(ssplant, -K*inv(ssplant.c), +1);
t_settle = 0.75;
damp_ratio = 0.7;
plot_poles(cl_sys, t_settle, damp_ratio);

% Question 3
Q = diag([1 5e4 1 1]);
K = lqr(ssplant, Q, R)
cl_sys = feedback(ssplant, -K*inv(ssplant.c), +1);
figure
plot_poles(cl_sys, t_settle, damp_ratio);

% Question 4
c = [1 0 0 0; 0 1 0 0];
ssplant = ss(a, b, c, d);

% Question 5
obs_pole_mult = 3;
p = pole(cl_sys);
q = obs_pole_mult * p;
L = place(ssplant.a', ssplant.c', q)';

% Question 6
% Create a state space observer-controller
ssobsctrl = ss(ssplant.a-L*ssplant.c, [L ssplant.b-L*ssplant.d], -K, 0);

% Question 7
% Augment the plant model to pass the inputs as additional outputs
r = size(ssplant.b, 2); % Number of inputs
n = size(ssplant.a, 1); % Number of states
ssplant_aug = ss(ssplant.a, ssplant.b, [ssplant.c; zeros(r, n)], [ssplant.d; eye(r)]);

% Question 8
% Form the closed loop system with positive feedback
sscl = feedback(ssplant_aug, ssobsctrl, +1);

figure
plot_poles(sscl, t_settle, damp_ratio);

% Question 9
% Extract the system from the reference input to the cart position
sys_r_to_x = ssplant(2,1);

% Question 10
% Compute the feedforward gain
Nxu = inv([sys_r_to_x.a sys_r_to_x.b; sys_r_to_x.c sys_r_to_x.d]) * [zeros(n,1); 1];
Nx = Nxu(1:n);
Nu = Nxu(end);
N = Nu + K*Nx

% Question 11
% Form the closed loop system with positive feedback
sscl = N*sscl;

% Plot the step response
set(sscl,'InputName','r (m)', 'OutputName', {'theta (rad)', 'x (m)', 'F (N)'});
figure
step(sscl)