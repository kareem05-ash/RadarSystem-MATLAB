function range_compress_sig_td = range_detection_matched_filter(R_sig, P_t)

[N_fast_time, N_pulses] = size(R_sig);
N_P_t = length(P_t);

% Matched Filter Impulse Response h(t) = P*(-t)
h_matched = conj(flipud(P_t(:))); 

% Length of convolution output: N_fast_time + N_P_t - 1
N_conv = N_fast_time + N_P_t - 1;

% NEW: äÓÊÎÏã length(P_t) + length(R_sig(:,n)) - 1
range_compress_sig_td = zeros(N_conv, N_pulses); 

% Apply Matched Filtering (Convolution) column-wise (Fast-Time)
for n = 1:N_pulses
    
    % Step 1: äÚãá Convolution ÈÇáÕíÛÉ ÇáÃÓÇÓíÉ (2 inputs)
    conv_output = conv(R_sig(:, n), h_matched(:));
    
    % Step 2: äŞæã ÈÊÎÒíä ÇáÜOutput ßÇãáÇğ
    % (ÇáÜOutput ÈÊÇÚ conv ÇáÃÓÇÓíÉ ÏÇÆãğÇ åæ 'full')
    range_compress_sig_td(:, n) = conv_output;
end

end