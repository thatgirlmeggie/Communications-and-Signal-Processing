% Set random number generator seed for reproducibility
rng(123);

% Generate known information bits for an OFDM symbol size of 2048
bits = randi([0,1], 1, 2048);

% Map the information bit sequence to Gray-coded 16-QAM constellation
symbols = qammod(bits, 16, 'gray', 'UnitAveragePower', true);

% Plot the QAM constellation
scatterplot(symbols);
title('16-QAM Constellation');

% Perform OFDM symbol generation without comb-interleaved pilots
ofdm_symbols = ifft(symbols);

% Insert cyclic prefix of length 0, 16, 32, and 64 samples
ofdm_symbols_cp0 = ofdm_symbols;
ofdm_symbols_cp16 = circshift(ofdm_symbols,[0,16]);
ofdm_symbols_cp32 = circshift(ofdm_symbols,[0,32]);
ofdm_symbols_cp64 = circshift(ofdm_symbols,[0,64]);

% Plot the time-domain signal for each cyclic prefix length
subplot(2,2,1);
stem(real(ofdm_symbols_cp0));
title('OFDM Signal with CP Length 0');
subplot(2,2,2);
stem(real(ofdm_symbols_cp16));
title('OFDM Signal with CP Length 16');
subplot(2,2,3);
stem(real(ofdm_symbols_cp32));
title('OFDM Signal with CP Length 32');
subplot(2,2,4);
stem(real(ofdm_symbols_cp64));
title('OFDM Signal with CP Length 64');

% Initialize BER vector with zeros
num_simulations = 10000;
BER = zeros(1,6);

% Monte Carlo simulation for AWGN channel
for SNR = 0:5:25
    % AWGN channel
    rx_symbols = awgn(ofdm_symbols, SNR);
    
    % Plot the received signal
    figure;
    stem(real(rx_symbols));
    title(['Received Signal at SNR = ' num2str(SNR) ' dB']);
    
    % Perform OFDM demodulation
    demod_symbols = fft(rx_symbols);
    
    % Plot the demodulated symbols
    figure;
    scatterplot(demod_symbols);
    title(['Demodulated Symbols at SNR = ' num2str(SNR) ' dB']);
    
    % Perform 16-QAM demodulation using the minimum Euclidean distance approach
    demod_bits = qamdemod(demod_symbols, 16, 'gray', 'UnitAveragePower', true);
    
    % Plot the bit errors
    figure;
    stem(find(demod_bits ~= bits), ones(1,sum(demod_bits ~= bits)), 'r');
    hold on;
    stem(find(demod_bits == bits), ones(1,sum(demod_bits == bits)), 'g');
    title(['Bit Errors at SNR = ' num2str(SNR) ' dB']);
    
    % Compute BER
    errors = sum(demod_bits ~= bits);
    BER(SNR/5 + 1) = errors / length(bits);
end

% Initialize BER_multipath vector with zeros
BER_multipath = zeros(1,6);

% Monte Carlo simulation for frequency selective multipath channel with impulse response h(n) and AWGN (ITU Pedestrian B, Channel 103)
% Create a impulse response of an AWGN channel with a delay of 0, 1, and 2 OFDM symbol periods
h1 = [1, 0.2, 0.4, 0.3, 0.1];
h2 = [0.1, 0.3, 0.4, 0.2, 1];
h3 = [0.3, 0.2, 1, 0.2, 0.3];
h = [h1; h2; h3];

% Normalize the impulse response to have a maximum amplitude of 1
h = h / max(abs(h(:)));

% Create a random delay for the impulse response
delay = randi([0, 2048], 1, size(h,1));

% Initialize BER vector with zeros
num_simulations = 10000;
BER_multipath = zeros(1,6);

for SNR = 0:5:25
% Frequency selective multipath channel
rx_symbols_multipath = filter(h, 1, ofdm_symbols);
rx_symbols_multipath_delayed = zeros(size(rx_symbols_multipath));
for i = 1:size(h,1)
rx_symbols_multipath_delayed(i,:) = circshift(rx_symbols_multipath(i,:), delay(i));
end

rx_symbols_multipath = sum(rx_symbols_multipath_delayed);
rx_symbols_multipath = awgn(rx_symbols_multipath, SNR);

% Perform OFDM demodulation
demod_symbols_multipath = fft(rx_symbols_multipath);

% Perform 16-QAM demodulation using the minimum Euclidean distance approach
demod_bits_multipath = qamdemod(demod_symbols_multipath, 16, 'gray', 'UnitAveragePower', true);

% Compute BER
errors_multipath = sum(demod_bits_multipath ~= bits);
BER_multipath(SNR/5 + 1) = errors_multipath / length(bits);
end

% Plot the BER for the AWGN and multipath channels
figure;
semilogy(0:5:25, BER, 'o-', 'LineWidth', 2);
hold on;
semilogy(0:5:25, BER_multipath, 'o-', 'LineWidth', 2);
grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate');
legend('AWGN Channel', 'Frequency Selective Multipath Channel');
title('Bit Error Rate vs. SNR');

