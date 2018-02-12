%--------------------------------------------------------------------------
% impulse2LTI_ex4.m
% Another complex kernel function
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber), University of 
% Illinois at Urbana-Champaign
% Project link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
close all; clear; clc

% impulse/kernel function
K = @(t) (tanh(-50*(t-0.25))+1)/2 + (tanh(-5*(t-0.75))+1)/2 + (tanh(-20*(t-2))+1);

% options
opts.points.tf = 4; % length of the time horizon
opts.fitting.N = 6; % number of basis functions, 2*N states

% generate LTI (A,B,C) system matrices that best approximate provided K
[A,B,C,opts] = impulse2LTI(K,opts);