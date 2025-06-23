EbN0_dB = 1:11;
N = 1e6; % Número total de bits (N/3 símbolos)
ber_8psk = zeros(size(EbN0_dB));

% Definir constelación 8-PSK (8 puntos en el círculo unitario)
angles = (0:7) * 2*pi/8;
constellation = exp(1j * angles); % puntos complejos

% Convertir la constelación a pares [real imag] para knnsearch
constellation_realimag = [real(constellation(:)), imag(constellation(:))];

for i = 1:length(EbN0_dB)
    bits = randi([0 1], 1, 3*N); % 3 bits por símbolo
    bit_groups = reshape(bits, 3, []).';
    symbol_indices = bi2de(bit_groups, 'left-msb') + 1; % índice del símbolo (1 a 8)
    tx_symbols = constellation(symbol_indices);

    EbN0 = 10^(EbN0_dB(i)/10);
    noise = (randn(1, N) + 1j*randn(1, N)) / sqrt(2 * log2(8) * EbN0);
    rx_symbols = tx_symbols + noise;

    % Convertir rx a [real imag]
    rx_realimag = [real(rx_symbols(:)), imag(rx_symbols(:))];

    % Buscar el punto más cercano en la constelación
    detected_indices = knnsearch(constellation_realimag, rx_realimag);

    detected_bits = de2bi(detected_indices - 1, 3, 'left-msb').';
    detected_bits = detected_bits(:).';

    ber_8psk(i) = sum(bits ~= detected_bits) / (3*N);
end

semilogy(EbN0_dB, ber_8psk, 'o-g', 'LineWidth', 1.5);
xlabel('Eb/N0 [dB]');
ylabel('Bit Error Rate (BER)');
title('BER vs Eb/N0 para 8-PSK');
grid on;
