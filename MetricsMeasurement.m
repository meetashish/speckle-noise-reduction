function metrics = MetricsMeasurement(Orig_Image,Esti_Image)

% This function MetricMeasurement calculates various performance metrics as
% discussed in paper entitled as "Finding out general tendencies in 
% speckle noise reduction in ultrasound images" by Juan L. Mateo a, Antonio
% Fernández-Caballero a,b,*; published on Expert Systems with Applications 
% 36 (2009) 7786–7797.
%
% INPUTS: Orig_Image = Original Image
%         Esti_Image = Estimation of the original image obtained from a
%         noisy image after filtering it.
% OUTPUT:
%         metrics = is a strucutre with following fields
%                 Mean-Square Error (M_SE)
%                 Signal-to-Noise Ratio (SNR)
%                 Peak Signal-to-Noise Ratio (PSNR)
%                 Beta
%

% ASHISH MESHRAM (meetashish85@gmail.com

%---Checking Input Arguments
if nargin<1||isempty(Esti_Image), error('Input Argument: Estiamted Image Missing');end

%---Implentation starts here
if (size(Orig_Image)~= size(Esti_Image)) %---Check images size
    error('Input images should be of same size');
else
    %---Mean-Square Error(MSE) Calculation
    Orig_Image = im2double(Orig_Image);%---Convert image to double class
    Esti_Image = im2double(Esti_Image);%---Convert image to double class
    [M N] = size(Orig_Image);%---Size of Original Image
    err = Orig_Image - Esti_Image;%---Difference between two images
    metrics.M_SE = (sum(sum(err .* err)))/(M * N);

    %---Signal-to-Noise Ratio(SNR) Calculation
    metrics.SNR = 10*log10((1/M*N)*sum(sum(Orig_Image.*Orig_Image))/(metrics.M_SE));

    %---Peak Signal-to-Noise Ratio(PSNR) Calculation 
    if(metrics.M_SE > 0)
        metrics.PSNR = 10*log10(255*255/metrics.M_SE);
    else
        metrics.PSNR = 99;
    end

    %---Beta Calculation
    h = fspecial('laplacian');
    I1 = imfilter(Orig_Image,h);
    I2 = imfilter(Esti_Image,h);
    I_1 = mean2(I1);
    I_2 = mean2(I2);
    metrics.Beta = sum(sum((I1 - I_1).*(I2 - I_2)))./(sqrt(sum(((I1 - I_1).^2).*((I2 - I_2).^2))));
end
    
