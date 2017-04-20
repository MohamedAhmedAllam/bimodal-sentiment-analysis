
%%%%% Bimodal Sentiment Analysis Using Textual and Visual Clues %%%%%
%%%%% Ahmed Medhat % Mohamed Ahmed Mohamed % Mohamed Ashraf Hassan % Ahmed Samir % Waleed Hamdy %%%%%


% takes numbers of N okao points and calculates the average point between
% them. (points numbering can be found in OkAO_info pdf)

function [Mean_pts] = MeanOkaoPts(OKAO_Data, varargin)
    Pts = [];
    for i = 1:nargin-1
        Pts = [Pts; varargin{i}];
    end
    
    P = zeros(size(OKAO_Data,1),2,nargin-1);
    for i = 1:nargin-1
        P(:,1,i) = OKAO_Data(:,3*Pts(i)+7); % X coordinates
        P(:,2,i) = OKAO_Data(:,3*Pts(i)+8); % Y coordinates
    end
    
    Mean_pts = zeros(size(OKAO_Data,1),2);    
    for i = 1:nargin-1
        Mean_pts(:,1) = Mean_pts(:,1) + P(:,1,i);
        Mean_pts(:,2) = Mean_pts(:,2) + P(:,2,i);
    end
    Mean_pts = Mean_pts/(nargin-1);