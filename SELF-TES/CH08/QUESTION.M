% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 8 - Answers to Self-Test questions

clear all
close all

% Question 1
a = [  -126.8       0       1       0; ...
            0  -55.07       0       1; ...
        -5566       0       0       0; ...
            0  -737.8       0       0];

b = [   126.8       0       0; ...
            0   55.07       0; ...
         5657       0  -23.08; ...
        -2.26   737.8    3.08];

c = [   97.74  223.6  11.35  65.36];

d = 0;

sys = ss(a, b, c, d);

% Question 2
Ts = 0.01;
method = 'foh';
dsys = c2d(sys, Ts, method);

% Question 3
% Continuous system frequency response
w = logspace(-1, 3, 1000);
[mag_cont, phase_cont, w_cont] = bode(sys, w);
mag_cont = squeeze(mag_cont(:, 1, :));
mag_cont_db = 20*log10(mag_cont);
phase_cont = squeeze(phase_cont(:, 1, :));

% Continuous system step response
t = [0:0.001:0.1];
[y_cont, t_cont] = step(sys, t);
y_cont = y_cont(:, 1);

% Discrete-time system frequency response
[mag_foh, phase_foh, w_foh] = bode(dsys);
mag_foh = squeeze(mag_foh(:, 1, :));
mag_foh_db = 20*log10(mag_foh);
t = [0:Ts:0.1];
phase_foh = squeeze(phase_foh(:, 1, :));

% Discrete-time system step response
[y_foh, t_foh] = step(dsys, t);
y_foh = y_foh(:, 1);

% Plot the results
subplot(311)
plot(t_cont, y_cont, 'k-');
hold on
stairs(t_foh, y_foh, 'k:');
hold off
xlabel('Time, seconds')
ylabel('Response')
legend('continuous', method)

subplot(312)
semilogx(w_cont, mag_cont_db, 'k-', w_foh, mag_foh_db, 'k:');
ylabel('Magnitude, dB')

subplot(313)
semilogx(w_cont, phase_cont, 'k-', w_foh, phase_foh, 'k:');
xlabel('Frequency, rad/sec')
ylabel('Phase, degrees')

% Question 4
write_cpp_model(dsys, 'pend_dsys.cpp')

% Question 5
us = [4 2 1000];
xs = [2 1 100 20];
ys = [1000];

dsys_fixpt = dsys;
write_cpp_fixpt_model(dsys_fixpt, us, xs, ys, 'pend_dsys_fixpt.cpp');

% Question 6
% See the file pendulum\main.cpp

% Question 7
load dsys_output.txt

pend_dsys_output = dsys_output(:, 1);
pend_dsys_fixpt_output = dsys_output(:, 2);

figure
plot(t_cont, y_cont, 'k-');
hold on
stairs(t_foh, pend_dsys_output, 'k--');
stairs(t_foh, pend_dsys_fixpt_output, 'k:');
hold off
xlabel('Time, seconds')
ylabel('Response')
legend('continuous', 'floating-point', 'fixed-point')

