% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Figure 4.1
% This M-file requires the Control System Toolbox

clear all
close all

tfplant = tf(100, [1 1.8 100])

sisotool('rlocus', tfplant)
