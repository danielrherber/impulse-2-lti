%--------------------------------------------------------------------------
% impulse2LTI_errors.m
% Given fitting parameters and points, calculate the errors
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber), University of 
% Illinois at Urbana-Champaign
% Project link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function [E,varargout] = impulse2LTI_errors(x,tv,Kv,N)
% reshape into row vector
x = reshape(x,1,[]);

% extract fitting parameters
T1 = x(1:N);
T2 = x(N+1:2*N);
T3 = x(2*N+1:3*N);
T4 = x(3*N+1:4*N);

% temporary variables
t0 = T3.*tv+T4;
t1 = exp(-T2.*tv);
t2 = cos(t0);
t3 = T1.*t1;

% calculate the approximate function using the basis functions
K = t2.*t3;

% compute the errors
E = sum(K,2) - Kv;

% calculate Jacobian
if nargout > 1
	% temporary variables
	t4 = sin(t0).*t3;

	% simplified
	dFdT1 = t2.*t1;
	dFdT2 = -tv.*K;
	dFdT3 = -tv.*t4;
	dFdT4 = -t4;

	% combine
	J = [dFdT1,dFdT2,dFdT3,dFdT4];

	% output
    varargout{1} = J;
end

end
% K = T1.*cos(T3.*tv+T4).*exp(-T2.*tv);
% dFdT1 = cos(T3.*tv-T4).*exp(-T2.*tv);
% dFdT2 = -tv.*T1.*cos(T3.*tv-T4).*exp(-T2.*tv);
% dFdT3 = tv.*T1.*sin(T3.*tv-T4).*exp(-T2.*tv);
% dFdT4 = -T1.*sin(T3.*tv-T4).*exp(-T2.*tv);