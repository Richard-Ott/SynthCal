function [TotalPDF,PDFs] = HistCal(cal_ages, dR, dR_err, an_err, type)
% Compute historic posterior probability density functions of historic
% earthquakes. This does neglect uncertainties during the first conversion
% from calendar to radiocarbon years.
% Input:    cal_ages - calendar ages in BP!!!!
%           dR       - reservoir effect
%           dR_err   - uncertainty on reservoir effect
%           an_err   - analytical uncertainty of AMS
%           type     - 'single' or 'double' for single or double
%           consideration of calibration curve uncertainty

% Richard Ott, 2018

[R_sim,R_sim_err] = R_simulate(cal_ages,'BP','Marine13'); % calc simulated 14C age
PDFs = cell(1,length(cal_ages));
TotalPDF= zeros(50001,1);      

if strcmpi(type,'single')
    tot_err = an_err*ones(length(cal_ages));
elseif strcmpi(type,'double')
    tot_err = sqrt(an_err^2 + R_sim_err.^2);
else
    disp('Come on. Type argument must be either single or double....')
end

% calculate posteriors
for i = 1:length(cal_ages)
    [~,~, PDFs{i}, ~] = matcal(R_sim(i), tot_err(i), 'Marine13', 'CalBP'...
        ,'resage',-dR,'reserr', dR_err);  % negative reservoir effect because you need to shift the C14 age the other way for synthetic ages
    TotalPDF = TotalPDF + PDFs{i}(:,2);
end

end