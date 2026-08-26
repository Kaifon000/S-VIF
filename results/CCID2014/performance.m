objectiveValues = textread('output_CCID2014.txt'); 
mos = textread('mos_ccid2014.txt');
[SRCC,KRCC,PLCC,RMSE] = performance_analysis(mos,objectiveValues);
metrics(1,1) = SRCC;
metrics(2,1) = KRCC;
metrics(3,1) = PLCC;
metrics(4,1) = RMSE;