function [ks,adf] = stationarity_test(Y1,Y2)
A = zeros(2,size(Y1,1),size(Y1,2));
A(1,:,:) = Y1;
A(2,:,:) = Y2;
A = reshape(A,2,size(Y1,2),size(Y1,1));
% data strcuture = nxmxN; n = #chnl N = #trials, m = #observation

%kpss null hyp = stationary. reject null if kpss>c (more pos)
[ksstat,c_kpss] = mvgc_kpss(A,0.05);
ks = mean(100*(sum(ksstat>c_kpss))./(size(ksstat,1)));
display([num2str(ks) ' % trials nonstationary, KPSS test'])

% adf null hyp = non stat. reject null if ts<c (more neg)
[tstat,c_adf] = mvgc_adf(A,0.05);
adf = mean(100*(sum(tstat<c_adf))./(size(tstat,1)));
display([num2str(adf) ' % trials stationary, ADF test'])
end

