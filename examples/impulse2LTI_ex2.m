%--------------------------------------------------------------------------
% impulse2LTI_ex2.m
% Sum of three exponential functions
%--------------------------------------------------------------------------
% Can be exactly represented with a 3 state LTI system
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber), University of 
% Illinois at Urbana-Champaign
% Project link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
close all; clear; clc

% impulse/kernel function
K = @(t) exp(-t/2)/10 + exp(-2*t)/5 + exp(-3*t)/2;

% options
opts.fitting.N = 3; % number of basis functions, 2*N states
opts.fitting.nStart = 10; % number of start points to test with multistart option

% generate LTI (A,B,C) system matrices that best approximate provided K
[A,B,C,opts] = impulse2LTI(K,opts);