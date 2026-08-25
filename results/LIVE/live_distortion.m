function [KRCC,SRCC] = live_distortion(mos,objectiveValues)

subjective = mos(1:169);
objective = objectiveValues(1:169);
KRCC(1,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(1,1) = corr(subjective, objective, 'type', 'spearman');
KRCC(1,1) = abs(KRCC(1,1));
SRCC(1,1) = abs(SRCC(1,1));

subjective = mos(170:344);
objective = objectiveValues(170:344);
KRCC(2,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(2,1) = corr(subjective, objective, 'type', 'spearman');
KRCC(2,1) = abs(KRCC(2,1));
SRCC(2,1) = abs(SRCC(2,1));
    
subjective = mos(345:489);
objective = objectiveValues(345:489);
KRCC(3,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(3,1) = corr(subjective, objective, 'type', 'spearman');
KRCC(3,1) = abs(KRCC(3,1));
SRCC(3,1) = abs(SRCC(3,1));
    
subjective = mos(490:634);
objective = objectiveValues(490:634);
KRCC(4,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(4,1) = corr(subjective, objective, 'type', 'spearman');
KRCC(4,1) = abs(KRCC(4,1));
SRCC(4,1) = abs(SRCC(4,1));
    
subjective = mos(635:779);
objective = objectiveValues(635:779);
KRCC(5,1) = corr(subjective, objective, 'type', 'kendall');
SRCC(5,1) = corr(subjective, objective, 'type', 'spearman');
KRCC(5,1) = abs(KRCC(5,1));
SRCC(5,1) = abs(SRCC(5,1));   