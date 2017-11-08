%setting environment
%Add folders to the path
here = mfilename('fullpath');
[path, ~, ~] = fileparts(here);
addpath(genpath(path));

javaaddpath 'C:\Users\Aortega\Pictures\Fiji.app\plugins\jars\mij.jar'
javaaddpath 'C:\Users\Aortega\Pictures\Fiji.app\plugins\jars\ij.jar'
