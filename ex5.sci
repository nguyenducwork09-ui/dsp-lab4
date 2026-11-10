funcprot(0);

function show_img(m, ttl)
    Matplot(m + 1);
    a = gca();
    a.isoview = "on";
    a.axes_visible = ["off", "off", "off"];
    title(ttl);
endfunction

function h = histo(m)
    h = zeros(1, 256);
    for k = 0:255
        h(k + 1) = sum(bool2s(m == k));
    end
endfunction

function show_hist(h, ttl)
    plot2d3(0:255, h, style = 2);
    xgrid();
    title(ttl);
    xlabel("Muc xam");
    ylabel("So pixel");
endfunction

function e = histeq(m)
    h = histo(m);
    c = cumsum(h) / sum(h);
    cmin = min(c(h > 0));
    map = round((c - cmin) / (1 - cmin) * 255);
    e = matrix(map(m + 1), size(m));
endfunction

n = 128;
[X, Y] = meshgrid(1:n, 1:n);
img = 70 + 0.3 * X + 12 * sin(Y / 9) + 35 * bool2s(((X - 64).^2 + (Y - 64).^2) < 28^2);
img = round(min(max(img, 0), 255));

h0 = histo(img);
eq = histeq(img);
h1 = histo(eq);

kernel = ones(5, 5) / 25;
blur = round(conv2(img, kernel, "same"));

wmask = (abs(X - 112) + abs(Y - 112)) < 12;
wmk = img;
wmk(wmask) = round(0.5 * img(wmask) + 0.5 * 255);

bits = bool2s(pmodulo(floor(X / 8) + floor(Y / 8), 2) == 1);
emb = img - pmodulo(img, 2) + bits;
ext = pmodulo(emb, 2);

scf(0);
clf();
f = gcf();
f.color_map = (0:255)' / 255 * [1 1 1];
subplot(2, 2, 1);
show_img(img, "Anh goc");
subplot(2, 2, 2);
show_hist(h0, "Histogram anh goc");
subplot(2, 2, 3);
show_img(eq, "Anh sau can bang histogram");
subplot(2, 2, 4);
show_hist(h1, "Histogram sau can bang");

scf(1);
clf();
f = gcf();
f.color_map = (0:255)' / 255 * [1 1 1];
subplot(2, 2, 1);
show_img(blur, "Lam mo (trung binh 5x5)");
subplot(2, 2, 2);
show_img(wmk, "Watermark nhin thay (alpha = 0.5)");
subplot(2, 2, 3);
show_img(emb, "Anh nhung watermark LSB");
subplot(2, 2, 4);
show_img(ext * 255, "Watermark LSB trich xuat");

mprintf("Min/Max anh goc: %d / %d\n", min(img), max(img));
mprintf("Min/Max sau can bang: %d / %d\n", min(eq), max(eq));
mprintf("Sai khac lon nhat do LSB: %d\n", max(abs(emb - img)));
mprintf("Trich xuat watermark LSB dung: %s\n", string(and(ext == bits)));
