

i1=1:880;
i2=881:1386;
i3=1387:2010;
i4=2011:2486;
for i=i1:i4
    for j=1:4
    [bpks(j),blocs(j)]= findpeaks(inresp_sig3c(i));

M(j)=mean(bpks(j));
std(j)=std(bpks(j));
ldis(j)=M(j)-std(j);
udis(j)=M(j)+std(j);
s=size(bpks(j));
Bplocs(j)=zeros(s);
Bpjs(j)=zeros(s);
% 
% for k=1:s(1)
%     if bpks(j)(k,1)>= ldis(j) && bpks(j)(k,1)<= udis(j) %finding peaks with having limitation with std
%         Bplocs((j))(k)=blocs((j))(k);
%         Bpks(j)((k))=bpks(j)((k));
%         
%     end

    end
end