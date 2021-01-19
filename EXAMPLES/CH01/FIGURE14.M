% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Figure 1.4

clear all
close all

% Time range
tmax = 2;
dt = 0.0001;
t = 0:dt:tmax;

% Generate & plot the function
damping = 0.3;
omega = 10;
f = 1 - (exp(-damping*omega*t) / sqrt(1-damping^2)).* ...
    sin(omega*sqrt(1-damping^2)*t + acos(damping));
h = plot(t,f, 'k');
set(h, 'LineWidth', 2)

grid
axis([0 tmax 0 1.5])
hold on

% Find & plot 0.1 and 0.9 step response x coordinates
pt1 = find(f >= 0.1);
xpt1 = (pt1(1) - 1)*dt;

pt9 = find(f >= 0.9);
xpt9 = (pt9(1) - 1)*dt;

plot([xpt1 xpt1], [0 0.1+0.05], 'k');
plot([xpt9 xpt9], [0 0.9+0.05], 'k');

% Find & plot the peak
ypeak = max(f);
xpeak = find(f == ypeak);
tpeak = dt*(xpeak(1) - 1);

plot([tpeak tpeak], [ypeak-0.05 1.5], 'k')
plot([tpeak-0.1 0.7], [ypeak ypeak], 'k')

plot([1.3 2], [1.01 1.01], 'k')
plot([1.3 2], [0.99 0.99], 'k')

% Select data from 1.3 seconds to end
tskip = 1.3;
nskip = tskip / dt;
f1 = f(nskip:end);

% Find & plot settling time to within 1%
xsettle = find(f1 > 0.99);
tsettle = dt*(xsettle(1) - 1) + tskip;
plot([tsettle tsettle], [0 0.99], 'k')

% Show no X ticks & desired Y ticks
hold off
set(gca, 'xtick', [], 'ytick', [0 0.1 0.9 1])
