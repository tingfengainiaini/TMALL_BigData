clear
clc

S.numUsersLimit=2000;
S.activePerc=0.3;
S.percReported=0.8;
S.percPredicted=0.2;
S.crossValNum=1;
S.K=10;
S.coeff=0.5;
S.sigma=0.7;
S.numValues=10;
S.cutValue = 10;

[sim1Err,sim2Err,PDErr,avgErr,constErr,S]=eachMovieComparison(S);
save experiment1 sim1Err sim2Err PDErr avgErr constErr S;

tp=1;
disp([mean(sim1Err{1}(tp,:)) mean(sim2Err{1}(tp,:)) ...
        mean(PDErr{1}(tp,:)) mean(avgErr{1}(tp,:)) mean(constErr{1}(tp,:)) ]);
tp=2;
disp([mean(sim1Err{1}(tp,:)) mean(sim2Err{1}(tp,:)) ...
        mean(PDErr{1}(tp,:)) mean(avgErr{1}(tp,:)) mean(constErr{1}(tp,:)) ]);
tp=3;
disp([mean(sim1Err{1}(tp,:)) mean(sim2Err{1}(tp,:)) ...
        mean(PDErr{1}(tp,:)) mean(avgErr{1}(tp,:)) mean(constErr{1}(tp,:)) ]);
