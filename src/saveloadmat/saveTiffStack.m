function [outputArg1,outputArg2] = saveTiffStack(filename,imgstack)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% filename Specify the output file name

imgstack=im2uint16(imgstack); %default chosen format uint16
i_s = size(imgstack); 
nImages = i_s(3);
for idx = 1:nImages
    if idx == 1
        imwrite(imgstack(:,:,idx),filename);
    else
        imwrite(imgstack(:,:,idx),filename,'WriteMode','append');
    end
end
end

