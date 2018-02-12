%--------------------------------------------------------------------------
% impulse2LTI_plot.m
% Plot the fit; potentially perform some simulations for validation
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber), University of 
% Illinois at Urbana-Champaign
% Project link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function impulse2LTI_plot(tv,Kv,A,B,C,opts)
% unscale
Kv = Kv*opts.scale.K;
tv = tv*opts.scale.t;

% calculate over finer time grid
tV = linspace(tv(1),tv(end)*10,10000)';
KV = impulse(ss(A,B,C,[]),tV);

% simulation
if opts.plot.simulation
    % stiffness
    k = 10;
    
    % input
    u = @(t) sin(t);
    
    % ode tolerances
    options = odeset('RelTol',1e-4,'AbsTol',1e-7);
    
    % simulation with LTI approximation
    [tLTI,yLTI] = ode15s(@(t,y) derivLTI(t,y,A,B,C,u,k),[0 tv(end)*15],zeros(length(A)+2,1),options);

    % simulation with convolution integral
    tCI = 0; yCI = zeros(1,2); % initialize
    for idx = 2:length(tLTI)
        % update saved state values
        T = tCI; DX = yCI(:,2);

        % simulation the current time step
        [tout,yout] = ode15s(@(t,y) derivCI(t,y,u,k,tv(1),[-1,T],[0;DX],opts.K),[tLTI(idx-1) tLTI(idx)],yCI(idx-1,:),options);
        
        % save the final values
        tCI(idx) = tout(end);
        yCI(idx,:) = yout(end,:);
        
        % display current time
        % disp(max(tout))
    end
end

%--------------------------------------------------------------------------
% pre tasks
fontlabel = 20; % x,y label font size
fontlegend = 12; % x,y legend font size
fonttick = 12; % x,y tick font size
wcolor = [1 1 1]; % white color
bcolor = [0 0 0]; % black color
set(0,'DefaultTextInterpreter','latex'); % change the text interpreter
set(0,'DefaultLegendInterpreter','latex'); % change the legend interpreter
set(0,'DefaultAxesTickLabelInterpreter','latex'); % change the tick interpreter

%--------------------------------------------------------------------------
% simulation errors
if opts.plot.simulation
    hf = figure; % create a new figure and save handle
    hf.Color = wcolor; % change the figure background color
    hf.Position = [200 200 550 400]; % set figure size and position
    
    % plot convolution integral simulation results
    semilogy(tCI,abs(yCI(:,2)-yLTI(:,2)),'k','linewidth',1.5); hold on
    
    % axis
    xlabel('$t$') % create x label
    ylabel('$|\dot{y}_{\mathrm{CI}}-\dot{y}_{\mathrm{LTI}}|$') % create y label
    xlim([tCI(1) tCI(end)]) % change x limits
    ha = gca; % get current axis handle
    ha.XAxis.Color = bcolor; % change the x axis color to black (not a dark grey)
    ha.YAxis.Color = bcolor; % change the y axis color to black (not a dark grey)
    ha.XAxis.FontSize = fonttick; % change x tick font size
    ha.YAxis.FontSize = fonttick; % change y tick font size
    ha.XAxis.Label.FontSize = fontlabel; % change x label font size
    ha.YAxis.Label.FontSize = fontlabel; % change y label font size
    ha.Layer = 'top'; % place the axes on top of the data

end

%--------------------------------------------------------------------------
% simulation
if opts.plot.simulation
    hf = figure; % create a new figure and save handle
    hf.Color = wcolor; % change the figure background color
    hf.Position = [200 200 550 400]; % set figure size and position
    
    % plot convolution integral simulation results
    plot(tCI,yCI(:,2),'.r','markersize',16); hold on

    % plot LTI approximation simulation results
    plot(tLTI,yLTI(:,2),'k','linewidth',1.5); hold on

    % combine
    AllData = [yLTI(:,2);yCI(:,2)];
    
    % axis
    xlabel('$t$') % create x label
    ylabel('$\dot{y}(t)$') % create y label
    xlim([tCI(1) tCI(end)]) % change x limits
    ylim([min(AllData)-0.05 max(AllData)+0.05]) % change y limits
    ha = gca; % get current axis handle
    ha.XAxis.Color = bcolor; % change the x axis color to black (not a dark grey)
    ha.YAxis.Color = bcolor; % change the y axis color to black (not a dark grey)
    ha.XAxis.FontSize = fonttick; % change x tick font size
    ha.YAxis.FontSize = fonttick; % change y tick font size
    ha.XAxis.Label.FontSize = fontlabel; % change x label font size
    ha.YAxis.Label.FontSize = fontlabel; % change y label font size
    ha.Layer = 'top'; % place the axes on top of the data

    % legend
    hl = legend({'$\dot{y}_{\mathrm{CI}}(t)$','$\dot{y}_{\mathrm{LTI}}(t)$'},'location','Best'); % create legend
    hl.FontSize = fontlegend; % change legend font size
    hl.EdgeColor = bcolor; % change the legend border to black (not a dark grey)
    
end

%--------------------------------------------------------------------------
% bode plot
hf = figure; % create a new figure and save handle
hf.Color = wcolor; % change the figure background color
hf.Position = [200 200 550 400]; % set figure size and position

% obtain magnitude and phase
W = 2*pi*logspace(-3,3,10000);
[mag,phase] = bode(ss(A,B,C,[]),W);
mag = squeeze(mag);
phase = squeeze(phase);
H = W/(2*pi);

% plot magnitude
subplot(2,1,1)
semilogx(H,20*log10(mag),'k','linewidth',1.5); hold on

% axis
xlabel('$f$ [Hz]') % create x label
ylabel('Magnitude [dB]') % create y label
xlim([min(H) max(H)]) % change x limits
ha = gca; % get current axis handle
ha.XAxis.Color = bcolor; % change the x axis color to black (not a dark grey)
ha.YAxis.Color = bcolor; % change the y axis color to black (not a dark grey)
ha.XAxis.FontSize = fonttick*0.8; % change x tick font size
ha.YAxis.FontSize = fonttick*0.8; % change y tick font size
ha.XAxis.Label.FontSize = fontlabel*0.8; % change x label font size
ha.YAxis.Label.FontSize = fontlabel*0.8; % change y label font size
ha.Layer = 'top'; % place the axes on top of the data

% plot phase
subplot(2,1,2)
semilogx(H,phase,'k','linewidth',1.5); hold on

% axis
xlabel('$f$ [Hz]') % create x label
ylabel('Phase [deg]') % create y label
xlim([min(H) max(H)]) % change x limits
ha = gca; % get current axis handle
ha.XAxis.Color = bcolor; % change the x axis color to black (not a dark grey)
ha.YAxis.Color = bcolor; % change the y axis color to black (not a dark grey)
ha.XAxis.FontSize = fonttick*0.8; % change x tick font size
ha.YAxis.FontSize = fonttick*0.8; % change y tick font size
ha.XAxis.Label.FontSize = fontlabel*0.8; % change x label font size
ha.YAxis.Label.FontSize = fontlabel*0.8; % change y label font size
ha.Layer = 'top'; % place the axes on top of the data

%--------------------------------------------------------------------------
% long time horizon
hf = figure; % create a new figure and save handle
hf.Color = wcolor; % change the figure background color
hf.Position = [200 200 550 400]; % set figure size and position

% plot original kernel
plot(tv,Kv,'.r','markersize',10); hold on

% plot fitted kernel
plot(tV,KV,'k','linewidth',1.5); hold on

% combine
AllData = [Kv(:);KV(:)];

% axis
xlabel('$t$') % create x label
ylabel('$K(t)$') % create y label
xlim([tV(1) tV(end)]) % change x limits
ylim([min(AllData)-0.05 max(AllData)+0.05]) % change y limits
ha = gca; % get current axis handle
ha.XAxis.Color = bcolor; % change the x axis color to black (not a dark grey)
ha.YAxis.Color = bcolor; % change the y axis color to black (not a dark grey)
ha.XAxis.FontSize = fonttick; % change x tick font size
ha.YAxis.FontSize = fonttick; % change y tick font size
ha.XAxis.Label.FontSize = fontlabel; % change x label font size
ha.YAxis.Label.FontSize = fontlabel; % change y label font size
ha.Layer = 'top'; % place the axes on top of the data

% legend
hl = legend({'Sampled $K(t)$','Fitted $K(t)$'},'location','Best'); % create legend
hl.FontSize = fontlegend; % change legend font size
hl.EdgeColor = bcolor; % change the legend border to black (not a dark grey)

%--------------------------------------------------------------------------
% fitted kernel function
hf = figure; % create a new figure and save handle
hf.Color = wcolor; % change the figure background color
hf.Position = [200 200 550 400]; % set figure size and position

% plot original kernel
plot(tv,Kv,'.r','markersize',10); hold on

% plot fitted kernel
plot(tV,KV,'k','linewidth',1.5); hold on

% combine
AllData = [Kv(:);KV(:)];

% axis
xlabel('$t$') % create x label
ylabel('$K(t)$') % create y label
xlim([tv(1) tv(end)]) % change x limits
ylim([min(AllData)-0.05 max(AllData)+0.05]) % change y limits
ha = gca; % get current axis handle
ha.XAxis.Color = bcolor; % change the x axis color to black (not a dark grey)
ha.YAxis.Color = bcolor; % change the y axis color to black (not a dark grey)
ha.XAxis.FontSize = fonttick; % change x tick font size
ha.YAxis.FontSize = fonttick; % change y tick font size
ha.XAxis.Label.FontSize = fontlabel; % change x label font size
ha.YAxis.Label.FontSize = fontlabel; % change y label font size
ha.Layer = 'top'; % place the axes on top of the data

% legend
hl = legend({'Sampled $K(t)$','Fitted $K(t)$'},'location','Best'); % create legend
hl.FontSize = fontlegend; % change legend font size
hl.EdgeColor = bcolor; % change the legend border to black (not a dark grey)

%--------------------------------------------------------------------------
% command window outputs
if opts.displevel > 2 % very verbose
    disp(''); disp('eig(A)'); disp(eig(A)');
    disp('A'); disp(A); disp('B'''); disp(B'); disp('C'); disp(C)
end

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
% derivative function with convolution integral
function yp = derivCI(t,y,u,k,t0,T,DX,K)
% derivative of the first state
yp(1) = y(2);

% handle when t=t0
if t == T(end)
    fdx = @(tau) interp1(T,DX,tau,'pchip');
else
    fdx = @(tau) interp1([T,t],[DX;y(2)],tau,'pchip');
end

% compute the convolution integral
CI = integral(@(tau) K(t-tau).*fdx(tau),t0,t,'RelTol',1e-6,'AbsTol',1e-9);

% derivative of the second state
yp(2) = -k*y(1) - CI + u(t);

% column vector output
yp = yp(:);
end