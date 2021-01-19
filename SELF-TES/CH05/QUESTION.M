% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Question 10

clear all
close all

% Create the plant model
tfplant = tf(2, [1 16 50])
ssplant = ss(tfplant);

% Controller performance specifications
t_settle = 0.5; % Seconds
damp_ratio = 0.7;
obs_pole_mult = 4; % Multiplies closed loop poles to place observer poles

% Check controllability
c0 = ctrb(ssplant);
controllable = (rank(c0) == length(c0))
if ~controllable
    error('Plant is not controllable');
end

% Check observability
ob = obsv(ssplant);
observable = (rank(ob) == length(ob))
if ~observable
    error('Plant is not observable');
end

n = size(ssplant.a, 1); % Number of states
m = size(ssplant.c, 1); % Number of outputs

% Augment the plant with the error integral
a = [zeros(m) ssplant.c; zeros(n, m) ssplant.a];
b = [ssplant.d; ssplant.b];

% Design the controller gain
p = select_poles(n+1, t_settle, damp_ratio);
K = place(a, b, p);
Ki = K(1);
K0 = K(2:end);

% Design the observer gain
q = obs_pole_mult * select_poles(n, t_settle, damp_ratio);
L = place(ssplant.a', ssplant.c', q)'

% Create a state space observer
ssobs = ss(ssplant.a-L*ssplant.c, [L ssplant.b-L*ssplant.d], eye(n), 0);

% Compute the feedforward gain
Nxu = inv([ssplant.a ssplant.b; ssplant.c ssplant.d]) * [zeros(n,m); eye(m)];
Nx = Nxu(1:n, :);

% Augment the plant model to pass the inputs as additional outputs
ssplant_aug = ss(ssplant.a, ssplant.b, [ssplant.c; zeros(m, n)], [ssplant.d; eye(m)]);

% Extract the linear model from the ss_pid.mdl Simulink diagram
[a,b,c,d] = linmod('ss_pid');
sscl = ss(a,b,c,d);

% Display closed loop poles and step response
plot_poles(sscl, t_settle, damp_ratio);
figure(2)
step(sscl, 0:0.001:1)