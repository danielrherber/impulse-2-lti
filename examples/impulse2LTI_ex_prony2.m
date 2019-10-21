%--------------------------------------------------------------------------
% impulse2LTI_ex_prony2.m
% Impulse response function composed of Prony basis functions
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
close all; clear; clc

% impulse/kernel function
N = 10; X = 3*rand(N,4); X(:,3) = linspace(0,5,N)';
K = @(t) Kfun(t,X,N);

% method
% opts.fitting.formulation = 'basis.pbf.ls';
opts.fitting.formulation = 'prony';
% opts.fitting.algorithm = 'lsqnonlin';
% opts.fitting.algorithm = 'patternsearch-lsqnonlin';

% other options
opts.fitting.N = N; % number of basis functions, 2*N states
opts.points.tf = 100; % length of the time horizon
opts.points.N = 8*N; % number of time grid points
opts.fitting.T1min = -5; % minimum amplitude bound
opts.fitting.T1max = 5; % maximum amplitude bound
opts.fitting.T2min = 0; % minimum decay rate bound
opts.fitting.T2max = 5; % maximum decay rate bound
opts.fitting.T3max = 5; % maximum frequency bound
opts.modredflag = false; % perform model reduction to reduce the number of states
opts.parallel = true; % parallel computing
opts.name = 'ex_prony2'; % name of the example
opts.path = mfoldername(mfilename('fullpath'),''); % path for saving

% generate LTI (A,B,C,D) system matrices that best approximate provided K
[A,B,C,D] = impulse2LTI(K,opts);

function Kv = Kfun(tv,X,N)
X = reshape(X,1,[]);
T1 = X(1:N); T2 = X(N+1:2*N); T3 = X(2*N+1:3*N); T4 = X(3*N+1:4*N);
t0 = T3.*tv+T4; t1 = exp(-T2.*tv); t2 = cos(t0); t3 = T1.*t1;
K = t2.*t3;
Kv = sum(K,2);
end