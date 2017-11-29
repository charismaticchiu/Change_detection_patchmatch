mAP_labModrgbPM = zeros(3,7,5);
mAP_noModrgbPM = zeros(3,7,5);
mAP_noModlabPM = zeros(3,7,5);
mAP_rgbModrgbPM = zeros(3,7,5);
mAP_rgbModlabPM = zeros(3,7,5);
mAP_labModrgbPMPrc = zeros(2,16,2);
mAP_labModrgbPMPrc1 = zeros(1,16,5);
mAP_labModrgbPMPrc4 = zeros(1,16,5);
mAP_labModrgbPMPrc7 = zeros(1,16,5);
mAP_noModrgbPMPrc1 = zeros(1,16,5);
mAP_noModrgbPMPrc4 = zeros(1,16,5);
mAP_noModrgbPMPrc7 = zeros(1,16,5);
labelNum = 41;
for i = 1:labelNum
mAP_labModrgbPM = mAP_labModrgbPM + changeDetectAconBrgbSiftlabModrgbPM{i,5};
end
mAP_labModrgbPM = mAP_labModrgbPM/labelNum;

for i = 1:labelNum
mAP_noModrgbPM = mAP_noModrgbPM + changeDetectAconBrgbSiftnoModrgbPM{i,5};
end
mAP_noModrgbPM = mAP_noModrgbPM/labelNum;

for i = 1:labelNum
mAP_noModlabPM = mAP_noModlabPM + changeDetectAconBrgbSiftnoModlabPM{i,5};
end
mAP_noModlabPM = mAP_noModlabPM/labelNum;

for i = 1:labelNum
mAP_rgbModrgbPM = mAP_rgbModrgbPM + changeDetectAconBrgbSiftrgbModrgbPM{i,5};
end
mAP_rgbModrgbPM = mAP_rgbModrgbPM/labelNum;


for i = 1:labelNum
mAP_rgbModlabPM = mAP_rgbModlabPM + changeDetectAconBrgbSiftrgbModlabPM{i,5};
end
mAP_rgbModlabPM = mAP_rgbModlabPM/labelNum;
labelNum = 40;
for i = 1:labelNum
mAP_labModrgbPMPrc = mAP_labModrgbPMPrc + changeDetectAconBrgbSiftlabModrgbPMPrc{i,5};
end
mAP_labModrgbPMPrc = mAP_labModrgbPMPrc/labelNum;

for i = 1:labelNum
mAP_labModrgbPMPrc1 = mAP_labModrgbPMPrc1 + changeDetectAconBrgbSiftlabModrgbPMPrc1{i,5};
end
mAP_labModrgbPMPrc1 = mAP_labModrgbPMPrc1/labelNum;

for i = 1:labelNum
mAP_labModrgbPMPrc4 = mAP_labModrgbPMPrc4 + changeDetectAconBrgbSiftlabModrgbPMPrc4{i,5};
end
mAP_labModrgbPMPrc4 = mAP_labModrgbPMPrc4/labelNum;

for i = 1:labelNum
mAP_labModrgbPMPrc7 = mAP_labModrgbPMPrc7 + changeDetectAconBrgbSiftlabModrgbPMPrc7{i,5};
end
mAP_labModrgbPMPrc7 = mAP_labModrgbPMPrc7/labelNum;


for i = 1:labelNum
mAP_noModrgbPMPrc1 = mAP_noModrgbPMPrc1 + changeDetectAconBrgbSiftnoModrgbPMPrc1{i,5};
end
mAP_noModrgbPMPrc1 = mAP_noModrgbPMPrc1/labelNum;

for i = 1:labelNum
mAP_noModrgbPMPrc4 = mAP_noModrgbPMPrc4 + changeDetectAconBrgbSiftnoModrgbPMPrc4{i,5};
end
mAP_noModrgbPMPrc4 = mAP_noModrgbPMPrc4/labelNum;

for i = 1:labelNum
mAP_noModrgbPMPrc7 = mAP_noModrgbPMPrc7 + changeDetectAconBrgbSiftnoModrgbPMPrc7{i,5};
end
mAP_noModrgbPMPrc7 = mAP_noModrgbPMPrc7/labelNum;

