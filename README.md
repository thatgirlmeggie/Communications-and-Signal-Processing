# Communications-and-Signal-Processing
Aim: The aim of this process is to simulate a wireless communication link.  

Transmitter Structure and Tasks

For single-antenna system: 
• Random information bit generation for an OFDM symbol size of 2048.
• Mapping of the information bit sequence to Gray-coded 16-QAM 
constellation.
• OFDM symbol generation without and with comb-interleaved pilots.
• Cyclic prefix insertion: No CP, 16, 32, and 64 samples.
• Loop for Monte Carlo simulation of the communication link that runs for at 
least 106 16-QAM symbols per signal-to-noise ratio (SNR) point.

For multi-antenna system: 
• Simulation of the system directly in frequency domain.
• Extend the transmitter to MIMO.
• Simulation of 2 × 2, 2 × 5 and 2 × 10 MIMO systems.

Channel Specifications and Tasks

For single-antenna system, two different channels to be implemented:
• AWGN: SNR = 0-16 dB in steps of 1 dB
• Frequency selective multipath channel with impulse response h(n) and AWGN:
o ITU Pedestrian B, Channel 103.
o SNR: 0-40 dB in steps of 2 dB.
• Perfect symbol timing is assumed.
Code to perform:
• Computation of the theoretical standard deviation for the AWGN noise samples.
• Frequency response of the multipath channel.
• Channel filtering of the transmitted signal.

For multi-antenna system, the channels to be implemented:
• Rayleigh channels (complex Gaussian coefficients) in the presence of AWGN.
• Different Tx/Rx antenna combinations: 2 × 2, 2 × 5 and 2 × 10 MIMO systems.

Receiver Structure and Tasks for single-antenna system

FFT and 16-QAM demodulation using the minimum Euclidean distance approach.
• Zero Forcing equalization with perfect channel knowledge.
• ZF equalization with channel estimation using a comb distributed pilots, e.g. 1 
pilot for every 8 subcarriers.
• Constellation plots at the output of the equalizer for specific SNR point, e.g. 5, 15 
and 25 dB.
• Performance of mean square error (MSE) of channel estimation, 𝑒𝑀𝑆𝐸 =
𝐸{|𝐻 𝑛 − 𝐻෡(𝑛)|
2
}, vs. SNR for different cyclic prefix lengths and the two 
investigated multipath channels.
• BER vs. SNR in dB for the 2 channels and 2 receivers.
• For the AWGN channel no cyclic prefix is required.
• For the multipath channel + AWGN the ZF and MMSE receiver must be evaluated 
with or without channel knowledge and for the different cyclic prefix lengths.

Receiver Structure and Tasks for multi-antenna system

ZF equalization with perfect channel knowledge.
• MMSE equalization with perfect channel knowledge.
• BER vs. SNR in dB for the Rayleigh channel in the presence of AWGN 
for the 2 receivers (ZF, MMSE) and different Tx/Rx antenna 
combinations, i.e. 2 × 2, 2 × 5 and 2 × 10.
• For the AWGN channel select appropriate SNR range so that the 
performance is shown down to a BER range of 10^−5.
