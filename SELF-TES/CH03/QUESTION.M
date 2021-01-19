% Embedded Control Systems in C/C++
%
% By Jim Ledin
%
% This M-file requires the Control System Toolbox and the 
% the System Identification Toolbox
%
% This M-file performs the following sequence of steps:
%
% 1) Create a 4th order linear system model.
% 2) Generate swept-frequency and step input signals.
% 3) Execute the linear model using the input signals with noise
%    added to the outputs.
% 4) Perform system identification using N4SID.
% 5) Plot comparisons of the original and identified systems.

clear all
close all

disp('Running...')
nbits = 12; % Adjust this to change the quantization level

% Create a 4th order linear system
num = [-11 54 -87 65];
den = [1 12 54 108 65];
sys = tf(num, den)
noise_amp = 0.000;

% Generate a swept sine and a step response
f0 = 0;
ff = 4;
dt = 0.01;
tmax = 40;
t = (0:dt:tmax)';
n1 = noise_amp * randn(size(t));
n2 = noise_amp * randn(size(t));

w = 2*pi*(f0 + (ff-f0)*t/tmax);
u1 = sin(w.*t/2);

len = length(t);
y1 = lsim(sys, u1, t) + n1;
y1 = quant(y1, 2/2^(nbits-1));
u2 = ones(size(u1));
y2 = lsim(sys, u2, t) + n2;
y2 = quant(y2, 2/2^(nbits-1));

subplot(211)
h = plot(t, u1, 'k', t, y1, 'k--');
set(h, 'LineWidth', 2)
legend('u1', 'y1')
ylabel('Swept Frequency')
grid

subplot(212)
h = plot(t, u2, 'k', t, y2, 'k--');
set(h, 'LineWidth', 2)
legend('u2', 'y2')
ylabel('Step Response')
xlabel('Time, Seconds')
grid

% Perform system identification
data = merge(iddata(y1, u1, dt), iddata(y2, u2, dt));

order = 4;
id_sys = pem(data, order, 'focus', 'simulation');
id_sys = d2c(id_sys);
tf(id_sys)

% Compare the resulting model to the original system
figure(2)
pzmap(sys, id_sys)
legend('Original System', 'Identified System')

figure(3)
[y_sys, t_sys] = step(sys, t);
[y_id, t_id] = step(id_sys, t);
h = plot(t_sys,y_sys, 'k', t_id,y_id, 'k--');
set(h, 'LineWidth', 2)
legend('Original System', 'Identified System')
ylabel('Step Response')
xlabel('Time, Seconds')
grid
disp('Done')
