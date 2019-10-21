%--------------------------------------------------------------------------
% impulse2LTI_ex_viscoelastic1.m
% Single exponential function
%--------------------------------------------------------------------------
% Can be exactly represented with a 1 state LTI system
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
close all; clear; clc

% impulse/kernel function
K = @(t) exp(-t);

% fitting method
opts.fitting.formulation = 'basis.pbf.ls';
% opts.fitting.algorithm = 'patternsearch-lsqnonlin';
opts.fitting.algorithm = 'lsqnonlin';

% other options
opts.fitting.N = 2; % number of basis functions, 2*N states
opts.fitting.T1min = 10;
opts.points.tf = 5; % length of the time horizon
opts.points.N = 2000;
opts.name = 'ex_viscoelastic1';
opts.path = mfoldername(mfilename('fullpath'),''); % path for saving

% generate LTI (A,B,C,D) system matrices that best approximate provided K
[A,B,C,D] = impulse2LTI(K,opts);