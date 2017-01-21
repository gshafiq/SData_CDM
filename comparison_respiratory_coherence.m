%Technical Validation for Dataset "Shafiq, G. and Veluvolu, K. C. FigShare
%https://dx.doi.org/10.6084/m9.figshare.c.3258022 (2016)"
%Detailed experimental setup and annotations are provided in datadescriptor
%Multimodal chest surface motion data for respiratory and cardiovascular monitoring applications

%Comparison of respiratory signal modalities
%Phase Coherence between:
%       i) VICON and Strain Belt
%       ii) VICON and Nasal Thermal Sensor
%       iii) Strain belt and Nasal Thermal Sensor

% Written and tested in Matlab R2015a
% Authors: Ghufran Shafiq, Kalyana C. Veluvolu



close all; clear all; clc
DataType = 4; %1 - Free, 2 -  hold, 3 -irregular, 4 - exercise
fs = 100; %sampling grequency
fc = 2*[0.08 10]/fs; %Cutoff for filter
[b,a] = butter(5,fc,'bandpass');
mpath = 'E:\KNU Studies\Research Work\RPM_scientific data\';
switch DataType
    case 1 %free breathing
        fpath = [mpath '\Data_Free\T'];
        trials = [1:10 15:48];
    case 2 % Breath Hold
        fpath = [mpath 'Data_Hold\T'];
        trials = [1:3 5:11];
    case 3 %Irregular Breathing
        fpath = [mpath 'Data_Irreg\T'];
        trials = 1:5;
    case 4 %Post Exercise
        fpath = [mpath 'Post_Ex\T'];
        trials = [1 3:5];
end
scales = logspace(3,0,500);
scales = fliplr(scales);
wname = 'cgau3';
Frq = scal2frq(scales,wname,1/100);
for i = 1:length(trials)
    fprintf('\nTrial Number: %d\n', i);
    load([fpath num2str(trials(i))]);
    belt = filtfilt(b,a,standarize(mp36_s(2,:)));
    air = filtfilt(b,a,standarize(mp36_s(4,:)));
    motion = filtfilt(b,a,standarize(vicon_s(60,:))); %Marker M2 (on belt), z-axis
    clear mp36_s vicon_s
    [wcoh12,wcs12,cwt_x1,cwt_x2] = wcoher(motion,belt,scales,wname);
    [wcoh13,wcs13,~,cwt_x3] = wcoher(motion,air,scales,wname);
    a1 = real(cwt_x1);
    b1 = imag(cwt_x1);
    a2 = real(cwt_x2);
    b2 = imag(cwt_x2);
    a3 = real(cwt_x3);
    b3 = imag(cwt_x3);
    
    [PCoh12(i,:)] = g_PhaseCoherence(a1,b1,a2,b2); %Phase coherence between vicon and belt
    [PCoh13(i,:)] = g_PhaseCoherence(a1,b1,a3,b3);
    [PCoh23(i,:)] = g_PhaseCoherence(a2,b2,a3,b3);
end
%% Max Phase Coherence Values in 0.1-0.6Hz
band = [0.1 0.6];
fr_ind(2) = find(Frq<=band(1),1);
fr_ind(1) = find(Frq<=band(2),1); %indices revsersed since Frq is flipped

for i = 1:length(trials)
    
    r12(i,:) = PCoh12(i,fr_ind(1):fr_ind(2));
    r13(i,:) = PCoh13(i,fr_ind(1):fr_ind(2));
    r23(i,:) = PCoh23(i,fr_ind(1):fr_ind(2));
    mx12(i) = max(r12(i,:));
    mx13(i) = max(r13(i,:));
    mx23(i) = max(r23(i,:));
    
    p12(i) = sum(r12(i,:))/sum(PCoh12(i,:));
    p13(i) = sum(r13(i,:))/sum(PCoh13(i,:));
    p23(i) = sum(r23(i,:))/sum(PCoh23(i,:));
    
end

figure(1);  stem(mx12); hold on; stem(mx13,'r'); stem(mx23,'k');
legend('V&B','V&N','B&N'); title('Max Phase Coherence Values in 0.1-0.6Hz')
set(gca,'XTick',1:length(trials),'XTickLabel',{trials})

mmx12 = mean(mx12); smx12 = std(mx12);
mmx13 = mean(mx13); smx13 = std(mx13);
mmx23 = mean(mx23); smx23 = std(mx23);

figure(2);
boxplot([mx12',mx13',mx23'],'notch','off','labels',{'V&B','V&N','B&N'})