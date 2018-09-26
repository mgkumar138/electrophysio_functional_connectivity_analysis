function plot_pair_corr(trial_mean, shuf_mean, N, win_len, nlags)
figure
        x = 1:win_len:size(N,2);
        plot(x,trial_mean(nlags+1,:,1),x,shuf_mean(nlags+1,:,1))
        set(gca,'xtick',[0:100:size(N,2)])
        title('Zerolag correlation')
        
        figure
        subplot(3,1,1)
        xax = [1 size(F1,2)];
        yax = [-nlags nlags];
        colormap('jet')
        imagesc(xax,yax,trial_mean(:,:,1))
        colorbar
        title(['Trial-Trial Correlation, win_len=' num2str(win_len)])
        xlabel('Time')
        ylabel('Lag')
        hold on;
        line([500,500], [-20,20], 'Color', 'w')
        line([800,800], [-20,20], 'Color', 'w')
        line([500,500], [-20,20], 'Color', 'w')
        line([1800,1800], [-20,20], 'Color', 'w')
        line([2100,2100], [-20,20], 'Color', 'w')
        
       
        coinc_mean = trial_mean - shuf_corr;
        subplot(3,1,3)
        xax = [1 size(F1,2)];
        yax = [-nlags nlags];
        colormap('jet')
        imagesc(xax,yax,coinc_mean(:,:,1))
        colorbar
        title(['Trial-Shuffle Correlation, win_len=' num2str(win_len)])
        xlabel('Time')
        ylabel('Lag')
        hold on;
        line([500,500], [-20,20], 'Color', 'w')
        line([800,800], [-20,20], 'Color', 'w')
        line([500,500], [-20,20], 'Color', 'w')
        line([1800,1800], [-20,20], 'Color', 'w')
        line([2100,2100], [-20,20], 'Color', 'w')
        
        subplot(3,1,3)
        xax = [1 size(F1,2)];
        yax = [-nlags nlags];
        colormap('jet')
        imagesc(xax,yax,shuf_mean(:,:,1))
        colorbar
        title(['Shuffle Correlation, win_len=' num2str(win_len)])
        xlabel('Time')
        ylabel('Lag')
        hold on;
        line([500,500], [-20,20], 'Color', 'w')
        line([800,800], [-20,20], 'Color', 'w')
        line([500,500], [-20,20], 'Color', 'w')
        line([1800,1800], [-20,20], 'Color', 'w')
        line([2100,2100], [-20,20], 'Color', 'w')
end
