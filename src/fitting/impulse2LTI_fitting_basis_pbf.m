%--------------------------------------------------------------------------
% impulse2LTI_fitting_basis_pbf.m
% Find an LTISS model using the basis.pbf formulation
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function [A,B,C,D,X,tv,Kv,opts] = impulse2LTI_fitting_basis_pbf(K,opts)
% extract 
Nv = opts.fitting.N; % desired sequence of basis function counts

% data points for fitting
[tv,Kv,~,~,opts] = impulse2LTI_points(K,opts);

% initialize
X = []; N = 0;

% go through the each set of basis functions and fit
for k = 1:length(Nv)
    % current number of basis functions
    opts.fitting.N = Nv(k);

    % data points for fitting
    [~,~,tvs,Kvs,opts] = impulse2LTI_points(K,opts);

    % fitting through optimization
    [x,n,opts] = method_fit(tvs,Kvs,opts);

    % compute error
    e = -impulse2LTI_errors(x,tvs*opts.scale.t,Kvs*opts.scale.K);

    % update impulse function with the current error
    K = @(t) interp1(tvs*opts.scale.t,e,t);

    % combine with previous fit
    X = vertcat(X,x);
    N = N + n;
end

% calculate state space matrices
[A,B,C,D,opts] = impulse2LTI_matrices(X,N,opts);

end
% 
function [X,N,opts] = method_fit(tv,Kv,opts)
% extract 
fitting = opts.fitting;
N = fitting.N; % number of basis functions
T1min = fitting.T1min/opts.scale.K; % amplitude minimum
T1max = fitting.T1max/opts.scale.K; % amplitude maximum
T2min = fitting.T2min*opts.scale.t; % decay rate minimum
T2max = fitting.T2max*opts.scale.t; % decay rate maximum
T3min = fitting.T3min*opts.scale.t; % frequency minimum
T3max = fitting.T3max*opts.scale.t; % frequency maximum
T4min = fitting.T4min; % phase shift minimum
T4max = fitting.T4max; % phase shift maximum
scaleflag = fitting.scaleflag; % scaling flag

% create bounds (unscaled)
LBopt = [T1min*ones(N,1);T2min*ones(N,1);T3min*ones(N,1);T4min*ones(N,1)];
UBopt = [T1max*ones(N,1);T2max*ones(N,1);T3max*ones(N,1);T4max*ones(N,1)];

% potentially modify the bounds for scaling
if scaleflag
    % assign current bounds as true bounds
    LBs = LBopt;
    UBs = UBopt;

    % define scaled bounds
    LBopt = zeros(size(LBopt));
    UBopt = ones(size(UBopt));
else
    % define dummy scale bounds (should not be used)
    LBs = zeros(size(LBopt));
    UBs = ones(size(UBopt));
end

% number of optimization variables
n = length(LBopt);

% get starting point
x0 = rand(n,1);
x0(2*N+1:3*N) = linspace(LBopt(3),UBopt(3),N)';

% perform the fitting
[X,F] = impulse2LTI_fitting(@method_errors,tv,Kv,N,LBs,UBs,x0,LBopt,UBopt,fitting,opts);

% unscale time
if opts.points.normflag
    X(:,2:3) = X(:,2:3)/opts.scale.t;
end

% (potentially) display objective function value
impulse2LTI_dispfun(opts.displevel,'objective',F)
end
% given model fitting parameters and data points, calculate the errors
function [E,varargout] = method_errors(X,tv,Kv,N,LB,UB,scaleflag)
% (potentially) unscale the optimization variables
if scaleflag
    % unscale
    X = (UB-LB).*X+LB;
end

% reshape into row vector
X = reshape(X,1,[]);

% extract fitting parameters
T1 = X(1:N); T2 = X(N+1:2*N); T3 = X(2*N+1:3*N); T4 = X(3*N+1:4*N);

% temporary variables
t0 = T3.*tv+T4; t1 = exp(-T2.*tv); t2 = cos(t0); t3 = T1.*t1;

% calculate the approximate function using the basis functions
K = t2.*t3;

% compute the errors
E = sum(K,2) - Kv;

% calculate Jacobian
if nargout > 1
	% temporary variables
	t4 = sin(t0).*t3;

	% simplified derivatives
	dFdT1 = t2.*t1;	dFdT2 = -tv.*K;	dFdT3 = -tv.*t4; dFdT4 = -t4;

	% combine
	J = [dFdT1,dFdT2,dFdT3,dFdT4];

    % (potentially) scale
    if scaleflag
        J = (UB-LB)'.*J;
    end

	% output
    varargout{1} = J;
end

end