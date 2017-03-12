function plotfft=nothing(hz,filename,dfs,tag)
    M=csvread(filename);
    x=M(:,3);
    y=M(:,4);
    z=M(:,5);

    Fs = hz;             % Sampling frequency
    T = 1/Fs;             % Sampling period
    L = length(x);        % Length of signal
    t = (0:L-1)*T;        % Time vector

    %%test for filter
    [B,A] = butter(10,30/(Fs/2),'high');
    x = filter(B,A,x);
        
    
    Y = fft(x);
    P2 = abs(Y)/L;
    P1 = P2(1:L/2+1); %%extract half of fft because of fft is symmatric of max sample rate
    P1(2:end-1) = 2*P1(2:end-1);
    f=(0:L/2)*Fs/L;
    
    f1=figure(1);
    plot(f,P1)
    axis([0 Fs/1.95 0 500])
    title('x');
    %plotfft=0;
    str1=sprintf('%s[%d][X]%s.fig',filename,dfs,tag);
    saveas(f1,str1);
    for i = 0:3
        str3=sprintf('%s_x_%d.mat',filename,i);
        mat_data = x(1+i*2048:(i+1)*2048);
        save(str3,'mat_data','-mat');
    end
    
    
    %%test for filter
    [B,A] = butter(10,30/(Fs/2),'high');
    y = filter(B,A,y);
    
    
    Y = fft(y);
    P2 = abs(Y)/L;
    P1 = P2(1:L/2+1); %%extract half of fft because of fft is symmatric of max sample rate
    P1(2:end-1) = 2*P1(2:end-1);
    f=(0:L/2)*Fs/L;
    plot(f,P1)
    axis([0 Fs/1.95 0 500])
    title('y');
    str2=sprintf('%s[%d][Y]%s.fig',filename,dfs,tag);
    saveas(f1,str2);
    for i = 0:3
        str3=sprintf('%s_y_%d.mat',filename,i);
        mat_data = y(1+i*2048:(i+1)*2048);
        save(str3,'mat_data','-mat');
    end
    
    
    %%test for filter
    [B,A] = butter(4,30/(Fs/2),'high');
    z = filter(B,A,z);
    
    
    
    Y = fft(z);
    P2 = abs(Y)/L;
    P1 = P2(1:L/2+1); %%extract half of fft because of fft is symmatric of max sample rate
    P1(2:end-1) = 2*P1(2:end-1);
    f=(0:L/2)*Fs/L;
    plot(f,P1)
    axis([0 Fs/1.95 0 500])
    title('z');
    str3=sprintf('%s[%d][Z]%s.fig',filename,dfs,tag);
    saveas(f1,str3);
    for i = 0:3
        str3 = sprintf('%s_z_%d.mat',filename,i);
        mat_data = z(1+i*2048:(i+1)*2048);
        save(str3,'mat_data','-mat');
    end
    
    
    
    a = angle(Y);
    
    %figure(4)
    %plot(a)
    plotfft=M;
    
    
    %%
    
    f2=figure(2);
    %plot wavelet spectrum
    subplot(2,1,1);
    plot(t,z); 
    axis tight
    title('Analyzed Signal');

    
    % Wavelet packet spectrum
    level = 5;
    wpt = wpdec(z,level,'sym8');
    subplot(2,1,2);
    [S,T,F] = wpspectrum(wpt,Fs,'plot');
    str3=sprintf('%s[%d][z]%s.fig',filename,dfs,'wps');
    saveas(f2,str3);
    
end