%--------------------------------------------------------------------------
% impulse2LTI_ex_waves2_ssfitting.m
% Fit wave force models from the reference below
%--------------------------------------------------------------------------
% T Duarte, SS_Fitting Theory and User Manual, 5th ed., National Renewable
% Energy Laboratory, Golden, CO, USA, Sep. 2013.
% NOTE: requires data from available in SS_Fitting
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
close all; clear; clc

% impulse/kernel function
test = 3;
switch test
    case 1
        load('Spar099.mat') % load data
        num = 3; % test number (7 impulse functions available)
        K = @(t) interp1(stime,Kt(:,num),t); % impulse/kernel function
        opts.points.tf = stime(end); % length of the time horizon
        opts.fitting.N = [2 2 2 2 2]; % number of basis functions, 2*N states
    case 2
        load('Spar097.mat') % load data
        num = 7; % test number (7 impulse functions available)
        K = @(t) interp1(stime,Kt(:,num),t); % impulse/kernel function
        opts.points.tf = stime(end); % length of the time horizon
        opts.fitting.N = 3; % number of basis functions, 2*N states
    case 3
        load('MarinSemi097.mat') % load data
        num = 3; % test number (8 impulse functions available)
        K = @(t) interp1(stime,Kt(:,num),t); % impulse/kernel function
        opts.points.tf = stime(end); % length of the time horizon
        opts.fitting.N = 3; % number of basis functions, 2*N states
end

% method
opts.fitting.formulation = 'basis.pbf.ls';
opts.fitting.algorithm = 'patternsearch-lsqnonlin';
% opts.fitting.algorithm = 'lsqnonlin';

% other options
opts.points.N = 2000; % number of testing points
opts.fitting.T3max = 10;
opts.parallel = true; % parallel computing
opts.name = 'ex_waves2_ssfitting'; % name of the example
opts.path = mfoldername(mfilename('fullpath'),''); % path for saving
opts.displevel = 3; % very verbose, controls displaying diagnostics to the command window

% generate LTI (A,B,C,D) system matrices that best approximate provided K
[A,B,C,D] = impulse2LTI(K,opts);

% LTI system in companion form
csys = canon(ss(A,B,C,[]),'companion');