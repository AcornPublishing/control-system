% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Figure 1.5

clear all
close all

% Time range
tmax = 10;
dt = 0.0001;
t = 0:dt:tmax;

% Generate & plot the function
damping = -0.02;
omega = 2*pi;
f = 1 - (exp(-damping*omega*t) / sqrt(1-damping^2)).* ...
    sin(omega*sqrt(1-damping^2)*t + acos(damping));
h = plot(t,f, 'k', [-1 0 0 tmax], [0 0 1 1], 'k');
set(h, 'LineWidth', 2)

% Set scaling, grid, & label
axis([-1 tmax -3 5])
grid
xlabel('Time, seconds')
