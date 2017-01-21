function [mean_dif LoA per_in_CI] = bland_altman(X1,X2)
% performs bland_altman analysis for given X1, X2 and finds SD and
% percentage points in the confidence interval

sm = (X1+X2)/2;
dif = X1-X2;
mean_dif = mean(dif);
SD = std(dif);
CI = 1.96*SD;
LoA = [mean_dif-CI mean_dif+CI];
per_in_CI = (length(find(dif>LoA(1)&dif<LoA(2)))/length(dif))*100;
figure() % BA plot
plot([min(sm) max(sm)], [mean_dif mean_dif],'--k', 'Linewidth',1.2)
hold on;
plot(sm, dif, 'x')
plot([min(sm) max(sm)], [LoA(1) LoA(1)],'--r','Linewidth',1.2)
plot([min(sm) max(sm)], [LoA(2) LoA(2)],'--r','Linewidth',1.2)
ylabel('X_1-X_2 (seconds)')
xlabel('(X_1+X_2)/2 (seconds)')
ylim([-0.8 0.4]); xlim([0.62 1.35])


figure(); % Correlation Plot
plot(X1,X2,'x');
hold on;
lsline
plot([min(X1) max(X2)], [min(X1) max(X2)],'k','Linewidth',1);
xlabel('X_1 (seconds)'); ylabel('X_2 (seconds)')
xlim([min(X1) max(X2)])
ylim([min(X2)-0.2 max(X2)])


