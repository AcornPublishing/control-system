% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 6 - Self-Test questions 1-12.

clear all
close all

tf1 = tf(1, [1 0]);
tf2 = tf(1, [1 250]);
tf3 = tf(4e7, [1 40 9e4]);
tfplant = tf1 * tf2 * tf3;
ssplant = ss(tfplant);

ssplant2 = ssplant;
ssplant2.c = eye(4);

t_settle = 0.05;
damp_ratio = 0.7;

Q = eye(4); % Attempt 1
Q = 1e5*eye(4); % Attempt 2
Q = diag([8e5 5e5 1e5 1e5]); % Final attempt
R = 1;

K = lqr(ssplant, Q, R);

G = ssplant.b;
H = ssplant.d;
QN = 0.5^2;
RN = 0.01^2/12;
obs_plant = ss(ssplant.a, [ssplant.b G], ssplant.c, [ssplant.d H]);
[kest, L] = kalman(obs_plant, QN, RN)

sscl = feedback(ssplant2, -K, +1);
plot_poles(sscl, t_settle, damp_ratio);
figure
step(sscl)

% Create a state space observer-controller:
ssobsctrl = ss(ssplant.a-L*ssplant.c, ...
   [L ssplant.b-L*ssplant.d], -K, 0);

% Compute the feedforward gain: 
n = length(ssplant.a);
Nxu = inv([ssplant.a ssplant.b; ssplant.c ssplant.d]) ...
   * [zeros(n,1); 1];
Nx = Nxu(1:n, :);
Nu = Nxu(n+1:end, :);
N = Nu + K*Nx;

% Augment the plant model to pass the inputs as additional outputs:
ssplant_aug = ss(ssplant.a, ssplant.b, ...
   [ssplant.c; zeros(1, n)], [ssplant.d; 1]);
% Form the closed loop system using positive feedback:
sscl = N * feedback(ssplant_aug, ssobsctrl, +1);

figure
plot_poles(sscl, t_settle, damp_ratio);

figure
step(sscl, 0:0.0001:0.04)