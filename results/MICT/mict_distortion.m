function [KRCC,SRCC] = mict_distortion(mos,objectiveValues)

subjective = mos(1:84);
objective = objectiveValues(1:84);
KRCC(1,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(1,1) = corr(subjective, objective, 'type', 'spearman');

subjective = mos(85:168);
objective = objectiveValues(85:168);
KRCC(2,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(2,1) = corr(subjective, objective, 'type', 'spearman');
