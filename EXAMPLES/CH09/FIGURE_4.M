% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 9 - Figure 9.4.

clear all
close all

sys = ss(tf(1, [1 2 1]));
delay = 0.005;
order = 2;
[num, den] = pade(delay, order);
sys_delayed = sys * ss(tf(num, den));

bode(sys, sys_delayed, logspace(-2,2))
legend('Original', 'Delayed')
