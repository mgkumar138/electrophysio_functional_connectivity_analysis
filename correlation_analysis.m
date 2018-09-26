% Correlation analysis between time series data
%
% Raw data --> Bandpass using appropriate filter --> n trials x p
% observations
%  
% 

clear; close all
load('Pancake_allch_full_clean.mat')
%% define data & channels
data = full;

ch_num = [8,13,14,15,16,27,40,41,44,63,66,68,73,83,89,91,92,96,98,99,101,102,104,105,108,110,116,117,118,124,125,127];
% define size of data
N = data.(['lowpass_ch' num2str(ch_num(1))]){2,3}(:,1:end-2);

%% Define window length and lags
prompt1 = 'Sliding Window length for correlation: ';
win_len = input(prompt1);
prompt2 = 'Number of lags: ';
nlags = input(prompt2); % max lag = win_len-1

%% define time based adjecncy matrix [ch x ch x win_len]

zerolag_trial = zeros(size(ch_num,2),size(ch_num,2),size(N,2)/win_len);
zerolag_shuffle = zeros(size(ch_num,2),size(ch_num,2),size(N,2)/win_len);
zerolag_coinc = zeros(size(ch_num,2),size(ch_num,2),size(N,2)/win_len);

%% stationary tests
nonstat_ks = zeros(size(ch_num,2),size(ch_num,2));
stat_adf = zeros(size(ch_num,2),size(ch_num,2));


%% Run correlation test for each pairwise correlation
for ch1 = 1:size(ch_num,2)
    for ch2 = ch1:size(ch_num,2)
        tic
        display(['Status : Ch' num2str(ch_num(ch1)) ' & Ch' num2str(ch_num(ch2))])
        
        % use LFP data from visual target (2,3) n = 97
         F1 = data.(['lowpass_ch' num2str(ch_num(ch1))]){2,3}(:,1:end-2);
         F2 = data.(['lowpass_ch' num2str(ch_num(ch2))]){2,3}(:,1:end-2);

         % plot signals & select signal length
         % subplot(2,1,1)
         % plot(1:size(F1,2),F1)
         % title(['F1:lowpass_ch' num2str(ch_num(ch1))])
         % subplot(2,1,2)
         % plot(1:size(Y2,2),Y2)
         % title(['F2:lowpass_ch' num2str(ch_num(ch2))])
       
        
        % test for stationarity
        [nonstat_ks(ch1,ch2),stat_adf(ch1,ch2)] = stationarity_test(F1,F2);
        
        %% Correlation: pairwise correlation at zerolag
                     
        trial_mean=zeros(nlags*2+1,size(N,2)/win_len,2);
        shuf_mean=zeros(nlags*2+1,size(N,2)/win_len,2);
        h=zeros(2,size(N,2)/win_len);
        
        % nonoverlapping window correlation
        for win = 0:size(N,2)/win_len-1
            
            start = 1+win*win_len;
            stop = start+win_len-1;
            x1 = F1(:,start:stop);
            y2 = F2(:,start:stop);
            
            rxy = correlation_test(x1,y2,nlags);
            
            % [nlags x totaltime/win_len x meanorvar]
            trial_mean(:,win+1,1) = rxy.trial_mean';
            %trial_mean(:,win+1,2) = rxy.trial_var';
            shuf_mean(:,win+1,1) = rxy.shuffle_mean';
            %shuf_mean(:,win+1,2) = rxy.shuffle_var';
            %h(:,win+1) = rxy.h;
        end
        
        %% plot pairwise correlations @ 0 lag and all lag
        
        plot_pair_corr(trial_mean, shuf_mean, N, win_len, nlags)

        %% [ch1 x ch2 x totaltime/win_len]
        coinc_mean = (trial_mean(:,:,1)-shuf_mean(:,:,1));
        
        zerolag_trial(ch1,ch2,:) = trial_mean(nlags,:,1);
        zerolag_shuffle(ch1,ch2,:) = shuf_mean(nlags,:,1);
        zerolag_coinc(ch1,ch2,:) = coinc_mean(nlags,:);
        
        toc
    end
end

% clearvars -except zerolag_coinc zerolag_trial zerolag_shuffle N win_len
% save('zerolag_data.mat')

%% time course correlation between all channels
% [xcorr_t1 x xcorr_t2]
time_corr = zeros(size(N,2)/win_len,size(N,2)/win_len);

for t1 = 1:size(N,2)/win_len
    for t2 = 1:size(N,2)/win_len
        A = xcorr2(zerolag_coinc(:,:,t1),zerolag_coinc(:,:,t2));
        time_corr(t1,t2) = A(size(zerolag_coinc,1),size(zerolag_coinc,2)); % zerolag
    end
end

xax = [1 size(N,2)/win_len];
yax = [1 size(N,2)/win_len];
imagesc(xax, yax, time_corr)
colormap('jet')
set(gca,'YDir','normal')
title('Time based (3.1s) Cross Correlation: trial-shuffle, symmetric')
xlabel(['Time: ' num2str(win_len) 'ms bins nonoverlap'])
ylabel(['Time: ' num2str(win_len) 'ms bins nonoverlap'])
% demarcate task target regions
line([11,11], [1,62], 'Color', 'w','LineWidth',2)
line([15,15], [1,62], 'Color', 'w','LineWidth',2)
line([37,37], [1,62], 'Color', 'w','LineWidth',2)
line([41,41], [1,62], 'Color', 'w','LineWidth',2)

line([1,62], [11,11], 'Color', 'w','LineWidth',2)
line([1,62], [15,15], 'Color', 'w','LineWidth',2)
line([1,62], [37,37], 'Color', 'w','LineWidth',2)
line([1,62], [41,41], 'Color', 'w','LineWidth',2)



