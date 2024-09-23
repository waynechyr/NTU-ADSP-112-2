k = 16;
N = 2*k+1;
N_PTS = 10000;

hilbert = @(x) (x == 0)*0 + (0 < x & x <= 0.5)*(-1i) + (0.5 < x & x <= 1)*1i;

samples = arrayfun(hilbert, linspace(0, 1, N+1));
samples = samples(1:end-1);  % Exclude the last point because it is the same as the first point

% Add transition band 
samples(2)  = -0.9i;
samples(k+1) = -0.7i;
samples(k+2) =  0.7i;
samples(2*k+1)  = 0.9i;

r_1 = ifft(samples);
r_n = [r_1(ceil(N/2)+1:end), r_1(1:floor(N/2)+1)];  % + r_1[floor(N/2)] + r_1[:math.floor(N/2)]

R_F = zeros(1, N_PTS);
F = linspace(0, 1, N_PTS+1);
F = F(1:end-1);  % Exclude the last point because it is the same as the first point
for i = 1:length(F)
    F_i = F(i);
    s = 0;
    for n = -k:k
        s = s + r_n(n+k+1)*exp(-1i*2*pi*F_i*n);
    end
    R_F(i) = imag(s);
end

figure('Position', [10 10 900 400])
plot(F, R_F)
hold on
plot(F, imag(arrayfun(hilbert, F)))
title('Frequency Response')
legend('R(F)', 'H_d(F)')

figure('Position', [10 10 900 400])
stem(-k:k, r_n)
title('Impulse Response r[n]')
legend('r[n]')
