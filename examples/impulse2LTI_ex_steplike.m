%--------------------------------------------------------------------------
% impulse2LTI_ex_arbitrary1.m
% Complex "step-like" kernel function
%--------------------------------------------------------------------------
% This kernel function was used in the following reference:
% C Lin, DR Herber, Vedant, YH Lee, A Ghosh, RH Ewoldt, JT Allison. 
% 'Attitude control system complexity reduction via tailored viscoelastic
% damping co-design.' In 2018 AAS Guidance & Control Conference, 
% Breckenridge, CO, Feb 2018.
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
close all; clear; clc

% impulse/kernel function
K = @(t) (tanh(-14*(t-0.5))+1)/2;

% method
opts.fitting.formulation = 'basis.pbf.ls';
opts.fitting.algorithm = 'patternsearch-lsqnonlin';
% opts.fitting.algorithm = 'lsqnonlin';

% other options
opts.fitting.N = 3; % number of basis functions, 2*N states
opts.fitting.scaleflag = true; % scale optimization variables
% opts.fitting.T1min = -500; % minimum amplitude bound
% opts.fitting.T1max = 500; % maximum amplitude bound
% opts.fitting.T2min = 1e-0; % minimum decay rate bound
% opts.fitting.T2max = 300; % maximum decay rate bound
% opts.fitting.T3max = 50; % maximum frequency bound
% opts.fitting.nStart = 200; % number of start points to test with multistart option
opts.points.tf = 2; % length of the time horizon
opts.points.N = 100; % number of testing points
opts.points.reduceflag = false; % no, reduce the number of testing points based on MFX 52552
opts.points.normflag = true; % yes, normalize the testing points
opts.modredflag = true; % perform model reduction to reduce the number of states
opts.parallel = true; % parallel computing
opts.plotflag = true; % create the plots
opts.saveflag = false; % don't save, save the solution to disk
opts.name = 'ex_steplike'; % name of the example
opts.path = mfoldername(mfilename('fullpath'),''); % path for saving
opts.displevel = 3; % very verbose, controls displaying diagnostics to the command window
opts.plot.simulationflag = false; % yes, perform the additional simulations for validating the fit

% generate LTI (A,B,C,D) system matrices that best approximate provided K
[A,B,C,D] = impulse2LTI(K,opts);