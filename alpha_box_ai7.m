a_99 = [1,0.85,1,0.9667,1]';
a_97 = []';
a_96 = []';
a_95 = []';
a_94 = []';
a_93 = []'; 
a_91 = []';
a_89 = []';
a_87 = []';
a = [a_99, a_97, a_96, a_95, a_94, a_93, a_91, a_89, a_87];

t_99 = [14.2917,10.6250]';
t_97 = []';
t_96 = []';
t_95 = []';
t_94 = []';
t_93 = []';
t_91 = []';
t_89 = []';
t_87 = []';
t_mean = [mean(t_99), mean(t_97), mean(t_96), mean(t_95), mean(t_94), mean(t_93), mean(t_91), mean(t_89), mean(t_87)];
t_std = [std(t_99), std(t_97), std(t_96), std(t_95), std(t_94), std(t_93), std(t_91), std(t_89), std(t_87)];

figure;
hold on
title('Class error and decision time as a function of different alpha values');
boxplot(a);
ylabel('Class error');
yyaxis right
ylabel('Decision time [s]');
errorbar(t_mean,t_std,'-s','MarkerSize',4,...
    'MarkerEdgeColor','red','MarkerFaceColor','red');
xlabel(['alpha']);
xticklabels({'0.99','0.97','0.96','0.95','0.94','0.93','0.91','0.89','0.87'});
hold off