%--------------------------------------------------------------------------
% impulse2LTI_fitting_basis_pbf_ls.m
% Find an LTISS model using the basis.pbf.ls formulation
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function [A,B,C,D,X,tv,Kv,opts] = impulse2LTI_fitting_basis_pbf_ls(K,opts)
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
% method fitting function
function [X,N,opts] = method_fit(tv,Kv,opts)

% extract 
fitting = opts.fitting;
N = fitting.N; % number of basis functions
T2min = fitting.T2min*opts.scale.t; % decay rate minimum
T2max = fitting.T2max*opts.scale.t; % decay rate maximum
T3min = fitting.T3min*opts.scale.t; % frequency minimum
T3max = fitting.T3max*opts.scale.t; % frequency maximum
scaleflag = fitting.scaleflag; % scaling flag

% create bounds (unscaled)
LBopt = [T2min*ones(N,1);T3min*ones(N,1)];
UBopt = [T2max*ones(N,1);T3max*ones(N,1)];

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

% get starting point
x0 = [0*linspace(LBopt(1),UBopt(1),N)';linspace(LBopt(2),UBopt(2),N)'];

% no gradients in ls method
fitting.lsqnonlin.SpecifyObjectiveGradient = false;

% perform the fitting
[x,F] = impulse2LTI_fitting(@method_errors,tv,Kv,N,LBs,UBs,x0,LBopt,UBopt,fitting,opts);

% unscale time
if opts.points.normflag
    x = x/opts.scale.t;
end

% obtain B coefficients using unscale data
[B,~] = calcLLS(x,tv*opts.scale.t,Kv*opts.scale.K,N,LBs,UBs,0);

% reshape and extract
B = reshape(B,[],2);
T5 = B(:,1);
T6 = B(:,2);

% obtain T1 and T4
T1 = sign(T5).*sqrt(T5.^2+T6.^2);
T4 = 2*atan2((T5-T1),T6);

% combine
x = reshape(x,[],2);
X = [T1,x,T4];

% (potentially) display objective function value
impulse2LTI_dispfun(opts.displevel,'objective',F)

% warning on
warning('on','MATLAB:rankDeficientMatrix')

end
% method error function
function E = method_errors(X,tv,Kv,N,LB,UB,scaleflag)
% obtain linear least-squares estimate
[~,K] = calcLLS(X,tv,Kv,N,LB,UB,scaleflag);

% compute the errors
E = K - Kv;

end
% obtain linear least-squares estimate
function [B,K] = calcLLS(X,tv,Kv,N,LB,UB,scaleflag)
% (potentially) unscale the optimization variables
if scaleflag
    % unscale
    X = (UB-LB).*X+LB;
end

% reshape into row vector
X = reshape(X,1,[]);

% extract fitting parameters
T2 = X(1:N);
T3 = X(N+1:2*N);

% temporary variables
t0 = exp(-T2.*tv);
t1 = t0.*cos(T3.*tv);
t2 = t0.*sin(T3.*tv);

% combine 
X  = [t1,t2];

% warning off
warning('off','MATLAB:rankDeficientMatrix')

% solve the linear system of equations
B = linsolve(X,Kv);

% calculate the approximate function using the basis functions
K = X*B;

end