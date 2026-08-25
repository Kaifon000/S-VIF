function [KRCC,SRCC] = ivc_distortion(mos,objectiveValues)

subjective = mos(1:20);
objective = objectiveValues(1:20);
KRCC(1,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(1,1) = corr(subjective, objective, 'type', 'spearman');

subjective = mos(21:70);
objective = objectiveValues(21:70);
KRCC(2,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(2,1) = corr(subjective, objective, 'type', 'spearman');
    
subjective = mos(71:95);
objective = objectiveValues(71:95);
KRCC(3,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(3,1) = corr(subjective, objective, 'type', 'spearman');
    
subjective = mos(96:145);
objective = objectiveValues(96:145);
KRCC(4,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(4,1) = corr(subjective, objective, 'type', 'spearman');
    
subjective = mos(146:185);
objective = objectiveValues(146:185);
KRCC(5,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(5,1) = corr(subjective, objective, 'type', 'spearman');
