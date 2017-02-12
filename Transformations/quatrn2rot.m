%**************************************************************************
%   File Name     : quatrn2rot.m
%   Author        : Dingjiang Zhou
%                   Boston University, Boston, 02215
%   Create Time   :  
%   Last Modified : 2014/07/16 by Eric Cristofalo
%   Purpose       : convert the quaternion expression into the rotation
%                   matrix.
%**************************************************************************
function R = quatrn2rot(q)
q0 = q(1);
q1 = q(2);
q2 = q(3);
q3 = q(4);

% Save Calculation Time
q1q2 = q1*q2;
q1q3 = q1*q3;
q0q2 = q0*q2;
q0q3 = q0*q3;
q0q1 = q0*q1;
q2q3 = q2*q3;
q02 = q0^2;
q12 = q1^2;
q22 = q2^2;
q32 = q3^2;

% Rotation Matrix
R = [1-2*(q22+q32)   2*(q1q2-q0q3)   2*(q0q2+q1q3);
     2*(q1q2+q0q3)   1-2*(q12+q32)   2*(q2q3-q0q1);
     2*(q1q3-q0q2)   2*(q0q1+q2q3)   1-2*(q12+q22)];
 
end