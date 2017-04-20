Durations = xlsread('durations.xlsx','A2:C281');
FrmRate = [15,24,29,29,30,29,29,14,13,29,25,14, ...
                  29,14,14,29,29,14,29,30,29,30,14,29, ...
                  29,29,13,29,29,29,9,30,11,29,29,23, ...
                  29,29,30,30,14,29,29,29,29,30,25,29]';

OkoaFiles = getAllFiles('C:\EXTRAS\fall2016\Sentimental analysis\codes\OKOA');

[m,n] = size(Durations);
for i = 1:48
    OkoaFeats = dlmread(strjoin(OkoaFiles(i)));
    NumFrames = []';
    for j = 1:m
        SmileyFrames = 0;
        if Durations(j,1) == i
            NumFrames(j) = (Durations(j,3)-Durations(j,2))/FrmRate(i);
        
            if j == 1
                for k = 1: NumFrames(j)-1
                    if OkoaFeats(1,134)>=75
                        smileyFrames = smileyFrames + 1;
                    end
                end    
                
            
            else
                for k = sum(NumFrames(1:j-1)):sum(NumFrames(1:j-1))+ NumFrames(j)
%                     if OkoaFeats(k,134)> 75
%                         smileyFrames = smileyFrames + 1;
%                     end
                    
                end  
             end
                
         end
         SmileFeat= SmileyFrames/NumFrames(j);
    end
end
            
            