%--------------------------------------------------------------------------
% impulse2LTI_matrices.m
% Given fitting parameters and options, generate the state-space matrices
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function [A,B,C,D,opts] = impulse2LTI_matrices(X,N,opts)
% extract fitted parameters
T1 = X(1:N);
T2 = X(N+1:2*N);
T3 = X(2*N+1:3*N);
T4 = X(3*N+1:4*N);

% initialize
A = cell(N,1); B = A; C = A; D = A;

% obtain individual block matrices
for k = 1:N
    if T3(k) == 0
        A{k} = -T2(k);
        B{k} = T1(k)*cos(T4(k));
        C{k} = 1;
        D{k} = 0;
    else
        A{k} = [-T2(k) T3(k); -T3(k) -T2(k)];
        B{k} = [T1(k)*sin(T4(k));T1(k)*cos(T4(k))];
        C{k} = [0 1];
        D{k} = 0;
    end
end

% combine matrices
A = blkdiag(A{:});
B = vertcat(B{:});
C = horzcat(C{:});
D = sum([D{:}]);

end