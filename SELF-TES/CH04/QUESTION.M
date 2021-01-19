% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 4 Self-test question 1
% This M-file requires the Control System Toolbox

clear all
close all

tf1 = tf(1, [1 0]);
tf2 = tf(1, [1 250]);
tf3 = tf(4e7, [1 40 9e4]);
tfplant = tf1 * tf2 * tf3;

sisotool('rlocus', tfplant)
