%--------------------------------------------------------------------------
% impulse2LTI_fitting_prony.m
% Find an LTISS model using Prony's method
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function [A,B,C,D,X,tv,Kv,opts] = impulse2LTI_fitting_prony(K,opts)
% extract 
N = 2*opts.fitting.N; % desired sequence of basis function counts

% data points for fitting
[tv,Kv,tvs,Kvs,opts] = impulse2LTI_points(K,opts);

% number of samples
Ns = length(tv); 

% sample time
ts = tvs(2) - tvs(1); 

% check if this is an equidistant grid
if uniquetol(diff(tvs))>1
    error('prony method requires an equidistant grid')
end

% find Pm
A = toeplitz(Kvs(N:Ns-1),Kvs(N:-1:1));
Pm = -A\Kvs(N+1:Ns);
Lm = roots([1,Pm(:)']);

% obtain T2 model parameter
T2 = -real(log(Lm))/ts/opts.scale.t;

% obtain T3 model parameter
T3 = imag(log(Lm))/ts/opts.scale.t;

% find unique rows
[C,~,~] = uniquetol([T2,abs(T3)],'ByRows',true);

% extract new roots
T2 = C(:,1);
T3 = C(:,2);

% obtain B coefficients using unscale data
B = calcLLS([T2,T3],tv,Kv);

% reshape and extract
B = reshape(B,[],2);
T5 = B(:,1);
T6 = B(:,2);

% obtain T1 and T4
T1 = sign(T5).*sqrt(T5.^2+T6.^2);
T4 = 2*atan2((T5-T1),T6);

% combine
X = [T1,T2,T3,T4];

% update N
N = size(X,1);

% calculate state space matrices
[A,B,C,D,opts] = impulse2LTI_matrices(X,N,opts);

end
% obtain linear least-squares estimate
function B = calcLLS(X,tv,Kv)
% extract fitting parameters
T2 = X(:,1)';
T3 = X(:,2)';

% temporary variables
t0 = exp(-T2.*tv);
t1 = t0.*cos(T3.*tv);
t2 = t0.*sin(T3.*tv);

% combine 
X = [t1,t2];

% solve the linear system of equations
B = linsolve(X,Kv);

end