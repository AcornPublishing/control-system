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
% 3) Execute the linear model using the input signals.
% 4) Perform system identification using N4SID.
% 5) Plot comparisons of the original and identified systems.

clear all
close all

% Create a 4th order linear system in transfer function form
num = [-11 54 -87 65];
den = [1 12 54 108 65];
sys = tf(num, den)

% Generate swept sine and step input signals for a 20 second
% period with a sample rate of 100 Hz.
f0 = 0;
ff = 2;
dt = 1/100;
tmax = 20;
t = (0:dt:tmax)';

w = 2*pi*(f0 + (ff-f0)*t/tmax);
u1 = sin(w.*t/2);

u2 = ones(size(u1));

% Perform the experiments
y1 = lsim(sys, u1, t);
y2 = lsim(sys, u2, t);

% Plot the experiment inputs and outputs
subplot(211)
plot(t, u1, t, y1);
legend('u1', 'y1')
ylabel('Swept Frequency')
grid

subplot(212)
plot(t, u2, t, y2);
legend('u2', 'y2')
ylabel('Step Response')
xlabel('Time, Seconds')
grid

% Perform system identification & convert result to a continuous-time model
data = merge(iddata(y1, u1, dt), iddata(y2, u2, dt));

order = 4;
id_sys = n4sid(data, order, 'focus', 'simulation');
id_sys = d2c(id_sys);
tf(id_sys)

% Compare the resulting model to the original system
figure(2)
pzmap(sys, id_sys)
legend('Original System', 'Identified System')

figure(3)
[y_sys, t_sys] = step(sys, t);
[y_id, t_id] = step(id_sys, t);
plot(t_sys,y_sys, t_id,y_id);
legend('Original System', 'Identified System')
ylabel('Step Response')
xlabel('Time, Seconds')
grid
