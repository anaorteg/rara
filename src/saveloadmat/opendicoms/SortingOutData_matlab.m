function []
dcmNames = dir(dcmDir);
numNames = length(dcmNames);
format long;
if (numNames <= 2)
	error('dcmDir does not contain any files');
end
for k=1:numNames;    
    ResortedDataNew{k}=dcmNames(k).name;    
end
[ResortedData,index] = sort_nat(ResortedDataNew);   %%% sort_nat=sorting natural names of files
		tmpImg = dicomread(char(ResortedData(i)));

