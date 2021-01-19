% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Pendulum model used by figure_3_2.m

function dy = pend(t, y)
% xdd = -3*xd^2 - 5*x + 1
g = 9.81;
l = 1;

dy = [y(2); -g/l*sin(y(1))];