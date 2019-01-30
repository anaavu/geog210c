%% QUESTION 2
% PART 1

%load the data
load('var.mat');
%select -30 to 30 lat
var2 = var(:,21:41,:); 
%reshape into 2d
var2_reshaped = reshape(var2, 2520, 456); %smaller var reshaping
var_reshaped = reshape(var,7320,456); %original var reshaping

%EOF function acquired from the web; Credit: David M. Kaplan
%The zip file may contain two downloaded EOF codes, I used EOF_2 (not eof)
[L,EOFs,EC,error,norm] = EOF_2(var2_reshaped);
[L2,EOFs2,EC2,error2,norm2] = EOF_2(var_reshaped);
% EOFs stored in EOFs matrix. This represents temporal variability.
% PCs stored in ECs matrix. This represents spatial variability.

% Plotting

for i=1:120
    for j=1:61
        map(j,i)=var(i,j,1);
    end
end


figure(1)
subplot(2,2,1)
plot(EOFs(:,1))
title('EOF 1')
xlabel('EOF')
ylabel('PC')
%pcolor(lon1,lat1,map)
%shading interp
%colorbar

figure(1)
subplot(2,2,2)
plot(EOFs(:,2))
title('EOF 2')
xlabel('EOF')
ylabel('PC')

subplot(2,2,3)
plot(EOFs(:,3))
title('EOF 3')
xlabel('EOF')
ylabel('PC')

subplot(2,2,4)
plot(EOFs(:,4))
title('EOF 4')
xlabel('EOF')
ylabel('PC')

%The eigenvalues of the covariance matrix tells you the
%fraction of variance explained by each individual EOF.
%This is represented by L matrix.
%The first four eigenvalues representing total variation through each EOF
%are
%   33.7420
%   25.5596
%   13.7162
%   11.2190



%% PART 2 - 90% Variational accuracy
% Here, I did a little experimenting. What we are looking for is the number
% of timesteps needed to reach 90% accuracy, i.e. 90% of the total
% variation is explained by a limited number of EOFs/PCs. L tells us these
% values independently. And the total variation explained in L is:
sum(L) % = 276.9924
%90% of total variation is
.90*sum(L) % = 249.2932
add = 0; counter = 0;
for i=1:456
        add = add+L(i,1);
        counter = counter+1;
        if (add > 249.2932)
            break;
        end
end
%116 values are needed to reach 90% accuracy

intermediate = L2'*EOFs2;
reconstruct = intermediate*EC2';
var3_reshaped = reshape(reconstruct,120,61); 

[L3,EOFs3,EC3,error3,norm3] = EOF_2(var3_reshaped);

%new_L = L3-L2;
%% PART 3 - Orthogonality

   mult(1,1) = EOFs(:,1)'*EOFs(:,2);
   mult(2,1) = EOFs(:,1)'*EOFs(:,3);
   mult(3,1) = EOFs(:,1)'*EOFs(:,4);
   mult(4,1) = EOFs(:,2)'*EOFs(:,3);
   mult(5,1) = EOFs(:,2)'*EOFs(:,4);
   mult(6,1) = EOFs(:,3)'*EOFs(:,4);

   mult(1,2) = EC(:,1)'*EC(:,2);
   mult(2,2) = EC(:,1)'*EC(:,3);
   mult(3,2) = EC(:,1)'*EC(:,4);
   mult(4,2) = EC(:,2)'*EC(:,3);
   mult(5,2) = EC(:,2)'*EC(:,4);
   mult(6,2) = EC(:,3)'*EC(:,4);

% All values approach zero.

%% PART 4 - FFT/Power spectrum

figure(3)
periodogram(EC(:,1),rectwin(length(EC(:,1))),length(EC(:,1)))

corrcoef(EC2,var) % calculated to be .0094
