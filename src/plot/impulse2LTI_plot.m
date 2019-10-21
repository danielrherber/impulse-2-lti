%--------------------------------------------------------------------------
% impulse2LTI_plot.m
% Plot the fit; potentially perform some simulations for validation
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function impulse2LTI_plot(tv,Kv,A,B,C,D,X,opts)
% calculate over finer time grid
m1 = 5; m2 = 5;
tV = linspace(tv(1),m1*tv(end),m2*m1*opts.points.N)';
KVimpulse = impulse(ss(A,B,C,D),tV);
if all(diff(tv) == tv(2)-tv(1))
    Kvimpulse = impulse(ss(A,B,C,D),tv); % original
    [ti,Ii] = sort([tv;tV]);
    Ki = [Kvimpulse;KVimpulse];
    Ki = Ki(Ii);
else
    tv2 = linspace(tv(1),tv(1)+1,m2*2*opts.points.N)';
    Kvimpulse = impulse(ss(A,B,C,D),tv2); % original
    [ti,Ii] = sort([tv2;tV]);
    Ki = [Kvimpulse;KVimpulse];
    Ki = Ki(Ii);
end

% simulation plots
if opts.plot.simulationflag
    impulse2LTI_plotSimulation(tv,A,B,C,D,opts);
end

% bode plots
impulse2LTI_plotBode(A,B,C,D,opts);

% basis function plots
if contains(opts.fitting.formulation,{'prony','basis.pbf','basis.ghm','basis.ps'})
    impulse2LTI_plotBasis(tv,Kv,ti,Ki,X,opts);
end

% impulse plots
impulse2LTI_plotImpulse(tv,Kv,ti,Ki,A,opts);

% command window outputs
if opts.displevel > 2 % very verbose
    disp(''); disp('eig(A)'); disp(eig(A)');
    if length(B) <= 8
        disp('A'); disp(A); disp('B'''); disp(B'); disp('C'); disp(C)
    end
    
end

end