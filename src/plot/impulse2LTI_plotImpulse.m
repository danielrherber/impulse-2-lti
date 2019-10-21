%--------------------------------------------------------------------------
% impulse2LTI_plotImpulse.m
% Plot fitted impulse function
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function impulse2LTI_plotImpulse(tv,Kv,tV,KV,A,opts)
% preliminary plot options
flag = 'preliminary'; impulse2LTI_plotCommon %#ok<NASGU>

%% plot fitted impulse function with long time horizon
hf = figure; % create a new figure and save handle
hf.Color = wcolor; % change the figure background color
hf.Position = [200 200 550 400]; % set figure size and position
hold on

% plot original impulse
plot(tv,Kv,'.r','markersize',10);

% plot fitted impulse
plot(tV,KV,'k','linewidth',1.5);

% combine
AllData = [Kv(:);KV(:)];

% axis
xlabel('$t$') % create x label
ylabel('Impulse Response') % create y label
xlim([tV(1) tV(end)]) % change x limits
ylim([min(AllData)-0.05 max(AllData)+0.05]) % change y limits
flag = 'axis'; impulse2LTI_plotCommon %#ok<NASGU>
% ha.XScale = 'log';

% legend
hl = legend({'Original sampled $k(t)$',['Fitted $\tilde{k}(t)$ with ',num2str(length(A)),...
    ' states']},'location','Best'); % create legend
flag = 'legend'; impulse2LTI_plotCommon %#ok<NASGU>

% save
flag = 'save'; figname = 'fit-longer'; impulse2LTI_plotCommon %#ok<NASGU>

%% plot fitted impulse function
hf = figure; % create a new figure and save handle
hf.Color = wcolor; % change the figure background color
hf.Position = [200 200 550 400]; % set figure size and position
hold on

% plot original impulse
plot(tv,Kv,'.r','markersize',10); 

% plot fitted impulse
plot(tV,KV,'k','linewidth',1.5);

% combine
AllData = [Kv(:);KV(:)];

% axis
xlabel('$t$') % create x label
ylabel('Impulse Response') % create y label
xlim([tv(1) tv(end)]) % change x limits
ylim([min(AllData)-0.05 max(AllData)+0.05]) % change y limits
flag = 'axis'; impulse2LTI_plotCommon %#ok<NASGU>
% ha.XScale = 'log';

% legend
hl = legend({'Original sampled $k(t)$',['Fitted $\tilde{k}(t)$ with ',num2str(length(A)),...
    ' states']},'location','Best'); % create legend
flag = 'legend'; impulse2LTI_plotCommon %#ok<NASGU>

% save
flag = 'save'; figname = 'fit'; impulse2LTI_plotCommon %#ok<NASGU>

end