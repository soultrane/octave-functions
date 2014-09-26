% Plot a complex function

function Cplot
    res = 1000;
    mx = 10;
    xmin = ymin = -mx;
    xmax = ymax = mx;
    xres = yres = res;
    x = linspace(xmin,xmax,xres);
    y = linspace(ymin,ymax,yres);
    [x,y] = meshgrid(x,y);
    z = x+i*y;
    F = z;
    H = F;
    Y = ((z.^(1 + 3*i)));
    G = Y;
%%{
    figure(1);
    p = surf(real(z),imag(z),log10(abs(F)),(angle(-F)));
    set(p,'EdgeColor','none');
    caxis([-pi,pi]);
    colormap(hsv(256));
    view(0,90), axis equal;

    figure(2);
    p = surf(real(z),imag(z),log10(abs(H)),log10(abs(H)));
    set(p,'EdgeColor','none');
    caxis([-pi,pi]);
    colormap(gray(64));
    view(0,90), axis equal;
%}
%%{
    figure(3);
    p = surf(real(z),imag(z),log10(abs(Y)),angle(-Y));
    set(p,'EdgeColor','none');
    caxis([-pi,pi]);
    colormap(hsv(256));
    view(0,90), axis equal; 

    figure(4);
    p = surf(real(z),imag(z),log10(abs(G)),log10(abs(-G)));
    set(p,'EdgeColor','none');
    caxis([-pi,pi]);
    colormap(gray(64));
    view(0,90), axis equal; 
%}
end
