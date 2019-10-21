%--------------------------------------------------------------------------
% impulse2LTI_ex_viscoelastic2.m
% Sum of three exponential functions
%--------------------------------------------------------------------------
% Can be exactly represented with a 3 state LTI system
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
close all; clear; clc

% impulse/kernel function
K = @(t) exp(-t/2)/10 + exp(-2*t)/5 + exp(-3*t)/2;

% fitting method
opts.fitting.formulation = 'basis.pbf.ls';
opts.fitting.algorithm = 'patternsearch-lsqnonlin';
% opts.fitting.algorithm = 'lsqnonlin';
% opts.fitting.formulation = 'imp2ss';
% opts.fitting.formulation = 'prony';

% other options
opts.fitting.N = 4; % number of basis functions, 2*N states
opts.fitting.T1min = 10;
opts.fitting.T3max = 30;
opts.points.tf = 5; % length of the time horizon
opts.points.N = 200;
opts.name = 'ex_viscoelastic2';
opts.path = mfoldername(mfilename('fullpath'),''); % path for saving

% generate LTI (A,B,C,D) system matrices that best approximate provided K
[A,B,C,D] = impulse2LTI(K,opts);