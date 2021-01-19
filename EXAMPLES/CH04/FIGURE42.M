% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Figure 4.11
% This M-file requires the Control System Toolbox

clear all
close all

tfplant = tf(100, [1 1.8 100])

sisotool(tfplant)
