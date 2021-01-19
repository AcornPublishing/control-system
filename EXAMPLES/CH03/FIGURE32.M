% Embedded Control Systems in C/C++
% by Jim Ledin
%
% This M-file uses the pendulum model contained in pend.m
%
% Figure 3.2

clear all
close all

% Set up solution parameters
options = odeset('RelTol', 1e-9);
tspan = [0 20];

% Model parameters
theta0 = [0:90];
dtr = pi/180;
g = 9.81;
l = 1;
lin_period = 2*pi*sqrt(l/g) * ones(1,length(theta0));
period(1) = lin_period(1);

% Find the oscillation period for each initial deflection angle
disp('Running...');
for i=2:length(theta0)
    % Solve the pendulum motion equation
    ic = [dtr*theta0(i) 0];
    [t, y] = ode45('pend', tspan, ic, options);
    
    % Search pendulum trajectory to get oscillation period
    if (ic(1) < 0)
        % Find first minimum
        lb = 2;
        while y(lb-1,2)<y(lb,2) | y(lb,2)>y(lb+1,2)
            lb = lb + 1;
        end
        
        % Find next maximum
        ub = lb + 1;
        while y(ub-1,2)>y(ub,2) | y(ub,2)<y(ub+1,2)
            ub = ub + 1;
        end
    else
        % Find first maximum
        lb = 2;
        while y(lb-1,2)>y(lb,2) | y(lb,2)<y(lb+1,2)
            lb = lb + 1;
        end
        
        % Find next maximum
        ub = lb + 1;
        while y(ub-1,2)<y(ub,2) | y(ub,2)>y(ub+1,2)
            ub = ub + 1;
        end
    end
    
    % Compute the oscillation period
    period(i) = interp1(y(lb:ub,2), t(lb:ub), 0);
end   

% Plot the oscillation period as a function of initial deflection angle
f = figure(1);
set(f, 'Color', [1 1 1]);
plot(theta0, period, 'k', theta0, lin_period, 'k--');
axis([0 90 1.9 2.4])

% Annotate the plot
xlabel('{\it\theta_0}, degrees')
ylabel('Oscillation Period, seconds')
grid on
legend('Nonlinear Model', 'Linearized Model');

disp('Done');
