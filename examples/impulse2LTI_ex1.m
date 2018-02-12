%--------------------------------------------------------------------------
% K2LTI_ex1.m
% Single exponential function
%--------------------------------------------------------------------------
% Can be exactly represented with a 1 state LTI system
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber), University of 
% Illinois at Urbana-Champaign
% Project link: https://github.com/danielrherber/relaxation-kernel-2-lti
%--------------------------------------------------------------------------
close all; clear; clc

% impulse/kernel function
K = @(t) exp(-t);

% generate LTI (A,B,C) system matrices that best approximate provided K
[A,B,C,opts] = K2LTI(K,[]);