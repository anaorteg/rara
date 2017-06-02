%houskeeping
clear
close all
clc

%Add folders to the path
here = mfilename('fullpath');
[path, ~, ~] = fileparts(here);
addpath(genpath(path));

%% *********************** ACQ Parameters *********************************
% Data paths and files
acqPath = 'D:\GSK_IMAGES\73\1453808242879\';
binning= 4; %Binning of acquisition
nos = 514; %number of steps
n_angles_step = 8; %number of projections per step
n_phases_desired=1;
fmt = 'uint16';

% Data paths and files
%floodFileName=['D:\GSK_IMAGES\fl_quick_b2\subvolume00\'];
floodFileName='D:\GSK_IMAGES\floodDb\presets\fl_quick\subvolume00\';

%% ********************** Central body **********************************
%splitter(patient,acqPath , width,height,n_angles_step,nos,fmt);
nof = nos*n_angles_step; % number of files
width =  3072/binning;
height = 1944/binning;
%procPath = preproc_multiflood_ctf (acqPath,floodFileName, binning, nof,n_angles_step,fmt)
%procPath = preproc_singleflood_ctf( acqPath,floodFileName, width, height, nof,fmt);
% With '\' at the end
sortPath = [acqPath 'raw\'];
procPath = [acqPath 'preproc\'];
outputPath = CChav_gating_it1(procPath,width,height,nos,n_angles_step,fmt);
outputPath = CChav_gating_avgStep(procPath,nos,n_angles_step,binning,fmt);
%outputPath = procPath;

