%--------------------------------------------------------------------------
% impulse2LTI_ex_igamma.m
% Inverse gamma function
%--------------------------------------------------------------------------
% 
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
close all; clear; clc

% impulse/kernel function
K = @(t) 1./gamma(t);

% method
opts.fitting.formulation = 'basis.pbf.ls';
% opts.fitting.formulation = 'imp2ss';
% opts.fitting.algorithm = 'lsqnonlin';
% opts.fitting.algorithm = 'multilsqnonlin';
opts.fitting.algorithm = 'patternsearch-lsqnonlin';

% other options
opts.fitting.N = 2; % number of basis functions, 2*N states
opts.points.tf = 10; % length of the time horizon
opts.points.N = 2000; % number of testing points
opts.points.reduceflag = false; % no, reduce the number of testing points based on MFX 52552
opts.points.normflag = true; % yes, normalize the testing points
opts.modredflag = true; % perform model reduction to reduce the number of states
opts.name = 'ex_igamma'; % name of the example
opts.path = mfoldername(mfilename('fullpath'),''); % path for saving
opts.displevel = 3; % very verbose, controls displaying diagnostics to the command window
opts.plot.simulationflag = false; % yes, perform the additional simulations for validating the fit

% generate LTI (A,B,C,D) system matrices that best approximate provided K
[A,B,C,D] = impulse2LTI(K,opts);