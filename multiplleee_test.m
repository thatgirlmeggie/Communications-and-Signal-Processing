% System parameters
Nt = 2; % number of transmit antennas
Nr = 2; % number of receive antennas
mod_order = 16; % modulation order (16-QAM)
SNR_dB = 0:2:20; % SNR range in dB
sim_len = 1e4; % simulation length

% Set the seed value for the random number generator
rng(0);

% Generate known data sequence
known_data = [1 0 1 0 1 0 1 0];

% Repeat data sequence for the duration of the simulation
tx_data = repmat(known_data, Nt, ceil(sim_len/length(known_data)));
tx_data = tx_data(:, 1:sim_len);

% Modulate data
tx_symbols = qammod(tx_data, mod_order);

% Create the Rayleigh fading channel matrix
H = (randn(Nr, Nt) + 1i*randn(Nr, Nt))/sqrt(2);

% Initialize mmse_ber array
mmse_ber = zeros(size(SNR_dB));

% Generate noise
for snr_idx = 1:length(SNR_dB)
SNR = 10^(SNR_dB(snr_idx)/10); % convert SNR from dB to linear scale
noise = sqrt(1/SNR)*randn(Nr, sim_len) + 1i*sqrt(1/SNR)*randn(Nr, sim_len);

% Add noise to the received signal
rx_signal = H*tx_symbols + noise;

% ZF equalization with perfect channel knowledge
zfeq = inv(H)*rx_signal;

% MMSE equalization with perfect channel knowledge
mmseq = inv(H'*H + eye(Nt)/SNR)*H'*rx_signal;

% Calculate bit error rate (BER) for ZF equalization
[~, zfeq_data] = min(abs(repmat(zfeq, [1 1 mod_order]) - repmat(reshape(qammod(0:mod_order-1, mod_order), [1 1 mod_order]), [Nr sim_len 1])), [], 3);
zfeq_ber(snr_idx) = sum(sum(zfeq_data ~= tx_data))/(Nt*sim_len);
zfeq_symbols = zfeq(:);
scatterplot(zfeq_symbols);
title('Equalized Symbols (ZF)');

% Calculate bit error rate (BER) for MMSE equalization and store the result in the mmse_ber array
[~, mmseq_data] = min(abs(repmat(mmseq, [1 1 mod_order]) - repmat(reshape(qammod(0:mod_order-1, mod_order), [1 1 mod_order]), [Nr sim_len 1])), [], 3);
mmse_ber(snr_idx) = sum(sum(mmseq_data ~= tx_data))/(Nt*sim_len);
zfeq_symbols = zfeq(:);
scatterplot(zfeq_symbols);
title('Equalized Symbols (ZF)');
end

% Plot BER vs SNR curves
figure;
semilogy(SNR_dB, zfeq_ber, '-o', 'LineWidth', 2); % plot ZF equalization BER vs. SNR curve
hold on;
semilogy(SNR_dB, mmse_ber, '-s', 'LineWidth', 2); % plot MMSE equalization BER vs. SNR curve
grid on;
xlabel('SNR (dB)');
ylabel('BER');
legend('ZF equalization', 'MMSE equalization');
title(sprintf('%d x %d MIMO System', Nt, Nr));
