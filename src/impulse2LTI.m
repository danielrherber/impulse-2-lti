%--------------------------------------------------------------------------
% impulse2LTI.m
% Given a impulse response function (IRF), generate an LTI system matrices 
% (A,B,C,D) that 'best' approximates the IRF in the time domain
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function [A,B,C,D] = impulse2LTI(K,varargin)
% parse inputs
if nargin > 1
    opts = varargin{1};
else
    opts = [];
end

% assign impulse response function
opts.K = K;

% get default options
opts = impulse2LTI_opts(opts);

% potentially start the timer
if (opts.displevel > 0) % minimal
    tic % start timer
end

% determine the fitting formulation
formulation = lower(opts.fitting.formulation);
switch formulation
    %----------------------------------------------------------------------
    case 'full'
        error(strcat("formulation ",formulation," not yet available"))
    %----------------------------------------------------------------------
    case 'canon.direct'
        error(strcat("formulation ",formulation," not yet available"))
    %----------------------------------------------------------------------
    case 'canon.direct.ls'
        error(strcat("formulation ",formulation," not yet available"))
    %----------------------------------------------------------------------
    case 'canon.roots'
        error(strcat("formulation ",formulation," not yet available"))
    %----------------------------------------------------------------------
    case 'canon.roots.ls'
        error(strcat("formulation ",formulation," not yet available"))
    %----------------------------------------------------------------------
    case 'prony'
        fitmethod = @impulse2LTI_fitting_prony;
    %----------------------------------------------------------------------
    case 'basis.pbf'
        fitmethod = @impulse2LTI_fitting_basis_pbf;
    %----------------------------------------------------------------------
    case 'basis.pbf.ls'
        fitmethod = @impulse2LTI_fitting_basis_pbf_ls;
    %----------------------------------------------------------------------
    case 'basis.ghm'
        error(strcat("formulation ",formulation," not yet available"))
    %----------------------------------------------------------------------
    case 'basis.ghm.ls'
        error(strcat("formulation ",formulation," not yet available"))
    %----------------------------------------------------------------------
    case 'basis.ps'
        error(strcat("formulation ",formulation," not yet available"))
    %----------------------------------------------------------------------
    case 'basis.ps.ls'
        error(strcat("formulation ",formulation," not yet available"))
    %----------------------------------------------------------------------
    case 'imp2ss'
        fitmethod = @impulse2LTI_fitting_imp2ss;
    %----------------------------------------------------------------------
    otherwise
        error("Formulation not found")
end

% obtain a realization with the selected method
[A,B,C,D,X,tv,Kv,opts] = fitmethod(K,opts);

% use model reduction techniques to reduce the number of states
if opts.modredflag
    [A,B,C,D,opts] = impulse2LTI_modred(A,B,C,D,opts);
end

% end the timer
if (opts.displevel > 0) % minimal
    T = toc;
end

% (potentially) save the results
if opts.saveflag
    save(fullfile(opts.path,[opts.name,'-ABC.mat']),...
        'tv','Kv','X','A','B','C','opts','T');
end

% (potentially) display to the command window
impulse2LTI_dispfun(opts.displevel,'final-stats',A,B,C,D,tv,Kv,T)

% plots
if opts.plotflag
    impulse2LTI_plot(tv,Kv,A,B,C,D,X,opts);
end

end