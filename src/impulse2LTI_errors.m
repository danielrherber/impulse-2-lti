%--------------------------------------------------------------------------
% impulse2LTI_errors.m
% Given model parameters and data points, calculate error
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function E = impulse2LTI_errors(X,tv,Kv)
% extract fitting parameters
T1 = X(:,1)'; T2 = X(:,2)'; T3 = X(:,3)'; T4 = X(:,4)';

% temporary variables
t0 = T3.*tv+T4;
t1 = exp(-T2.*tv);
t2 = cos(t0);
t3 = T1.*t1;

% calculate the approximate function using the basis functions
K = sum(t2.*t3,2);

% compute the errors
E = K - Kv;

end