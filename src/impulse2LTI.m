%--------------------------------------------------------------------------
% impulse2LTI.m
% Given a impulse/kernel function and options, generate LTI (A,B,C) system 
% matrices that best approximate
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber), University of 
% Illinois at Urbana-Champaign
% Project link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function [A,B,C,varargout] = impulse2LTI(K,varargin)
%--------------------------------------------------------------------------
% inputs and options
%--------------------------------------------------------------------------    
if nargin > 1
    opts = varargin{1};
else
    opts = [];
end

% extract kernel function
opts.K = K;

% get default options
opts = impulse2LTI_opts(opts);

% potentially start the timer
if (opts.displevel > 0) % minimal
    tic % start timer
end

% close all figures
close all

%--------------------------------------------------------------------------
% data points for fitting
%--------------------------------------------------------------------------
[tv,Kv,opts] = impulse2LTI_points(K,opts);

%--------------------------------------------------------------------------
% fitting through optimization
%--------------------------------------------------------------------------
[X,N,opts] = impulse2LTI_fit(tv,Kv,opts);

%--------------------------------------------------------------------------
% calculate state space matrices
%--------------------------------------------------------------------------
[A,B,C,opts] = impulse2LTI_matrices(X,N,opts);

%--------------------------------------------------------------------------
% use model reduction techniques to reduce the number of states
%--------------------------------------------------------------------------
if opts.modred
    [A,B,C,opts] = impulse2LTI_modred(A,B,C,opts);
end

% end the timer
if (opts.displevel > 0) % minimal
    T = toc;
end

% display to the command window
if (opts.displevel > 1) % verbose
    disp(['impulse2LTI fitting time: ', num2str(T), ' s'])
end

%--------------------------------------------------------------------------
% plots and output
%--------------------------------------------------------------------------
if opts.plotflag
    impulse2LTI_plot(tv,Kv,A,B,C,opts);
end

% output options
if nargout > 1
    varargout{1} = opts;
end

end