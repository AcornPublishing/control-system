% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 10 - Helicopter control system example
%
% This M-file sets up the system parameters for the
% Helicopter simulation.

% Units: Metric (meters, kg*m^2); Angles measured in degrees.

ground_position = [0 0 0];
gravity_vector = [0 0 9.81];

% Helicopter Body:
body_mass = 10;
body_length = 1;
body_radius = 0.4;
body_inertia = body_mass * ...
    [body_radius^2/2 0 0; 0 body_length^2/2 0; 0 0 body_length^2/2];
body_position_ic = [0 0 0];
body_orientation_ic = [0 0 0];

% Helicopter main rotor:
mr_mass = 0.1;
mr_length = 1;
mr_radius = 0.025;
mr_inertia = mr_mass * ...
    [mr_radius^2/2 0 0; 0 mr_length^2/2 0; 0 0 mr_length^2/2];
mr_position = [0.1 0 -0.2];
mr_angle_ic = 90;
mr_orientation = [0 0 0];
mr_rotation_axis = [0 0 1];
mr_vel = -(125/(mr_length / 2)) * 360/(2*pi) / 2; % Tip speed = 125 m/s

% Helicopter tail rotor:
tr_mass = 0.01;
tr_length = 0.4;
tr_radius = 0.015;
tr_inertia = tr_mass * ...
    [tr_radius^2/2 0 0; 0 tr_length^2/2 0; 0 0 tr_length^2/2];
tr_position = [-1.5 0 -0.04];
tr_orientation = [0 0 0]; % [psi theta phi]
tr_rotation_axis = [0 1 0];
tr_vel = (100/(tr_length / 2)) * 360/(2*pi) / 2; % Tip speed = 100 m/s

% Compute trim lift and pitching moment
trim_lift_force = -(body_mass + mr_mass + tr_mass) * gravity_vector(3);
trim_pitch_mom = (mr_mass*(mr_position(1) - body_position_ic(1)) + ...
    tr_mass*(tr_position(1) - body_position_ic(1))) * gravity_vector(3);

% Drag coefficient
Cd = 0.1;

% Discrete-time controller time step
dt = 0.01;

% Waypoint table
% Columns: WP N, WP E, WP Alt, Hover Yaw, Hover Delay, Next WP
% (0 means just increment to the next waypoint)
waypoint = [ ...
    100,   0,  25,  0,  0,  0; ...
    100, 100,  25,  0,  0,  0; ...
      0, 100,  25,  0,  0,  0; ...
      0,   0,  25,  0,  0,  0; ...
    100,   0,  25,  0,  0,  0; ...
    100, 200,  50,  0,  0,  0; ...
    200, 200,  50,  0,  0,  0; ...
    200, 100,  50,  0,  0,  0; ...
    100, 100,  50,  0,  0,  0; ...
    100, 200,  50,  0,  0,  0; ...
    200, 200,  50,  0,  0,  0; ...
    200, 100,  50,  0,  0,  0; ...
      0, 100,  25,  0,  0,  0; ...
      0,   0,  25,  0,  0,  1; ...
];

% Adjust North and East positions to match the VR world arrangement
waypoint(:,1:2) = -waypoint(:,1:2);

% Virtual Reality display constants
ned_pos_to_vr = [0 0 -1; 1 0 0; 0 -1 0];
ned_rot_to_vr = [0 0 -1 0; 1 0 0 0; 0 -1 0 0; 0 0 0 1];
mr_offset = [1.47 0 0.2];
tr_offset = [-4.88 0 -1.36];