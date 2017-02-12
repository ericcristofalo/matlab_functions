function [X,t] = poissrp(N,t,l)
% [X,t] = poissrp(N,t,l)
%
% N : Number of sample paths to generate
% t : Vector of time points at which to generate samples
% l : Arrival rate. OPTIONAL. Default l=1.
%
% X : Matrix of process sample paths. Each row is a sample path, each column
%     is a different time point. 
%
% X(t) = Poisson Random process with rate l
%
%                   n
%               (lt)   -lt
% f_{X(t)}(n) = ----  e
%                n!

% W. C. Karl 

if min(size(t)) > 1
  error('t must be a vector of time point')
end;

if max(size(N))>1
  error('N must be a scalar number of sample paths to generate')
end;

if nargin<3
  l = 1;
end;

t = t(:)'; % Make a row vector
maxt = max(t);

% Get sizes
Nt = length(t);
Np = N;

% Generate exponential interarrival times till all samples exceed maxt
% Tau contains the set of exponential interarrival times for each experiment
% -- one per row
Tau = randexp(Np,5,l);
while min(sum(Tau')) < maxt
  Tau = [Tau,randexp(Np,1,l)];
end;

% Generate Waiting times from interarrival times
W = cumsum(Tau')';

% Generate Process values at the desired time points by summing number of
% arrivals prior to each time
X = zeros(Np,Nt);
for i = 1:Nt
  X(:,i) = sum((W<t(i))')';
end;

