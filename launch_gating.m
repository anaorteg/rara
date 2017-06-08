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
acqPath = 'D:\nmurty\data\9\1445270389791\'; %KEEP THE "\"
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
procPath = [acqPath 'preproc\'];
%[data_table, path_dest] = respSignal(procPath,width,height,nos,n_angles_step,fmt);
  path_dest = [procPath 'p1\subvolume00\'];
  load([procPath 'p1\data_table.mat'], 'data_table')
outputPath = cardSignal(path_dest,width,height,nos,n_angles_step,fmt,data_table, procPath);
%outputPath = cardSignal(path_dest,width,height,nos,n_angles_step,fmt,data_table);
avgStep(data_table, binning, nos, n_angles_step, width, height, procPath, path_dest, fmt);

