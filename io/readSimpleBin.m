function [d, refT]=readSimpleBin(fName,sizeRow,sizeCol,sizeSlices,fmt,headerSize)

f=fopen(fName,'rb');
d = zeros([sizeRow,sizeCol,sizeSlices]);
aux = uint16([0 0]);
refT = zeros([sizeSlices,1]);
sizeSli = sizeRow*sizeCol;
 if(exist('headerSize','var'))
     fseek(f,headerSize,'bof');
 end
% 
% if(exist('fmt','var'))
%      for nSli = 1:sizeSlices,
%         %keyboard
%         %gapSize = cast(gapSize,'double')
%         %fseek(f,gapSize,'cof');
%         
%         % Retrieving timing data
%         
% %         aux(1,1) = fread(f,1,'uint16');
% %         aux(1,2) = fread(f,1,'uint16');
% %         refT(nSli) = typecast(aux, 'uint32');
%         %fseek(f,2,'cof');
%         % Reading frame data
%         ptr = ((nSli-1)*sizeSli)+1;
%         d(ptr:ptr+sizeSli-1)=fread(f,sizeSli,fmt);
%     end
%     %d=fread(f,sizeRow*sizeCol*sizeSlices,fmt);
% else
    d=fread(f,sizeRow*sizeCol*sizeSlices,fmt);

% end;

d=reshape(d,[sizeRow sizeCol sizeSlices]);
fclose(f);