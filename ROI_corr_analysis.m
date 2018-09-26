%% area specfic time course correlation
load('zerolag_correlation_matrix.mat')

area8 = 1:6; FEF = 7:10; DLPFC = 11:18; vdlpfc= 19:32; all=1:32;
R = zerolag_shuffle;

area8_corr = R(area8,area8,:);
fef_corr = R(FEF,FEF,:);
dlpfc_corr = R(DLPFC,DLPFC,:);
vdl_corr = R(vdlpfc,vdlpfc,:);

for i = 1:62
    a8(1,i) = mean(nonzeros(triu(area8_corr(:,:,i),1)));
    a8(2,i) = var(nonzeros(triu(area8_corr(:,:,i),1)));
    
    fef(1,i) = mean(nonzeros(triu(fef_corr(:,:,i),1)));
    fef(2,i) = var(nonzeros(triu(fef_corr(:,:,i),1)));
    
    dlpfc(1,i) = mean(nonzeros(triu(dlpfc_corr(:,:,i),1)));
    dlpfc(2,i) = var(nonzeros(triu(dlpfc_corr(:,:,i),1)));
    
    vdl(1,i) = mean(nonzeros(triu(vdl_corr(:,:,i),1)));
    vdl(2,i) = var(nonzeros(triu(vdl_corr(:,:,i),1)));
end

figure
errorbar(1:62,a8(1,:),a8(2,:))
hold on
errorbar(1:62,fef(1,:),fef(2,:))
hold on
errorbar(1:62,dlpfc(1,:),dlpfc(2,:))
hold on
errorbar(1:62,vdl(1,:),vdl(2,:))
legend('a8 6xCh','fef 4xCh','dlpfc 8xCh','vdlpfc 14xCh')
title('zerolag shuffle')
xlabel('Time')
ylabel('Correlation')
hold on
line([11,11], [0,max(fef(1,:))], 'Color', 'k')
line([16,16], [0,max(fef(1,:))], 'Color', 'k')
line([37,37], [0,max(fef(1,:))], 'Color', 'k')
line([42,42], [0,max(fef(1,:))], 'Color', 'k')

% saveas(gca,'allarea_corr_shuffle.png')