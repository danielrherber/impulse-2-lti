%--------------------------------------------------------------------------
% impulse2LTI_opts.m
% Set the unset options to their defaults
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber), University of 
% Illinois at Urbana-Champaign
% Project link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function opts = impulse2LTI_opts(opts)
%--------------------------------------------------------------------------
% general options
%--------------------------------------------------------------------------
% plots
if ~isfield(opts,'plotflag')
    opts.plotflag = 1; % create the plots
    % opts.plotflag = 0; % don't create the plots
end

% save the solution to disk
if ~isfield(opts,'saveflag')
    % opts.saveflag = 1; % save
    opts.saveflag = 0; % don't save
end

% name of the example
if ~isfield(opts,'name')
    opts.name = 'impulse2LTI'; 
end

% path for saving
if ~isfield(opts,'path')
    opts.path = mfoldername(mfilename('fullpath'),'_private'); 
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
    opts.parallel = 1; % yes
    % opts.parallel = 0; % no
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
    % opts.points.reduceflag = 1; % yes
    opts.points.reduceflag = 0; % no
end

% normalize the testing points
if ~isfield(opts.points,'normflag')
    opts.points.normflag = 1; % yes
    % opts.points.normflag = 0; % no
end

%--------------------------------------------------------------------------
% fitting options
%--------------------------------------------------------------------------
% initialize field
if ~isfield(opts,'fitting')
    opts.fitting = [];
end

% fitting method
if ~isfield(opts.fitting,'method')
    opts.fitting.method = 'multistart-lsqnonlin';
    % opts.fitting.method = 'particleswarm-lsqnonlin';
    % opts.fitting.method = 'ga-lsqnonlin';
    % opts.fitting.method = 'particleswarm';
    % opts.fitting.method = 'ga';
    % opts.fitting.method = 'patternsearch';
    % opts.fitting.method = 'fmincon';
    % opts.fitting.method = 'lsqnonlin';
end

% number of basis functions, 2*N states
if ~isfield(opts.fitting,'N')
	opts.fitting.N = 4; % 4 basis functions
end

% minimum amplitude bound
if ~isfield(opts.fitting,'T1min')
    opts.fitting.T1min = -500;
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

% maximum frequency bound
if ~isfield(opts.fitting,'T3max')
    opts.fitting.T3max = 300;
end

% number of start points to test with multistart option
if ~isfield(opts.fitting,'nStart')
	opts.fitting.nStart = 10;
end

% perform model reduction to reduce the number of states
if ~isfield(opts,'modred')
    opts.modred = 1; % use
    % opts.modred = 0; % don't use
end

%--------------------------------------------------------------------------
% plotting options
%--------------------------------------------------------------------------
% initialize field
if ~isfield(opts,'plot')
    opts.plot = [];
end

% perform the additional simulations for validating the fit
if ~isfield(opts.plot,'simulation')
    % opts.plot.simulation = 1; % yes
    opts.plot.simulation = 0; % no
end

end