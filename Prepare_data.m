
%%%%% Bimodal Sentiment Analysis Using Textual and Visual Clues %%%%%
%%%%% Ahmed Medhat % Mohamed Ahmed Mohamed % Mohamed Ashraf Hassan % Ahmed Samir % Waleed Hamdy %%%%%

%Preparedata.m loads all gavam and okao vision features from all videos,
%preprocess them and extract visual features to acquire the visual features matrix
%P.S you do not have to run this code if you already have the "VisualFtrVctr" ASCII file
clear all; clc;

%loading important files. Change the directory if you have the features' text files somewhere else
fileList_GVM = getAllFiles('data_package\features\VisualFeatures\GAVAM');   %load GAVAM file list
fileList_OKAO = getAllFiles('data_package\features\VisualFeatures\OKAO');   %load OKAO Vision file list
load('FrmRate.mat')                                                                                  %load the frame rate vector
Durations = xlsread('Durations&Annotations.xlsx','A2:C281');                        %load excel file contains utterances' time intervals and annotations


%important variables 
L = length(fileList_GVM);
[m,n] = size(Durations);
GVM_mean = zeros(m,6);              %gavam features matrix
OKAO_mean = zeros(m,8);            %okao features matrix
SmileGaze = zeros(m,3);               %smile and gaze features matrix
%%
for e = 1:L
for i = 1:e     %loop over number of videos
    
    GVM =  load(fileList_GVM{i});                    %load gavam file for video(i)
    GVM(:,2) = GVM(:,2)*30/FrmRate(i);         %correct the frame rate 
    
    OKAO = load(fileList_OKAO{i});                  %load okao file for video(i)
    
    Sgmnts = find(Durations(:,1)==i);              % find the index of utterances of video(i) in the excel sheet
    
    for j = 1:length(Sgmnts)    %loop over number of utterances per video(i)
        
        GVM_Data = GVM(find(GVM(:,2)>Durations(Sgmnts(j),2)*1000 & GVM(:,2)<=Durations(Sgmnts(j),3)*1000),:);      %find all the frames in GAVAM file which fall in the time interval of utterance(j) in video(i)
       
        GVM_mean(Sgmnts(j),:) = mean(GVM_Data(:,4:9));   %get the average of GAVAM selected features of all the frames in utterance(j) in video(i)
        
        OKAO_Data = OKAO((find(GVM(:,2)>Durations(Sgmnts(j),2)*1000 & GVM(:,2)<=Durations(Sgmnts(j),3)*1000))+3,:);  %find all the frames in OKAO file which fall in the time interval of utterance(j) in video(i)
        OKAO_Data = OKAO_Data(find(OKAO_Data(:,1) ~= 0 & OKAO_Data(:,3) ~= 0),:);       %neglect the frames with all data == 0 (failed frames)
        
        REyeMean =  MeanOkaoPts(OKAO_Data,0,1,2,3);                                                               %mean coordinates of right eye
        LEyeMean =  MeanOkaoPts(OKAO_Data,8,9,10,11);                                                             %mean coordinates of right eye
        EyesDiff = sqrt((REyeMean(:,1)-LEyeMean(:,1)).^2+(REyeMean(:,2)-LEyeMean(:,2)).^2);     %Distance between eyes 
        
        OKAO_feat = [Distance(OKAO_Data,0,1), ...       %inner and outer right eye distance
                             Distance(OKAO_Data,8,9), ...       %inner and outer left eye distance
                             Distance(OKAO_Data,2,3), ...       %upper and lower of right eye distance
                             Distance(OKAO_Data,10,11), ...    %upper and lower of left eye distance
                             Distance(OKAO_Data,18,21), ...    %upper and lower of mouth (outer) distance
                             Distance(OKAO_Data,19,20), ...    %upper and lower of mouth (inner) distance
                             Distance(OKAO_Data,16,17), ...    %left and right of mouth distance
                             EyesDiff];                                   %Distance between eyes 
                         
        OKAO_mean(Sgmnts(j),:) = mean(OKAO_feat);  %get the average of OKAO based features of all the frames in utterance(j) in video(i) 
        
        Smile_75 = sum(OKAO_Data(:,134)>=75)/size(OKAO_Data,1);                                  %percent of frames in utterance(j) in video(i) with smile intensity > 75
        Smile_50 = sum(OKAO_Data(:,134)>=50)/size(OKAO_Data,1);                                  %percent of frames in utterance(j) in video(i) with smile intensity > 50
        Gaze = sum(OKAO_Data(:,125)<=10 & OKAO_Data(:,126)<=10)/size(OKAO_Data,1); %percent of frames in utterance(j) in video(i) with speaker looking to camera
        
        SmileGaze(Sgmnts(j),:) = [Smile_75, Smile_50, Gaze];      % get the SmileGaze features for utterance(j) in video(i)
    end
end

%final visual features matrix (contains all features concatenated) column per feature
VisualFtrVctr = [GVM_mean, OKAO_mean, SmileGaze];        %every row represents an utterance. every column represents a feature.

% save the visual features matrix in ASCII format
fid = fopen('VisualFtrVctr','w');    
    for i=1:size(VisualFtrVctr,1)
        for j=1:size(VisualFtrVctr,2)
            fprintf(fid,' %2.8f', VisualFtrVctr(i,j));
        end
            fprintf(fid,'\n');
    end
    fclose(fid);
    
Testing_mean_elm;       %uncomment to run ELM classification on visual features
Testing_for_curve(e,:) = [e, AverageTestingAccuracy];
%Testing_mean_svm;       %uncomment to run SVM classification on visual features
end