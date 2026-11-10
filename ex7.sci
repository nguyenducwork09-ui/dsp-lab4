funcprot(0);

function stem2(n, y, col)
    plot2d3(n, y, style = col);
    a = gca();
    a.data_bounds = [min(n) - 1, min(0, min(y)) - 1; max(n) + 1, max(0, max(y)) + 1];
    xgrid();
endfunction

x = [1 2 -3 2 1];
h = [1 0 -1 -1 1];
N = length(x);
M = length(h);
n = 0:N-1;

y1 = zeros(1, N);
for i = 0:N-1
    xs = zeros(1, M);
    for k = 0:M-1
        xs(k + 1) = x(pmodulo(i - k, N) + 1);
    end
    y1(i + 1) = sum(h .* xs);
    mprintf("n = %d: x[(n-k) mod N] = [%s], y(n) = %g\n", i, strcat(string(xs), " "), y1(i + 1));
end

Xc = zeros(N, M);
for i = 0:N-1
    for k = 0:M-1
        Xc(i + 1, k + 1) = x(pmodulo(i - k, N) + 1);
    end
end
y2 = (Xc * h')';

disp(Xc);
mprintf("Folding and shifting: %s\n", strcat(string(y1), " "));
mprintf("Matrix method       : %s\n", strcat(string(y2), " "));
mprintf("Sai khac lon nhat   : %g\n", max(abs(y1 - y2)));

if M == N then
    y3 = real(ifft(fft(x) .* fft(h)));
    mprintf("FFT                 : %s\n", strcat(string(round(y3 * 1e6) / 1e6), " "));
end

Ex = sum(x.^2);
Ey = sum(y1.^2);
mprintf("Nang luong x(n) = %g, nang luong y(n) = %g\n", Ex, Ey);

scf(0);
clf();
subplot(2, 2, 1);
stem2(n, x, 2);
title("x(n)");
xlabel("n");
subplot(2, 2, 2);
stem2(n, y1, 5);
title("y(n) = x(n) (*) h(n), tich chap vong");
xlabel("n");
subplot(2, 2, 3);
stem2(n, x.^2, 2);
title(msprintf("Nang luong x(n), tong = %g", Ex));
xlabel("n");
subplot(2, 2, 4);
stem2(n, y1.^2, 5);
title(msprintf("Nang luong y(n), tong = %g", Ey));
xlabel("n");
