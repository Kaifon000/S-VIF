function [KRCC,SRCC] = csiq_distortion(mos,objectiveValues)
    
subjective = mos(1:150);
objective = objectiveValues(1:150);
KRCC(1,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(1,1) = corr(subjective, objective, 'type', 'spearman');
KRCC(1,1) = abs(KRCC(1,1));
SRCC(1,1) = abs(SRCC(1,1));

subjective = mos(151:300);
objective = objectiveValues(151:300);
KRCC(2,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(2,1) = corr(subjective, objective, 'type', 'spearman');
KRCC(2,1) = abs(KRCC(2,1));
SRCC(2,1) = abs(SRCC(2,1));

subjective = mos(301:450);    
objective = objectiveValues(301:450);    
KRCC(3,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(3,1) = corr(subjective, objective, 'type', 'spearman');
KRCC(3,1) = abs(KRCC(3,1));
SRCC(3,1) = abs(SRCC(3,1));

subjective = mos(451:600);
objective = objectiveValues(451:600);
KRCC(4,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(4,1) = corr(subjective, objective, 'type', 'spearman');
KRCC(4,1) = abs(KRCC(4,1));
SRCC(4,1) = abs(SRCC(4,1));

subjective = mos(601:750);
objective = objectiveValues(601:750);
KRCC(5,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(5,1) = corr(subjective, objective, 'type', 'spearman');
KRCC(5,1) = abs(KRCC(5,1));
SRCC(5,1) = abs(SRCC(5,1));

subjective = mos(751:866);
objective = objectiveValues(751:866);
KRCC(6,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(6,1) = corr(subjective, objective, 'type', 'spearman');
KRCC(6,1) = abs(KRCC(6,1));
SRCC(6,1) = abs(SRCC(6,1));