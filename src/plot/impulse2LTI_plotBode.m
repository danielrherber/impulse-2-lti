%--------------------------------------------------------------------------
% impulse2LTI_plotBode.m
% Plot bode diagram for the state-space model
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber)
% Link: https://github.com/danielrherber/impulse-2-lti
%--------------------------------------------------------------------------
function impulse2LTI_plotBode(A,B,C,D,opts)
% preliminary plot options
flag = 'preliminary'; impulse2LTI_plotCommon %#ok<NASGU>

% bode plot
hf = figure; % create a new figure and save handle
hf.Color = wcolor; % change the figure background color
hf.Position = [200 200 750 500]; % set figure size and position

% calculate bounds
w = abs(imag(eig(A)));
w(w==0) = [];
wmin = min(w);
wmax = max(w);
if abs(wmax-wmin) < 1e-5
    wmin = 1e-1;
    wmax = 1e0;
elseif isempty(w)
    wmin = 1e-1;
    wmax = 1e0;
end
W = logspace(log10(wmin)-3,log10(wmax)+3,10000);

% obtain magnitude and phase
[mag,phase] = bode(ss(A,B,C,D),W);
mag = squeeze(mag);
phase = squeeze(phase);
H = W/(2*pi);

% plot magnitude
hf1 = subplot(2,1,1); hf1.XScale = 'log'; hold on
plot(H,20*log10(mag),'k','linewidth',1.5);

% axis
xlabel('$f$ [Hz]') % create x label
ylabel('Magnitude [dB]') % create y label
xlim([min(H) max(H)]) % change x limits
flag = 'axis'; impulse2LTI_plotCommon %#ok<NASGU>

% plot phase
hf2 = subplot(2,1,2); hf2.XScale = 'log'; hold on
plot(H,phase,'k','linewidth',1.5); 

% axis
xlabel('$f$ [Hz]') % create x label
ylabel('Phase [deg]') % create y label
xlim([min(H) max(H)]) % change x limits
flag = 'axis'; impulse2LTI_plotCommon %#ok<NASGU>

% save
flag = 'save'; figname = 'tf'; impulse2LTI_plotCommon %#ok<NASGU>

end