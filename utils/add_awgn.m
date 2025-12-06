% --- utils/add_awgn.m ---
function y_noisy = add_awgn(x, SNR_dB)
    % ADD_AWGN: Adds complex Additive White Gaussian Noise to a signal vector x.
    
    Px = sum(abs(x).^2) / length(x);
    SNR_linear = 10^(SNR_dB / 10);
    Pn = Px / SNR_linear;
    sigma = sqrt(Pn/2);
    noise = sigma * (randn(size(x)) + 1j * randn(size(x)));
    y_noisy = x + noise;
end