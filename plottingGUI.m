% plottingGUI.m
%
% Peyton McClintock
% 12/4/2018

clear

%%  Make GUI

% Create Figure
fig = figure(1); clf;

% Create Axes
ax = axes;
ax.Position = ax.Position + [0 0.25 0 -.25];
centerAx = ax.Position(3)/2 + ax.Position(1);
rightAx = ax.Position(3) + ax.Position(1);
t = linspace(0,1,1000);
p = plot(ax,t,10*sin(2*pi*(5)*(t + deg2rad(0))));
grid on;
ax.Title.String = 'My Sinusoid';
xlabel('Time')
ylabel('Amplitude')
axis([0 1 -40 40])

% Create Control
amps = uibuttongroup(fig,'Position',[ax.Position(1) 0 0.125 0.25]);
amp1 = uicontrol(amps,'Style','radiobutton','String','10',...
        'Position',[10 60 100 20]);
amp2 = uicontrol(amps,'Style','radiobutton','String','20',...
        'Position',[10 40 100 20]);
amp3 = uicontrol(amps,'Style','radiobutton','String','30',...
        'Position',[10 20 100 20]);
amp4 = uicontrol(amps,'Style','radiobutton','String','40',...
        'Position',[10 0 100 20]);
ampText = uicontrol(amps,'Style','Text','String','Amplitude',...
        'Position',[10 80 100 20],'HorizontalAlignment','left');
    
phase = uicontrol(fig,'Style','Edit','Units','normalized',...
        'Position',[centerAx-.1 0.125 .2 .05],'String','0');
phaseText = uicontrol(fig,'Style','Text','Units','normalized',...
        'Position',[centerAx-.1 0.19 .2 .05],'String','Phase (deg)');

freq = uicontrol(fig,'Style','Slider','Units','normalized',...
        'Position',[rightAx-.2 0.125 .2 .05],'Max',10,'Value',5,'Min',0,...
        'SliderStep',[0.1 1]);
freqText = uicontrol(fig,'Style','Text','Units','normalized',...
        'Position',[rightAx-.2 0.19 .2 .05],'String','Frequency (Hz)');
freqMin = uicontrol(fig,'Style','Text','Units','normalized',...
        'Position',[rightAx-.2 0.05 .1 .05],'String','0',...
        'HorizontalAlignment','left');
freqMax = uicontrol(fig,'Style','Text','Units','normalized',...
    'Position',[rightAx-.1 0.05 .1 .05],'String','10',...
    'HorizontalAlignment','right');

% Define Callback
amp1.Callback  = {@replot,ax,amps,phase,freq,t};
amp2.Callback  = {@replot,ax,amps,phase,freq,t};
amp3.Callback  = {@replot,ax,amps,phase,freq,t};
amp4.Callback  = {@replot,ax,amps,phase,freq,t};
phase.Callback = {@replot,ax,amps,phase,freq,t};
freq.Callback  = {@replot,ax,amps,phase,freq,t};

%% Callback Function

function [] = replot(~,~,ax,amps,phase,freq,t)

    amplitude = str2double(amps.SelectedObject.String);
    phase     = deg2rad(str2double(phase.String));
    frequency = freq.Value;
    
    ax.Children.YData = amplitude*sin(2*pi*frequency*(t + phase));
end














