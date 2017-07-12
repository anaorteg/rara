%houskeeping
clear
close all
clc

%Initialize DIP
dip_initialise();

%Add folders to the path
here = mfilename('fullpath');
[path, ~, ~] = fileparts(here);
addpath(genpath(path));

%% *********************** ACQ Parameters *********************************
% Data paths and files
acqPath = 'C:\Users\Student\Documents\NM\Data\954\20170609T082519\'; %KEEP THE "\"
binning= 4; %Binning of acquisition
nos = 514; %number of steps
n_angles_step = 8; %number of projections per step
n_phases_desired=1;
fmt = 'uint16';

%% ********************** Central body **********************************
%splitter(patient,acqPath , width,height,n_angles_step,nos,fmt);
nof = nos*n_angles_step; % number of files
width =  3072/binning; % 768
height = 1944/binning; % 486
% With '\' at the end
% floodFileName = '\\PC-178-154\Users\Public\Documents\NM\flat_field\';
%procPath = [acqPath 'subvolume00\'];
% procPath = preproc_multiflood_ctf (acqPath,floodFileName, binning, nof,n_angles_step,fmt);
procPath = [acqPath 'preproc\'];

%get p1
% [data_table, path_dest, brate] = respSignal(procPath,width,height,nos,n_angles_step,fmt);
% 
% %get c1
% [data_table, path_dest, hrate] = cardSignal(path_dest,width,height,nos,n_angles_step,fmt,data_table, procPath);

[ resp_data_table, card_data_table, brate, hrate, card_path_dest ] = respCardSignal( procPath,width,height,nos,n_angles_step,fmt );


%% To make Nikhil's life easier/make all three calibration folders
%get Calib_c1
avgStep(card_data_table, binning, nos, n_angles_step, width, height, procPath, card_path_dest, fmt);
folder = cd(procPath);
movefile('Calib', 'Calib_c1');
cd(folder);

%get Calib_p1
path_dest = [procPath 'p1\subvolume00\'];
avgStep(resp_data_table, binning, nos, n_angles_step, width, height, procPath, path_dest, fmt);
cd(procPath); %CHANGE THIS
movefile('Calib', 'Calib_p1');
cd(folder);

%get Calib_unedited
path_dest=procPath;
data_table = resp_data_table;
data_table(3,:) = 1; 
avgStep(data_table, binning, nos, n_angles_step, width, height, procPath, path_dest, fmt);
cd(procPath); %CHANGE THIS
movefile('Calib', 'Calib_unedited');
cd(folder);

%display breathing and heart rates
fprintf('The average breathing rate is %.2f breaths per minute.\n The average heart rate is %.2f beats per minute.\n',brate,hrate)

