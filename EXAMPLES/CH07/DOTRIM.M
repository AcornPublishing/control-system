% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 7 - Aircraft glideslope control design example
% This file uses the Simulink model Glideslope.mdl.

clear all
close all

% Set up the initial states
x0 = [81.8 -3*pi/180 0]';
ix = [1 2 3];
u0 = [2*pi/180; 50000];
iu = [];
y0 = [];
iy = [];

alpha_trim = 0;
T_trim = 0;

% Perform the trim procedure
[x,u,y,dx]=trim('glideslope', x0, u0, y0, ix, iu, iy);

% Extract the trim angle of attack and thrust values
alpha_trim = u(1)
T_trim = u(2)

u0 = [0 0];

% Extract a linear model about the trim conditions
[a,b,c,d] = linmod('glideslope', x0, u0);
ssplant = ss(a,b,c,d);
set(ssplant, 'InputName', {'alpha','T'}, 'StateName', {'V','gamma','h_err'}, ...
    'OutputName', {'V','gamma','h_err'})
ssplant