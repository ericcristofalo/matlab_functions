%--------------------------------------------------------------------------
%
% File Name:      wiener.m
% Date Created:   2015/02/26
% Date Modified:  2015/02/26
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    EC 505 Stochastic Processes
%                 Homework 4 - Problem 4.6.c
%                 Generates Wiener Random Process
%
% Inputs:         From the poissrp.m function:
%                 T: Time step.
%                 alpha: Ratio of step size squared to the time interval.
%
% Outputs:        X: Output sample path.
%                 t: Vector of time points for plotting. 
%
% Example:        [X,t] = wiener(T,alpha)
%
%--------------------------------------------------------------------------

function [X,t] = wiener(T,alpha)

% Define Time Range
t = 0:T:1;
% Finding the Step Size
s = sqrt(alpha.*T);
% Bernoulli Trials via Rounded Uniform RVs
z = round(rand(length(t),1));
% Generate the Jump of Size s
jumps = s*sign(z-0.5);
% Generate Wiener Process Values
X = cumsum(jumps);

end