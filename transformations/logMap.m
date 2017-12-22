%--------------------------------------------------------------------------
%
% File Name:      logMap.m
% Date Created:   2017/09/21
% Date Modified:  2017/09/25
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Logarithmic Map for Rotation Matrices
%                 Tron et al. 
%                 Distributed Pose Averaging in Camera Networks via Consensus on SE(3)
%
% Inputs:         R: R in SO(d)
%
% Outputs:        logR: log(R) in so(d)
%
%--------------------------------------------------------------------------

function logR = logMap(R)

d_ = size(R,1);
theta = real(acos((trace(R)-1.0)/2.0));
if theta~=0
  logRSkew = 1/(2.0*sin(theta))*(R-R');
else
  logRSkew = zeros(d_,d_);
end

if ( d_==2 )
  d = 1;
  logR = -logRSkew(1,2);
elseif ( d_==3 )
  d = 3;
  logR = [-logRSkew(1,2);logRSkew(1,3);-logRSkew(2,3)];
else
  error('Error in expMap.m: wrong dimension of rotation matrix');
end


end