objectiveValues = textread('output_LIVE.txt'); 
mos = textread('dmos_live.txt');
[SRCC,KRCC,PLCC,RMSE] = performance_analysis(mos,objectiveValues);
[KRCC_distortion,SRCC_distortion] = live_distortion(mos,objectiveValues);
metrics(1,1) = SRCC;
metrics(2,1) = KRCC;
metrics(3,1) = PLCC;
metrics(4,1) = RMSE;