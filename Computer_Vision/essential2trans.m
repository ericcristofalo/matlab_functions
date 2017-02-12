%--------------------------------------------------------------------------
%
% File Name:      computeHomography.m
% Date Created:   2016/04/28
% Date Modified:  2016/05/02
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Compute Transformation from Essential Matrix
%
% Inputs:         E: Essential Matrix [3x3]
%
% Outputs:        R: Rotation Matrix [3x3]
%                 t: Translation Vector [3x1]
%
% Example:        
%
%
%--------------------------------------------------------------------------

[U,Sig,V] = svd(E);

R1 = U*rotMat('z',pi/2)'*V';
rot2euler(R1)
R2 = U*rotMat('z',-pi/2)'*V';
rot2euler(R2)

t1 = U*[1,0,0;0,1,0;0,0,0]*rotMat('z',pi/2)'*V';
t1 = [-t1(2,3);t1(1,3);-t1(1,2)]
t2 = U*[1,0,0;0,1,0;0,0,0]*rotMat('z',-pi/2)'*V';
t2 = [-t2(2,3);t2(1,3);-t2(1,2)]





