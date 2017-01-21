function standSig = standarize2(OldSig)
% Limits the signal amplitude to 1

sig = OldSig - mean (OldSig')' * ones (1,size (OldSig, 2));

for t = 1: size(sig,1)
    standSig(t,:) = sig(t,:)/max(abs(sig(t,:)));
end



