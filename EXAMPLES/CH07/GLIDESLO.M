% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 7 - Aircraft glideslope control design example

clear all
close all

% Create and display the linear plant model
a = [-0.01800143125991  -9.79655573578622                  0; ...
      0.00292507812316  -0.00627647592567                  0; ...
     -0.00000000000000  81.91225790130675                  0];
 
b = [-4.83740055421646   0.00000525737720; ...
      0.57861798257709   0.00000000301493; ...
                     0                  0];
   
c = eye(3);
d = 0;

ssplant = ss(a, b, c, d);

set(ssplant, 'InputName', {'alpha','T'}, 'StateName', {'V','gamma','h_err'}, ...
    'OutputName', {'V','gamma','h_err'})
ssplant

% Design the observer-controller
n = size(ssplant.a, 1); % Number of states
t_settle = 2;
damp_ratio = 0.8;

p = select_poles(n, t_settle, damp_ratio);
K = place(ssplant.a, ssplant.b, p)

obs_pole_mult = 3;
q = obs_pole_mult * p;
L = place(ssplant.a', ssplant.c', q)'
ssobsctrl = ss(ssplant.a-L*ssplant.c, [L ssplant.b-L*ssplant.d], -K, 0);

r = size(ssplant.b, 2); % Number of inputs
ssplant_aug = ss(ssplant.a, ssplant.b, [ssplant.c; zeros(r, n)], ...
       [ssplant.d; eye(r)]);
sscl = feedback(ssplant_aug, ssobsctrl, +1);

% Plot the closed loop pole locations
figure
plot_poles(sscl, t_settle, damp_ratio);
