ii=0;
for i=0:0.1:1
    ii=ii+1;
    [density(ii),flow(ii)]=simulate_cars(i,0.5,false);
end

moveProb = 0:0.1:1;

linData = vertcat(moveProb,density,flow)';

fitlm(moveProb,density)
fitlm(moveProb,flow)