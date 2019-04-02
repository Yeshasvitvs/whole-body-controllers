x =  -pi:0.01:pi;
y = 2*sin(12*x) + 3*cos(0.2*pi+2);
plot(x,y, 'k');
p = get(gca, 'Position');
h = axes('Parent', gcf, 'Position', [p(1)+.06 p(2)+.06 p(3)-.5 p(4)-.5]);
plot(h, x, y, 'r');
set(h, 'Xlim', [-0.2 0], 'Ylim', [-5 -4]);
set(h, 'XTick', [], 'YTick', []);