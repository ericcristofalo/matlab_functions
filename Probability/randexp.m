function y = randexp(m,n,a)
% y = randexp([m,n],a)
% y = randexp(m,n,a)
%
%       m,n  : Dimensions of matrix generated (mxn).
%       a    : Parameter of Exponential pdf. Optional. Default: a=1.
%
%       Produces variates from the Exponential pdf defined by:
%
%                    -ax
%       f_X(x) =  a e    , x>= 0
%
%       Here a is 1/mean of the distribution. Generates an mxn matrix of
%       Exponential random variates.
%
%       The random numbers are generated using the transform method.

% W. C. Karl 

if max(size(m))>1 & nargin == 1
  a = 1;
  n = m(2);
  m = m(1);
elseif max(size(m))>1 & nargin == 2  
  a = n;
  n = m(2);
  m = m(1);
elseif max(size(m))==1 & nargin == 2
  a = 1;
elseif max(size(m))==1 & nargin == 3
else
  error(['Unrecognized input configuration'])
end;

% Generate uniform random variates
x = rand(m,n);

% Perform Transformation
y = -log(1-x)/a;
