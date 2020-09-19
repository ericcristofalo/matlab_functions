%--------------------------------------------------------------------------
%
% File Name:      cayley.m
% Date Created:   2019/01/22
% Date Modified:  2019/01/22
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Cayley Transform Matrices
%                 Cay(R) = (I-R)*(I+R)^(-1)
%
% Inputs:         R: R in SO(d)
%
% Outputs:        w: in so(d) "tangent space"
%
%--------------------------------------------------------------------------

function w = cayley(R)

d = size(R,1);
w_ = (eye(d)-R)/(eye(d)+R);
w = skewSymMatInv(w_);

end