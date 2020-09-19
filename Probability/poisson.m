%--------------------------------------------------------------------------
%
% File Name:      poisson.m
% Date Created:   2015/02/26
% Date Modified:  2015/02/26
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    EC 505 Stochastic Processes
%                 Homework 4 - Problem 4.6.a
%                 Generates Poisson Random Process
%
% Inputs:         Na: Desired number of arrivals to generate.
%                 lab: Arrival rate of the process.
%
% Outputs:        T: Generated vector of arrival times.
%                 NT: Corresponding vector of arrivals.
%
% Example:        [T,NT] = poisson(Na,lam)
%
%--------------------------------------------------------------------------

function [T,NT] = poisson(Na,lam)

% Na Independent, Exponentially Distributed Interarrival Times
tau = randexp(Na,1,lam) ;

% Corresponding Vector of Waiting Times
T = cumsum(tau);

% Cumulative Sum of Arrivals
NT = (1:length(T))';

end