%setting environment
%Add folders to the path
here = mfilename('fullpath');
[path, ~, ~] = fileparts(here);
addpath(genpath(path));