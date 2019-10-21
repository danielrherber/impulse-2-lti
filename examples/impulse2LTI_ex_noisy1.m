%--------------------------------------------------------------------------
% impulse2LTI_ex_noisy1.m
% Sum of three exponential functions with noise
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
close all; clear; clc

% method
opts.fitting.formulation = 'basis.pbf.ls';
% opts.fitting.formulation = 'imp2ss';
% opts.fitting.algorithm = 'lsqnonlin';
% opts.fitting.algorithm = 'multilsqnonlin';
opts.fitting.algorithm = 'patternsearch-lsqnonlin';

% other options
opts.fitting.N = 3; % number of basis functions, 2*N states
opts.points.N = 2000;
opts.points.tf = 5;
opts.fitting.T2min = 1e-0;

% generate LTI (A,B,C,D) system matrices that best approximate provided K
[A,B,C,D] = impulse2LTI(@(t) Kfun(t,0.01),opts);

% impulse/kernel function
function K = Kfun(t,sig)
    rng(12535)
    K = exp(-t/2)/10 + exp(-2*t)/5 + exp(-3*t)/2 + sig*(rand(size(t))-0.5);
end