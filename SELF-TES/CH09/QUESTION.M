% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 9 - Answers to Self-Test question 3

a = [0 0 1 0; 0 0 0 1; 90.55 0 0 0; -2.26 0 0 0];
b = [0; 0; -23.08; 3.08];
c = [1 0 0 0; 0 1 0 0];
d = [0; 0];

% The plant has 1 input and 4 states
% Augment the model to pass the input as an output
ssplant_aug = ss(a, b, [c; zeros(1, 4)], [d; 1]);

h = 0.01;
pend_model = c2d(ssplant_aug, h, 'foh');

write_cpp_model(pend_model, 'pend_model.cpp');
