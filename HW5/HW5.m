% Type signal length N
N = input('Type signal length N: ');

% Random N point real signal x 和 y
x = randn(N, 1);
y = randn(N, 1);

disp('signal x:');
disp(x);

disp('signal y:');
disp(y);

% calculate FFT
[Fx, Fy] = fftreal(x, y);

% Result
disp('FFT of x:');
disp(Fx);

disp('FFT of y:');
disp(Fy);

function [Fx, Fy] = fftreal(x, y)
    fx = x(:);
    fy = y(:);

    % step 1
    fz = fx + 1i * fy;

    % step 2
    Fz = fft(fz);

    % step 3
    N = length(Fz);

    Fx = (Fz + conj(Fz(N:-1:1))) / 2;
    Fy = (Fz - conj(Fz(N:-1:1))) / (2i);

    Fx = real(Fx);
    Fy = real(Fy);
end

