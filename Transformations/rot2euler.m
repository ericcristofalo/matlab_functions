%--------------------------------------------------------------------------
%
% File Name:      rot2euler.m
% Date Created:   2014/07/24
% Date Modified:  2017/09/19
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Calculates the Euler angles given a rotation matrix.
%                 Adapted from Dingjiang Zhou.
%
% Inputs:         R: rotation matrix [3x3] or [2x2]
%
% Outputs:        euler: vector of Euler angles [3x1] or [1]
%
% Example:        euler = rot2euler(R)
%
%--------------------------------------------------------------------------

function euler = rot2euler(R)

if ( size(R,1)==2 )
  euler = acos(R(1,1));
elseif ( size(R,1)==3 )
  euler = zeros(3,1);
  euler(1,1) = atan2(R(3,2),R(3,3));      % phi
  euler(2,1) = asin(-R(3,1));             % theta
  euler(3,1) = atan2(R(2,1),R(1,1));      % psi
else
  error('Error in rot2euler.m: wrong dimensions of rotation matrix, R.');
end

end