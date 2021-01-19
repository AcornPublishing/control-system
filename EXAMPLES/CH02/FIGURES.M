% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Simulink is required: This M-file executes the Simulink model
% PID_Controller.mdl
%
% Figures 2.2-2.5

clear all
close all

% Controller parameters
Kp = 2; % Full PID control
Ki = 0.1;
Kd = 1;
limit = inf; % No limiting
delay = 0.001;
integ_threshold = 1e9; % No integrator threshold

% Run the simulation
sim('PID_Controller')

subplot(411)
h = plot(response.time, response.signals.values, 'k');
set(h, 'LineWidth', 2)
grid
ylabel('Response, y')

subplot(412)
h = plot(error.time, error.signals.values, 'k');
set(h, 'LineWidth', 2)
grid
ylabel('Error, e')

subplot(413)
h = plot(derivative.time, derivative.signals.values, 'k');
set(h, 'LineWidth', 2)
grid
ylabel('Derivative of e')

subplot(414)
h = plot(integral.time, integral.signals.values, 'k');
set(h, 'LineWidth', 2)
grid
xlabel('Time')
ylabel('Integral of e')

figure(2)

Kp = 1; % Proportional-only control
Ki = 0;
Kd = 0;
sim('PID_Controller')

subplot(211)
h = plot(response.time, response.signals.values, 'k');
set(h, 'LineWidth', 2)
grid
ylabel('Response, y')
title('Proportional Control')

Kp = 1; % PD control
Ki = 0;
Kd = 1.6;
sim('PID_Controller')

subplot(212)
h = plot(response.time, response.signals.values, 'k');
set(h, 'LineWidth', 2)
grid
xlabel('Time')
ylabel('Response, y')
title('PD Control')

figure(3)

Kp = 10; % PD control with increased proportional gain
Ki = 0;
Kd =0.5;
sim('PID_Controller')

h = plot(response.time, response.signals.values, 'k');
set(h, 'LineWidth', 2)
grid
xlabel('Time')
ylabel('Response, y')
title('PD Control')

figure(4)

Kp = 10; % PID control with actuator saturation
Ki = 0.1;
Kd = 0.8;
limit = 0.5;
sim('PID_Controller')

subplot(211)
h = plot(actuator.time, actuator.signals.values, 'k');
set(h, 'LineWidth', 2)
grid
ylabel('Actuator Position')
hold on

subplot(212)
h = plot(response.time, response.signals.values, 'k');
disp(['Peak response (no windup control): ' num2str(max(response.signals.values))])
set(h, 'LineWidth', 2)
grid
xlabel('Time')
ylabel('Response, y')
hold on

integ_threshold = 0.1; % Turn on integration threshold
sim('PID_Controller')

subplot(211)
h = plot(actuator.time, actuator.signals.values, 'k--');
set(h, 'LineWidth', 2)
hold off
a = axis;
a(3) = -1; a(4) = 1;
axis(a);

legend('No Windup Control', 'With Windup Control')

subplot(212)
h = plot(response.time, response.signals.values, 'k--');
disp(['Peak response (with windup control): ' num2str(max(response.signals.values))])
set(h, 'LineWidth', 2)
hold off

legend('No Windup Control', 'With Windup Control')
