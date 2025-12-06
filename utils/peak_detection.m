function [detected_values, peak_indices] = peak_detection(spectrum_magnitude, axis_vector, domain_name)
% PEAK_DETECTION: Identifies significant peaks in a spectrum (Range or Doppler).
%
% Inputs:
%   spectrum_magnitude: The magnitude array (e.g., |RC_td(:, 1)| or |V_spectrum|)
%   axis_vector:        The corresponding axis (Range_fast_axis or V_axis)
%   domain_name:        String for logging/identification ('Time Domain', 'Doppler')
%
% Outputs:
%   detected_values:    Values on the axis corresponding to the peaks (m or m/s)
%   peak_indices:       Indices (row/column numbers) of the detected peaks

    % 1. Determine the Noise Floor and Threshold
    % A common approach is using the mean or median of the spectrum, 
    % and adding a certain offset (e.g., 6-10 dB) as a Guard Band.
    
    % Convert spectrum to dB scale for easier thresholding (optional but helpful)
    spectrum_dB = 20 * log10(spectrum_magnitude + eps); 
    
    % Estimate the noise floor using the median (more robust than mean)
    noise_floor_dB = median(spectrum_dB);
    
    % Define the Detection Threshold (e.g., 6 dB above the noise floor)
    threshold_dB = noise_floor_dB + 6; 

    % 2. Find Peaks above Threshold
    % Find indices where the signal magnitude exceeds the threshold
    initial_peak_indices = find(spectrum_dB > threshold_dB);
    
    if isempty(initial_peak_indices)
        detected_values = [];
        peak_indices = [];
        fprintf('  [Peak Detection] No targets detected in the %s.\n', domain_name);
        return;
    end
    
    % 3. Apply Peak Cleaning (Non-Maximum Suppression)
    % When multiple adjacent bins are above the threshold, only the center/max should be counted.
    
    % Use MATLAB's built-in peak finder if available, or manually suppress non-maxima.
    % A simple method: filter indices to ensure the peak is the local maximum within a small window.
    
    % For robust detection, use the 'findpeaks' function (requires Signal Processing Toolbox)
    % If Signal Processing Toolbox is unavailable, you can use a custom peak finding logic:
    
    % --- Custom Peak Finding Logic ---
    % 1. Filter out samples below the threshold
    S_thresholded = spectrum_magnitude;
    S_thresholded(spectrum_dB < threshold_dB) = 0;
    
    % 2. Find local maxima using the 'diff' function
    % This is a simple approximation for local maxima
    [pks, locs] = findpeaks(S_thresholded); 
    
    % Filter out zero-magnitude locations (i.e., noise)
    valid_locs = locs(pks > 0);
    
    % --- End Custom Peak Finding Logic ---

    if isempty(valid_locs)
        detected_values = [];
        peak_indices = [];
        fprintf('  [Peak Detection] No significant peaks found in the %s.\n', domain_name);
        return;
    end
    
    peak_indices = valid_locs;
    
    % 4. Map Indices to Axis Values
    detected_values = axis_vector(peak_indices);

    fprintf('  [Peak Detection] Detected %d targets in the %s at values: %s\n', ...
            length(detected_values), domain_name, num2str(detected_values));
end