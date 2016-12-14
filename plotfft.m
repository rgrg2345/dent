function plotfft=nothing(hz,filename,dfs,tag)
    M=csvread(filename);
    x=M(:,4);
    y=M(:,5);
    z=M(:,6);

    Fs = hz;             % Sampling frequency
    T = 1/Fs;             % Sampling period
    L = length(x);        % Length of signal
    t = (0:L-1)*T;        % Time vector

    Y = fft(x);
    P2 = abs(Y)/L;
    P1 = P2(1:L/2+1); %%extract half of fft because of fft is symmatric of max sample rate
    P1(2:end-1) = 2*P1(2:end-1);
    f=(0:L/2)*Fs/L;
    
    f1=figure(1)
    plot(f,P1)
    axis([0 Fs/1.95 0 100])
    title('x');
    %plotfft=0;
    str1=sprintf('%s[%d][X]%s.png',filename,dfs,tag);
    saveas(f1,str1);
    
    f2=figure(2)
    Y = fft(y);
    P2 = abs(Y)/L;
    P1 = P2(1:L/2+1); %%extract half of fft because of fft is symmatric of max sample rate
    P1(2:end-1) = 2*P1(2:end-1);
    f=(0:L/2)*Fs/L;
    plot(f,P1)
    axis([0 Fs/1.95 0 100])
    title('y');
    str2=sprintf('%s[%d][Y]%s.png',filename,dfs,tag);
    saveas(f2,str2);
    
    f3=figure(3)
    Y = fft(z);
    P2 = abs(Y)/L;
    P1 = P2(1:L/2+1); %%extract half of fft because of fft is symmatric of max sample rate
    P1(2:end-1) = 2*P1(2:end-1);
    f=(0:L/2)*Fs/L;
    plot(f,P1)
    axis([0 Fs/1.95 0 100])
    title('z');
    str3=sprintf('%s[%d][Z]%s.png',filename,dfs,tag);
    saveas(f3,str3);
    a = angle(Y);
    
    plotfft=M;
end