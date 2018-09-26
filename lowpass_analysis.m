%%--------------------------------------------------------------------------------------------%%
% M Ganeshkumar 13/08/2018 Shih-Cheng Andrew & Thomas Lab 
% LFP & Spike data analysis to determine
% i) Activation:
%        - autocorrelation (t) 
%        - power spectral density (f) 
%            + Spectral power & field potential decay
%            + Oscillations
% ii) Correlation and Coherence:
%       - Cross correlation(t) or Spectral Coherence (f)
%            + Coherence = correlation coefficient
%            + LFP, Spike, Spike-field coherence (SFC)
%            + Signal/Noise ratio reduction
%            + SFC model - GLM / Pairwise phase consistency (PPC)
%            + Volume conduction ?
% ii) Communication - Granger, directed coherence
% iii) Decoding - modelling signal using GLM, find parameters
% iv) Graphical representation with whole model
%       - see change in modularity 
%       - circuitry, recurrent
%
% Channels with spikes (58)
% FEF 33-64 : 40(1), 41(3), 44(1), 63(1)
% DLPFC 65-96 : 66(3), 68(1), 73(1), 83(2), 89(1), 91(1), 92(1), 96(2),
% area8 1-32 : 8(2), 13(3), 14(3), 15(1), 16(2), 27(4)
% VDLPFC 97-128 : 98(1), 99(4), 101(3), 102(2), 104(1), 105(1), 108(2), 
% 110(2), 116(1), 117(1), 118(1), 124(2), 125(3), 127(1)
% ------------------------------------------------------------------------------------

%% load data
% ch_num = [40,41,44,63,66,68,73,83,89,91,92,96,8,13,14,15,16,27,98,99,101,102,104,105,108,110,116,117,118,124,125,127];
% for chnum = 1:2
%     load(['Pancake_230913_channel_' num2str(ch_num(ch_num(chnum))) '_lowpass.mat']);
%     lowpass.(genvarname(['lowpassch_' num2str(ch_num(ch_num(chnum)))])) = lowpassdata.data;
% end
% clearvars lowpassdata

%%
alltrials = loadTrialInfo('Pancake_230913_1_event_data.mat');

% Clean up trials with sessions without premature failure and with task reward
cleantrials = alltrials(4); % initiate same stucture to clean trials
n = 0;
for i = 1:size(alltrials,2)
    if isempty(alltrials(i).failure) && ~isempty(alltrials(i).target)
        n = n+1;
        cleantrials(n) = alltrials(i);
    else 
    end
end

clearvars n i

%% Extract delay segments
ch_num = [40,41,44,63,66,68,73,83,89,91,92,96,8,13,14,15,16,27,98,99,101,102,104,105,108,110,116,117,118,124,125,127];
for chnum = 1:size(ch_num,2)
    load(['Pancake_230913_channel_' num2str(ch_num(chnum)) '_lowpass.mat']);
    lowpass.(genvarname(['lowpassch_' num2str(ch_num(chnum))])) = lowpassdata.data;
    
    lowpass_d1 = zeros(size(cleantrials,2), 1002);
    lowpass_d2 = zeros(size(cleantrials,2), 1002);
    lowpass_fix = zeros(size(cleantrials,2), 502);
    lowpass_full = zeros(size(cleantrials,2), 3102);
    
    for i = 1:size(cleantrials,2)
        trial = cleantrials(i);
        target_loc = [cleantrials(i).target.row,cleantrials(i).target.column];
        
        lowpass_d1(i,1001:1002) = target_loc;
        d1_start = 300 + 1000*round(trial.start + trial.target.timestamp, 3);
        d1_end = 1300 + 1000*round(trial.start + trial.target.timestamp, 3)-1;
        lowpass_d1(i,1:end-2) = lowpass.(genvarname(['lowpassch_' num2str(ch_num(chnum))])).data(d1_start:d1_end)';
        
        lowpass_d2(i,1001:1002) = target_loc;
        d2_start = 1600 + 1000*round(trial.start + trial.target.timestamp, 3);
        d2_end = 2600 + 1000*round(trial.start + trial.target.timestamp, 3)-1;
        lowpass_d2(i,1:end-2) = lowpass.(genvarname(['lowpassch_' num2str(ch_num(chnum))])).data(d2_start:d2_end)';
        
        lowpass_fix(i,501:502) = target_loc;
        fix_start = 1000*round(trial.start + trial.target.timestamp, 3) - 500;
        fix_end = 1000*round(trial.start + trial.target.timestamp, 3)-1;
        lowpass_fix(i,1:end-2) = lowpass.(genvarname(['lowpassch_' num2str(ch_num(chnum))])).data(fix_start:fix_end)';
        
        lowpass_full(i,3101:3102) = target_loc;
        full_start = 1000*round(trial.start + trial.target.timestamp, 3) - 500;
        full_end = 2600 + 1000*round(trial.start + trial.target.timestamp, 3)-1;
        lowpass_full(i,1:end-2) = lowpass.(genvarname(['lowpassch_' num2str(ch_num(chnum))])).data(full_start:full_end)';
        
    end
    
    
    d1.(genvarname(['lowpass_ch' num2str(ch_num(chnum))])) = cell(3,3);
    d2.(genvarname(['lowpass_ch' num2str(ch_num(chnum))])) = cell(3,3);
    fix.(genvarname(['lowpass_ch' num2str(ch_num(chnum))])) = cell(3,3);
    full.(genvarname(['lowpass_ch' num2str(ch_num(chnum))])) = cell(3,3);
    
    d1.(genvarname(['lowpass_ch' num2str(ch_num(chnum))])){2,2} = lowpass_d1;
    d2.(genvarname(['lowpass_ch' num2str(ch_num(chnum))])){2,2} = lowpass_d2;
    fix.(genvarname(['lowpass_ch' num2str(ch_num(chnum))])){2,2} = lowpass_fix;
    full.(genvarname(['lowpass_ch' num2str(ch_num(chnum))])){2,2} = lowpass_full;
    %Average LFP across trial, specific to target location
    for k = 1:3
        for m = 1:3
            n=1;
            for i = 1: 622 % target location is 4,4
                if lowpass_d1(i,1001) == k+1 && lowpass_d1(i,1002) == m+1;
                    d1.(genvarname(['lowpass_ch' num2str(ch_num(chnum))])){k,m}(n,:) = lowpass_d1(i,:);
                    d2.(genvarname(['lowpass_ch' num2str(ch_num(chnum))])){k,m}(n,:) = lowpass_d2(i,:);
                    fix.(genvarname(['lowpass_ch' num2str(ch_num(chnum))])){k,m}(n,:) = lowpass_fix(i,:);
                    full.(genvarname(['lowpass_ch' num2str(ch_num(chnum))])){k,m}(n,:) = lowpass_full(i,:);
                    n=n+1;
                else
                end
            end
        end
    end
end

clearvars -except cleantrials lowpass d1 d2 alltrials fix full
% save('Pancake_allch_full_clean.mat')
%% Time based
% subplot(1,2,1); 
% plot(1:1001, avglowpass_d1_ch40)
% hold on 
% plot(1:1001, lowpass_d1_ch40(1,:));
% title('Delay 1 LFP')
% xlabel('Time (ms)')
% ylabel('Lowpass band')
% axis([0 1000 -0.02 0.02])
% subplot(1,2,2);
% plot(1:1001, avglowpass_d2_ch40)
% title('Delay 2 LFP')
% xlabel('Time (ms)')
% ylabel('Lowpass band')
% axis([0 1000 -0.02 0.02])

% %% plot sequentially to see overall pattern
% fig = plot(1:1001, target_interest(1,1:1001));
% for k = 2:100
%     pause(1)
%     hold on
%     plot(1:1001, lowpass_d2_ch40(k,1:1001))    
% end 





