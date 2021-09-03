function FI = NSRFilters(InI,fname,varargin)

% This function NSRFilters is implemented to apply various filters on image
% as specified on the paper entitled as "Finding out general tendencies in 
% speckle noise reduction in ultrasound images" by Juan L. Mateo a, Antonio
% Fernández-Caballero a,b,*; published on Expert Systems with Applications 
% 36 (2009) 7786–7797.
% 
% Filters implemented here in are Median, Adaptive weighted median filter, 
% Fourier Ideal, Fourier Butterworth,Wavelet and there various combinations
% with homomorphic filter....
% 
% This function uses Image Processing Toolbox and Wavelet Toolbox from
% MATLAB R2012a.
%
% INPUTS:
%               InI = Original Image on which filter has to be applied
%             fname = Filter name; to be used as shown below
%                FI = NSRFilters(InI,'med',[m n])
%                FI = NSRFilters(Ini,'awmf',[m n],c1,c2)
%                FI = NSRFilters(InI,'ideal',D0)
%                FI = NSRFilters(InI,'btw',D0,n);
%                FI = NSRFilters(InI,'hmp-ideal',D0);
%                FI = NSRFilters(InI,'hmp-btw',D0,n);
%                FI = NSRFilters(InI,'wlet','band','Wname',level);
%                FI = NSRFilters(InI,'hmp-wlet','band','Wname',level);
%
% OUTPUT:
%           FI = Filtered Image as per as the filter used
%
%
% DEFINITION AND USAGES:
%
% For Median Filter using syntax
% FI = NSRFilters(InI,'med',[m n]);
%       InI = imread('--------------');% Read Image and assign it to InI
%       FI = NSRFilters(InI,'med',[3 3]); Perform Median filtering on Image
%       InI with window size of 3x3
%
% For AWMF Filter using syntax
% FI = NSRFilters(InI,'awmf',[m n],c1,c2);
% This Adaptive Weighted Median Filter uses weighted function as
%       
%       w(i,j) = c1*(1 - c2*( d / (SNR)^2 ))
%
% where c1,c2 are weight adjustment constants
% d is the Eucledian distance from the (i,j) position from the center of
% the window
% SNR indicated the relationship between the mean and the standard deviation
% of the pixel which falls inside the window
%
%       InI = imread('--------------');% Read Image and assign it to InI
%       FI = NSRFilters(InI,'awmf',[5 5],99,1); Performs AWMF filtering on
%       Image InI with window size 5x5 and constant parameter c1 = 99 and
%       c2 = 1
%
% For Fourier Ideal Filter using syntax
% FI = NSRFilters(InI,'ideal', D0); uses Fourier Ideal Low-Pass Filter
% defined as
%               H(u,v) = { 1 if D(u,v) <= D0
%                        { 0 if D(u,v) > D0
%
%       InI = imread('--------------');% Read Image and assign it to InI
%       FI = NSRFilters(InI,'ideal',50);% Perform Ideal filtering on image
%       InI with cutoff frequency D0 = 50
%
% For Fourier Butterworth Second Order Filter using syntax
% FI = NSRFilters(InI,'btw',D0,n); uses Fourier Butterworth second order
% Low-Pass filter defined as
%
%               H(u,v) = __________1__________
%                         1 + [D(u,v)/D0]^2n  
%
%       InI = imread('--------------');% Read Image and assign it to InI
%       FI = NSRFilters(InI,'btw',50,2);% Perform Butterworth filtering on
%       image InI with cutoff frequency D0 = 50 and order n = 2
%
% For Homomorphic Ideal Filter using syntax
% FI = NSRFilters(InI,'hmp-ideal', D0); uses Homomorphic Fourier Ideal
% Low-Pass filter modelled as
% 
%   In ---> ln ---> FFT ---> Ideal Filter ---> IFFT ---> exp ---> FI
%
%       InI = imread('--------------');% Read Image and assign it to InI
%       FI = NSRFilters(InI,'hmp-ideal',50);% Perform Homomorphic Ideal 
%       filtering on image InI with cutoff frequency D0 = 50
%
% For Homomorphic Butterworth Filter using syntax
% FI = NSRFilters(InI,'hmp-btw', D0,n); uses Homomorphic Fourier
% Butterworth Low-Pass Filter modelled as
%
%   In ---> ln ---> FFT ---> Butterworth Filter ---> IFFT ---> exp ---> FI
%
%       InI = imread('--------------');% Read Image and assign it to InI
%       FI = NSRFilters(InI,'btw',50,2);% Perform Homomorphic Butterworth 
%       filtering on image InI with cutoff frequency D0 = 50 and order n = 2
%
% For Wavelet Filter using syntax
% FI = NSRFilters(InI,'wlet',band,Wname,level);
% where 
%        Bands              
%         HL                
%         LH                
%         HH                
%   HL-LH or LH-HL          
%   HL-HH or HH-HL          
%   LH-HH or HH-LH
%      LH-HL-HH
%
%        Wname
% Daubechies           :  'db1' or 'haar', 'db2', ... ,'db10', ... , 'db45'
% Coiflets             :  'coif1', ... , 'coif5'
% Symlets              :  'sym2', ... , 'sym8', ... ,'sym45'
% Discrete Meyer       :  'dmey'
% Biorthogonal         :  'bior1.1', 'bior1.3', 'bior1.5'
%                         'bior2.2', 'bior2.4', 'bior2.6', 'bior2.8'
%                         'bior3.1', 'bior3.3', 'bior3.5', 'bior3.7'
%                         'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8'
% Reverse Biorthogonal :  'rbio1.1', 'rbio1.3', 'rbio1.5'
%                         'rbio2.2', 'rbio2.4', 'rbio2.6', 'rbio2.8'
%                         'rbio3.1', 'rbio3.3', 'rbio3.5', 'rbio3.7'
%                         'rbio3.9', 'rbio4.4', 'rbio5.5', 'rbio6.8'
%       InI = imread('--------------');% Read Image and assign it to InI
%       FI = NSRFilters(InI,'wlet','HH','db1',2);% performs Wavlet filtering
%       on Image InI by eliminating band 'HH' using Daubechies 'db1'
%       wavelet
% Limitation: Image can be decomposed upto level 2 only.
%
% For Homomorphic Wavelet Filter using syntax
% FI = NSRFilters(InI,'hmp-wlet',band,Wname,level); uses homomorphic
% wavelet filter defined as 
%
%   In ---> ln ---> DWT ---> Wavelet Filter ---> IDWT ---> exp ---> FI
%
%       InI = imread('--------------');% Read Image and assign it to InI
%       FI = NSRFilters(InI,'hmp-wlet','HL','db2',1); performs Homomorphic
%       wavelet filtering on Image InI by eliminating band 'HL' using
%       Daubechies 'db2' wavelet.
%

% ASHISH MESHRAM (meetashish85@gmail.com
%
%-------------------------Implementation Starts---------------------------%
%

if nargin<1||isempty(InI),error('Image not selected'),end;
if nargin<2||isempty(fname),error('Specify the filter name to be applied'),end;
if nargin<3,error('Parameter missing for the specified filter'),end;

nrg = nargin; %---Get number of input arguments

switch fname
%---------------------Spatial Domain Filtering----------------------------%
    case 'med'
        PreIm = Preprocess(InI);%---Preprocessing Original Image
        if nrg==2
            FI = medfilt2(PreIm.Ig);%---Applying median filter
        else
            %---Get window size
            m = varargin{1};
            n = varargin{2};
            FI = medfilt2(PreIm.Ig,[m n]);%---Applying median filter
        end

%-------------------Adaptive Weighted Median Filter-----------------------%

    case 'awmf'
        disp('Under Construction');
        
%---------------------Ideal Frequency Filtering---------------------------%

    case 'ideal'
        PreIm = Preprocess(InI);%---Preprocessing Original Image
        %---Fourier Transform of preprocessed image of an orignial Image
        F = fft2(PreIm.Ig,PreIm.PQ(1),PreIm.PQ(2));
        if nrg==2
            error('Input Argument Missing');
        else
            D0 = varargin{1}; %---Get cutoff frequency
            H = double(PreIm.D <= D0);%---Transfer Function
            G = H.*F;%---Multiplying the transform by filter
            g = ifft2(G);%---Inverse Fourier Transform
            FI = g(1:size(PreIm.Ig,1),1:size(PreIm.Ig,2));%---Post-Processing
        end

%--------------------Butterworth Frequency Filtering----------------------%

    case 'btw'
         PreIm = Preprocess(InI);%---Preprocessing Original Image
         %---Fourier Transform of preprocessed image of an orignial Image
         F = fft2(PreIm.Ig,PreIm.PQ(1),PreIm.PQ(2));
         %---Low-Pass Butterworth Filter Transfer Function
         if nrg==2
             error('Input Argument Missing');
         else
             D0 = varargin{1};%---Get Cutoff Frequency
             n = varargin{2};%---Get Filter Order
             H = 1./(1 + (PreIm.D./D0).^(2*n)); %---Transfer Function
             G = H.*F;%---Multiplying the transform by filter
             g = ifft2(G);%---Inverse Fourier Transform
             FI = g(1:size(PreIm.Ig,1),1:size(PreIm.Ig,2));%---Post-Processing
         end
         
%---------------------Homomorphic using AWMF Filtering--------------------%

    case 'hmp-awmf'

%--------------Homomorphic using Ideal Frequency Filtering----------------%

    case 'hmp-ideal'
        PreIm = Preprocess(1+InI);%---Preprocessing Original Image
        IgLog = log(PreIm.Ig);%---Natural Log of processed image
        D0 = varargin{1}; %---Get cutoff frequency
        FI = NSRFilters(IgLog,'ideal',D0);%---Perform Ideal Filtering
        FI = exp(FI);%---Perform Exponential operation on filtered image
               
%----------Homomorphic using Butterworth Frequency Filtering--------------%

    case 'hmp-btw'
        PreIm = Preprocess(1+InI);%---Preprocessing Original Image
        IgLog = log(PreIm.Ig);%---Natural Log of processed image
        D0 = varargin{1};%---Get Cutoff Frequency
        n = varargin{2};%---Get Filter Order
        FI = NSRFilters(IgLog,'btw',D0,n);%---Perform Butterworth Filtering
        FI = exp(FI);%---Perform Exponential operation on filtered image
            
%-----------------------------Wavelet Filtering---------------------------%

    case 'wlet'
        PreIm = Preprocess(InI);%---Preprocessing Original Image
        band = varargin{1};%---Get Band to be eliminated
        Wname = varargin{2};%---Get wavelet name to be used
        level = varargin{3};%---Get level for decomposition of image
        if level==1%---Single level of decomposition
            [cA1,cH1,cV1,cD1] = dwt2(PreIm.Ig,Wname);%---Discrete Wavelet Transform
            switch band
                case 'HL' %---For HL or Vertical 
                    [m n] = size(cV1);%---Get size of HL band image
                    cV1 = zeros(m,n);%---Eliminating HL band image by zero
                    FI = idwt2(cA1,cH1,cV1,cD1,Wname);%---Inverse DWT
                case 'LH'%---For LH or Horizontal
                    [m n] = size(cH1);%---Get size of LH band image
                    cH1 = zeros(m,n);%---Eliminating LH band image by zero
                    FI = idwt2(cA1,cH1,cV1,cD1,Wname);%---Inverse DWT
                case 'HH'%---For HH or Diagonal
                    [m n] = size(cD1);%---Get size of HH band image
                    cD1 = zeros(m,n);%---Eliminating HH band image by zero
                    FI = idwt2(cA1,cH1,cV1,cD1,Wname);%---Inverse DWT
                case 'HL-HH'%---For HL-HH or Vertical and Diagonal
                    [m1 n1] = size(cV1);%---Get size of HL band image
                    [m2 n2] = size(cD1);%---Get size of HH band image
                    cV1 = zeros(m1,n1);%---Eliminating HL band image by zero
                    cD1 = zeros(m2,n2);%---Eliminating HH band image by zero
                    FI = idwt2(cA1,cH1,cV1,cD1,Wname);%---Inverse DWT
                case 'LH-HH'%---For LH-HH or Horizontal and Diagonal
                    [m1 n1] = size(cH1);%---Get size of LH band image
                    [m2 n2] = size(cD1);%---Get size of HH band image
                    cH1 = zeros(m1,n1);%---Eliminating LH band image by zero
                    cD1 = zeros(m2,n2);%---Eliminating HH band image by zero
                    FI = idwt2(cA1,cH1,cV1,cD1,Wname);%---Inverse DWT
                case 'HL-LH'%---For HL-LH or Vertical and Horizontal
                    [m1 n1] = size(cV1);%---Get size of HL band image
                    [m2 n2] = size(cH1);%---Get size of LH band image
                    cV1 = zeros(m1,n1);%---Eliminating HL band image by zero
                    cH1 = zeros(m2,n2);%---Eliminating LH band image by zero
                    FI = idwt2(cA1,cH1,cV1,cD1,Wname);%---Inverse DWT
                case 'HL-LH-HH'%---For HL-LH-HH or Vertical,Horizontal and Diagonal
                    [m1 n1] = size(cV1);%---Get size of HL band image
                    [m2 n2] = size(cH1);%---Get size of LH band image
                    [m3 n3] = size(cD1);%---Get size of HH band image
                    cV1 = zeros(m1,n1);%---Eliminating HL band image by zero
                    cH1 = zeros(m2,n2);%---Eliminating LH band image by zero
                    cD1 = zeros(m3,n3);%---Eliminating HH band image by zero
                    FI = idwt2(cA1,cH1,cV1,cD1,Wname);%---Inverse DWT
            end
        elseif level==2%---Second level of decomposition
            [cA1,cH1,cV1,cD1] = dwt2(PreIm.Ig,Wname);%---Discrete Wavelet Transform
            [cA2,cH2,cV2,cD2] = dwt2(cA1,Wname);%---Discrete Wavelet Transform
            switch band
                case 'HL'%---For HL or Vertical 
                    [r c] = size(PreIm.Ig);%---Get size of Preprocessed Image
                    [m n] = size(cV2);%---Get size of HL band image
                    cV2 = zeros(m,n);%---Eliminating HL band image by zero
                    If = idwt2(cA2,cH2,cV2,cD2,Wname);%---Inverse DWT
                    FI = imresize(If,[r c]);%---Resizing filtered image to preprocessed image
                case 'LH'%---For LH or Horizontal
                    [r c] = size(PreIm.Ig);%---Get size of Preprocessed Image
                    [m n] = size(cH2);%---Get size of LH band image
                    cH2 = zeros(m,n);%---Eliminating LH band image by zero
                    If = idwt2(cA2,cH2,cV2,cD2,Wname);%---Inverse DWT
                    FI = imresize(If,[r c]);%---Resizing filtered image to preprocessed image
                case 'HH'%---For HH or Diagonal
                    [r c] = size(PreIm.Ig);%---Get size of Preprocessed Image
                    [m n] = size(cD2);%---Get size of HH band image
                    cD2 = zeros(m,n);%---Eliminating HH band image by zero
                    If = idwt2(cA2,cH2,cV2,cD2,Wname);%---Inverse DWT
                    FI = imresize(If,[r c]);%---Resizing filtered image to preprocessed image
                case 'HL-HH'%---For HL-HH or Vertical and Diagonal
                    [r c] = size(PreIm.Ig);%---Get size of Preprocessed Image
                    [m1 n1] = size(cV2);%---Get size of HL band image
                    [m2 n2] = size(cD2);%---Get size of HH band image
                    cV2 = zeros(m1,n1);%---Eliminating HL band image by zero
                    cD2 = zeros(m2,n2);%---Eliminating HH band image by zero
                    If = idwt2(cA2,cH2,cV2,cD2,Wname);%---Inverse DWT
                    FI = imresize(If,[r c]);%---Resizing filtered image to preprocessed image
                case 'LH-HH'%---For LH-HH or Horizontal and Diagonal
                    [r c] = size(PreIm.Ig);%---Get size of Preprocessed Image
                    [m1 n1] = size(cH2);%---Get size of LH band image
                    [m2 n2] = size(cD2);%---Get size of HH band image
                    cH2 = zeros(m1,n1);%---Eliminating LH band image by zero
                    cD2 = zeros(m2,n2);%---Eliminating HH band image by zero
                    If = idwt2(cA2,cH2,cV2,cD2,Wname);%---Inverse DWT
                    FI = imresize(If,[r c]);%---Resizing filtered image to preprocessed image
                case 'HL-LH'%---For HL-LH or Vertical and Horizontal
                    [r c] = size(PreIm.Ig);%---Get size of Preprocessed Image
                    [m1 n1] = size(cV2);%---Get size of HL band image
                    [m2 n2] = size(cH2);%---Get size of LH band image
                    cV2 = zeros(m1,n1);%---Eliminating HL band image by zero
                    cH2 = zeros(m2,n2);%---Eliminating LH band image by zero
                    If = idwt2(cA2,cH2,cV2,cD2,Wname);%---Inverse DWT
                    FI = imresize(If,[r c]);%---Resizing filtered image to preprocessed image
                case 'HL-LH-HH'%---For HL-LH-HH or Vertical,Horizontal and Diagonal
                    [r c] = size(PreIm.Ig);%---Get size of preprocessed Image
                    [m1 n1] = size(cV2);%---Get size of HL band image
                    [m2 n2] = size(cH2);%---Get size of LH band image
                    [m3 n3] = size(cD2);%---Get size of HH band image
                    cV2 = zeros(m1,n1);%---Eliminating HL band image by zero
                    cH2 = zeros(m2,n2);%---Eliminating LH band image by zero
                    cD2 = zeros(m3,n3);%---Eliminating HH band image by zero
                    If = idwt2(cA2,cH2,cV2,cD2,Wname);%---Inverse DWT
                    FI = imresize(If,[r c]);%---Resizing filtered image to preprocessed image
            end
        else
            disp('Level not allowed: Decompostion upto level 2 only');
        end
                
%-------------------Homomorphic using Wavelet Filtering-------------------%
    case 'hmp-wlet'
        PreIm = Preprocess(1+InI);%---Preprocessing Original Image
        band = varargin{1};%---Get band to be eliminated
        Wname = varargin{2};%---Get wavelet name to be used
        level = varargin{3};%---Get level for decomposition of image
        ILog = log(PreIm.Ig);%---Perform natural Logarithm on Image
        FI = NSRFilters(ILog,'wlet',band,Wname,level);%---Perform wavelet filtering
        FI = exp(FI);%---Perform exponential operation on filtered image
        
%-----------------------------Unknown Filtering---------------------------%

    otherwise
        error('Unknown filter type')
end

