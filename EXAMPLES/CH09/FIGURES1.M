% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 9 - Figures 9.1 and 9.2.

clear all
close all

% One-dimensional lookup table
y = [0.2 0.4 0.7 0.8 0.67 0.4 0.6 0.9];
x = [0:0.1:0.7];

stem(x,y, 'k', 'filled')
axis([-0.05 0.75 0 1])
xlabel('Input')
ylabel('Output')

% Linear breakpoint interpolation
figure

stem(x,y, 'k', 'filled')
axis([-0.05 0.75 0 1])
xlabel('Input')
ylabel('Output')

hold on
plot(x,y, 'k')
hold off