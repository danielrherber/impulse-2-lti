%--------------------------------------------------------------------------
% impulse2LTI_plotSimulation.m
% Run a simulation and plot the results
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function impulse2LTI_plotSimulation(tv,A,B,C,D,opts)

% NOTE: fix D term input

% preliminary plot options
flag = 'preliminary'; impulse2LTI_plotCommon %#ok<NASGU>

%% simulation
% simulation end time
tfsim = tv(end)*10;

% stiffness
k = 10;

% input
u = @(t) sin(t);

% ode tolerances
% options = odeset('RelTol',1e-2,'AbsTol',1e-4);
options = odeset('RelTol',1e-6,'AbsTol',1e-9);

% simulation with LTI approximation
tint = toc;
[tLTI,yLTI] = ode15s(@(t,y) derivLTI(t,y,A,B,C,u,k),[0 tfsim],zeros(length(A)+2,1),options);
tstop = toc;

disp(['LTI simulation time ',num2str(tstop-tint),' s'])

% simulation with direct convolution integral
tint = toc;
tCI = 0; yCI = zeros(1,2); % initialize
for idx = 2:length(tLTI)
    % update saved state values
    T = tCI; DX = yCI(:,2);

    % simulation the current time step
    [tout,yout] = ode15s(@(t,y) derivCI(t,y,u,k,tv(1),T,DX,opts.K),[tLTI(idx-1) tLTI(idx)],yCI(idx-1,:),options);

    % save the final values
    tCI(idx) = tout(end);
    yCI(idx,:) = yout(end,:);

    % display current time
    % disp(max(tout))
end
tstop = toc;

disp(['CI simulation time ',num2str(tstop-tint),' s'])

% simulation with trapezodial rule
tint = toc;
tCItrapz = 0; yCItrapz = zeros(1,2); % initialize
for idx = 2:length(tLTI)
    % update saved state values
    T = tCItrapz; DX = yCItrapz(:,2);

    % simulation the current time step
    [tout,yout] = ode15s(@(t,y) derivCItrapz(t,y,u,k,tv(1),T,DX,opts.K),[tLTI(idx-1) tLTI(idx)],yCI(idx-1,:),options);

    % save the final values
    tCItrapz(idx) = tout(end);
    yCItrapz(idx,:) = yout(end,:);

    % display current time
    % disp(max(tout))
end
tstop = toc;

disp(['CI with trapz simulation time ',num2str(tstop-tint),' s'])

% simulation without convolution integral
tint = toc;
[tNOCI,yNOCI] = ode15s(@(t,y) derivNOCI(t,y,u,k),[0 tfsim],zeros(2,1),options);
tstop = toc;

disp(['no CI simulation time ',num2str(tstop-tint),' s'])

%% plot simulation errors
hf = figure; % create a new figure and save handle
hf.Color = wcolor; % change the figure background color
hf.Position = [200 200 550 400]; % set figure size and position
hold on

% plot convolution integral simulation results
semilogy(tCI,abs(yCItrapz(:,2)-yLTI(:,2)),'b','linewidth',1.5);
semilogy(tCI,abs(yCI(:,2)-yLTI(:,2)),'r','linewidth',1.5);

% axis
xlabel('$t$') % create x label
ylabel('Error') % create y label
xlim([tCI(1) tCI(end)]) % change x limits
flag = 'axis'; impulse2LTI_plotCommon %#ok<NASGU>

% legend
hl = legend({'$|\dot{x}_{\mathrm{CI,trapz}}-\dot{x}_{\mathrm{LTI}}|$',...
    '$|\dot{x}_{\mathrm{CI,direct}}-\dot{x}_{\mathrm{LTI}}|$'},'location','Best'); % create legend
flag = 'legend'; impulse2LTI_plotCommon %#ok<NASGU>

% save
flag = 'save'; figname = 'sim-error'; impulse2LTI_plotCommon %#ok<NASGU>

%% plot simulation
hf = figure; % create a new figure and save handle
hf.Color = wcolor; % change the figure background color
hf.Position = [200 200 550 400]; % set figure size and position
hold on

% % plot convolution integral simulation results
% plot(tNOCI,yNOCI(:,2),'.g','markersize',12);

% plot convolution integral simulation results
plot(tCItrapz,yCItrapz(:,2),'.b','markersize',16);

% plot convolution integral simulation results
plot(tCI,yCI(:,2),'.r','markersize',16);

% plot LTI approximation simulation results
plot(tLTI,yLTI(:,2),'k','linewidth',1.5);

% combine
AllData = [yLTI(:,2);yCI(:,2)];

% axis
xlabel('$t$') % create x label
ylabel('$\dot{x}(t)$') % create y label
xlim([tCI(1) tCI(end)]) % change x limits
ylim([min(AllData)-0.05 max(AllData)+0.05]) % change y limits
flag = 'axis'; impulse2LTI_plotCommon %#ok<NASGU>

% legend
hl = legend({'$\dot{x}_{\mathrm{CI,trapz}}(t)$','$\dot{x}_{\mathrm{CI,direct}}(t)$',...
    '$\dot{x}_{\mathrm{LTI}}(t)$'},'location','Best'); % create legend
flag = 'legend'; impulse2LTI_plotCommon %#ok<NASGU>

% save
flag = 'save'; figname = 'sim'; impulse2LTI_plotCommon %#ok<NASGU>

end

%--------------------------------------------------------------------------
% derivative function with LTI approximation
function yp = derivLTI(t,y,A,B,C,u,k)
% derivatives
yp = [0 1 zeros(1,length(A)); -k 0 -C;...
    zeros(length(A),1) B A]*y + [0; u(t);...
    zeros(length(A),1)];
end
%--------------------------------------------------------------------------
% derivative function with direct convolution integral
function yp = derivCI(t,y,u,k,t0,T,DX,K)
% derivative of the first state
yp(1) = y(2);

% handle when t=t0
if t == T(end)
    CI = 0;
else
    % interpolation function
	fdx = @(tau) interp1([T,t]',[DX;y(2)],tau,'pchip');

    % compute the convolution integral
    CI = integral(@(tau) K(t-tau).*fdx(tau),t0,t,'RelTol',1e-5,'AbsTol',1e-8,'WayPoints',[T,t])';
end

% derivative of the second state
yp(2) = -k*y(1) - CI + u(t);

% column vector output
yp = yp(:);
end
%--------------------------------------------------------------------------
% derivative function with trapezodial rule
function yp = derivCItrapz(t,y,u,k,t0,T,DX,K)
% derivative of the first state
yp(1) = y(2);

% handle when t=t0
if t == T(end)
    CI = 0;
else
    T2 = [T,t]';
    F2 = [DX;y(2)];
    K2 = K(t-T2);
    CI = trapz(T2,K2.*F2);
end

% derivative of the second state
yp(2) = -k*y(1) - CI + u(t);

% column vector output
yp = yp(:);
end

%--------------------------------------------------------------------------
% derivative function with no convolution integral
function yp = derivNOCI(t,y,u,k)
% derivatives
yp = [0 1; -k 0]*y + [0; u(t)];
end