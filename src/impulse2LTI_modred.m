%--------------------------------------------------------------------------
% impulse2LTI_modelreduct.m
% Given a state-space model, perform model reduction to reduce the number
% of states
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function [A,B,C,D,opts] = impulse2LTI_modred(A,B,C,D,opts)
% initialize
continueflag = 1;

% create a state-space model
sys = ss(A,B,C,D);

% reduce states until no more reduction is needed
while continueflag
    % previous number of states
    nold = length(sys.A);

	% gramian-based input/output balancing of state-space realization
	[sys,g] = balreal(sys);

	% determine which states to remove
	elim = (g < 1e-6);

	% eliminate states
	if sum(elim) ~= 0
	    if (opts.displevel > 1) % verbose
	        disp(['eliminating ',num2str(sum(elim)),' states']);
	    end

	    % eliminate states from state-space models
	    sys = modred(sys,elim,'truncate'); % check truncate
	end

    % compare with previous number of states
    if nold == length(sys.A)
        continueflag = 0; % stop
    end
end

% get modal form
sys = canon(sys,'modal');

% extract matrices
A = sys.A; B = sys.B; C = sys.C; D = sys.D;

end