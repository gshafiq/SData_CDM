%Technical Validation for Dataset "Shafiq, G. and Veluvolu, K. C. FigShare
%https://dx.doi.org/10.6084/m9.figshare.c.3258022 (2016)"
%Detailed experimental setup and annotations are provided in datadescriptor
%Multimodal chest surface motion data for respiratory and cardiovascular monitoring applications

%Comparison of cardiac signals
%The peak-peak intervals for the chest surface motion from VICON (L22Marker, z-axis)
%and R-R intervals for the standard lead-II ECG are compared
% BA analysis and scatter plots are illustrated here for these intervals

%Outputs:
%       Mean difference in intervals
%       Limits of Agreement
%       Percentage of Data occurring in Limits of Agreements
%       Correlation Coefficient between two types of intervals

% Written and tested in Matlab R2015a
% Authors: Ghufran Shafiq, Kalyana C. Veluvolu

%%
close all; clear all; clc
fs = 100; %sampling frequency
augmented_intervals_adj =[]; %augmented matrix for intervals in Chest Motion and ECG
t_count = 0; %Counter for attempts (combined)
d = 0; %Counter for discarded attempts
f_path = 'E:\KNU Studies\Research Work\RPM_scientific data\Data_Hold'; %Enter folder path here
for trial= 1:11;
    load([f_path '\T' num2str(trial)]); %Loading full trial
    t = 0:1/fs:(size(vicon_s,2)-1)/fs; %Full time vector
    for attempt = 1:length(s_pos) %For each attempt
        seg =s_pos(attempt):e_pos(attempt);     %Segment index: segmenting out the breath-hold attempt 
        %s_pos and e_pos are vectors containing the starting and ending
        %indices of each breath-hold attempt in a trial
         %% HighPass Filtering signals: 1-Movingaverage
         win_vic = 80; %Moving average window size for Chest Motion signal (VICON)
        win_ecg = 20; %Moving average window size for ECG signal
        b_vic = ones(1,win_vic)/win_vic;
        b_ecg = ones(1,win_ecg)/win_ecg;
        Chest_sig = vicon_s(18,seg); %L22 z-axis Chest motion signal
        drift_Chest_sig = filtfilt(b_vic,1,Chest_sig); %Drift in Chest Motion signal
        filt_Chest_sig = standarize2(Chest_sig-drift_Chest_sig); %Filtered Chest Motion Signal
        filt_ecg = standarize2(mp36_s(3,seg)-filtfilt(b_ecg,1,mp36_s(3,seg)));
        %% Peak Detection
        pulse_Chest = filt_Chest_sig(300:500); % 2 second pulse (segment)
        %plot(t(seg),filt_Chest_sig, t(seg(300:500)),pulse_Chest,'r')
        [c_chest, lags_chest] = xcorr(filt_Chest_sig,pulse_Chest,length(seg));
        corr_sig_vicon = standarize2(c_chest(length(lags_chest)/2:end));
        [peaks_ecg,~] = PTDetect(filt_ecg,0.9); %R-peak detection for ECG
        [peaks_chest,~] = PTDetect(corr_sig_vicon,0.2); %Peak detection for Chest Motion signal
        [ad_peaks_chest,ad_peaks_ecg] = peak_adj2(peaks_chest,peaks_ecg); %Adjusting peaks for initial and final partial cycles
        if length(ad_peaks_chest)~=length(ad_peaks_ecg)
            d = d+1;
            Discarded.Trial(d) = trial;
            Discarded.Attempt(d) = attempt;
            fprintf('\nAttempt Discarded: Trial:  %d, Attempt:   %d\n\n',trial,attempt);
            break;
        end
        rr_chest = diff(ad_peaks_chest)/100;
        rr_ecg = diff(ad_peaks_ecg)/100;
        augmented_intervals_adj = [augmented_intervals_adj [rr_chest;rr_ecg]];
        t_count= t_count+1;
        beat_count(t_count) = length(rr_chest); %number of beats in current attempt
        clear error_vicon ad_peaks_vic ad_peaks_ecg rr_vic rr_ecg
    end
end
%% BA and Scatter Plots
[mean_dif, LoA, per_ci] = bland_altman(augmented_intervals_adj(1,:),augmented_intervals_adj(2,:));
corr_value = corr(augmented_intervals_adj(1,:)'/fs, augmented_intervals_adj(2,:)'/fs);
