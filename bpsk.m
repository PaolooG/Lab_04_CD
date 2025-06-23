EbN0_dB = 1:11;         % Rango de Eb/N0 en dB
N = 1e6;                % Número de bits
ber_bpsk = zeros(size(EbN0_dB));

for i = 1:length(EbN0_dB)
    bits = randi([0 1], 1, N);
    symbols = 2*bits - 1;   % Mapear 0 -> -1, 1 -> 1

    EbN0 = 10^(EbN0_dB(i)/10);
    noise = randn(1, N) / sqrt(2 * EbN0);
    
    received = symbols + noise;
    detected = received > 0;
    errors = sum(bits ~= detected);
    
    ber_bpsk(i) = errors / N;
end

semilogy(EbN0_dB, ber_bpsk, 'o-b', 'LineWidth', 1.5);
xlabel('Eb/N0 [dB]');
ylabel('Bit Error Rate (BER)');
title('BER vs Eb/N0 para BPSK');
grid on;
