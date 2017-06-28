function [data_table , avg] = respSignal(acqPath,path_dest, data_table, means,nof)
% Respiratory signal extracted from the intensities variations from
% a Region of Interest
% Sorts out any "breathing" images out from a set of ct scans so that the
% reconstruction shows a still diaphram

%Author: NMurty AOrtega (UC3M)
%Date: 25/05/2017

id_v = data_table(1,:);


    
%Plot the array
figure;
plot(id_v, means);
hline = refline([0 150]);
hline.Color = 'r';
    
%% Process    
    %Find breathing rate of mouse
    breath = zeros(1,nof);
    var = zeros(1,nof);
    count = 0;
    %find number of frames per breath
    for n = 1:nof
            if n>1 && n < nof 
                if means(n) > 170 + means(n-1)
                    if means(n+1)< means(n)&& means(n) > means(n-1) && means(n+1) > -50
                       breath(n)= count;
                       count = 0;
                        data_table(3,n) = 2;
                    end
                end
             
            
            %for peak at n = 1
            elseif n==1 && means(n+1)< means(n) && means(n+1) > 0
               breath(n) = 0;
                data_table(3,n) = 2;
            

            %for peak at n=nof
            elseif n==nof && means(n) > means(n-1)
               breath(n) = count;
                data_table(3,n) = 2;
            end
            
            %save files that dont have breathing
            if n>1 && n<nof && means(n) < 150
                    if abs(means(n)-means(n-1))<100 && means(n) - means(n+1)>-100
                        data_table(3,n) = 1 ;
                        copyfile ([acqPath num2str(n-1) '.ct'],path_dest);
                        fprintf('Saving heartbeat file %i\n',n)
                    end
                
            else
               data_table(3,n) = 0 ; 
            end
        
        count = count +1;
    end %for frames of breath
    
    %add time for changing angle
    counts = 0;
    avg = 0;
    for num = 1:nof     
        if breath(num) > 0
           if num > 7
              var(num) = breath(num) - mod(num,8); %used to find the number of times the angle has changed
              var(num)= fix(var(num)/8);
           end
           counts = counts +1;
        end
        breath(num) = (breath(num)*0.05) + var(num);
        avg = avg + breath(num);
    end %for rate
    
%% Find average breathing rate
    avg = avg/counts;
    avg = 60/avg;
%     fprintf('The average breathing rate is %.2f breaths per minute. Number of breaths taken is %d.\n',avg, counts) 
    
save([acqPath 'p1\data_table.mat'],'data_table')
        

end %function
