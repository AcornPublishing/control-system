% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 10 - Helicopter control system example
%
% This M-file contains the linear models used in the
% controller design for the Helicopter simulation.
% These models were produced by linearizing the
% helicopter plant model.

% Roll motion linear model
roll_num = -70.5739;
roll_den = [1 0 0];
roll_sys = ss(tf(roll_num, roll_den));

% Pitch motion linear model
pitch_num = 11.3746;
pitch_den = [1 0 0];
pitch_sys = ss(tf(pitch_num, pitch_den));

% Yaw motion linear model
yaw_num = -17.0959;
yaw_den = [1 0 0];
yaw_sys = ss(tf(yaw_num, yaw_den));

% Vertical motion linear model
vert_num = 0.0979335;
vert_den = [1 0 0];
vert_sys = ss(tf(vert_num, vert_den));
