% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 10 - Helicopter control system example
%
% This M-file designs the controllers for the
% Helicopter simulation

% Set up the parameters for the model
model_params

% Load the SISO linear models for the controller design
lin_models

% Design the pitch controller
t_settle = 0.4;
damp_ratio = 0.8;
obs_pole_mult = 3;
[N_p, ssobsctrl_p, sscl_p] = ss_design(0.5*pitch_sys, t_settle, ...
    damp_ratio, obs_pole_mult);

% Design the yaw controller
t_settle = 8;
[N_y, ssobsctrl_y, sscl_y] = ss_design(yaw_sys, t_settle, ...
    damp_ratio, obs_pole_mult);

% Design the roll controller
t_settle = 0.4;
[N_r, ssobsctrl_r, sscl_r] = ss_design(0.5*roll_sys, t_settle, ...
    damp_ratio, obs_pole_mult);

% Design the altitude controller
t_settle = 8;
[N_v, ssobsctrl_v, sscl_v] = ss_design(vert_sys, t_settle, ...
    damp_ratio, obs_pole_mult);

% Set up the horizontal position controller gains
Kp = 0.8; % PD proportional gain
Kd = 5; % PD derivative gain

% Set up the cross coupling reduction gains
Cp =  0.10; % Roll Torque Compensation
Cq =  0.15; % Pitch Torque Compensation

% Set limits used in the controllers
tilt_limit = 5;
alt_err_limit = 20;

% Time constant for pitch & roll smoothing filters, sec
tau = 0.8;

% Save all the variables for use in Simulink
save HelicopterData.mat