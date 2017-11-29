close all
load('video/Label/changeDetectAconBrgbSiftnoModrgbPMPrc7.mat')
load('video/Label/changeDetectAconBrgbSiftlabModrgbPMPrc7.mat')
%stable labModrgbPM percentile 89
labModrgbPMstabPrc(5) = 0;
for j = 1:5
    for i = 1:40
       
        labModrgbPMstabPrc(j) = labModrgbPMstabPrc(j) + changeDetectAconBrgbSiftlabModrgbPMPrc7{i,5}(1,14,j);
    end
end
labModrgbPMstabPrc = labModrgbPMstabPrc./40;


%stable  labModrgbPM win_size 200
labModrgbPMstabWin(16) = 0;
for j = 1:16
    for i = 1:40
       
        labModrgbPMstabWin(j) = labModrgbPMstabWin(j) + changeDetectAconBrgbSiftlabModrgbPMPrc7{i,5}(1,j,3);
    end
end
labModrgbPMstabWin = labModrgbPMstabWin./40;

%stable baseline percentile 89
baseStabPrc(5) = 0;
for j = 1:5
    for i = 1:40
       
        baseStabPrc(j) = baseStabPrc(j) + changeDetectAconBrgbSiftnoModrgbPMPrc7{i,5}(1,14,j);
    end
end
baseStabPrc = baseStabPrc./40;


%stable baseline win_size 200
baseStabWin(16) = 0;
for j = 1:16
    for i = 1:40
       
        baseStabWin(j) = baseStabWin(j) + changeDetectAconBrgbSiftnoModrgbPMPrc7{i,5}(1,j,3);
    end
end
baseStabWin = baseStabWin./40;
dir = strcat('./paperFigures');
s = 120;
%plot stabPrc
figure
scatter([100,150,200,250,300],baseStabPrc,s,'filled','o','MarkerFaceColor','b','LineWidth',1.5)
hold on
scatter([100,150,200,250,300],labModrgbPMstabPrc,s,'filled','o','MarkerFaceColor','r','LineWidth',1.5)

xlim([50 350])
hold off
print(strcat(dir,'/suppl_stablizePercentile'),'-djpeg','-r500')
close

%plot stabWin
figure
scatter((50:3:95),baseStabWin,s,'filled','o','MarkerFaceColor','b','LineWidth',1.5);
hold on
scatter((50:3:95),labModrgbPMstabWin,s,'filled','o','MarkerFaceColor','r','LineWidth',1.5)
xlim([45 100])
hold off
print(strcat(dir,'/suppl_stablizeWinSize'),'-djpeg','-r500')
close


figure
scatter([100,150,200,250,300],labModrgbPMstabPrc,s,'filled','o','MarkerFaceColor','r','LineWidth',1.5)
xlim([50 350])
print(strcat(dir,'/suppl_stablizePercentile_noBaseline'),'-djpeg','-r500')
close

figure
scatter((50:3:95),labModrgbPMstabWin,s,'filled','o','MarkerFaceColor','r','LineWidth',1.5)
xlim([45 100])
print(strcat(dir,'/suppl_stablizeWinSize_noBaseline'),'-djpeg','-r500')
close
