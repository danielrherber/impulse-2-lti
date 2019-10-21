%--------------------------------------------------------------------------
% impulse2LTI_opts.m
% Set the unset options to their defaults
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function opts = impulse2LTI_opts(opts)
%--------------------------------------------------------------------------
% general options
%--------------------------------------------------------------------------
% plots
if ~isfield(opts,'plotflag')
    opts.plotflag = true; % create the plots
    % opts.plotflag = false; % don't create the plots
end

% save the solution to disk
if ~isfield(opts,'saveflag')
    % opts.saveflag = true; % save
    opts.saveflag = false; % don't save
end

% name of the example
if ~isfield(opts,'name')
    opts.name = 'impulse2LTI'; 
end

% path for saving
if ~isfield(opts,'path')
    opts.path = mfoldername('INSTALL_impulse2LTI',''); 
end

% controls displaying diagnostics to the command window
if ~isfield(opts,'displevel')
    opts.displevel = 3; % very verbose
    % opts.displevel = 2; % verbose
    % opts.displevel = 1; % minimal
    % opts.displevel = 0; % none
end

% parallel computing
if ~isfield(opts,'parallel')
    % opts.parallel = true; % yes
    opts.parallel = false; % no
end

% potentially start the parallel pool
if opts.parallel
   gcp; 
end

%--------------------------------------------------------------------------
% testing points options
%--------------------------------------------------------------------------
% initialize field
if ~isfield(opts,'points')
    opts.points = [];
end

% length of the time horizon
if ~isfield(opts.points,'tf')
    opts.points.tf = 5;
end

% number of testing points
if ~isfield(opts.points,'N')
    opts.points.N = 2000;
end

% reduce the number of testing points based on MFX 52552
if ~isfield(opts.points,'reduceflag')
    % opts.points.reduceflag = true; % yes
    opts.points.reduceflag = false; % no
end

% normalize the testing points
if ~isfield(opts.points,'normflag')
    opts.points.normflag = true; % yes
    % opts.points.normflag = false; % no
end

%--------------------------------------------------------------------------
% fitting options
%--------------------------------------------------------------------------
% initialize field
if ~isfield(opts,'fitting')
    opts.fitting = [];
end

% fitting formulation
if ~isfield(opts.fitting,'formulation')
    % opts.fitting.formulation = 'full'; % NOT AVAILABLE
    % opts.fitting.formulation = 'canon.direct'; % NOT AVAILABLE
    % opts.fitting.formulation = 'canon.direct.ls'; % NOT AVAILABLE
    % opts.fitting.formulation = 'canon.roots'; % NOT AVAILABLE
    % opts.fitting.formulation = 'canon.roots.ls'; % NOT AVAILABLE
    % opts.fitting.formulation = 'prony';
    % opts.fitting.formulation = 'basis.pbf';
    opts.fitting.formulation = 'basis.pbf.ls';
    % opts.fitting.formulation = 'basis.ghm'; % NOT AVAILABLE
    % opts.fitting.formulation = 'basis.ghm.ls'; % NOT AVAILABLE
    % opts.fitting.formulation = 'basis.ps'; % NOT AVAILABLE
    % opts.fitting.formulation = 'basis.ps.ls'; % NOT AVAILABLE
    % opts.fitting.formulation = 'imp2ss';
end

% fitting algorithm
if ~isfield(opts.fitting,'algorithm')
    % opts.fitting.algorithm = 'multistart-lsqnonlin';
    % opts.fitting.algorithm = 'particleswarm-lsqnonlin';
    % opts.fitting.algorithm = 'ga-lsqnonlin';
    % opts.fitting.algorithm = 'particleswarm';
    % opts.fitting.algorithm = 'ga';
    % opts.fitting.algorithm = 'patternsearch';
    % opts.fitting.algorithm = 'fmincon';
    opts.fitting.algorithm = 'lsqnonlin';
end

% number of basis functions, 2*N states
if ~isfield(opts.fitting,'N')
	opts.fitting.N = 4; % 4 basis functions
end

% scale the optimization variables between 0-1
if ~isfield(opts.fitting,'scaleflag')
    opts.fitting.scaleflag = true; % use
    % opts.fitting.scaleflag = false; % don't use
end

% minimum amplitude bound
if ~isfield(opts.fitting,'T1min')
    opts.fitting.T1min = 0;
end

% maximum amplitude bound
if ~isfield(opts.fitting,'T1max')
    opts.fitting.T1max = 500;
end

% minimum decay rate bound
if ~isfield(opts.fitting,'T2min')
    opts.fitting.T2min = 1e-4;
end

% maximum decay rate bound
if ~isfield(opts.fitting,'T2max')
    opts.fitting.T2max = 100;
end

% minimum frequency bound
if ~isfield(opts.fitting,'T3min')
    opts.fitting.T3min = 0;
end

% maximum frequency bound
if ~isfield(opts.fitting,'T3max')
    opts.fitting.T3max = 300;
end

% minimum phase shift
if ~isfield(opts.fitting,'T4min')
    opts.fitting.T4min = 0;
end

% maximum phase shift
if ~isfield(opts.fitting,'T4max')
    opts.fitting.T4max = 2*pi;
end

% number of start points to test with multistart option
if ~isfield(opts.fitting,'nStart')
	opts.fitting.nStart = 10;
end

% perform model reduction to reduce the number of states
if ~isfield(opts,'modredflag')
    opts.modredflag = true; % use
    % opts.modredflag = false % don't use
end

% optimization algorithm options (see function below)
opts = opts_algorithms(opts);

%--------------------------------------------------------------------------
% plotting options
%--------------------------------------------------------------------------
% initialize field
if ~isfield(opts,'plot')
    opts.plot = [];
end

% perform the additional simulations for validating the fit
if ~isfield(opts.plot,'simulationflag')
    % opts.plot.simulationflag = true; % yes
    opts.plot.simulationflag = false; % no
end

end

% optimization algorithm options subfunction
function opts = opts_algorithms(opts)

% extract
algorithm = opts.fitting.algorithm;

% control display of iterations during the fitting
if (opts.displevel > 2) % very verbose
    iterflag = 'iter';
else
    iterflag = 'none';
end

% lsqnonlin options
if contains(algorithm,'lsqnonlin','IgnoreCase',true)
    opts.fitting.lsqnonlin = optimoptions('lsqnonlin','Display',iterflag,...
        'UseParallel',opts.parallel,'StepTolerance',1e-7,...
        'FunctionTolerance',0,'OptimalityTolerance',0,...
        'MaxFunctionEvaluations',1e7,'MaxIterations',50000,...
        'SpecifyObjectiveGradient',true,...
        'CheckGradients',false);
end

% fmincon options
if contains(algorithm,'fmincon','IgnoreCase',true)
    opts.fitting.fmincon = optimoptions('fmincon','Display',iterflag,...
        'UseParallel',opts.parallel);
end

% patternsearch options
if contains(algorithm,'patternsearch','IgnoreCase',true)
	opts.fitting.patternsearch = optimoptions('patternsearch',...
        'Display',iterflag,'UseParallel',opts.parallel);
end

% ga options
if contains(algorithm,'ga','IgnoreCase',true)
    opts.fitting.ga = optimoptions('ga',...
        'Display',iterflag,'UseParallel',opts.parallel,...
        'MaxGenerations',50,'PopulationSize',5000);
end

% particleswarm options
if contains(algorithm,'particleswarm','IgnoreCase',true)
    opts.fitting.particleswarm = optimoptions('particleswarm',...
        'Display',iterflag,'UseParallel',opts.parallel,'SwarmSize',1000,...
        'MaxIterations',200);
end

% multistart options
if contains(algorithm,'multistart','IgnoreCase',true)
    opts.fitting.multistart = MultiStart('Display',iterflag,...
        'UseParallel',opts.parallel,'StartPointsToRun','bounds');
end

end