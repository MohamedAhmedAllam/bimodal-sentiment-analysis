
%%%%% Bimodal Sentiment Analysis Using Textual and Visual Clues %%%%%
%%%%% Ahmed Medhat % Mohamed Ahmed Mohamed % Mohamed Ashraf Hassan % Ahmed Samir % Waleed Hamdy %%%%%

%Run this code only if do not have the "FrmRate.mat" file in your codes folder, place
%this code in the videos dataset folder and run it to calculate the proper frame rate of all
%the videos then take the FrmRate.mat output and place it in the codes folder

fnames = dir('*.mp4');
numfids = length(fnames);
FrmRate = zeros(numfids,1);
vals = cell(1,numfids);

for K = 1:numfids
  vals{K} = VideoReader(fnames(K).name);
  FrmRate(K) = vals{K}.FrameRate;
end
