function [X,t] = wienerp(N,t,T,alpha)
% [X,t] = wienerp(N,t,T,alpha)
%
% N     : Number of sample paths to generate
% t     : Vector of time points at which to generate samples
% T     : Time step of approximation
% alpha : Variance parameter of resulting process. OPTIONAL. Default: alpha=1
%
% X     : Matrix of process sample paths. Each row is a sample path, each
%         column is a different time point. 
%
% Generates samples of a discrete approximation to the Wiener-Levy process
% or Brownian motion. Recall this process is defined as the limit of a
% discrete time random walk. In particular, let
%
%          inf                             / +s; Prob = .5
% X_T(t) = sum W[k] u(t-kT), where W[k] = |
%          k=0                             \ -s; Prob = .5
%
% is a sequence of i.i.d. scaled Bernoulli trials. Then the Wiener-Levy
% process is obtained as:
%
%     lim    X_T(t)
%     T->0
%  s^2/T=alpha
%
% Recall that ideally m_x=0, Var[X(t)]=alpha t

% W. C. Karl 

if min(size(t)) > 1
  error('t must be a vector of time points')
end;

if max(size(N))>1
  error('N must be a scalar number of sample paths to generate')
end;

if min(t) < 0
  error('Time points must be positive');
end;

if nargin<4
  alpha = 1;
end;

t = t(:)'; % Make a row vector
maxt = max(t);

% Get sizes
Nt = length(t);
Np = N;

% Generate sampled time axis and Ns = number of sampled points
ts = 0:T:maxt+T; 
Nts = length(ts);

% For convergence the step size of the discrete time random walk must scale
% with alpha and T so that s^2/T = alpha. This assures that.
s = sqrt(alpha*T);

% Now generate a sequence of Bernoulli trials and scale it to +-s
z = rand(Np,Nts) > .5;    % Bernoulli Trials
jumps =  s*( sign(z - .5) );

% Now generate the Wiener process values at times ts 
% as cumulative sum of values in jumps
Xs = cumsum(jumps')';

% Find indices of sampled time points corresponding to specified times
I = sum( ( ts'*ones(1,Nt) ) <= ( ones(Nts,1)*t ) );

% Find process values
X = Xs(:,I);
