clear
%fid=fopen('/Users/Precise/Desktop/NTU/MVNL/personal report/16-10-12/data.txt'
formatSpec1='/Users/Precise/Desktop/NTU/MVNL/personal report/16-10-12/%s.txt';
formatSpec2='/Users/Precise/Desktop/NTU/MVNL/personal report/16-10-12/%s.png';
formatSpec3='/Users/Precise/Desktop/NTU/MVNL/personal report/16-10-12/%sfft.txt';
st='have'
str1=sprintf(formatSpec1,st)
str2=sprintf(formatSpec2,st)
str3=sprintf(formatSpec3,st)
M=csvread(str1);

x=M(:,4);
y=M(:,5);
z=M(:,6);

Fs = 167;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = length(x);             % Length of signal
t = (0:L-1)*T;        % Time vector

Y = fft(x);
P2 = abs(Y)/L;
P1 = P2(1:L/2+1); %%extract half of fft because of fft is symmatric of max sample rate
P3=P2(1:L/2+1);
P3(2:end-1) = 2*P1(2:end-1);



N=length(x);

hz=167;

f=(0:N-1)*hz/N;%t


xf=abs(fft(x,N))/N*2;
yf=abs(fft(y,N))/N*2;
zf=abs(fft(z,N))/N*2;


fig1=figure();
subplot(2,2,1);
plot(f,xf);
axis([0 200 0 max(xf(5:N/2))])
title('fft-x')

subplot(2,2,2);
plot(f,yf);
axis([0 200 0 max(yf(5:N/2))])
title('fft-y')

subplot(2,2,3);
plot(f,zf);
axis([0 200 0 max(zf(5:N/2))])
title('fft-z')
subplot(2,2,4);

plot(x,'r');
hold on
plot(y,'g');
plot(z,'b');
title('red:x,green:y,blue:z')
axis([0 N -20 20])


saveas(fig1,str2);



rank=30;
xm=zeros(1,30);
ym=zeros(1,30);
zm=zeros(1,30);

for i =1 :rank
[a,b]=max(xf(1:N/2));
xm(1,i)=round(b*hz/N);
xf(b,1)=0;
[a,b]=max(yf(1:N/2));
ym(1,i)=round(b*hz/N);
yf(b,1)=0;
[a,b]=max(zf(1:N/2));
zm(1,i)=round(b*hz/N);
zf(b,1)=0;
end

res=[ xm' sort(xm)' ym' sort(ym)' zm' sort(zm)']
fileID = fopen(str3,'w+');
fprintf(fileID,'%s\t%s\t%s\t%s\t%s\t%s\n','x','x','y','y','z','z');
for ii = 1:size(res,1)
    for jj=1:6
        fprintf(fileID,'%g\t',res(ii,jj));
    end
    fprintf(fileID,'\n');
end

%fclose()