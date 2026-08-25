function [KRCC,SRCC] = a57_distortion(mos,objectiveValues)

for i=1:6
    a = (i-1)*9+1;
    b = i*9;
    subjective = mos(a:b);
    objective = objectiveValues(a:b);
    KRCC(i,1) = corr(subjective, objective, 'type', 'kendall');
    SRCC(i,1) = corr(subjective, objective, 'type', 'spearman');
    KRCC(i,1) = abs(KRCC(i,1));
    SRCC(i,1) = abs(SRCC(i,1));
end