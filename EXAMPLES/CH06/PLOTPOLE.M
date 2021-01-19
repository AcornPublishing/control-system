function plot_poles(sscl, t_settle, damp_ratio)

%PLOT_POLES  Plot system pole locations  with settling time and damping ratio constraints.
%
%   PLOT_POLES(SSCL, T_SETTLE, DAMP_RATIO)
%
%   This function plots the pole locations for the closed loop
%   system SSCL along with the settling time constraint
%   T_SETTLE (in seconds) and damping ratio DAMP_RATIO.

%   By Jim Ledin, 2002.

plot(pole(sscl), 'o')

axis equal
a = axis;
x_min = a(1); x_max = a(2);
y_min = a(3); y_max = a(4);

settling_pct = 0.01; % If no settling percentage given, use 1%
settling_limit = -log(settling_pct) / t_settle;
if x_max < -settling_limit + 0.1*(x_max - x_min)
    x_max = -settling_limit + 0.1*(x_max - x_min);
    a(2) = x_max;
end

hold on
plot([x_min x_max], [0 0], '--k')
plot([0 0], [y_min y_max], '--k')

plot([-settling_limit -settling_limit], [y_min y_max]);

angle = acos(damp_ratio);
plot([x_min 0 x_min], [x_min*tan(angle) 0 -x_min*tan(angle)])

axis(a)
hold off