%--------------------------------------------------------------------------
%
% File Name:      telerp.m
% Date Created:   2015/02/26
% Date Modified:  2015/02/26
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    EC 505 Stochastic Processes
%                 Homework 4 - Problem 4.6.b
%                 Generates Random Telegraph Wave Random Process
%
% Inputs:         From the poissrp.m function:
%                 X: Matrix of process sample paths.
%                    Each row is a sample path, each column is a 
%                    different time point. 
%                 t: Vector of time points at which to generate samples.
%
% Outputs:        Y: Output sample path.
%                 t: Vector of time points for plotting. 
%
% Example:        [Y,t] = telerp(X,t)
%
%--------------------------------------------------------------------------

function [Y,t] = telerp(X,t)

% Generate Random Variable Z
% Z = +1 wp 0.5
% z = -1 wp 0.5
Z = sign(2*rand(size(X))-1);

% Calculate Random Telegraph Wave
Y = Z.*(-1*ones(size(X))).^X;

end