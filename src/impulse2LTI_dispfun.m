%--------------------------------------------------------------------------
% impulse2LTI_dispfun.m
% (Potentially) display stuff to command window
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function impulse2LTI_dispfun(displevel,category,varargin)
% determine what we want to display
switch category
    %----------------------------------------------------------------------
    case 'objective'
        % display objective function value
        if (displevel > 1) % verbose
            F = varargin{1}; % extract
            disp(['objective function value: ',num2str(F)]);
        end
    %----------------------------------------------------------------------
    case 'final-stats'
        % display final statistics
        if (displevel > 1) % verbose
            [A,B,C,D,tv,Kv,T] = deal(varargin{:});

            % calculate errors
            tv = linspace(tv(1),tv(end),length(tv))'; % ensure constant step size
            e = Kv - impulse(ss(A,B,C,D),tv); % residuals
            SSres = sum(e.^2); % sum of squares of residuals
            Rsq = 1 - SSres/sum((Kv-mean(Kv)).^2); % coefficient of determination

            % sum of the squared residuals
            disp(['SSres: ', num2str(SSres)])

            % coefficient of determination
            disp(['R^2: ', num2str(Rsq)])

            % check if the system is BIBO stable
            sf = all(real(eig(A)) < 0);
            disp(strcat("BIBO stable system: ",string(sf)));

            % check if the system is passive
            pf = isPassive(ss(A,B,C,D));
            disp(strcat("Passive system: ",string(pf)))

            % fitting time
            disp(['impulse2LTI fitting time: ', num2str(T), ' s'])
        end
end