function [newrawSeries_path] = newSeries(mod_num,beamdata_path,dst_path)
%newSeries define the reduced dataset as a new series 
%   Acquisition folder structure to be use in the standard imaging chain
%   Folder name convention-> 
%       #modification000 -> home path 
%       #modification001 -> raw data (sorted projections)
%       #modification002 -> beam data 
%       #modification003 -> empty folder for the reconstruction

%% creating the empty folders
% dst_path is our parent folder
homename = strcat(int2str(mod_num),'000');
rawname = strcat(int2str(mod_num),'001');
beamname = strcat(int2str(mod_num),'002');
reconname = strcat(int2str(mod_num),'003');
mkdir(dst_path,homename); %home folder for our series
home_path = strcat(dst_path,homename,'/');
mkdir(home_path,rawname); %raw data folder for our series
mkdir(home_path,beamname); %beam folder for our series
mkdir(home_path,reconname); %recon folder for our series
%% Coping beam files
beamsrcfiles = dir(strcat(beamdata_path,'*.dcm'));
beamdstpath = strcat(home_path,beamname,'/');
    for j = 1 : length(beamsrcfiles)
        filename = strcat(beamsrcfiles(j).name);
        % modify dicom tags
        % stored them in beamdstpath
    end
newrawSeries_path = strcat(home_path,rawname,'/');
end

