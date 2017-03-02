function readfft=nothing(hz,filename,tag)
    M=csvread(filename);
    x=M(:,3);
    y=M(:,4);
    z=M(:,5);

    Fs = hz;             % Sampling frequency
    T = 1/Fs;             % Sampling period
    L = length(x);        % Length of signal
    t = (0:L-1)*T;        % Time vector

    %%x
    [B,A] = butter(10,30/(Fs/2),'high');
    x = filter(B,A,x);
        
    
    Y = fft(x);
    P2 = abs(Y)/L;
    P1 = P2(1:L/2+1); %%extract half of fft because of fft is symmatric of max sample rate
    P1(2:end-1) = 2*P1(2:end-1);
    P1_x = P1;
    f=(0:L/2)*Fs/L;
    
    
    %%y
    [B,A] = butter(10,30/(Fs/2),'high');
    y = filter(B,A,y);
    
    
    Y = fft(y);
    P2 = abs(Y)/L;
    P1 = P2(1:L/2+1); %%extract half of fft because of fft is symmatric of max sample rate
    P1(2:end-1) = 2*P1(2:end-1);
    P1_y = P1;
    
    
    %%z
    [B,A] = butter(4,30/(Fs/2),'high');
    z = filter(B,A,z);

    Y = fft(z);
    P2 = abs(Y)/L;
    P1 = P2(1:L/2+1); %%extract half of fft because of fft is symmatric of max sample rate
    P1(2:end-1) = 2*P1(2:end-1);
    P1_z = P1;
%     plot(f,P1)
%     axis([0 Fs/1.95 0 100])
%     title('z');
    
    %% Output analysis
    time = 0:0.1:hz/2-0.1;
    tmpx =interp1(f,P1_x,time);
    tmpy =interp1(f,P1_y,time);
    tmpz =interp1(f,P1_z,time);
    fileID = fopen(sprintf('%s_fft.txt',tag),'w+');
    for i = 1:size(time,2)
        fprintf(fileID,'%f,%f,%f,%f\n',time(i),tmpx(i),tmpy(i),tmpz(i));
    end
    readfft=tmpx;
end