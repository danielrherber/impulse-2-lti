%--------------------------------------------------------------------------
% impulse2LTI_fitting.m
% General fitting function
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function [X,F] = impulse2LTI_fitting(method_errors,tv,Kv,N,LBs,UBs,X,LBopt,UBopt,fitting,opts)

% extract
scaleflag = fitting.scaleflag;

% get the run order for the optimization algorithms
algorithms = strsplit(lower(fitting.algorithm),'-');

% number of optimization variables
n = length(LBopt);

% perform the fitting
for idx = 1:length(algorithms)

    switch algorithms{idx}
        %------------------------------------------------------------------
        case 'lsqnonlin'
            [X,F] = lsqnonlin(@(x) method_errors(x,tv,Kv,N,LBs,UBs,scaleflag),...
                X,LBopt,UBopt,fitting.lsqnonlin);
        %------------------------------------------------------------------
        case 'fmincon'
            [X,F] = fmincon(@(x) sum(method_errors(x,tv,Kv,N,LBs,UBs,scaleflag).^2),...
                X,[],[],[],[],LBopt,UBopt,[],fitting.fmincon);
        %------------------------------------------------------------------
        case 'patternsearch'
            [X,F] = patternsearch(@(x) sum(method_errors(x,tv,Kv,N,LBs,UBs,scaleflag).^2),...
                X,[],[],[],[],LBopt,UBopt,[],fitting.patternsearch);
        %------------------------------------------------------------------
        case 'ga'
            [X,F] = ga(@(x) sum(method_errors(x,tv,Kv,N,LBs,UBs,scaleflag).^2),...
                n,[],[],[],[],LBopt,UBopt,[],fitting.ga);
        %------------------------------------------------------------------
        case 'particleswarm'
            [X,F] = particleswarm(@(x) sum(method_errors(x,tv,Kv,N,LBs,UBs,scaleflag).^2),...
                n,LBopt,UBopt,fitting.particleswarm);
        %------------------------------------------------------------------
        case 'multilsqnonlin'       
            lsqnonlin_options = optimoptions(fitting.lsqnonlin,'Display','none');
            problem = createOptimProblem('lsqnonlin','objective',...
                @(x) method_errors(x,tv,Kv,N,LBs,UBs,scaleflag),'X',X,...
                'lb',LBopt,'ub',UBopt,'options',lsqnonlin_options);
            [X,F] = run(fitting.multistart,problem,fitting.nStart);
    end

end

% reshape optimization variables in column vector
X = X(:);

% (potentially) unscale
if scaleflag
    X = (UBs-LBs).*X+LBs;
end

% reshape
X = reshape(X,N,[]);

end