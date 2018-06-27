%--------------------------------------------------------------------------
% impulse2LTI_matrices.m
% Given fitting parameters and options, generate the state-space matrices
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber), University of 
% Illinois at Urbana-Champaign
% Project link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function [A,B,C,opts] = impulse2LTI_matrices(X,N,opts)
% extract fitted parameters
T1 = X(1:N);
T2 = X(N+1:2*N);
T3 = X(2*N+1:3*N);
T4 = X(3*N+1:4*N);

% initialize numerator and denominator
P = 0; Q = 1;

% sequentially combine the partial fractions; [P*q + p*Q]/(Q*q)
for k = 1:N
    % coefficients for the rational function that is to be combined
    p = [T1(k)*cos(T4(k)) T1(k)*(T2(k)*cos(T4(k)) - T3(k)*sin(T4(k)))];
    q = [1 2*T2(k) (T2(k)^2 + T3(k)^2)];
    
    % products
    Pq = conv(P,q);
    pQ = conv(p,Q);
    qQ = conv(q,Q);
    
    % assign numerator and denominator
    P = polysum(Pq, pQ);
    Q = qQ;

end

% construct transfer function
sys = tf(P,Q);

% get a balanced realization
sys = balreal(sys);

% get modal form
sys = canon(sys,'modal');

% extract matrices (ignore D since it is 0 or small)
A = sys.A;
B = sys.B;
C = sys.C;

% unscale
A = A/opts.scale.t;
C = C*opts.scale.K;

% create state-space model
sys = ss(A,B,C,[]);

% get modal form (again)
sys = canon(sys,'modal');

% extract matrices (ignore D since it is 0 or small)
A = sys.A;
B = sys.B;
C = sys.C;

% (potentially) save the results
if opts.saveflag
    save(fullfile(opts.path,[opts.name,'-ABC.mat']),'X','N','tv','Kv','A','B','C','opts')
end

end

function psum = polysum(x1, x2)
x1_order = length(x1);
x2_order = length(x2);
if x1_order > x2_order
     max_order = size(x1);
else
     max_order = size(x2);
end
new_x1 = padarray(x1,max_order-size(x1),0,'pre');
new_x2 = padarray(x2,max_order-size(x2),0,'pre');
psum = new_x1 + new_x2;
end

% old method

% create set of s-domain testing points
% S = logspace(-4,4,100*N);

% construct denominator polynomial from the roots
% Q = poly([-T2+T3*1i;-T2-T3*1i]);

% evaluate the basis functions in the s-domain
% Ks = sum(T1.*cos(T4).*(S+T2+T3.*tan(T4))./(S.^2 + 2*T2.*S + T2.^2 + T3.^2),1);

% use linear least-squares fitting to determine the numerator polynomial
% P = vander(S)\(polyval(Q,S).*Ks)';
% P = polyfit(S,polyval(Q,S).*Ks,2*N-1);