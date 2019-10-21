%--------------------------------------------------------------------------
% impulse2LTI_plotBasis.m
% Plot the individual basis functions
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function impulse2LTI_plotBasis(tv,Kv,tV,KV,X,opts)
% reshape into row vector
X = reshape(X,1,[]);

% number of basis functions
N = length(X)/4;

% extract fitting parameters
T1 = X(1:N);
T2 = X(N+1:2*N);
T3 = X(2*N+1:3*N);
T4 = X(3*N+1:4*N);

% temporary variables
t0 = T3.*tV+T4;
t1 = exp(-T2.*tV);
t2 = cos(t0);
t3 = T1.*t1;

% calculate the approximate function using the basis functions
K = t2.*t3;

% preliminary plot options
flag = 'preliminary'; impulse2LTI_plotCommon %#ok<NASGU>

hf = figure; % create a new figure and save handle
hf.Color = wcolor; % change the figure background color
hf.Position = [200 200 550 400]; % set figure size and position
hold on

% plot original impulse
plot(tv,Kv,'.r','markersize',10);

% plot fitted impulse
plot(tV,KV,'k','linewidth',1.5);

% create a color map for the basis function lines
cmap = parula(N+2);

% plot each basis function
for idx = 1:N
    plot(tV,K(:,idx),'linewidth',1,'color',cmap(idx,:))
end

% combine
AllData = [K(:);Kv(:)];

% axis
xlabel('$t$') % create x label
ylabel('Impulse Response') % create y label
xlim([tv(1) tv(end)]) % change x limits
ylim([min(AllData)-0.01 max(AllData)+0.01]) % change y limits
flag = 'axis'; impulse2LTI_plotCommon %#ok<NASGU>
% ha.XScale = 'log';

% legend
bstr = regexp(sprintf('%d#', 1:N),'#','split'); bstr(end) = [];
bstr = cellstr(strcat('$\phi_{',bstr','}$'));
hl = legend([{'Org $k(t)$'},{'Fit $\tilde{k}(t)$'},bstr(:)'],'location','eastoutside'); % create legend
flag = 'legend'; impulse2LTI_plotCommon %#ok<NASGU>

% title
ht = title('NOTE: this plot is only valid if no model reduction is performed');

% save
flag = 'save'; figname = 'basis'; impulse2LTI_plotCommon %#ok<NASGU>

end