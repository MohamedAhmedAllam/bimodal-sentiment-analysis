
%%%%% Bimodal Sentiment Analysis Using Textual and Visual Clues %%%%%
%%%%% Ahmed Medhat % Mohamed Ahmed Mohamed % Mohamed Ashraf Hassan % Ahmed Samir % Waleed Hamdy %%%%%

% Input: Visual feature matrix
%output: yu_train.ASCII: ASCII file contains matrix of random training set 
           %yu_test.ASCII:ASCII file contains matrix of random test set 
           
function [] = Prepare_data_2(VisualFtrVctr)

%load features and supervised output vector into dataset matrix
    dataset = zeros(size(VisualFtrVctr,1), size(VisualFtrVctr,2)+1);
    dataset(:,end) = xlsread('Durations&Annotations.xlsx','D2:D281');
    dataset(:,1:end-1) = VisualFtrVctr;
    
    %Randomization
    rand_sequence=randperm(size(dataset,1));
    temp_dataset=dataset;
    
    dataset=temp_dataset(rand_sequence, :);

    %Normalization
    for i=1:size(dataset,2)-1
        dataset(:,i)=(dataset(:,i)-min(dataset(:,i)))/(max(dataset(:,i))-min(dataset(:,i)))*2;
    end             
    
    Prcnt = 0.8;     %Training to test set ratio
    P1 = dataset(1:floor(Prcnt*size(dataset,1)),1:size(dataset,2)-1);
    T1=dataset(1:floor(Prcnt*size(dataset,1)),size(dataset,2));
    
    %Obtain Random Validation Matrix
    X=dataset(floor(Prcnt*size(dataset,1))+1:size(dataset,1),1:size(dataset,2)-1);
    Y=dataset(floor(Prcnt*size(dataset,1))+1:size(dataset,1),size(dataset,2));
    
    %save training set to yu_train
    fid = fopen('yu_train','w');
    for i=1:size(P1,1)
        fprintf(fid,'%2.8f ',T1(i,1));
        for j=1:size(P1,2)
            fprintf(fid,' %2.8f', P1(i,j));    %   for ELM
        end
            fprintf(fid,'\n');
        end
    fclose(fid);

    %save test set to yu_test
    fid = fopen('yu_test','w');    
    for i=1:size(X,1)
        fprintf(fid,'%2.8f ',Y(i,1));
        for j=1:size(X,2)
            fprintf(fid,' %2.8f', X(i,j));     %   for ELM
        end
            fprintf(fid,'\n');
        end
    fclose(fid);