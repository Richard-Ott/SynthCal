% This code illustrates the use of the synthetic posterior probability
% density (PDF) functions for calendar ages, in this case historic earthquakes. 
% It plots the individual PDFs for historic earthquakes on Crete together
% with a joint PDF as shown in Ott et al., 2020, Figure 2.
% See MANUSCRIPT DOI PLACEHOLDER
% Richard F. Ott, 2019
clc
clear
close all

% INPUT ----------------------------------------------------------------- %
data = xlsread('Historic_events.xlsx',2);
dR = 58;            % reservoir effect
dR_err = 85;        % uncert. reservoir effect
an_err = 30;        % analytical uncert.
% ----------------------------------------------------------------------- %

events = data(:,1);                % assign historic events in AD/BC
events = abs(events - 1950);       % convert to BP

% calculate joint and individual PDFs of event ages
[jointPDF,PDFs] = SynthCal(events, dR, dR_err, an_err,'Marine13', 'double');

% plot the data
figure()
for i = 1:length(events)
    plot(PDFs{i}(:,1),PDFs{i}(:,2),'Color',[.7,.7,.7])  % plot synthethic PDFs of earthquakes
    hold on
end
xh = PDFs{1}(:,1);
plot(xh,jointPDF,'k-') % plot joint PDF
xlim([1000,3000])
ylabel('probability')
xlabel('cal BP')