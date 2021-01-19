% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 6 - LQR & Kalman Filter design example
% This file creates Figures 6.2 and 6.3.

clear all
close all

tfplant = tf(100, [1 1.8 100])
ssplant = ss(tfplant);
Q = diag([50 1])
R = 1;
K = lqr(ssplant, Q, R)

ssplant.c = eye(2);
cl_sys = feedback(ssplant, -K, +1);
step(cl_sys)

figure
t_settle = 1;
damp_ratio = 0.7;
plot_poles(cl_sys, t_settle, damp_ratio)

QN = 0.1^2;
RN = 0.1^2/12;

tfplant = tf(100, [1 1.8 100])
ssplant = ss(tfplant);
G = ssplant.b;
H = ssplant.d;

obs_plant = ss(ssplant.a, [ssplant.b G], ssplant.c, [ssplant.d H]);

[kest, L] = kalman(obs_plant, QN, RN);
L

[N, ssobsctrl, sscl] = optimal_siso(ssplant, Q, R, G, H, QN, RN);
figure
plot_poles(sscl, t_settle, damp_ratio)
