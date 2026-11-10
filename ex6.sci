funcprot(0);

function stem2(n, y, col)
    plot2d3(n, y, style = col);
    a = gca();
    a.data_bounds = [min(n) - 1, min(0, min(y)) - 1; max(n) + 1, max(0, max(y)) + 1];
    xgrid();
endfunction

x = [1 2 -3 2 1];
nx = 0:4;
h = [1 0 -1];
nh = 0:2;

Nx = length(x);
ny = (nx(1) + nh(1)):(nx($) + nh($));
Ny = length(ny);

y1 = zeros(1, Ny);
for i = 1:Ny
    n = ny(i);
    hs = zeros(1, Nx);
    for j = 1:Nx
        m = n - nx(j);
        if m >= nh(1) & m <= nh($) then
            hs(j) = h(m - nh(1) + 1);
        end
    end
    y1(i) = sum(x .* hs);
    mprintf("n = %d: h(n-k) = [%s], y(n) = %g\n", n, strcat(string(hs), " "), y1(i));
end

H = zeros(Ny, Nx);
for i = 1:Ny
    for j = 1:Nx
        m = ny(i) - nx(j);
        if m >= nh(1) & m <= nh($) then
            H(i, j) = h(m - nh(1) + 1);
        end
    end
end
y2 = (H * x')';

y3 = convol(x, h);

disp(H);
mprintf("Folding and shifting: %s\n", strcat(string(y1), " "));
mprintf("Matrix method       : %s\n", strcat(string(y2), " "));
mprintf("convol              : %s\n", strcat(string(y3), " "));
mprintf("Sai khac lon nhat   : %g\n", max(abs(y1 - y2)) + max(abs(y1 - y3)));

Ex = sum(x.^2);
Ey = sum(y1.^2);
mprintf("Nang luong x(n) = %g, nang luong y(n) = %g\n", Ex, Ey);

scf(0);
clf();
subplot(2, 2, 1);
stem2(nx, x, 2);
title("x(n)");
xlabel("n");
subplot(2, 2, 2);
stem2(ny, y1, 5);
title("y(n) = x(n) * h(n)");
xlabel("n");
subplot(2, 2, 3);
stem2(nx, x.^2, 2);
title(msprintf("Nang luong x(n), tong = %g", Ex));
xlabel("n");
subplot(2, 2, 4);
stem2(ny, y1.^2, 5);
title(msprintf("Nang luong y(n), tong = %g", Ey));
xlabel("n");
