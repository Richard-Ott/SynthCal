% Compute historic posterior probability density functions of historic
% earthquakes. This does neglect uncertainties during the first conversion
% from calendar to radiocarbon years.
% Richard Ott, 2018
clc
clear
close all

addpath('C:\Richard\PhD_ETH\data\geochronology\radiocarbon')

% INPUT ----------------------------------------------------------------- %
data = xlsread('Historic_events.xlsx',2);
dR = 58;            % reservoir effect
dR_err = 85;        % uncert. reservoir effect
an_err = 30;        % analytical uncert.
% ----------------------------------------------------------------------- %

events = data(:,1);                % assign historic events in AD/BC
events = abs(events - 1950);       % convert to BP
events = events(1:8);

[R_sim, R_sim_err] = R_simulate(events,'BP','Marine13'); % calc simulated 14C age

% calculate posteriors
calprob = cell(1,length(events));
p95_4 = nan(3,length(events)); p68_2 = nan(3,length(events)); med_age = nan(1,length(events));
totalprob = zeros(50001,1);
for i = 1:length(events)
    [~,~, calprob{i}, med_age(i)] = matcal(R_sim(i), an_err, 'Marine13', 'CalBP'...
        ,'resage',-dR,'reserr', dR_err);
    
    % plot
    figure(2)
    plot(calprob{i}(:,1),calprob{i}(:,2),'r-')
    hold on
    totalprob = totalprob + calprob{i}(:,2);
end

xh = calprob{1}(:,1);
plot(xh,totalprob,'k-')
xlim([1000,3000])
ylabel('probability')
xlabel('cal BP')

save('HistCalCurve.mat','totalprob','xh','calprob');