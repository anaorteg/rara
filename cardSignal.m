function [ data_table, path_dest, avg ] = cardSignal(acqPath,  path_dest, resp_data_table, data_table, means,nof)
% Cardiac signal extracted from the intensities variations from
% a Region of Interest
% Sorts out any "beating" images out from a set of ct scans so that the
% reconstruction shows a still heart

%Author: NMurty AOrtega (UC3M)
%Date: 25/05/2017

id_v = data_table(1,:);

%% Plot the array
    figure;
    plot(id_v, means);
    hline = refline([0 60]);
    hline.Color = 'r';

    
%% Find heart rate of mouse
    beat = zeros(1,nof);
    var = zeros(1,nof);
    count = 0;
    %find number of frames per beats
    for n = 1:nof 
        if resp_data_table(3, n) == 1
            if means(n) > 2 && means(n) < 60
                %for normal peaks
                if n>1 && n < nof
                    if means(n+1)< means(n)&& means(n) > means(n-1) && means(n+1) > -10 
                       beat(n)= count;
                       count = 0;
                       copyfile ([acqPath num2str(n-1) '.ct'],path_dest);
                       fprintf('Saving frozen file %i\n',n)
                       data_table(3,n) = 1;
                    end
                end
                
                %for peak at n = 1
                if n==1 && means(n+1)< means(n)
                   beat(n) = 0;
                   data_table(3,n) = 1;
                   copyfile ([acqPath num2str(n-1) '.ct'],path_dest);
                   fprintf('Saving frozen file %i\n',n)
                end
                
                %for peak at n=nof
                if n==nof && means(n) > means(n-1)
                   beat(n) = count;
                   data_table(3,n) = 1;
                   copyfile ([acqPath num2str(n-1) '.ct'],path_dest);
                   fprintf('Saving frozen file %i\n',n)                   
                end
            elseif means(n) >= 20 || means(n) < -20 || means(n)== 0
                count = count +0;
                data_table(3,n) = 0;
            else
                count = count +1;
                data_table(3,n) = 0;
            end
        end %if for resp_data_table
        
    end %for frames of beat
    
    %add time for changing angle
    counts = 0;
    avg = 0;
    for num = 1:nof     
        if beat(num) > 0
           if num > 7
              var(num) = beat(num) - mod(num,8); %used to find the number of times the angle has changed
              var(num)= fix(var(num)/8);
           end
           counts = counts +1;
        end
        beat(num) = (beat(num)*0.05) + var(num);
        avg = avg + beat(num);
    end %for rate
    
 %% Find average heart rate
    avg = avg/counts;
    avg = 60/avg;
%     fprintf('The average heart rate is %.2f beats per minute. Number of beats is %f \n',avg, counts) 
    save([acqPath 'c1\data_table.mat'],'data_table')
    
        

end %function
