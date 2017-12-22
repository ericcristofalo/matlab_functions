%--------------------------------------------------------------------------
%
% File Name:      expMap.m
% Date Created:   2017/09/21
% Date Modified:  2017/09/25
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Exponential Map for Rotation Rates
%                 Tron et al. 
%                 Distributed Pose Averaging in Camera Networks via Consensus on SE(3)
%
% Inputs:         omega: vector of rotation rates, either 1 or 3
%                        dimensional
%
% Outputs:        expOmega: exp(omega)
%
%--------------------------------------------------------------------------

function expOmega = expMap(omega)

if ( size(omega,2)~=1 )
  omega = skewSymMatInv(omega);
end
d_ = length(omega);
if ( d_==1 )
  d = 2;
  Omega = [0 -omega; omega 0];
elseif ( d_==3 )
  d = 3;
  Omega = [0 -omega(3) omega(2); omega(3) 0 -omega(1); -omega(2) omega(1)  0];
else
  error('Error in expMap.m: wrong dimension of rotation rate vector');
end
normOmega = norm(omega);
if ( normOmega==0 )
  expOmega = eye(d);
else
  expOmega = eye(d) + ...
             Omega/normOmega*sin(normOmega*pi) + ...
             Omega*Omega/(normOmega^(2.0))*(1.0-cos(normOmega*pi));
end

end