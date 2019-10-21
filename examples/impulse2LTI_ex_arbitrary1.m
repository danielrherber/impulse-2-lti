%--------------------------------------------------------------------------
% impulse2LTI_ex_arbitrary1.m
% Another arbitrary IFR function
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
close all; clear; clc

% impulse/kernel function
K = @(t) (tanh(-50*(t-0.25))+1)/2 + (tanh(-5*(t-0.75))+1)/2 + (tanh(-20*(t-2))+1);

% method
opts.fitting.formulation = 'basis.pbf.ls';
% opts.fitting.formulation = 'imp2ss';
% opts.fitting.algorithm = 'lsqnonlin';
% opts.fitting.algorithm = 'multilsqnonlin';
opts.fitting.algorithm = 'patternsearch-lsqnonlin';

% other options
opts.fitting.N = 6; % number of basis functions, 2*N states
opts.points.tf = 5; % length of the time horizon
opts.points.N = 2000; % number of time grid points
opts.parallel = true; % parallel computing
opts.name = 'ex_arbitrary1'; % name of the example
opts.path = mfoldername(mfilename('fullpath'),''); % path for saving

% generate LTI (A,B,C,D) system matrices that best approximate provided K
[A,B,C,D] = impulse2LTI(K,opts);