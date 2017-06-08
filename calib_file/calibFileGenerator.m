function [ res ] = calibFileGenerator(outputPath, angles, binning)
   
 masterCalibrationPath='detailedCalibration_high_b1_JUN16.txt';
    nProy=720;

% updateLog(['[calibFileGenerator] Master calibration file: ' masterCalibrationPath]);
 % updateLog(['[calibFileGenerator] Output calibration file: ' outputCalibrationPath]);


outputCalibrationPath=[outputPath 'detailedCalibration.txt'];



proyAngle=zeros(nProy,1);
DSO=zeros(nProy,1);
DDO=zeros(nProy,1);
offsetX=zeros(nProy,1);
offsetY=zeros(nProy,1);
etaCalc=zeros(nProy,1);
thetaCalc=zeros(nProy,1);

acqAngle=angles;



%% Load Calibration File

    fileID = fopen(masterCalibrationPath,'r');
    if fileID ~=-1
        fgetl(fileID);
%         fgetl(fileID);  %Para cuando hay hueco
        
        for i=1:nProy
            buff=   fgets(fileID);
            buff= sscanf(buff,'%f\t%f\t%f\t%f\t%f\t%f\t%f');
                        
            proyAngle(i)=buff(1);
            DSO(i)=buff(2);
            DDO(i)=buff(3);
            offsetX(i)=buff(4);
            offsetY(i)=buff(5);
            etaCalc(i)=buff(6);
            thetaCalc(i)=buff(7);
            
%             fgetl(fileID);    %Para cuando hay hueco
        end
        
        fclose(fileID);
        res=0;
    else
        disp(['Unable to open file: ' masterCalibrationPath])
    end


%% Generate calibration  file
      acqDSO=interp1(proyAngle,DSO,acqAngle);      
      acqDDO=interp1(proyAngle,DDO,acqAngle);
%          acqDSO=mean(DSO).*ones(nProyAcq,1);
%        acqDDO=mean(DDO).*ones(nProyAcq,1);
     acqoffsetX=(interp1(proyAngle,offsetX,acqAngle)./binning);
%     acqoffsetX=mean(offsetX./binning).*ones(nProyAcq,1);
        acqoffsetY=interp1(proyAngle,offsetY,acqAngle)./binning;
%          acqoffsetY=mean(offsetY./binning).*ones(nProyAcq,1);
 acqetaCalc=interp1(proyAngle,etaCalc,acqAngle);
% acqetaCalc=mean(interp1(proyAngle,etaCalc,acqAngle,'spline')./binning).*ones(nProyAcq,1);
acqthetaCalc=interp1(proyAngle,thetaCalc,acqAngle);
    
%% Write output calibrationfile    
    
resultsOutputFileGen(acqAngle, acqoffsetX, acqoffsetY, acqetaCalc,  acqDSO, acqDDO,acqthetaCalc, outputCalibrationPath)

