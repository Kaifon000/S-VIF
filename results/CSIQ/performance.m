objectiveValues = textread('output_CSIQ.txt'); 
mos = textread('dmos_csiq.txt');
[SRCC,KRCC,PLCC,RMSE] = performance_analysis(mos,objectiveValues);
[KRCC_distortion,SRCC_distortion] = csiq_distortion(mos,objectiveValues);
metrics(1,1) = SRCC;
metrics(2,1) = KRCC;
metrics(3,1) = PLCC;
metrics(4,1) = RMSE;