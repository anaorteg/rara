function [ res ] = resultsOutputFileGen(angles, Uoffset, Voffset, eta_degrees,  SOD, DDO, theta, fileName)
% resultsOutputFile( Uoffset, Voffset, eta_degrees,  SOD, DO, theta, fileName)
%
% Function to write calibration file
%
% Input:
%         Uoffset: Uoffset data vector
%         Voffset: Voffset data vector
%         eta_degrees: yaw angle data vector
%         SOD: Source to object data vector
%         DDO: Detector to object data vector
%         theta:
%         fileName:
%
% Output:
%         res: 0 if OK, -1 if something wrong
%
% LIM - BiiG - UC3M
% Author: AMV
% Version 0 - Sept 2014

nProy=length(Uoffset);
% proyAngle=0:360/nProy:(360-360/nProy);


fileID = fopen(fileName,'wt');
if fileID ~=-1
    fprintf(fileID,'Proj\tDSO\tDDO\tUOffset\tVOffset\tPivot\tdTeta\n');
    
    for i=1:nProy
        
            fprintf(fileID,'%.5f\t%.5f\t%.5f\t%.5f\t%.5f\t%.5f\t%.5f\n',angles(i),SOD(i),DDO(i),Uoffset(i),Voffset(i),eta_degrees(i),theta(i));
%         fprintf(fileID,'%f\t%f\t%f\t%f\t%f\t%f\t%f\n',angles(i),SOD(i),DDO(i),Uoffset(i),Voffset(i),eta_degrees(i),theta(i));
%    fprintf(fileID,'%.15f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\n',angles(i),SOD(i),DDO(i),Uoffset(i),Voffset(i),eta_degrees(i),theta(i));
    end
    
    fclose(fileID);
    res=0;
else
    res=-1;
end
end