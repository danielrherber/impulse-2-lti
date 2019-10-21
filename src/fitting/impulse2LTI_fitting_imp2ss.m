%--------------------------------------------------------------------------
% impulse2LTI_fitting_imp2ss.m
% Find an LTISS model using the imp2ss method
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function [A,B,C,D,X,tv,Kv,opts] = impulse2LTI_fitting_imp2ss(K,opts)
% data points for fitting
[tv,Kv,tvs,Kvs,opts] = impulse2LTI_points(K,opts);

% sample time
ts = tvs(2)-tvs(1); % scaled

% check if the time grid has constant sample time
if uniquetol(diff(tv)) > 1
    error('imp2ss method requires equidistant time grid')
end

% NEED: expose
tol = 1e-6;

% system identification via impulse response using Kung's SVD algorithm
[sys,~,~] = imp2ss(Kvs,ts,1,1,1e-6);

% gramian-based input/output balancing of state-space realization
[sys,g] = balreal(sys);

% initialize
elim = zeros(size(g));

% (potentially) perform model reduction
if opts.modredflag
    % eliminate states with small effect on the output
    elim = (g < tol);
end

% maximum number of states to keep
nmax = min(sum(opts.fitting.N)*2,length(g));

% eliminate all additional states
elim(nmax+1:end) = 1;

% eliminate states from state-space models
sys = modred(sys,elim,'truncate');

% get modal form
sys = canon(sys,'modal');

% extract matrices and unscale
A = sys.A/opts.scale.t;
B = sys.B*sqrt(ts);
C = sys.C*sqrt(ts)*opts.scale.K;
D = sys.D*ts;

% no model parameters using imp2ss method
X = nan;

end