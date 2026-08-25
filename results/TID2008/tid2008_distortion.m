function [KRCC,SRCC] = tid2008_distortion(mos,objectiveValues)

for i=1:17
    a = (i-1)*100+1;
    b = i*100;
    subjective = mos(a:b);
    objective = objectiveValues(a:b);
    KRCC(i,1) = corr(subjective, objective, 'type', 'kendall');
    SRCC(i,1) = corr(subjective, objective, 'type', 'spearman');
end