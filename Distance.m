
%%%%% Bimodal Sentiment Analysis Using Textual and Visual Clues %%%%%
%%%%% Ahmed Medhat % Mohamed Ahmed Mohamed % Mohamed Ashraf Hassan % Ahmed Samir % Waleed Hamdy %%%%%

% takes numbers of two okao points and calculates the distance between
% them. (points numbering can be found in OkAO_info pdf)
function[Dist] = Distance(OKAO_Data,Pt1,Pt2)

    Pts = [Pt1;Pt2];
    P = zeros(size(OKAO_Data,1),2,2);
    for i = 1:2
        P(:,1,i) = OKAO_Data(:,3*Pts(i)+7); % X coordinates
        P(:,2,i) = OKAO_Data(:,3*Pts(i)+8); % Y coordinates
    end
    
    Dist = sqrt( (P(:,1,1)-P(:,1,2)).^2 + (P(:,2,1)-P(:,2,2)).^2);