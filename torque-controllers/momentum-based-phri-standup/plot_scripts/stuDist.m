x = [0:.1:10];
y1 = tpdf(x,5);   % For nu = 5
y2 = tpdf(x,25);  % For nu = 25
y3 = tpdf(x,50);  % For nu = 50

figure;
plot(x,y1,'Color','black','LineStyle','-')
hold on
plot(x,y2,'Color','red','LineStyle','-.')
plot(x,y3,'Color','blue','LineStyle','--')
legend({'nu = 5','nu = 25','nu = 50'})
hold off