function mat2fft=nothing(path,startl,endl,hz)

    %init variable
    len = endl - startl + 1;
    Fs = hz;              % Sampling frequency
    T = 1/Fs;             % Sampling period
    titlename = ['x' 'y' 'z'];

    %% load x mat and apply fft
    axis([0 Fs/1.95 0 500]) 
    for k = 1 : 3
        fig = figure(k);

        for i = 1 : len
            for j = 0 :3
                filename = sprintf('%s.txt_%s_%d.mat',pad(startl+i-1),titlename(k),j);
                load(filename,'-mat')

                L = length(mat_data);        % Length of signal
                t = (0:L-1)*T;               % Time vector
                f = (0:L/2)*Fs/L;

                %% low pass filter
                [B,A] = butter(10,30/(Fs/2),'high');
                mat_data = filter(B,A,mat_data);

                Y = fft(mat_data);
                P2 = abs(Y)/L;
                P1 = P2(1:L/2+1); %%extract half of fft because of fft is symmatric of max sample rate
                P1 = 2 * P1;

                subplot(len,4,(i-1)*4+j+1);
                plot(f,P1)
                title(titlename(k));
            end
        end
        str = sprintf('sampling_fft[%d-%d]%s.fig',startl,endl,titlename(k));
        saveas(fig,str);
    end
end
%% padding
function padding = pad(index)
    index = sprintf('%d',index);
    len = numel(index);
    str = '';

    for i = 1 : 5 - len
        str = sprintf('0%s',str); 
    end

    padding = sprintf('%s%s',str,index);

end
