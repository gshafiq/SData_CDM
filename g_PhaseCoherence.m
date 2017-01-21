function [PCoh] = g_PhaseCoherence(a1,b1,a2,b2)
%a is real part of wavelet transform, b is imaginary part of wavelet
%transform

cosdph = ((a1.*a2)+(b1.*b2))./((a1.^2+b1.^2).^0.5.*(a2.^2+b2.^2).^0.5);
sindph = ((b1.*a2)-(a1.*b2))./((a1.^2+b1.^2).^0.5.*(a2.^2+b2.^2).^0.5);

cosm = mean(cosdph,2);
sinm = mean(sindph,2);

PCoh = (cosm.^2+sinm.^2).^0.5;