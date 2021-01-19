% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Figure 3.1
% This M-file requires the Control System Toolbox

clear all
close all

% Create a linear system
b = 100;
a = [1 1.8 100];
sys = tf(b, a);

% Compute the magnitude and phase of the response
w = logspace(0, 2, 1000);
[mag, phase, w] = bode(sys, w);
mag = mag(:);
phase = phase(:);

% Plot the magnitude
subplot(211)
semilogx(w, 20*log10(mag), 'k')
grid on
ylabel('Magnitude, dB')

% Plot the phase
subplot(212)
semilogx(w, phase, 'k')
grid on
ylabel('Phase, degrees')
xlabel('Frequency, rad/sec')
