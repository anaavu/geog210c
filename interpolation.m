x=load('x.txt');
y=load('y.txt');
t=1:92;
linterpx=interp1(x(:,1),x(:,2),t,'linear');
ninterpx=interp1(x(:,1),x(:,2),t,'nearest');
cinterpx=interp1(x(:,1),x(:,2),t,'cubic');
sinterpx=interp1(x(:,1),x(:,2),t,'spline');

linterpy=interp1(y(:,1),y(:,2),t,'linear');
ninterpy=interp1(y(:,1),y(:,2),t,'nearest');
cinterpy=interp1(y(:,1),y(:,2),t,'cubic');
sinterpy=interp1(y(:,1),y(:,2),t,'spline');

corrcoef(linterpx,linterpy) %0.7871
corrcoef(ninterpx,ninterpy) %0.7894
corrcoef(cinterpx,cinterpy) %0.7888
corrcoef(sinterpx,sinterpy) %0.79$
%Spline

