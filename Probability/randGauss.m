%--------------------------------------------------------------------------
%
% File Name:      randGuass.m
% Date Created:   2015/01/28
% Date Modified:  2015/01/28
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    EC 505 Stochastic Processes
%                 Homework 1 - Problem 1.8
%                 Random Guassian Generator
%                 Creates guassian distributed random variables from
%                 uniformly distrubted random variables using the
%                 Box-Muller technique. 
%
% Inputs:         U_R: vector of uniformly distributed random variable
%                      realizations which can be obtained using 
%                      rand(length,1)
%                 U_theta: vector of uniformly distributed random variable
%                      realizations which can be obtained using 
%                      rand(length,1)
% Outputs:        X: vector of Gaussian distributed random variable
%                    realizations
%                 Y: vector of Gaussian distributed random variable
%                    realizations
%
% Example:        [X,Y] = randGauss(rand(100,1),rand(100,1))
%
%--------------------------------------------------------------------------

function [X,Y] = randGauss(U_R,U_theta)

theta = U_theta.*(2*pi);      % Uniform distributed R.V. theta
R = (-2*log(1-U_R)).^(1/2);   % Rayleigh distributed R.V. R
X = R.*cos(theta);            % Gaussian distributed R.V. X
Y = R.*sin(theta);            % Gaussian distributed R.V. Y

end