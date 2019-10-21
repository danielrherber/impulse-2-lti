%--------------------------------------------------------------------------
% impulse2LTI_ex_arbitrary2.m
% Another arbitrary IFR function
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
close all; clear; clc

% impulse/kernel function
K = @(t) max(-exp(t) + exp(1),0);

% method
opts.fitting.formulation = 'basis.pbf.ls';
% opts.fitting.formulation = 'imp2ss';
% opts.fitting.algorithm = 'lsqnonlin';
% opts.fitting.algorithm = 'multilsqnonlin';
opts.fitting.algorithm = 'patternsearch-lsqnonlin';

% other options
opts.fitting.N = 4; % number of basis functions, 2*N states
opts.points.tf = 6; % length of the time horizon
opts.points.N = 2000; % number of time grid points
opts.parallel = true; % parallel computing
opts.name = 'ex_arbitrary2'; % name of the example
opts.path = mfoldername(mfilename('fullpath'),''); % path for saving

% generate LTI (A,B,C,D) system matrices that best approximate provided K
[A,B,C,D] = impulse2LTI(K,opts);