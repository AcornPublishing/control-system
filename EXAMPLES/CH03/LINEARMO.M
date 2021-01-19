% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 3 linear models
% This M-file requires the Control System Toolbox

% Create a transfer function model

tfplant = tf(100, [1 1.8 100])

% Convert the model to a frequency domain representation

freqs = logspace(0, 2);

frplant = frd(tfplant, freqs);

% Create a Bode plot of the frequency response model

bode(frplant)

% Extract the frequency response data from the model

[response, freqs] = frdata(frplant);

% Create a new frequency response model from the data

frplant2 = frd(response, freqs);

% Create a state space model from the transfer function above

ssplant = ss(tfplant)

% Convert the state space model to a transfer function

tfplant2 = tf(ssplant)

% Add a delay at the state space model input

ssplant.inputdelay = 0.1

% Compute the eigenvalues of the transfer function and state space models

eig(tfplant)
eig(ssplant)
