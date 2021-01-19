function p = select_poles(order, t_settle, damp_ratio, settling_pct)

%SELECT_POLES  Determine pole locations for pole placement design.
%
%   P = SELECT_POLES(ORDER, T_SETTLE, DAMP_RATIO) computes a set
%   of pole locations for the system order ORDER, with settling
%   time T_SETTLE (in seconds) and a damping ratio of DAMP_RATIO
%   where (0 < DAMP_RATIO < 1). The settling percentage error
%   defaults to 1%.
%
%   P = SELECT_POLES(ORDER, T_SETTLE, DAMP_RATIO, SETTLING_PCT)
%   allows the settling percentage error SETTLING_PCT to be
%   specified.
%
%   The poles are located equidistantly along an arc in the
%   complex plane that satisfies the given settling time and
%   damping ratio constraints.
%
%   Example: p = select_poles(4, 0.5, 0.8, 0.02)
%   This computes the poles for a 4th order system with a settling
%   time of 0.5 seconds, a damping ratio of 0.8 and a settling
%   error of 2%. The result is p = (-7.8240 +/- 5.8680i,
%   -9.5559 +/- 2.0818i).
%
%   By Jim Ledin 2002.

if nargin < 4
    settling_pct = 0.01; % If no settling percentage given, use 1%
end

settling_limit = -log(settling_pct) / t_settle;
amplitude = settling_limit / damp_ratio;
order_is_odd = (mod(order, 2) == 1);

if order_is_odd
    n_complex_pairs = (order-1) / 2;
    p(n_complex_pairs+1) = -amplitude; % One pole is on the real axis
else
    n_complex_pairs = order / 2;
end

if order > 1
    angle = acos(damp_ratio);
    d_theta = 2*angle / (order-1);
    theta = pi - angle  + (0:(n_complex_pairs-1))*d_theta;
    p(1:n_complex_pairs) = amplitude * exp(i*theta);
    
    if order_is_odd
        p(n_complex_pairs+2:2*n_complex_pairs+1) = conj(p(n_complex_pairs:-1:1));
    else
        p(n_complex_pairs+1:2*n_complex_pairs) = conj(p(n_complex_pairs:-1:1));
    end
end
