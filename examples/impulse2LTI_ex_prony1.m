%--------------------------------------------------------------------------
% impulse2LTI_ex_prony1.m
% Impulse response function composed of Prony basis functions
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
close all; clear; clc

% impulse/kernel function
K = @(t) 2*exp(-2*t).*cos(3*t+1) +...
    -5*exp(-1*t).*cos(2*t-1) +...
    1*exp(-0.5*t).*cos(10*t+0);

% method
opts.fitting.formulation = 'basis.pbf.ls';
% opts.fitting.formulation = 'prony';
% opts.fitting.algorithm = 'lsqnonlin';
opts.fitting.algorithm = 'patternsearch-lsqnonlin';

% other options
opts.fitting.N = 3; % number of basis functions, 2*N states
opts.points.tf = 10; % length of the time horizon
opts.points.N = 2000; % number of time grid points
opts.parallel = true; % parallel computing
opts.name = 'ex_prony1'; % name of the example
opts.path = mfoldername(mfilename('fullpath'),''); % path for saving

% generate LTI (A,B,C,D) system matrices that best approximate provided K
[A,B,C,D] = impulse2LTI(K,opts);