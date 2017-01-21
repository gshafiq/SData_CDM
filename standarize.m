function standSig = standarize(OldSig)
% making the signal zero mean and unit variance
sig = OldSig - mean (OldSig')' * ones (1,size (OldSig, 2));
for t = 1: size(sig,1)
    standSig(t,:) = sig(t,:)/std(sig(t,:));
end



