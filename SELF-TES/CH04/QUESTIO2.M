% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 4 Self-test question 6
% This M-file requires the Control System Toolbox

clear all
close all

tfplant = tf(2, [1 16 50]);

sisotool(tfplant)
