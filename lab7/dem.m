clear

%%
fid = fopen('S01E036.hgt','r');
SRTM = fread(fid,[1201,inf],'int16','b');
fclose(fid);

%%
SRTM = SRTM';
SRTM = flipud(SRTM);
SRTM(find(SRTM==-32768)) = NaN;

%%
F = 1/9 * ones(3,3);
SRTM = filter2(F, SRTM(750:1200,750:1200));
SRTM = SRTM(2:449,2:449);

%%
figure(1)
h = pcolor(SRTM);
demcmap(SRTM), colorbar
set(h,'LineStyle','none')
axis equal
title('Elevation [m]')
[r c] = size(SRTM);
axis([1 c 1 r])
set(gca,'TickDir','out');

%%
refvec = [1200 0 0];
[asp, slp] = gradientm(SRTM, refvec);

%%
figure(2)
h = pcolor(slp);
colormap(jet), colorbar
set(h,'LineStyle','none')
axis equal
title('Slope [°]')
[r c] = size(slp);
axis([1 c 1 r])
set(gca,'TickDir','out');

%%
figure(3)
h = pcolor(asp);
colormap(hsv), colorbar
set(h,'LineStyle','none')
axis equal
title('Aspect')
[r c] = size(asp);
axis([1 c 1 r])
set(gca,'TickDir','out');

%%
watersh = watershed(SRTM);

%%
figure(4)
h = pcolor(watersh);
colormap(hsv), colorbar
set(h,'LineStyle','none')
axis equal
title('Watershed')
[r c] = size(watersh);
axis([1 c 1 r])
set(gca,'TickDir','out');

%%
sinks = 1*imregionalmin(SRTM);

%%
figure(5)
h = pcolor(sinks);
colormap(gray)
set(h,'LineStyle','none')
axis equal
title('Sinks')
[r c] = size(sinks);
axis([1 c 1 r])
set(gca,'TickDir','out');

%%
N = [0 -1;-1 -1;-1 0;+1 -1;0 +1;+1 +1;+1 0;-1 +1];
[a b] = size(SRTM);
grads = zeros(a,b,8);
for c = 2 : 2 : 8
 grads(:,:,c) = (circshift(SRTM,[N(c,1) N(c,2)]) ...
 -SRTM)/sqrt(2*90);
end
for c = 1 : 2 : 7
 grads(:,:,c) = (circshift(SRTM,[N(c,1) N(c,2)]) ...
 -SRTM)/90;
end
grads = atan(grads)/pi*2;

%%
w = 1.1;
flow = (grads.*(-1*grads<0)).^w;

%%
upssum = sum(flow,3);
upssum(upssum==0) = 1;

%%
for i = 1:8
 flow(:,:,i) = flow(:,:,i).*(flow(:,:,i)>0)./upssum;
end

%%
inflowsum = upssum;
flowac = upssum;

%%
inflow = grads*0;

%%
while sum(inflowsum(:))>0
 for i = 1:8
 inflow(:,:,i) = circshift(inflowsum,[N(i,1) N(i,2)]);
 end
 inflowsum = sum(inflow.*flow.*grads>0,3);
 flowac = flowac + inflowsum;
end

%%
figure(6)
h =pcolor(log(1+flowac));
colormap(flipud(jet)), colorbar
set(h,'LineStyle','none')
axis equal
title('Flow accumulation')
[r c] = size(flowac);
axis([1 c 1 r])
set(gca,'TickDir','out');

%%
weti = log((1+flowac)./tand(slp));

%%
figure(7)
h = pcolor(weti);
colormap(flipud(jet)), colorbar
set(h,'LineStyle','none')
axis equal
title('Wetness index')
[r c] = size(weti);
axis([1 c 1 r])
set(gca,'TickDir','out');

%%
spi = flowac.*tand(slp);

%%
figure(8)
h = pcolor(log(1+spi));
colormap(jet), colorbar
set(h,'LineStyle','none')
axis equal
title('Stream power index')
[r c] = size(spi);
axis([1 c 1 r])
set(gca,'TickDir','out');

