function [fy,RMSE,MAE,U,OSR2]=OSforecast(y,x,isper)
% OS 1-step-ahead OS forecast using expanding windows

%   y <--> var to be forecast (T X 1 vector)
%   x <--> forecasting variables (s) (T X K matrix)
%   isper <--> in-sample period 


if max(x(:,1))>min(x(:,1)), x=[ones(numel(y),1),x]; end
T=numel(y)-isper;
fy=zeros(T,1);

for t=0:T-1
    Y=y(2:isper+t);
    X=x(1:isper+t-1,:);
    b=(X'*X)\(X'*Y);
    fy(t+1)=x(isper+t,:)*b;
end

cumavg = cumsum(y)./(1:numel(y))';
Y = y(isper+1:end);
e = Y - fy;
cumavg = cumavg(isper+1:end);
OSR2 = 1 - sum(e.^2)/sum((Y-cumavg).^2);
RMSE = sqrt(mean(e.^2));
MAE = mean(abs(e));
U = 1 - sum(e.^2)/sum((Y-y(isper:end-1)).^2); 


end