function [ varargout ] = R_simulate( date, datetype, curve )
% Takes a calendar date and a 14C calibration curve and computes the mean 
% radiocarbon age (and standard deviation) expected for this date. 
% Input: date, datetype (BP, AD or BC), calibration curve (Marine13,
% IntCal13...)
% Output: [radiocarbon age, standard deviation (optional)
% Richard Ott, 2018

if strcmp(datetype,'AD')           % convert to BP
    date = abs(date - 1950); 
elseif strcmp(datetype,'BC')
    date = date +1950;
end

% load calibration curve
headerlines = 11;
File = fopen([curve,'.14c']);
Contents = textscan(File,'%f %f %f %f %f','headerlines',headerlines,'delimiter',',');
fclose(File);

% assign data
curvecal = flipud(Contents{1});
curve14c = flipud(Contents{2});
curve14cerr = flipud(Contents{3});

% get mean 14C age of that date
R_sim  = interp1(curvecal,curve14c,date);

% get 1 sigma std
R_sim_err = interp1(curvecal,curve14cerr,date);


switch(nargout)
    case 1
        varargout = {R_sim};
    case 2
        varargout = {R_sim, R_sim_err};
end
end

