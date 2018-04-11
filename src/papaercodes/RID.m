%###########################################################################3
%This code compute the relative index distortion RID for two set of data
%A is the reference dataset and B is the dataset we want to compare its
%volume with reference dataset.the code has been writen according to papaer
%Acquiring a four-dimensional computed tomography dataset using an external respiratory
%signal
% RID =(|A ? B| ? |A ? B|)/|A ? B|.The distortion will be compute in axial
% and sagittal view
%###############################################################################3
%% raw reconstrcuted dataset


srcfiles = dir('E:\reconstrcution data\recondata\rawdata\1.2.3.1.11.3853.3\*.dcm');
numNames = length(srcfiles);
format long;
if (numNames <= 2)
    error('dcmDir does not contain any files');
end
for k=1:numNames;
    ResortedDataNew{k}=srcfiles(k).name;
end
[ResortedData,index] = sort_nat(ResortedDataNew);
for j = 1 :numNames
    filename=(("E:\reconstrcution data\recondata\rawdata\1.2.3.1.11.3853.3\"+char(ResortedData(j))));
    
    J = dicomread(char(filename));
    if j==1
        js = size(J);
        jstack=zeros(js(1),js(2),length(srcfiles));
    end
    jstack(:,:,j) = J(:,:,1,1);
    A(:,:,j)=jstack(:,:,j);
    
end
%% exhilation phase dataset

srcfiles = dir('E:\reconstrcution data\recondata\1269\1.2.3.2.11.3853\1.2.3.1.11.3853.3017\*.dcm');
numNames = length(srcfiles);
format long;
if (numNames <= 2)
    error('dcmDir does not contain any files');
end
for kk=1:numNames;
    ResortedDataNew{k}=srcfiles(kk).name;
end

[ResortedData,index] = sort_nat(ResortedDataNew);
for i = 1 : length(srcfiles)
    filename = strcat('E:\reconstrcution data\recondata\1269\1.2.3.2.11.3853\1.2.3.1.11.3853.3017\',srcfiles(i).name);
    I = dicomread(filename);
    if i==1
        Is = size(I);
        Istack=zeros(Is(1),Is(2),length(srcfiles));
    end
    Istack(:,:,i) = I(:,:,1,1);
    B(:,:,i)=Istack(:,:,i);
    
end
%#######################################################################################
%% Axial distortion 

Rida=zeros(480,480,numNames);
for i=1:numNames
    Rida=(abs(union(A(:,:,i),B(:,:,i)))-abs(intersect(A(:,:,i),B(:,:,i))))/(abs(union(A(:,:,i),B(:,:,i))));
    
end
 
Rids=zeros(480,480,numNames);
for i=1:numNames
    Rids=(abs(union(squeeze(A(:,i,:))',squeeze(B(:,i,:))'))-abs(intersect(squeeze(A(:,i,:))',squeeze(B(:,i,:))')))/(abs(union(squeeze(A(:,i,:))',squeeze(B(:,i,:))')));
    
end
 
    
    