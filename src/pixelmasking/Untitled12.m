profile on
srcfiles = dir('E:\18Sep2017_Live Mouse2\1.2.3.2.11.3853\1.2.3.1.11.3853.2\*.dcm');
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
        filename=(("E:\18Sep2017_Live Mouse2\1.2.3.2.11.3853\1.2.3.1.11.3853.2\"+char(ResortedData(j))));
    end      
    J = dicomread(char(filename));
    if j==1
        js = size(J);
        jstack=zeros(js(1),js(2),length(srcfiles));
    end
    jstack(:,:,j) = J(:,:,1,1);
    