objectiveValues = textread('output_IVC.txt'); 
mos = textread('mos_ivc.txt');
[SRCC,KRCC,PLCC,RMSE] = performance_analysis(mos,objectiveValues);
[KRCC_distortion,SRCC_distortion] = ivc_distortion(mos,objectiveValues);
metrics(1,1) = SRCC;
metrics(2,1) = KRCC;
metrics(3,1) = PLCC;
metrics(4,1) = RMSE;