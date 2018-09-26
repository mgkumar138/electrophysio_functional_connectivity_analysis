function corr_test = correlation_test(X,Y1,lags)
% Compute pairwise correlation where 
% xcf = ntrials x nlag x shuffle


xcf = zeros(size(X,1), lags*2+1, size(X,1));

for i = 1:size(X,1)
    Y = circshift(Y1,i-1); % shift rows down by i
    for trial = 1:size(X,1)
        xcf(trial,:,i) = xcorr(X(trial,:),Y(trial,:),lags);
    end
end

corr_test = struct();
corr_test.trial_mean = mean(xcf(:,:,1)); 
corr_test.trial_var = var(xcf(:,:,1));

corr_test.shuffle_mean = mean(mean(xcf(:,:,2:end),3)); 
corr_test.shuffle_var = var(var(xcf(:,:,2:end),0,3));

% test if trial & shuffle are similar distribution
% [hx,px] = ttest2(mean(xcf(:,:,1)),mean(mean(xcf(:,:,2:end),3)));
% corr_test.h = [hx;px];
end