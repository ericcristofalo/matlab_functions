%--------------------------------------------------------------------------
%
% File Name:      logMap.m
% Date Created:   2017/09/21
% Date Modified:  2019/01/23
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Logarithmic Map for Rotation Matrices
%                 Tron et al. 
%                 Distributed Pose Averaging in Camera Networks via Consensus on SE(3)
%                 Made some changes for robustness
%
% Inputs:         R: R in SO(d)
%
% Outputs:        w: log(R) in so(d) \subset \mathbb{R}^d
%
%--------------------------------------------------------------------------

function w = logMap(R)

if ( any(isnan((R)))==1 )
   error('Error in logMap.m: rotation matrix contains NAN values');
end

d = size(R);
if ( d(1,1)==2 && d(1,2)==2 )
   w = asin(R(2,1));
elseif ( d(1,1)==3 && d(1,2)==3 )
   % Find Direction Corresponding to Maximum Eigenvalue
   [V, S] = eig(R);
%    [~, index] = min(abs(diag(S) -1)); % has issues near identity matrix
   [~,index] = min(sum(abs(imag(V))));
   axis = V(:,index);
   % Find Theta
   cosTheta = (trace(R) - 1)/2;
   [~, index] = max(abs(axis));
   switch(index)
      case 1
         sinTheta = (R(3,2) - R(2,3))/(2*axis(index));
      case 2
         sinTheta = (R(1,3) - R(3,1))/(2*axis(index));
      case 3
         sinTheta = (R(2,1) - R(1,2))/(2*axis(index));
   end
   theta = atan2(sinTheta, cosTheta);
   % Set Vector
   w = theta*axis;
else
   error('Error in logMap.m: wrong dimension of rotation matrix');
end

end