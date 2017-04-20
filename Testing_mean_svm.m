
%%%%% Bimodal Sentiment Analysis Using Textual and Visual Clues %%%%%
%%%%% Ahmed Medhat % Mohamed Ahmed Mohamed % Mohamed Ashraf Hassan % Ahmed Samir % Waleed Hamdy %%%%%

% This piece of code performs ELM classification on the dataset 10 times with different randomization
%NOTE: you have to setup libsvm on matlab for this code to function properly

%variables
number_of_trial=10;
test_test=zeros(number_of_trial,1);
train_train=zeros(number_of_trial,1);

wb=waitbar(0,'Please waiting...');

rnd=0;
waitbar(rnd/number_of_trial,wb);

%load visual and text matrices into one final features matrix
VisualFtrVctr = load('VisualFtrVctr');
FinalFtrVctr = VisualFtrVctr;

% uncomment the following lines if you want to include the textual features
%TextFtrVctr = load('features.csv');     
%FinalFtrVctr = [VisualFtrVctr, TextFtrVctr];

for rnd = 1 : number_of_trial
    
    disp('Randomly generating training and testing dataset ... ...');
    Prepare_data_2(FinalFtrVctr);       %prepares training and dataset with randomization
    
    disp('Start training ... ...');
    
    yu_train = load('yu_train');
    yu_test = load('yu_test');
    model = svmtrain(yu_train(:,1), yu_train(:,2:end), '-c 2000');    %Training the model of SVM classifier
    [predicted_label_test, accuracy_test, decision_values_test] = svmpredict(yu_test(:,1), yu_test(:,2:end), model);        %predict the test set using the trained model
    [predicted_label_train, accuracy_train, decision_values_train] = svmpredict(yu_train(:,1), yu_train(:,2:end), model);  %predict the training set using the trained model

    test_test(rnd,1)=accuracy_test(1);
    train_train(rnd,1)=accuracy_train(1);

    waitbar(rnd/number_of_trial,wb);
    
end
close(wb);

%Calculate Average accuracy and standard deviation of both training and test sets .
AverageTrainingAccuracy=mean(train_train)/100
StandardDeviationofTrainingAccuracy=std(train_train)/100
AverageTestingAccuracy=mean(test_test)/100
StandardDeviationofTestingAccuracy=std(test_test)/100