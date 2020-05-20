function [jointPDF,PDFs] = SynthCal(cal_ages, dR, dR_err, an_err, curve,  type)
% Compute synthetic posterior probability density functions of a given
% calendar age. 
% Input:    cal_ages - calendar ages in BP
%           dR       - reservoir effect
%           dR_err   - uncertainty on reservoir effect
%           an_err   - analytical uncertainty of AMS
%           curve    - calibration curve (Marine13, IntCal13...)
%           type     - 'single' or 'double' for single or double
%           consideration of calibration curve uncertainty. 'Double' refers
%           to the effect that you add uncertainties from the calibration
%           curve twice; the first time when you convert a calendar age to
%           a radiocarbon PDF, the second time you convert that PDF back to
%           a calibrated time. The 'single' option will only use the
%           mean of the calibration curve in the first conversion from
%           calendar age to radiocarbon years. Using 'double' will slightly
%           increase your uncertainties and widen your posterior density
%           function.         
% Richard Ott, 2019

[R_sim,R_sim_err] = R_simulate(cal_ages,'BP',curve); % calc simulated 14C age
PDFs = cell(1,length(cal_ages));
jointPDF= zeros(50001,1);      

if strcmpi(type,'single')
    tot_err = an_err*ones(length(cal_ages));
elseif strcmpi(type,'double')
    tot_err = sqrt(an_err^2 + R_sim_err.^2);
else
    disp("Type argument must be either 'single' or 'double'....")
end

% calculate posteriors
for i = 1:length(cal_ages)
    [~,~, PDFs{i}, ~] = matcal(R_sim(i), tot_err(i), curve , 'CalBP'...
        ,'resage',-dR,'reserr', dR_err,'plot',0);  % negative reservoir effect because you need to shift the C14 age the other way for synthetic ages
    jointPDF = jointPDF + PDFs{i}(:,2);            % assemble joint PDF from individual ones
end

end