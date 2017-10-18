function [stack]=mat2stack( filename,variablename)
%MAT2STACK 
%   load variable 'variablename' located in filename containing the read&modified dicoms into a
%   matrix
%  ip String, String
%   o data format of the variable
F_s = load(filename);
stack =F_s.(variablename);
end