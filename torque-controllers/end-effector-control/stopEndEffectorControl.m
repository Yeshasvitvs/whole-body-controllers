% Create a folder for collecting data
if Config.SAVE_WORKSPACE

    if (~exist(['experiments',date],'dir'))

        mkdir(['experiments',date]);
    end
    
   matFileList = dir(['./experiments',date,'/*.mat']);  
   c            = clock; 
   
   save(['./experiments',date,'/exp_',num2str(c(4)),'-',num2str(c(5)),'.mat'])
end