EbN0_dB = 1:11;
N = 1e6; % Total de bits (2N/2 = N símbolos QPSK)
ber_qpsk = zeros(size(EbN0_dB));

for i = 1:length(EbN0_dB)
    bits = randi([0 1], 1, 2*N);
    I = 2*bits(1:2:end) - 1;
    Q = 2*bits(2:2:end) - 1;
    symbols = (I + 1j*Q) / sqrt(2); % Normalizado

    EbN0 = 10^(EbN0_dB(i)/10);
    noise = (randn(1, N) + 1j*randn(1, N)) / sqrt(2 * EbN0);
    
    received = symbols + noise;
    
    detected_bits = zeros(1, 2*N);
    detected_bits(1:2:end) = real(received) > 0;
    detected_bits(2:2:end) = imag(received) > 0;

    ber_qpsk(i) = sum(bits ~= detected_bits) / (2*N);
end

semilogy(EbN0_dB, ber_qpsk, 'o-r', 'LineWidth', 1.5);
xlabel('Eb/N0 [dB]');
ylabel('Bit Error Rate (BER)');
title('BER vs Eb/N0 para QPSK');
grid on;
