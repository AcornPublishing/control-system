% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 9 - Answers to Self-Test question 7

clear all
close all

load pend.txt

t     = pend(:, 1);
theta = pend(:, 2);
x     = pend(:, 3);
F     = pend(:, 4);

subplot(311), plot(t, theta), legend('theta')
subplot(312), plot(t, x), legend('x')
subplot(313), plot(t, F), legend('F')
