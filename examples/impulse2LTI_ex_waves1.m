%--------------------------------------------------------------------------
% impulse2LTI_ex_wave1.m
% Fit state-space models from the reference below
%--------------------------------------------------------------------------
% Z Yu and J Falnes, 'State-space modelling of a vertical cylinder in 
% heave,' Applied Ocean Research, vol. 17, no. 5, pp. 265–275, 1995.
% NOTE: this is fitting the already derived state-space models, not the
% original kernel function data in the paper. It is being assumed that good
% results fitting the found state-space models implies the ability to find
% a good fitting if the original data was used.
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
close all; clear; clc

% impulse/kernel function
test = 3;
switch test
    case 1
        A = [[zeros(1,5-1);eye(5-1)],[-409;-459;-226;-64;-9.96]];
        B =[1549866 -116380 24748 -644 19.3]';
        C = [0 0 0 0 1];
        opts.points.tf = 10; % length of the time horizon
    case 2
        A = [[zeros(1,2);eye(2)],[-17.9;-17.7;-4.41]];
        B = [36.5 394 75.1]';
        C = [0 0 1];
        opts.points.tf = 4; % length of the time horizon
    case 3
        A = [[zeros(1,5-1);eye(5-1)],[-192.34;-178.04;-77.14;-27.24;-5.12]];
        B =[194.49 -60.46 9.72 -1.29 -0.012]';
        C = [0 0 0 0 1];
        opts.points.tf = 50; % length of the time horizon
end

t2 = linspace(0,opts.points.tf,10000);
k2 = impulse(ss(A,B,C,[]),t2);
K = @(t) interp1(t2,k2,t);

% method
opts.fitting.formulation = 'basis.pbf.ls';
opts.fitting.algorithm = 'patternsearch-lsqnonlin';
% opts.fitting.algorithm = 'lsqnonlin';

% other options
opts.fitting.N = 3; % number of basis functions, 2*N states
opts.fitting.T3max = 5; % maximum frequency bound
opts.points.N = 2000; % number of testing points
opts.modredflag = true; % perform model reduction to reduce the number of states
opts.parallel = true; % parallel computing
opts.name = 'ex_wave1'; % name of the example
opts.path = mfoldername(mfilename('fullpath'),''); % path for saving
opts.displevel = 3; % very verbose, controls displaying diagnostics to the command window

% generate LTI (A,B,C,D) system matrices that best approximate provided K
[A,B,C,D] = impulse2LTI(K,opts);

% LTI system in companion form
csys = canon(ss(A,B,C,[]),'companion');