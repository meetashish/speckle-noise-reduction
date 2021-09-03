

% This script Analysis.m is used to analyse various low pass filters used
% for suppressing or de-noising speckle noise introduced in Medical Imaging.
% Filters applied for this purpose are
%            1. Median Filter
%            2. Adaptive Weighted Median Filter
%            3. Fourier Ideal Filter
%            4. Butterworth Filter
%            5. Wavelet Filter
%            6. Homomorphic AWMF Filter
%            7. Homomorphic Ideal Filter
%            8. Homomorphic Butterworth Filter
%            9. Homomorphic Wavelet Filter
%                                                                    
% For comparision between various filters Performance Metrics such as
% MSE (Mean Square Error); SNR (Signal-to-Noise Ratio); PSNR (Pixel Signal-to-Noise Ratio)
% and Beta are used; all this performace metrics are being written in
% separate sheets of Microsoft Excel File named as Performance Metrics.xls

% ASHISH MESHRAM (meetashish85@gmail.com

clear;clc;%---Clear workspace and command window
%---Read image form the specified path and assign it to In
In = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';'*.*','All Files' },'Select Image File');
In = imread(In);%---Read iamge and assign it to In
I_Pre = Preprocess(In);%---Preprocessing Original Image
Ig = I_Pre.Ig;%---Assigning Image of double class to Ig
figure(1);subplot(1,2,1);imshow(In);%---Show Original Image on first Figure window
%---Check for RGB or Gray Scale Image
if I_Pre.o==1
    title('Original Grayscale Image');%---Title for Original Grayscale Image
else
    title('Original RGB Image');%---Title for Original RGB Image
end
figure(1);subplot(1,2,2);imshow(Ig);%---Show grayscale Image on first Figure window
%---Title for Grayscale double class image of an Original Image
title('Grayscale double class image of an Original Image');

%-----------------------------Analysis Starts-----------------------------%

%-------------------------Median Filter Analysis--------------------------%

%---Creating cell Fields for passing it to an excel file
Fields = {'Filter','Window','MSE','PSNR','SNR'};
%---Excel file in which performance metrics has to be written
xlswrite('Performance Metrics.xls', Fields, 1, 'A1');%---Writing on 1st sheet
for c = [3 5 8 10]
    I_anyl = NSRFilters(In,'med',c,c);%---Applying median filter
    if c == 3
        i = 1;
    elseif c == 5
        i = 2;
    elseif c == 8
        i = 3;
    else
        i = 4;
    end
    figure(2);subplot(2,2,i);imshow(I_anyl);%---Show Filtered Image on second Figure window
    title(['Filtered Image using Median Filter; window size = ',num2str(c)]);
    QM(i) = MetricsMeasurement(Ig,I_anyl);%---Calculating Performance Metrics
    mfmse(i) = QM(i).M_SE;mfpsnr(i) = QM(i).PSNR; mfsnr(i) = QM(i).SNR;
    QMxls = {'Median',c,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
    index_num = i+1;
    index = num2str(index_num);
    cell = strcat('A',index);
    xlswrite('Performance Metrics.xls', QMxls, 1, cell);%---Writing on 1st sheet
end
c = [3 5 8 10];
axis square;
figure(11);subplot(2,2,1);
semilogy(c,mfmse,'-ro',c,mfpsnr,'-ms',c,mfsnr,'-bd');
legend('MSE','PSNR','SNR',0);
xlabel('Window Size');
ylabel('Performance Metrics');
title('Variation in performance metrics with window size for Median Filter');

%---------------------Fourier Ideal Filter Analysis-----------------------%

%---Creating cell Fields for passing it to an excel file
Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
%---Excel file in which performance metrics has to be written
xlswrite('Performance Metrics.xls', Fields, 2, 'A1');%---Writing on 2nd sheet
for c = [10 20 30 40];%---Cutoff frequency for Fourier Ideal Filter
    I_anyl = NSRFilters(In,'ideal',c);%---Applying Ideal filter
    if c == 10
        i = 1;
    elseif c == 20
        i = 2;
    elseif c == 30
        i = 3;
    else
        i = 4;
    end
    figure(3);subplot(2,2,i);imshow(I_anyl);%---Show Filtered Image on second Figure window
    title(['Filtered Image using Ideal Filter; Cutoff frequency = ',num2str(c)]);
    QM(i) = MetricsMeasurement(Ig,I_anyl);%---Calculating Performance Metrics
    ifmse(i) = QM(i).M_SE;ifpsnr(i) = QM(i).PSNR; ifsnr(i) = QM(i).SNR;
    QMxls = {'Fourier Ideal Filter',c,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
    index_num = i+1;
    index = num2str(index_num);
    cell = strcat('A',index);
    xlswrite('Performance Metrics.xls', QMxls, 2, cell);%---Writing on 2nd sheet
end
c = [10 20 30 40];
axis square;
figure(11);subplot(2,2,2);
semilogy(c,ifmse,'-ro',c,ifpsnr,'-ms',c,ifsnr,'-bd');
legend('MSE','PSNR','SNR',0);
xlabel('Cutoff Frequency');
ylabel('Performacne Metrics');
title('Variation in performance metrics with Cutoff frequency for Ideal Filter');

%-----------------Fourier Butterworth Filter Analysis---------------------%

%---Creating cell Fields for passing it to an excel file
Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
%---Excel file in which performance metrics has to be written
xlswrite('Performance Metrics.xls', Fields, 3, 'A1');%---Writing on 3rd sheet
for c = [10 20 30 40];%---Cutoff frequency for Fourier Butterworth Filter
    I_anyl = NSRFilters(In,'btw',c,2);%---Applying Butterworth filter
    if c == 10
        i = 1;
    elseif c == 20
        i = 2;
    elseif c == 30
        i = 3;
    else
        i = 4;
    end
    figure(4);subplot(2,2,i);imshow(I_anyl);%---Show Filtered Image on second Figure window
    title(['Filtered Image using Butterworth Filter; Cutoff frequency = ',num2str(c)]);
    QM(i) = MetricsMeasurement(Ig,I_anyl);%---Calculating Performance Metrics
    bfmse(i) = QM(i).M_SE;bfpsnr(i) = QM(i).PSNR; bfsnr(i) = QM(i).SNR;
    QMxls = {'Fourier Butterworth Filter',c,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
    index_num = i+1;
    index = num2str(index_num);
    cell = strcat('A',index);
    xlswrite('Performance Metrics.xls', QMxls, 3, cell);%---Writing on 3rd sheet
end
c = [10 20 30 40];
axis square;
figure(11);subplot(2,2,3);
semilogy(c,bfmse,'-ro',c,bfpsnr,'-ms',c,bfsnr,'-bd');
legend('MSE','PSNR','SNR',0);
xlabel('Cutoff Frequency');
ylabel('Performacne Metrics');
title('Variation in performance metrics with Cutoff frequency for Butterworth Filter');

%----------Wavelet Filter Analysis (Single Level Decoposition)------------%

%---Creating cell Fields for passing it to an excel file
Fields = {'Filter','Level','Band','MSE','PSNR','SNR'};
%---Excel file in which performance metrics has to be written
xlswrite('Performance Metrics.xls', Fields, 4, 'A1');%---Writing on 4th sheet
for i = 1:3;
    level = 1;
    if i == 1
        bn = 'HL';
        I_anyl = NSRFilters(In,'wlet',bn,'db1',level);
    elseif i == 2
        bn = 'LH';
        I_anyl = NSRFilters(In,'wlet',bn,'db1',level);
    else
        bn = 'HH';
        I_anyl = NSRFilters(In,'wlet',bn,'db1',level);
    end
    figure(5);subplot(2,2,i);imshow(I_anyl);%---Show Filtered Image on sixth Figure window
    title(['Filtered Image using Wavelet Filter; Band Eliminated = ',bn]);
    QM(i) = MetricsMeasurement(Ig,I_anyl);%---Calculating Performance Metrics
    w1fmse(i) = QM(i).M_SE;w1fpsnr(i) = QM(i).PSNR; w1fsnr(i) = QM(i).SNR;
    QMxls = {'Wavelet Filter',level,bn,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
    index_num = i+1;
    index = num2str(index_num);
    cell = strcat('A',index);
    xlswrite('Performance Metrics.xls', QMxls, 4, cell);%---Writing on 4th sheet
end
c = [1 2 3];
axis square;
figure(11);subplot(2,2,4);
semilogy(c,w1fmse,'-ro',c,w1fpsnr,'-ms',c,w1fsnr,'-bd');
legend('MSE','PSNR','SNR',0);
xlabel('Cutoff Frequency');
ylabel('Performacne Metrics');
title('Variation in performance metrics with band elimination for Wavelet Filter for single level decomposition');

%----------Wavelet Filter Analysis (Double Level Decoposition)------------%

%---Creating cell Fields for passing it to an excel file
Fields = {'Filter','Level','Band','MSE','PSNR','SNR'};
%---Excel file in which performance metrics has to be written
xlswrite('Performance Metrics.xls', Fields, 5, 'A1');%---Writing on 5th sheet
for i = 1:4;
    level = 2;
    if i == 1
        bn = 'HL';
        I_anyl = NSRFilters(In,'wlet',bn,'db1',level);
    elseif i == 2
        bn = 'LH';
        I_anyl = NSRFilters(In,'wlet',bn,'db1',level);
    elseif i == 3
        bn = 'HH';
        I_anyl = NSRFilters(In,'wlet',bn,'db1',level);
    else
        bn = 'LH-HH';
        I_anyl = NSRFilters(In,'wlet',bn,'db1',level);
    end
    figure(6);subplot(2,2,i);imshow(I_anyl);%---Show Filtered Image on sixth Figure window
    title(['Filtered Image using Wavelet Filter; Band Eliminated = ',bn]);
    QM(i) = MetricsMeasurement(Ig,I_anyl);%---Calculating Performance Metrics
    w2fmse(i) = QM(i).M_SE;w2fpsnr(i) = QM(i).PSNR; w2fsnr(i) = QM(i).SNR;
    QMxls = {'Wavelet Filter',level,bn,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
    index_num = i+1;
    index = num2str(index_num);
    cell = strcat('A',index);
    xlswrite('Performance Metrics.xls', QMxls, 5, cell);%---Writing on 5th sheet
end
c = [1 2 3 4];
axis square;
figure(12);subplot(2,2,1);
semilogy(c,w2fmse,'-ro',c,w2fpsnr,'-ms',c,w2fsnr,'-bd');
legend('MSE','PSNR','SNR',0);
xlabel('Cutoff Frequency');
ylabel('Performacne Metrics');
title('Variation in performance metrics with band elimination for Wavelet Filter for second level decomposition');


%----------------Homomorphic Fourier Ideal Filter Analysis----------------%

%---Creating cell Fields for passing it to an excel file
Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
%---Excel file in which performance metrics has to be written
xlswrite('Performance Metrics.xls', Fields, 6, 'A1');%---Writing on 6th sheet
for c = [10 20 30 40];%---Cutoff frequency for Fourier Ideal Filter
    I_anyl = NSRFilters(In,'hmp-ideal',c);%---Applying Ideal filter
    if c == 10
        i = 1;
    elseif c == 20
        i = 2;
    elseif c == 30
        i = 3;
    else
        i = 4;
    end
    figure(7);subplot(2,2,i);imshow(I_anyl);%---Show Filtered Image on second Figure window
    title(['Filtered Image using Homomorphic Ideal Filter; Cutoff frequency = ',num2str(c)]);
    QM(i) = MetricsMeasurement(Ig,I_anyl);%---Calculating Performance Metrics
    hifmse(i) = QM(i).M_SE;hifpsnr(i) = QM(i).PSNR; hifsnr(i) = QM(i).SNR;
    QMxls = {'Homomorphic Fourier Ideal Filter',c,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
    index_num = i+1;
    index = num2str(index_num);
    cell = strcat('A',index);
    xlswrite('Performance Metrics.xls', QMxls, 6, cell);%---Writing on 6th sheet
end
c = [10 20 30 40];
axis square;
figure(12);subplot(2,2,2);
semilogy(c,hifmse,'-ro',c,hifpsnr,'-ms',c,hifsnr,'-bd');
legend('MSE','PSNR','SNR',0);
xlabel('Cutoff Frequency');
ylabel('Performacne Metrics');
title('Variation in performance metrics with Cutoff frequency for Homomorphic Using Ideal Filter');


%--------------Homomorphic Fourier Butterworth Filter Analysis------------%

%---Creating cell Fields for passing it to an excel file
Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
%---Excel file in which performance metrics has to be written
xlswrite('Performance Metrics.xls', Fields, 7, 'A1');%---Writing on 7th sheet
for c = [10 20 30 40];%---Cutoff frequency for Fourier Ideal Filter
    I_anyl = NSRFilters(In,'hmp-btw',c,2);%---Applying Ideal filter
    if c == 10
        i = 1;
    elseif c == 20
        i = 2;
    elseif c == 30
        i = 3;
    else
        i = 4;
    end
    figure(8);subplot(2,2,i);imshow(I_anyl);%---Show Filtered Image on second Figure window
    title(['Filtered Image using Homomorphic Ideal Filter; Cutoff frequency = ',num2str(c)]);
    QM(i) = MetricsMeasurement(Ig,I_anyl);%---Calculating Performance Metrics
    hbfmse(i) = QM(i).M_SE;hbfpsnr(i) = QM(i).PSNR; hbfsnr(i) = QM(i).SNR;
    QMxls = {'Homomorphic Fourier Butterworth Filter',c,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
    index_num = i+1;
    index = num2str(index_num);
    cell = strcat('A',index);
    xlswrite('Performance Metrics.xls', QMxls, 7, cell);%---Writing on 7th sheet
end
c = [10 20 30 40];
axis square;
figure(12);subplot(2,2,3);
semilogy(c,hbfmse,'-ro',c,hbfpsnr,'-ms',c,hbfsnr,'-bd');
legend('MSE','PSNR','SNR',0);
xlabel('Cutoff Frequency');
ylabel('Performacne Metrics');
title('Variation in performance metrics with Cutoff frequency for Homomorphic Butterworth Filter');


%-----Homomorphic Wavelet Filter Analysis (Single Level Decomposition)----%

%---Creating cell Fields for passing it to an excel file
Fields = {'Filter','Level','Band','MSE','PSNR','SNR'};
%---Excel file in which performance metrics has to be written
xlswrite('Performance Metrics.xls', Fields, 8, 'A1');%---Writing on 8th sheet
for i = 1:4;
    level = 1;
    if i == 1
        bn = 'HL';
        I_anyl = NSRFilters(In,'hmp-wlet',bn,'db1',level);
    elseif i == 2
        bn = 'LH';
        I_anyl = NSRFilters(In,'hmp-wlet',bn,'db1',level);
    elseif i == 3
        bn = 'HH';
        I_anyl = NSRFilters(In,'hmp-wlet',bn,'db1',level);
    else
        bn = 'LH-HH';
        I_anyl = NSRFilters(In,'hmp-wlet',bn,'db1',level);
    end
    figure(9);subplot(2,2,i);imshow(I_anyl);%---Show Filtered Image on sixth Figure window
    title(['Filtered Image using Wavelet Filter; Band Eliminated = ',bn]);
    QM(i) = MetricsMeasurement(Ig,I_anyl);%---Calculating Performance Metrics
    hw1fmse(i) = QM(i).M_SE;hw1fpsnr(i) = QM(i).PSNR; hw1fsnr(i) = QM(i).SNR;
    QMxls = {'Wavelet Filter',level,bn,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
    index_num = i+1;
    index = num2str(index_num);
    cell = strcat('A',index);
    xlswrite('Performance Metrics.xls', QMxls, 8, cell);%---Writing on 8th sheet
end
c = [1 2 3 4];
axis square;
figure(12);subplot(2,2,4);
semilogy(c,hw1fmse,'-ro',c,hw1fpsnr,'-ms',c,hw1fsnr,'-bd');
legend('MSE','PSNR','SNR',0);
xlabel('Cutoff Frequency');
ylabel('Performacne Metrics');
title('Variation in performance metrics with band elimination for Wavelet Filter for single level decomposition');

%-----Homomorphic Wavelet Filter Analysis (Double Level Decomposition)----%

%---Creating cell Fields for passing it to an excel file
Fields = {'Filter','Level','Band','MSE','PSNR','SNR'};
%---Excel file in which performance metrics has to be written
xlswrite('Performance Metrics.xls', Fields, 9, 'A1');%---Writing on 9th sheet
for i = 1:4;
    level = 2;
    if i == 1
        bn = 'HL';
        I_anyl = NSRFilters(In,'hmp-wlet',bn,'db1',level);
    elseif i == 2
        bn = 'LH';
        I_anyl = NSRFilters(In,'hmp-wlet',bn,'db1',level);
    elseif i == 3
        bn = 'HH';
        I_anyl = NSRFilters(In,'hmp-wlet',bn,'db1',level);
    else
        bn = 'LH-HH';
        I_anyl = NSRFilters(In,'hmp-wlet',bn,'db1',level);
    end
    figure(10);subplot(2,2,i);imshow(I_anyl);%---Show Filtered Image on sixth Figure window
    title(['Filtered Image using Wavelet Filter; Band Eliminated = ',bn]);
    QM(i) = MetricsMeasurement(Ig,I_anyl);%---Calculating Performance Metrics
    hw2fmse(i) = QM(i).M_SE;hw2fpsnr(i) = QM(i).PSNR; hw2fsnr(i) = QM(i).SNR;
    QMxls = {'Wavelet Filter',level,bn,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
    index_num = i+1;
    index = num2str(index_num);
    cell = strcat('A',index);
    xlswrite('Performance Metrics.xls', QMxls, 9, cell);%---Writing on 9th sheet
end
c = [1 2 3 4];
axis square;
figure(13);subplot(2,2,1);
semilogy(c,hw2fmse,'-ro',c,hw2fpsnr,'-ms',c,hw2fsnr,'-bd');
legend('MSE','PSNR','SNR',0);
xlabel('Cutoff Frequency');
ylabel('Performacne Metrics');
title('Variation in performance metrics with band elimination for Wavelet Filter for second level decomposition');


