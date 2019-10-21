%--------------------------------------------------------------------------
% impulse2LTI_points.m
% Given a impulse function and options, create the set of testing points
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function [tv,Kv,tvs,Kvs,opts] = impulse2LTI_points(K,opts)
% testing points
if isfield(opts.points,'t')
    tv = opts.points.t; % user provided testing points
    tv = tv(:);
else
    tf = opts.points.tf; % limit of time horizon
    N = opts.points.N; % number of testing points
    tv = linspace(0,tf,N)'; % linearly spaced testing points
end

% obtain impulse function values
Kv = K(tv);

% (potentially) reduce the number of testing points
if opts.points.reduceflag
    % options
    o.interior_optflag = 0;
    o.post_optflag = 0;
    o.display_flag = 0;
    
    % reduce the set of points
    [tv, Kv] = reduce_interp_1d_linear(tv,Kv,0.0001,o);
    
    % transpose
    tv = tv'; Kv = Kv';
end

% (potentially) normalize testing points
if opts.points.normflag
    % normalize points
    opts.scale.K = max(abs(Kv));
    opts.scale.t = max(abs(tv));
    Kvs = Kv/opts.scale.K; % maximum value of +-1
    tvs = tv/opts.scale.t; % maximum value of +-1
else
    % unitary values
    opts.scale.K = 1;
    opts.scale.t = 1;
    tvs = tv;
    Kvs = Kv;
end

end