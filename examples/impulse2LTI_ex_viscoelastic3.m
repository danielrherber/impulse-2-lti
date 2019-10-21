%--------------------------------------------------------------------------
% impulse2LTI_ex_viscoelastic3.m
% Power law relaxation kernel
%--------------------------------------------------------------------------
% 
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber), University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
close all; clear; clc

% impulse/kernel function
n = 1/4;
K = @(t) min((t+0.99).^(-n),1);

% fitting method
opts.fitting.formulation = 'basis.pbf.ls';
% opts.fitting.formulation = 'imp2ss';
% opts.fitting.formulation = 'prony';
opts.fitting.algorithm = 'patternsearch-lsqnonlin';
% opts.fitting.algorithm = 'lsqnonlin';

% other options
opts.fitting.N = 7; % number of basis functions, 2*N states
opts.points.t = [0,logspace(-3,5,300)];
opts.modredflag = true; % perform model reduction to reduce the number of states
opts.fitting.T1min = 0;
opts.fitting.T2max = 50;
opts.fitting.T3max = 10;
opts.name = 'ex_viscoelastic3';
opts.path = mfoldername(mfilename('fullpath'),''); % path for saving

% generate LTI (A,B,C,D) system matrices that best approximate provided K
[A,B,C,D] = impulse2LTI(K,opts);