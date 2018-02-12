%--------------------------------------------------------------------------
% impulse2LTI_fit.m
% Given the kernel function test points and fitting options, fit the poles 
% to the data
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber), University of 
% Illinois at Urbana-Champaign
% Project link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function [X,N,opts] = impulse2LTI_fit(tv,Kv,opts,varargin)
% set initial point
if ~isempty(varargin)
	x0 = varargin{1};
end

% extract number of basis functions
N = opts.fitting.N;

% extract bounds data
T1min = opts.fitting.T1min;
T1max = opts.fitting.T1max;
T2min = opts.fitting.T2min;
T2max = opts.fitting.T2max;
T3max = opts.fitting.T3max;

% create bounds
LB = [T1min*ones(N,1);T2min*ones(N,1);zeros(N,1);zeros(N,1)];
UB = [T1max*ones(N,1);T2max*ones(N,1);T3max*ones(N,1);2*pi*ones(N,1)];

% number of optimization variables
n = length(LB);

% starting point
if ~exist('x0','var') % if unspecified
    x0 = (UB-LB).*rand(n,1) + LB;
end

% control display of iterations during the fitting
if (opts.displevel > 2) % very verbose
    iterflag = 'iter';
else
    iterflag = 'none';
end

% extract fitting method
method = opts.fitting.method;

% options
if contains(method,'lsqnonlin','IgnoreCase',true)
    lsqnonlin_options = optimoptions('lsqnonlin','Display',iterflag,...
        'UseParallel',opts.parallel,'StepTolerance',1e-7,...
        'FunctionTolerance',0,'OptimalityTolerance',0,...
        'MaxFunctionEvaluations',1e7,'MaxIterations',20000,...
        'SpecifyObjectiveGradient',true,...
        'CheckGradients',false);
end
%--------------------------------------------------------------------------
if contains(method,'fmincon','IgnoreCase',true)
    fmincon_options = optimoptions('fmincon','Display',iterflag,'UseParallel',opts.parallel);
end
%--------------------------------------------------------------------------
if contains(method,'patternsearch','IgnoreCase',true)
	patternsearch_options = optimoptions('patternsearch','Display',iterflag,...
        'UseParallel',opts.parallel);
end
%--------------------------------------------------------------------------
if contains(method,'ga','IgnoreCase',true)
    ga_options = optimoptions('ga','Display',iterflag,'UseParallel',opts.parallel,...
    'MaxGenerations',20,'PopulationSize',5000);
end
%--------------------------------------------------------------------------
if contains(method,'particleswarm','IgnoreCase',true)
    particleswarm_options = optimoptions('particleswarm','Display',iterflag,...
        'UseParallel',opts.parallel,'SwarmSize',100,'MaxIterations',50);
end
%--------------------------------------------------------------------------
if contains(method,'multistart','IgnoreCase',true)
    multistart_options = MultiStart('Display',iterflag,'UseParallel',opts.parallel,...
        'StartPointsToRun','bounds');

end

% perform the fitting
switch method
    %----------------------------------------------------------------------
    case 'lsqnonlin'
        [X,F] = lsqnonlin(@(x) impulse2LTI_errors(x,tv,Kv,N),x0,LB,UB,...
            lsqnonlin_options);
    %----------------------------------------------------------------------
    case 'fmincon'
        [X,F] = fmincon(@(x) sum(impulse2LTI_errors(x,tv,Kv,N).^2),x0,[],...
            [],[],[],LB,UB,[],fmincon_options);
    %----------------------------------------------------------------------
    case 'patternsearch'
        [X,F] = patternsearch(@(x) sum(impulse2LTI_errors(x,tv,Kv,N).^2),...
            x0,[],[],[],[],LB,UB,[],patternsearch_options);
    %----------------------------------------------------------------------
    case 'ga'
        [X,F] = ga(@(x) sum(impulse2LTI_errors(x,tv,Kv,N).^2),n,[],[],[],...
            [],LB,UB,[],ga_options);
    %----------------------------------------------------------------------
    case 'particleswarm'
        [X,F] = particleswarm(@(x) sum(impulse2LTI_errors(x,tv,Kv,N).^2),...
            n,LB,UB,particleswarm_options);
    %----------------------------------------------------------------------
    case 'ga-lsqnonlin'
        [X,~] = ga(@(x) sum(impulse2LTI_errors(x,tv,Kv,N).^2),n,[],[],[],...
            [],LB,UB,[],ga_options);
        [X,F] = lsqnonlin(@(x) impulse2LTI_errors(x,tv,Kv,N),X,LB,UB,...
            lsqnonlin_options);
    %----------------------------------------------------------------------
    case 'particleswarm-lsqnonlin'
        [X,~] = particleswarm(@(x) sum(impulse2LTI_errors(x,tv,Kv,N).^2),...
            n,LB,UB,particleswarm_options);
        [X,F] = lsqnonlin(@(x) impulse2LTI_errors(x,tv,Kv,N),X,LB,UB,...
            lsqnonlin_options);
    %----------------------------------------------------------------------
    case 'multistart-lsqnonlin'       
        lsqnonlin_options = optimoptions(lsqnonlin_options,'Display','none');
        problem = createOptimProblem('lsqnonlin','objective',...
            @(x) impulse2LTI_errors(x,tv,Kv,N),'x0',x0,...
            'lb',LB,'ub',UB,'options',lsqnonlin_options);
        [X,F] = run(multistart_options,problem,opts.fitting.nStart);
end

% reshape optimization variables in column vector
X = X(:);

% control display of iterations during the fitting
if (opts.displevel > 1) % verbose
    disp(['objective function value: ',num2str(F)]);
end

end