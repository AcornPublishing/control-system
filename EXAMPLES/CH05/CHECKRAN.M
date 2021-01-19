% Embedded Control Systems in C/C++
% by Jim Ledin
%
% Chapter 5 - Rank checking example

a1=[1 1; 2 2]
a2=[1 1+1e-15; 2 2]
rank(a1)
rank(a2)
a2-a1

