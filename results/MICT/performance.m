objectiveValues = textread('output_MICT.txt'); 
mos = textread('mos_mict.txt');
[SRCC,KRCC,PLCC,RMSE] = performance_analysis(mos,objectiveValues);
[KRCC_distortion,SRCC_distortion] = mict_distortion(mos,objectiveValues);
metrics(1,1) = SRCC;
metrics(2,1) = KRCC;
metrics(3,1) = PLCC;
metrics(4,1) = RMSE;