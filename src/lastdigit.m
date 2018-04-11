
%%##############################################################################
%%this code id for computing the distance betweeen the projections that
%beloong to each phase .
% Note: in Mars rawdata , the ordrer of projections are a factor of two so for finding the 
%maximum distane it is important to deveide the max distacne to 2.
%%###################################################################################

srcfiles = dir('C:\UOC\ana worktogetermatlab\phase\rara_10-11\src\8 phase\2phasepi\1exhale\*.dcm');
numNames = length(srcfiles);
format long;
if (numNames <= 2)
    error('dcmDir does not contain any files');
end
for k=1:numNames;
    ResortedDataNew{k}=srcfiles(k).name;
end
[ResortedData,index] = sort_nat(ResortedDataNew);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileNo=zeros(numNames,1);
%%%%%%%%%%%%%%Write a loop
for i=1:numNames
    fileName=ResortedData{1,i};
    M=strrep(fileName, '.', ' ');
    N=textscan(M,'%f');
    v=cell2mat(N);
    fileNo(i,1)=v(7);
end
%%%%%%%%%%%%%%%%%%%%%%%%%% finding the max distance between projection
%%%%%%%%%%%%%%%%%%%%%%%%%% numbers

maxdiff=diff(fileNo); % a matrix with distacne between projection numbers value
[I,J]=max(maxdiff)/2; % I/2 maximum distance between projection number
meanp=mean(maxdiff);



