
% This Analyze script is implemented for applying selected or all filter(s)
% on image(s) selected by the user and save filtered image on a directory
% named as Filtered Image along with its Performance Metrics written in an
% Microsoft Excel File.

% ASHISH MESHRAM (meetashish85@gmail.com

clear all;clc;%---Clear workspace and command window

%---Get image(s) from the user
[FilePath PathStr FileName Ext Index] = GetFilePath();

path = strcat(PathStr,'\Filtered Image');%---Path for filtered image folder

mkdir(path);%---Creating Folder

%---Display Filters name for selection
disp('------------------------------------------------');
disp('       Filter Types                Mnemonics    ');
disp('------------------------------------------------');
disp('  Median                             med        ');
disp('  Ideal                              ideal      ');
disp('  Butterworth                        btw        ');
disp('  Wavelet                            wlet       ');
disp('  Homomorphic Ideal                  hmp-med    ');
disp('  Homomorphic Butterworth            hmp-btw    ');
disp('  Homomorphic Wavelet                hmp-wlet   ');
disp('  All Filter                         all        ');
disp('------------------------------------------------');

%---Prompt user for Filter Type
FilterName = input(...
    'Enter Corresponding Filter Choice Mnemonic (with single quote)= ');%---Accepting user filter type

I = cell(5,5);%---Preallocating Image Cell
PreI = cell(5,5);%---Preallocating Preprocessed Image Cell
% QM = struct('M_SE',[],'PSNR',[],'SNR',[]);%---Preallocating Performance Metrics Structure

if Index == 1;%---If single image is selected
    
    I = imread(FilePath);%---Read selected Image
    PreI = Preprocess(I);%---Preprocessing Image for  Performance Metrics
    
    switch FilterName
        
        %----------------------Median Filtering---------------------------%
        case 'med'
            %---Creating Cell Fields for passing it to an excel file
            Fields = {'Filter','Window','MSE','PSNR','SNR'};
            %---Excel filename for corresponding image
            xlsname = strcat(path,'\',FileName,' - ','Performance Metrics.xls');
            %---Excel file in which performance metrics has to be written
            xlswrite(xlsname, Fields, 1, 'A1');%---Writing on sheet 1 from cell A1
            for c = [3 5 7 9]; %---Window size to be applied on median filter
                EI = NSRFilters(I,'med',c,c);%---Applying median filter
                %---Filename of an image for corresponding filter's parameter
                FIName = strcat(path,'\',FileName,' - ','Median Filter',' [',...
                                    num2str(c),'x',num2str(c),']',Ext);
                imwrite(EI,FIName);%---Write image file
                %---Changing index for performance metrics calculation
                if c == 3
                    i = 1;
                elseif c == 5
                    i = 2;
                elseif c == 7
                    i = 3;
                else
                    i = 4;
                end
                QM(i) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                c_str = num2str(c);%---converting window size to string
                winsize = strcat(c_str,'x',c_str);%---concatnaing for window size as cxc
                %---creating performance metrics cell for passing it to xls file
                QMxls = {'Median Filter',winsize,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
                index_num = i+1;%---incrementing index for excel rows
                cell = strcat('A',num2str(index_num));%---Concatening Column A with index
                xlswrite(xlsname, QMxls, 1, cell);%---Writing on sheet 1 from cell A(i+1)
            end
        
        %------------------Fourier Ideal Filtering------------------------%    
        case 'ideal'
            %---Creating Cell Fields for passing it to an excel file
            Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
            %---Excel filename for corresponding image
            xlsname = strcat(path,'\',FileName,' - ','Performance Metrics.xls');
            %---Excel file in which performance metrics has to be written
            xlswrite(xlsname, Fields, 1, 'A1');%---Writing on sheet 1 from cell A1
            for c = [10 30 40 50];%---Cutoff frequency to be applied on Ideal Filter
                EI = NSRFilters(I,'ideal',c);%---Applying Ideal filter
                %---Filename of an image for corresponding filter's parameter
                FIName = strcat(path,'\',FileName,' - ','Ideal Filter',...
                                ' [Cutoff Frequency = ',num2str(c),']',Ext);
                imwrite(EI,FIName);%---Write image file
                %---Changing index for performance metrics calculation
                if c == 10
                    i = 1;
                elseif c == 30
                    i = 2;
                elseif c == 40
                    i = 3;
                else
                    i = 4;
                end
                QM(i) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                %---creating performance metrics cell for passing it to xls file
                QMxls = {'Fourier Ideal Filter',c,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
                index_num = i+1;%---incrementing index for excel rows
                cell = strcat('A',num2str(index_num));%---Concatening Column A with index
                xlswrite(xlsname, QMxls, 1, cell);%---Writing on sheet 1 from cell A(i+1)
            end
            
        %---------------Fourier Butterworth Filtering---------------------%    
        case 'btw'
            %---Creating Cell Fields for passing it to an excel file
            Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
            %---Excel filename for corresponding image
            xlsname = strcat(path,'\',FileName,' - ','Performance Metrics.xls');
            %---Excel file in which performance metrics has to be written
            xlswrite(xlsname, Fields, 1, 'A1');%---Writing on sheet 1 from cell A1
            for c = [10 30 40 50];%---Cutoff frequency to be applied on Buttwrworth Filter
                EI = NSRFilters(I,'btw',c,2);%---Applying Butterworth filter
                %---Filename of an image for corresponding filter's parameter
                FIName = strcat(path,'\',FileName,' - ','Butterworth Filter',...
                                ' [Cutoff Frequency = ',num2str(c),']',Ext);
                imwrite(EI,FIName);%---Write image file
                %---Changing index for performance metrics calculation
                if c == 10
                    i = 1;
                elseif c == 30
                    i = 2;
                elseif c == 40
                    i = 3;
                else
                    i = 4;
                end
                QM(i) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                %---creating performance metrics cell for passing it to xls file
                QMxls = {'Fourier Butterworth Filter',c,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
                index_num = i+1;%---incrementing index for excel rows
                cell = strcat('A',num2str(index_num));%---Concatening Column A with index
                xlswrite(xlsname, QMxls, 1, cell);%---Writing on sheet 1 from cell A(i+1)
            end
        
        %---------------------Wavelet Filtering---------------------------%    
        case 'wlet'
            
            %-------Wavelet Single Level Decomposition Filtering----------%
            %---Creating Cell Fields for passing it to an excel file
            Fields = {'Filter','Level','Band','MSE','PSNR','SNR'};
            %---Excel filename for corresponding image
            xlsname = strcat(path,'\',FileName,' - ','Performance Metrics.xls');
            %---Excel file in which performance metrics has to be written
            xlswrite(xlsname, Fields, 1, 'A1');%---Writing on sheet 1 from cell A1
            
            level = 1; %---Single Level Decomposition
            for c = [1 2 3 4]
                if c == 1
                    bn = 'HL';%---Vertical Details
                    EI = NSRFilters(I,'wlet',bn,'db1',level);%---Applying Wavelet filter
                    %---Filename of an image for corresponding filter's parameter
                    FIName = strcat(path,'\',FileName,' - ','Wavelet Filter',...
                                 ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);%---Write image file
                elseif c == 2
                    bn = 'LH';%---Horizontal Details
                    EI = NSRFilters(I,'wlet',bn,'db1',level);%---Applying Wavelet filter
                    %---Filename of an image for corresponding filter's parameter
                    FIName = strcat(path,'\',FileName,' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);%---Write image file
                elseif c == 3
                    bn = 'HH';%---Diagonal Details
                    EI = NSRFilters(I,'wlet',bn,'db1',level);%---Applying Wavelet filter
                    %---Filename of an image for corresponding filter's parameter
                    FIName = strcat(path,'\',FileName,' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);%---Write image file
                else
                    bn = 'LH-HH';%---Horizontal and Diagonal Details
                    EI = NSRFilters(I,'wlet',bn,'db1',level);%---Applying Wavelet filter
                    %---Filename of an image for corresponding filter's parameter
                    FIName = strcat(path,'\',FileName,' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);%---Write image file
                end
                QM(c) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                %---creating performance metrics cell for passing it to xls file
                QMxls = {'Wavelet Filter',level,bn,QM(c).M_SE,QM(c).PSNR,QM(c).SNR};
                index_num = c+1;%---incrementing index for excel rows
                cell = strcat('A',num2str(index_num));%---Concatening Column A with index
                xlswrite(xlsname, QMxls, 1, cell);%---Writing on sheet 1 from cell A(i+1)
            end
            
            %-------Wavelet Second Level Decomposition Filtering----------%
            xlswrite(xlsname, Fields, 2, 'A1');%---Writing on sheet 2 from cell A1
            level = 2; %---Second Level Decomposition
            for c = [1 2 3 4]
                if c == 1
                    bn = 'HL';%---Vertical Details
                    EI = NSRFilters(I,'wlet',bn,'db1',level);%---Applying Wavelet filter
                    %---Filename of an image for corresponding filter's parameter
                    FIName = strcat(path,'\',FileName,' - ','Wavelet Filter',...
                                 ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);%---Write image file
                elseif c == 2
                    bn = 'LH';%---Horizontal Details
                    EI = NSRFilters(I,'wlet',bn,'db1',level);%---Applying Wavelet filter
                    %---Filename of an image for corresponding filter's parameter
                    FIName = strcat(path,'\',FileName,' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);%---Write image file
                elseif c == 3
                    bn = 'HH';%---Diagonal Details
                    EI = NSRFilters(I,'wlet',bn,'db1',level);%---Applying Wavelet filter
                    %---Filename of an image for corresponding filter's parameter
                    FIName = strcat(path,'\',FileName,' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);%---Write image file
                else
                    bn = 'LH-HH';%---Horizontal and Diagonal Details
                    EI = NSRFilters(I,'wlet',bn,'db1',level);%---Applying Wavelet filter
                    %---Filename of an image for corresponding filter's parameter
                    FIName = strcat(path,'\',FileName,' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);%---Write image file
                end
                QM(c) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                %---creating performance metrics cell for passing it to xls file
                QMxls = {'Wavelet Filter',level,bn,QM(c).M_SE,QM(c).PSNR,QM(c).SNR};
                index_num = c+1;%---incrementing index for excel rows
                cell = strcat('A',num2str(index_num));%---Concatening Column A with index
                xlswrite(xlsname, QMxls, 2, cell);%---Writing on sheet 2 from cell A(i+1)
            end
        
        %---------------Homomorphic Wavelet Filtering---------------------%    
        case 'hmp-wlet'
            
            %--------Homomorphic Wavelet Single Level Filtering-----------%
            %---Creating Cell Fields for passing it to an excel file
            Fields = {'Filter','Level','Band','MSE','PSNR','SNR'};
            %---Excel filename for corresponding image
            xlsname = strcat(path,'\',FileName,' - ','Performance Metrics.xls');
            %---Excel file in which performance metrics has to be written
            xlswrite(xlsname, Fields, 1, 'A1');%---Writing on 5th sheet
            level = 1; %---Single Level Decomposition
            for c = [1 2 3 4]
                if c == 1
                    bn = 'HL';
                    EI = NSRFilters(I,'hmp-wlet',bn,'db1',level);
                    FIName = strcat(path,'\',FileName,' - ','Homomorphic Wavelet Filter',...
                                 ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);
                elseif c == 2
                        bn = 'LH';
                        EI = NSRFilters(I,'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName,' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                        imwrite(EI,FIName);
                elseif c == 3
                        bn = 'HH';
                        EI = NSRFilters(I,'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName,' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                        imwrite(EI,FIName);
                else
                        bn = 'LH-HH';
                        EI = NSRFilters(I,'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName,' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                        imwrite(EI,FIName);
                end
                QM(c) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                QMxls = {'Homomorphic Wavelet Filter',level,bn,QM(c).M_SE,QM(c).PSNR,QM(c).SNR};
                index_num = c+1;
                cell = strcat('A',num2str(index_num));
                xlswrite(xlsname, QMxls, 1, cell);%---Writing on 5th sheet
            end
            
            %--------Homomorphic Wavelet Second Level Filtering-----------%
            xlswrite(xlsname, Fields, 2, 'A1');%---Writing on 5th sheet
            level = 2; %---Second Level Decomposition
            for c = [1 2 3 4]
                if c == 1
                    bn = 'HL';
                    EI = NSRFilters(I,'hmp-wlet',bn,'db1',level);
                    FIName = strcat(path,'\',FileName,' - ','Homomorphic Wavelet Filter',...
                                 ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);
                elseif c == 2
                        bn = 'LH';
                        EI = NSRFilters(I,'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName,' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                        imwrite(EI,FIName);
                elseif c == 3
                        bn = 'HH';
                        EI = NSRFilters(I,'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName,' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                        imwrite(EI,FIName);
                else
                        bn = 'LH-HH';
                        EI = NSRFilters(I,'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName,' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                        imwrite(EI,FIName);
                end
                QM(c) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                QMxls = {'Homomorphic Wavelet Filter',level,bn,QM(c).M_SE,QM(c).PSNR,QM(c).SNR};
                index_num = c+1;
                cell = strcat('A',num2str(index_num));
                xlswrite(xlsname, QMxls, 2, cell);%---Writing on 5th sheet
            end
         
        %------------Homomorphic Fourier Ideal Filtering------------------%    
        case 'hmp-ideal'
            %---Creating Cell Fields for passing it to an excel file
            Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
            %---Excel filename for corresponding image
            xlsname = strcat(path,'\',FileName,' - ','Performance Metrics.xls');
            %---Excel file in which performance metrics has to be written
            xlswrite(xlsname, Fields, 1, 'A1');%---Writing on 1st sheet
            for c = [10 30 40 50];
                EI = NSRFilters(I,'hmp-ideal',c);
                FIName = strcat(path,'\',FileName,' - ','Homomorphic Ideal Filter',...
                                ' [Cutoff Frequency = ',num2str(c),']',Ext);
                imwrite(EI,FIName);
                if c == 10
                    i = 1;
                elseif c == 30
                    i = 2;
                elseif c == 40
                    i = 3;
                else
                    i = 4;
                end
                QM(i) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                QMxls = {'Homomorphic Fourier Ideal Filter',c,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
                index_num = i+1;
                cell = strcat('A',num2str(index_num));
                xlswrite(xlsname, QMxls, 1, cell);%---Writing on 1st sheet
            end
        
        %----------Homomorphic Fourier Butterworth Filtering--------------%    
        case 'hmp-btw'
            Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
            %---Excel filename for corresponding image
            xlsname = strcat(path,'\',FileName,' - ','Performance Metrics.xls');
            %---Excel file in which performance metrics has to be written
            xlswrite(xlsname, Fields, 1, 'A1');%---Writing on 1st sheet
            for c = [10 30 40 50];
                EI = NSRFilters(I,'hmp-btw',c,2);
                FIName = strcat(path,'\',FileName,' - ','Homomorphic Butterworth Filter',...
                                ' [Cutoff Frequency = ',num2str(c),']',Ext);
                imwrite(EI,FIName);
                if c == 10
                    i = 1;
                elseif c == 30
                    i = 2;
                elseif c == 40
                    i = 3;
                else
                    i = 4;
                end
                QM(i) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                QMxls = {'Homomorphic Fourier Butterworth Filter',c,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
                index_num = i+1;
                cell = strcat('A',num2str(index_num));
                xlswrite(xlsname, QMxls, 1, cell);%---Writing on 1st sheet
            end
            
        %-----------------------All Filtering-----------------------------%    
        case 'all'
            %----------------------Median Filtering-----------------------%
            %---Creating Cell Fields for passing it to an excel file
            Fields = {'Filter','Window','MSE','PSNR','SNR'};
            %---Excel filename for corresponding image
            xlsname = strcat(path,'\',FileName,' - ','Performance Metrics.xls');
            %---Excel file in which performance metrics has to be written
            xlswrite(xlsname, Fields, 1, 'A1');%---Writing on 1st sheet
            for c = [3 5 7 9];
                EI = NSRFilters(I,'med',c,c);
                FIName = strcat(path,'\',FileName,' - ','Median Filter',' [',...
                                    num2str(c),'x',num2str(c),']',Ext);
                imwrite(EI,FIName);
                if c == 3
                    i = 1;
                elseif c == 5
                    i = 2;
                elseif c == 7
                    i = 3;
                else
                    i = 4;
                end
                QM(i) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                c_str = num2str(c); winsize = strcat(c_str,'x',c_str);
                QMxls = {'Median Filter',winsize,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
                index_num = i+1;
                cell = strcat('A',num2str(index_num));
                xlswrite(xlsname, QMxls, 1, cell);%---Writing on 1st sheet
            end
            
            %------------------Fourier Ideal Filtering--------------------%
            %---Creating Cell Fields for passing it to an excel file
            Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
            xlsname = strcat(path,'\',FileName,' - ','Performance Metrics.xls');
            %---Excel file in which performance metrics has to be written
            xlswrite(xlsname, Fields, 2, 'A1');%---Writing on 2nd sheet
            for c = [10 30 40 50];%---Fourier Ideal Filtering
                EI = NSRFilters(I,'ideal',c);
                FIName = strcat(path,'\',FileName,' - ','Ideal Filter',...
                                ' [Cutoff Frequency = ',num2str(c),']',Ext);
                imwrite(EI,FIName);
                if c == 10
                    i = 1;
                elseif c == 30
                    i = 2;
                elseif c == 40
                    i = 3;
                else
                    i = 4;
                end
                QM(i) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                QMxls = {'Fourier Ideal Filter',c,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
                index_num = i+1;
                cell = strcat('A',num2str(index_num));
                xlswrite(xlsname, QMxls, 2, cell);%---Writing on 2nd sheet
            end
            
            %---------------Fourier Butterworth Filtering-----------------%
            %---Creating Cell Fields for passing it to an excel file
            Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
            xlsname = strcat(path,'\',FileName,' - ','Performance Metrics.xls');
            %---Excel file in which performance metrics has to be written
            xlswrite(xlsname, Fields, 3, 'A1');%---Writing on 3rd sheet
            for c = [10 30 40 50];
                EI = NSRFilters(I,'btw',c,2);
                FIName = strcat(path,'\',FileName,' - ','Butterworth Filter',...
                                ' [Cutoff Frequency = ',num2str(c),']',Ext);
                imwrite(EI,FIName);
                if c == 10
                    i = 1;
                elseif c == 30
                    i = 2;
                elseif c == 40
                    i = 3;
                else
                    i = 4;
                end
                QM(i) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                QMxls = {'Fourier Butterworth Filter',c,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
                index_num = i+1;
                cell = strcat('A',num2str(index_num));
                xlswrite(xlsname, QMxls, 3, cell);%---Writing on 3rd sheet
            end
            
            %-------Wavelet Single Level Decomposition Filtering----------%
            %---Creating Cell Fields for passing it to an excel file
            Fields = {'Filter','Level','Band','MSE','PSNR','SNR'};
            xlsname = strcat(path,'\',FileName,' - ','Performance Metrics.xls');
            %---Excel file in which performance metrics has to be written
            xlswrite(xlsname, Fields, 4, 'A1');%---Writing on 4th sheet
            %---Wavelet Filtering
            level = 1; %---Single Level Decomposition
            for c = [1 2 3 4]
                if c == 1
                    bn = 'HL';
                    EI = NSRFilters(I,'wlet',bn,'db1',level);
                    FIName = strcat(path,'\',FileName,' - ','Wavelet Filter',...
                                 ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);
                elseif c == 2
                    bn = 'LH';
                    EI = NSRFilters(I,'wlet',bn,'db1',level);
                    FIName = strcat(path,'\',FileName,' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);
                elseif c == 3
                    bn = 'HH';
                    EI = NSRFilters(I,'wlet',bn,'db1',level);
                    FIName = strcat(path,'\',FileName,' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);
                else
                    bn = 'LH-HH';
                    EI = NSRFilters(I,'wlet',bn,'db1',level);
                    FIName = strcat(path,'\',FileName,' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);
                end
                QM(c) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                QMxls = {'Wavelet Filter',level,bn,QM(c).M_SE,QM(c).PSNR,QM(c).SNR};
                index_num = c+1;
                cell = strcat('A',num2str(index_num));
                xlswrite(xlsname, QMxls, 4, cell);%---Writing on 4th sheet
            end
            
            %-------Wavelet Second Level Decomposition Filtering----------%
            %---Creating Cell Fields for passing it to an excel file
            Fields = {'Filter','Level','Band','MSE','PSNR','SNR'};
            xlsname = strcat(path,'\',FileName,' - ','Performance Metrics.xls');
            %---Excel file in which performance metrics has to be written
            xlswrite(xlsname, Fields, 5, 'A1');%---Writing on 5th sheet
            level = 2; %---Second Level Decomposition
            for c = [1 2 3 4]
                if c == 1
                    bn = 'HL';
                    EI = NSRFilters(I,'wlet',bn,'db1',level);
                    FIName = strcat(path,'\',FileName,' - ','Wavelet Filter',...
                                 ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);
                elseif c == 2
                    bn = 'LH';
                    EI = NSRFilters(I,'wlet',bn,'db1',level);
                    FIName = strcat(path,'\',FileName,' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);
                elseif c == 3
                    bn = 'HH';
                    EI = NSRFilters(I,'wlet',bn,'db1',level);
                    FIName = strcat(path,'\',FileName,' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);
                else
                    bn = 'LH-HH';
                    EI = NSRFilters(I,'wlet',bn,'db1',level);
                    FIName = strcat(path,'\',FileName,' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);
                end
                QM(c) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                QMxls = {'Wavelet Filter',level,bn,QM(c).M_SE,QM(c).PSNR,QM(c).SNR};
                index_num = c+1;
                cell = strcat('A',num2str(index_num));
                xlswrite(xlsname, QMxls, 5, cell);%---Writing on 5th sheet
            end
            
            %--------Homomorphic Wavelet Single Level Filtering-----------%
            %---Creating Cell Fields for passing it to an excel file
            Fields = {'Filter','Level','Band','MSE','PSNR','SNR'};
            xlsname = strcat(path,'\',FileName,' - ','Performance Metrics.xls');
            %---Excel file in which performance metrics has to be written
            xlswrite(xlsname, Fields, 6, 'A1');%---Writing on 5th sheet
            level = 1; %---Single Level Decomposition
            for c = [1 2 3 4]
                if c == 1
                    bn = 'HL';
                    EI = NSRFilters(I,'hmp-wlet',bn,'db1',level);
                    FIName = strcat(path,'\',FileName,' - ','Homomorphic Wavelet Filter',...
                                 ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);
                elseif c == 2
                        bn = 'LH';
                        EI = NSRFilters(I,'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName,' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                        imwrite(EI,FIName);
                elseif c == 3
                        bn = 'HH';
                        EI = NSRFilters(I,'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName,' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                        imwrite(EI,FIName);
                else
                        bn = 'LH-HH';
                        EI = NSRFilters(I,'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName,' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                        imwrite(EI,FIName);
                end
                QM(c) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                QMxls = {'Homomorphic Wavelet Filter',level,bn,QM(c).M_SE,QM(c).PSNR,QM(c).SNR};
                index_num = c+1;
                cell = strcat('A',num2str(index_num));
                xlswrite(xlsname, QMxls, 6, cell);%---Writing on 5th sheet
            end
            
            %--------Homomorphic Wavelet Second Level Filtering-----------%
            %---Creating Cell Fields for passing it to an excel file
            Fields = {'Filter','Level','Band','MSE','PSNR','SNR'};
            xlsname = strcat(path,'\',FileName,' - ','Performance Metrics.xls');
            %---Excel file in which performance metrics has to be written
            xlswrite(xlsname, Fields, 7, 'A1');%---Writing on 5th sheet
            level = 2; %---Second Level Decomposition
            for c = [1 2 3 4]
                if c == 1
                    bn = 'HL';
                    EI = NSRFilters(I,'hmp-wlet',bn,'db1',level);
                    FIName = strcat(path,'\',FileName,' - ','Homomorphic Wavelet Filter',...
                                 ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                    imwrite(EI,FIName);
                elseif c == 2
                        bn = 'LH';
                        EI = NSRFilters(I,'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName,' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                        imwrite(EI,FIName);
                elseif c == 3
                        bn = 'HH';
                        EI = NSRFilters(I,'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName,' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                        imwrite(EI,FIName);
                else
                        bn = 'LH-HH';
                        EI = NSRFilters(I,'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName,' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext);
                        imwrite(EI,FIName);
                end
                QM(c) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                QMxls = {'Homomorphic Wavelet Filter',level,bn,QM(c).M_SE,QM(c).PSNR,QM(c).SNR};
                index_num = c+1;
                cell = strcat('A',num2str(index_num));
                xlswrite(xlsname, QMxls, 7, cell);%---Writing on 5th sheet
            end
            
            %------------Homomorphic Fourier Ideal Filtering--------------%
            %---Creating Cell Fields for passing it to an excel file
            Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
            xlsname = strcat(path,'\',FileName,' - ','Performance Metrics.xls');
            %---Excel file in which performance metrics has to be written
            xlswrite(xlsname, Fields, 8, 'A1');%---Writing on 6th sheet
            for c = [10 30 40 50];
                EI = NSRFilters(I,'hmp-ideal',c);
                FIName = strcat(path,'\',FileName,' - ','Homomorphic Ideal Filter',...
                                ' [Cutoff Frequency = ',num2str(c),']',Ext);
                imwrite(EI,FIName);
                if c == 10
                    i = 1;
                elseif c == 30
                    i = 2;
                elseif c == 40
                    i = 3;
                else
                    i = 4;
                end
                QM(i) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                QMxls = {'Homomorphic Fourier Ideal Filter',c,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
                index_num = i+1;
                cell = strcat('A',num2str(index_num));
                xlswrite(xlsname, QMxls, 8, cell);%---Writing on 6th sheet
            end
            
            %---------Homomorphic Fourier Butterworth Filtering-----------%
            %---Creating Cell Fields for passing it to an excel file
            Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
            xlsname = strcat(path,'\',FileName,' - ','Performance Metrics.xls');
            %---Excel file in which performance metrics has to be written
            xlswrite(xlsname, Fields, 9, 'A1');%---Writing on 7th sheet
            for c = [10 30 40 50];
                EI = NSRFilters(I,'hmp-btw',c,2);
                FIName = strcat(path,'\',FileName,' - ','Homomorphic Butterworth Filter',...
                                ' [Cutoff Frequency = ',num2str(c),']',Ext);
                imwrite(EI,FIName);
                if c == 10
                    i = 1;
                elseif c == 30
                    i = 2;
                elseif c == 40
                    i = 3;
                else
                    i = 4;
                end
                QM(i) = MetricsMeasurement(PreI.Ig,EI);%---Calculating Performance Metrics
                QMxls = {'Homomorphic Fourier Butterworth Filter',c,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
                index_num = i+1;
                cell = strcat('A',num2str(index_num));
                xlswrite(xlsname, QMxls, 9, cell);%---Writing on 7th sheet
            end
            
        otherwise
            error('Unknown Filter: Try Again');
    end
    winopen(path);%---Open Filtered Image folder in Windows Explorer
    
else
    
    for i=1:Index%---If multiple images are selected (more than one)
        I{1,i} = imread(FilePath{1,i});%---Read images and assign it to a Cell I
        PreI{1,i} = Preprocess(I{1,i});%---Preprocessing Image for  Performance Metrics
        
        switch FilterName
            
            %----------------------Median Filtering-----------------------%
            case 'med'
                %---Creating Cell Fields for passing it to an excel file
                Fields = {'Filter','Window','MSE','PSNR','SNR'};
                xlsname = strcat(path,'\',FileName{1,i},' - ','Performance Metrics.xls');
                %---Excel file in which performance metrics has to be written
                xlswrite(xlsname, Fields, 1, 'A1');%---Writing on Sheet 1 from cell A1
                for c = [3 5 7 9];
                    EI = NSRFilters(I{1,i},'med',c,c);
                    FIName = strcat(path,'\',FileName{1,i},' - ','Median Filter',...
                          ' [',num2str(c),'x',num2str(c),']',Ext{1,i});
                    imwrite(EI,FIName);
                    if c == 3
                        j = 1;
                    elseif c == 5
                        j = 2;
                    elseif c == 7
                        j = 3;
                    else
                        j = 4;
                    end
                    QM(j) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    c_str = num2str(c); winsize = strcat(c_str,'x',c_str);
                    QMxls = {'Median Filter',winsize,QM(j).M_SE,QM(j).PSNR,QM(j).SNR};
                    index_num = j+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 1, cell);%---Writing on 1st sheet
                end
            
            %------------------Fourier Ideal Filtering--------------------%    
            case 'ideal'
                %---Creating Cell Fields for passing it to an excel file
                Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
                xlsname = strcat(path,'\',FileName{1,i},' - ','Performance Metrics.xls');
                %---Excel file in which performance metrics has to be written
                xlswrite(xlsname, Fields, 1, 'A1');%---Writing on Sheet 1 from cell A1
                for c = [10 30 40 50];
                    EI = NSRFilters(I{1,i},'ideal',c);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Ideal Filter',...
                                ' [Cutoff Frequency = ',num2str(c),']',Ext{1,i});
                    imwrite(EI,FIName);
                    if c == 10
                        j = 1;
                    elseif c == 30
                        j = 2;
                    elseif c == 40
                        j = 3;
                    else
                        j = 4;
                    end
                    QM(j) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    QMxls = {'Fourier Ideal Filter',c,QM(j).M_SE,QM(j).PSNR,QM(j).SNR};
                    index_num = j+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 1, cell);%---Writing on 1st sheet
                end
            
            %---------------Fourier Butterworth Filtering-----------------%    
            case 'btw'
                %---Creating Cell Fields for passing it to an excel file
                Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
                xlsname = strcat(path,'\',FileName{1,i},' - ','Performance Metrics.xls');
                %---Excel file in which performance metrics has to be written
                xlswrite(xlsname, Fields, 1, 'A1');%---Writing on Sheet 1 from cell A1
                for c = [10 30 40 50];
                    EI = NSRFilters(I{1,i},'btw',c,2);
                    FIName = strcat(path,'\',FileName{1,i},' - ','Butterworth Filter',...
                                ' [Cutoff Frequency = ',num2str(c),']',Ext{1,i});
                    imwrite(EI,FIName);
                    if c == 10
                        j = 1;
                    elseif c == 30
                        j = 2;
                    elseif c == 40
                        j = 3;
                    else
                        j = 4;
                    end
                    QM(j) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    QMxls = {'Fourier Butterworth Filter',c,QM(j).M_SE,QM(j).PSNR,QM(j).SNR};
                    index_num = j+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 1, cell);%---Writing on 1st sheet
                end
            
            %------------Homomorphic Fourier Ideal Filtering--------------%    
            case 'hmp-ideal'
                %---Creating Cell Fields for passing it to an excel file
                Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
                xlsname = strcat(path,'\',FileName{1,i},' - ','Performance Metrics.xls');
                %---Excel file in which performance metrics has to be written
                xlswrite(xlsname, Fields, 1, 'A1');%---Writing on Sheet 1 from cell A1
                for c = [10 30 40 50];
                    EI = NSRFilters(I{1,i},'hmp-ideal',c);
                    FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Ideal Filter',...
                                ' [Cutoff Frequency = ',num2str(c),']',Ext{1,i});
                    imwrite(EI,FIName);
                    if c == 10
                        j = 1;
                    elseif c == 30
                        j = 2;
                    elseif c == 40
                        j = 3;
                    else
                        j = 4;
                    end
                    QM(j) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    QMxls = {'Homomorphic Fourier Ideal Filter',c,QM(j).M_SE,QM(j).PSNR,QM(j).SNR};
                    index_num = j+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 1, cell);%---Writing on 1st sheet
                end
            
            %---------Homomorphic Fourier Butterworth Filtering-----------%    
            case 'hmp-btw'
                %---Creating Cell Fields for passing it to an excel file
                Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
                xlsname = strcat(path,'\',FileName{1,i},' - ','Performance Metrics.xls');
                %---Excel file in which performance metrics has to be written
                xlswrite(xlsname, Fields, 1, 'A1');%---Writing on Sheet 1 from cell A1
                for c = [10 30 40 50];
                    EI = NSRFilters(I{1,i},'hmp-btw',c,2);
                    FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Butterworth Filter',...
                                ' [Cutoff Frequency = ',num2str(c),']',Ext{1,i});
                    imwrite(EI,FIName);
                    if c == 10
                        j = 1;
                    elseif c == 30
                        j = 2;
                    elseif c == 40
                        j = 3;
                    else
                        j = 4;
                    end
                    QM(j) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    QMxls = {'Homomorphic Butterworth Ideal Filter',c,QM(j).M_SE,QM(j).PSNR,QM(j).SNR};
                    index_num = j+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 1, cell);%---Writing on 1st sheet
                end
            
            %--------------------Wavelet Filtering------------------------%    
            case 'wlet'
                
                %----Second Level Decomposition
                %---Creating Cell Fields for passing it to an excel file
                Fields = {'Filter','Level','Band','MSE','PSNR','SNR'};
                xlsname = strcat(path,'\',FileName{1,i},' - ','Performance Metrics.xls');
                %---Excel file in which performance metrics has to be written
                xlswrite(xlsname, Fields, 1, 'A1');%---Writing on Sheet 1 from cell A1
                level = 1;%----Second Level Decomposition
                for c = [1 2 3 4]
                    if c == 1
                        bn = 'HL';
                        EI = NSRFilters(I{1,i},'wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Wavelet Filter',...
                                 ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                        imwrite(EI,FIName);
                    elseif c == 2
                        bn = 'LH';
                        EI = NSRFilters(I{1,i},'wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                        imwrite(EI,FIName);
                    elseif c == 3
                        bn = 'HH';
                        EI = NSRFilters(I{1,i},'wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                        imwrite(EI,FIName);
                    else
                        bn = 'LH-HH';
                        EI = NSRFilters(I{1,i},'wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                        imwrite(EI,FIName);
                    end
                    QM(c) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    QMxls = {'Wavelet Filter',level,bn,QM(c).M_SE,QM(c).PSNR,QM(c).SNR};
                    index_num = c+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 1, cell);%---Writing on 1st sheet
                end
                
                
                %----Second Level Decomposition
                %---Excel file in which performance metrics has to be written
                xlswrite(xlsname, Fields, 2, 'A1');%---Writing on Sheet 2 from cell A1
                level = 2;%----Second Level Decomposition
                for c = [1 2 3 4]
                    if c == 1
                        bn = 'HL';
                        EI = NSRFilters(I{1,i},'wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Wavelet Filter',...
                                 ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                        imwrite(EI,FIName);
                    elseif c == 2
                        bn = 'LH';
                        EI = NSRFilters(I{1,i},'wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                        imwrite(EI,FIName);
                    elseif c == 3
                        bn = 'HH';
                        EI = NSRFilters(I{1,i},'wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                        imwrite(EI,FIName);
                    else
                        bn = 'LH-HH';
                        EI = NSRFilters(I{1,i},'wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                        imwrite(EI,FIName);
                    end
                    QM(c) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    QMxls = {'Wavelet Filter',level,bn,QM(c).M_SE,QM(c).PSNR,QM(c).SNR};
                    index_num = c+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 2, cell);%---Writing on 1st sheet
                end
            
            %---------------Homomorphic Wavelet Filtering-----------------%    
            case 'hmp-wlet'
                
                %----Second Level Decomposition
                %---Creating Cell Fields for passing it to an excel file
                Fields = {'Filter','Level','Band','MSE','PSNR','SNR'};
                xlsname = strcat(path,'\',FileName{1,i},' - ','Performance Metrics.xls');
                %---Excel file in which performance metrics has to be written
                xlswrite(xlsname, Fields, 1, 'A1');%---Writing on Sheet 1 from cell A1
                level = 1;%---Single Level Decomposition
                for c = [1 2 3 4]
                    if c == 1
                        bn = 'HL';
                        EI = NSRFilters(I{1,i},'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Wavelet Filter',...
                                 ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                        imwrite(EI,FIName);
                    elseif c == 2
                        bn = 'LH';
                        EI = NSRFilters(I{1,i},'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                        imwrite(EI,FIName);
                    elseif c == 3
                        bn = 'HH';
                        EI = NSRFilters(I{1,i},'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                        imwrite(EI,FIName);
                    else
                        bn = 'LH-HH';
                        EI = NSRFilters(I{1,i},'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                        imwrite(EI,FIName);
                    end
                    QM(c) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    QMxls = {'Homomorphic Wavelet Filter',level,bn,QM(c).M_SE,QM(c).PSNR,QM(c).SNR};
                    index_num = c+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 1, cell);%---Writing on 1st sheet
                end
                
                %----Second Level Decomposition
                xlswrite(xlsname, Fields, 2, 'A1');%---Writing on Sheet 2 from cell A1
                level = 2;%----Second Level Decomposition
                for c = [1 2 3 4]
                    if c == 1
                        bn = 'HL';
                        EI = NSRFilters(I{1,i},'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Wavelet Filter',...
                                 ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                        imwrite(EI,FIName);
                    elseif c == 2
                        bn = 'LH';
                        EI = NSRFilters(I{1,i},'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                        imwrite(EI,FIName);
                    elseif c == 3
                        bn = 'HH';
                        EI = NSRFilters(I{1,i},'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                        imwrite(EI,FIName);
                    else
                        bn = 'LH-HH';
                        EI = NSRFilters(I{1,i},'hmp-wlet',bn,'db1',level);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                        imwrite(EI,FIName);
                    end
                    QM(c) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    QMxls = {'Homomorphic Wavelet Filter',level,bn,QM(c).M_SE,QM(c).PSNR,QM(c).SNR};
                    index_num = c+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 2, cell);%---Writing on Sheet 2 from cell A(c+1)
                end
            
            %----------------------All Filtering--------------------------%    
            case 'all'
                
                %-----------------Median Filtering------------------------%
                %---Creating Cell Fields for passing it to an excel file
                Fields = {'Filter','Window','MSE','PSNR','SNR'};
                xlsname = strcat(path,'\',FileName{1,i},' - ','Performance Metrics.xls');
                %---Excel file in which performance metrics has to be written
                xlswrite(xlsname, Fields, 1, 'A1');%---Writing on Sheet 1 from cell A1
                for c = [3 5 7 9];%---Median Filtering
                    EI = NSRFilters(I{1,i},'med',c,c);
                    FIName = strcat(path,'\',FileName{1,i},' - ','Median Filter',...
                          ' [',num2str(c),'x',num2str(c),']',Ext{1,i});
                    imwrite(EI,FIName);
                    if c == 3
                        j = 1;
                    elseif c == 5
                        j = 2;
                    elseif c == 7
                        j = 3;
                    else
                        j = 4;
                    end
                    QM(j) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    c_str = num2str(c); winsize = strcat(c_str,'x',c_str);
                    QMxls = {'Median Filter',winsize,QM(j).M_SE,QM(j).PSNR,QM(j).SNR};
                    index_num = j+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 1, cell);%---Writing on Sheet 1 from cell A(j+1)
                end
                
                %--------------Fourier Ideal Filtering--------------------%
                %---Creating Cell Fields for passing it to an excel file
                Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
                xlsname = strcat(path,'\',FileName{1,i},' - ','Performance Metrics.xls');
                %---Excel file in which performance metrics has to be written
                xlswrite(xlsname, Fields, 2, 'A1');%---Writing on Sheet 2 from cell A1
                for c = [10 30 40 50];%---Fourier Ideal Filtering
                    EI = NSRFilters(I{1,i},'ideal',c);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Ideal Filter',...
                                ' [Cutoff Frequency = ',num2str(c),']',Ext{1,i});
                    imwrite(EI,FIName);
                    if c == 10
                        j = 1;
                    elseif c == 30
                        j = 2;
                    elseif c == 40
                        j = 3;
                    else
                        j = 4;
                    end
                    QM(j) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    QMxls = {'Fourier Ideal Filter',c,QM(j).M_SE,QM(j).PSNR,QM(j).SNR};
                    index_num = j+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 2, cell);%---Writing on Sheet 2 from cell A(j+1)
                end
                
                %------------Fourier Butterworth Filtering----------------%
                %---Creating Cell Fields for passing it to an excel file
                Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
                xlsname = strcat(path,'\',FileName{1,i},' - ','Performance Metrics.xls');
                %---Excel file in which performance metrics has to be written
                xlswrite(xlsname, Fields, 3, 'A1');%---Writing on Sheet 3 from cell A1
                for c = [10 30 40 50];%---Fourier Butterworth Filtering
                    EI = NSRFilters(I{1,i},'btw',c,2);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Butterworth Filter',...
                                ' [Cutoff Frequency = ',num2str(c),']',Ext{1,i});
                    imwrite(EI,FIName);
                    if c == 10
                        j = 1;
                    elseif c == 30
                        j = 2;
                    elseif c == 40
                        j = 3;
                    else
                        j = 4;
                    end
                    QM(j) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    QMxls = {'Fourier Butterworth Filter',c,QM(j).M_SE,QM(j).PSNR,QM(j).SNR};
                    index_num = j+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 3, cell);%---Writing on Sheet 3 from cell A(j+1)
                end
                
                %-----------Homomorphic Fourier Ideal Filtering-----------%
                %---Creating Cell Fields for passing it to an excel file
                Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
                xlsname = strcat(path,'\',FileName{1,i},' - ','Performance Metrics.xls');
                %---Excel file in which performance metrics has to be written
                xlswrite(xlsname, Fields, 4, 'A1');%---Writing on Sheet 4 from cell A1
                for c = [10 30 40 50];%---Homomorphic Fourier Ideal Filtering
                    EI = NSRFilters(I{1,i},'hmp-ideal',c);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Ideal Filter',...
                                ' [Cutoff Frequency = ',num2str(c),']',Ext{1,i});
                    imwrite(EI,FIName);
                    if c == 10
                        j = 1;
                    elseif c == 30
                        j = 2;
                    elseif c == 40
                        j = 3;
                    else
                        j = 4;
                    end
                    QM(j) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    QMxls = {'Homomorphic Fourier Ideal Filter',c,QM(j).M_SE,QM(j).PSNR,QM(j).SNR};
                    index_num = j+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 4, cell);%---Writing on Sheet 4 from cell A(j+1)
                end
                
                %---------Homomorphic Fourier Butterworth Filtering-------%
                %---Creating Cell Fields for passing it to an excel file
                Fields = {'Filter','Cutoff','MSE','PSNR','SNR'};
                xlsname = strcat(path,'\',FileName{1,i},' - ','Performance Metrics.xls');
                %---Excel file in which performance metrics has to be written
                xlswrite(xlsname, Fields, 5, 'A1');%---Writing on Sheet 5 from cell A1
                for c = [10 30 40 50];%---Homomorphic Fourier Butterworth Filtering
                    EI = NSRFilters(I{1,i},'hmp-btw',c,2);
                        FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Butterworth Filter',...
                                ' [Cutoff Frequency = ',num2str(c),']',Ext{1,i});
                    imwrite(EI,FIName);
                    if c == 10
                        j = 1;
                    elseif c == 30
                        j = 2;
                    elseif c == 40
                        j = 3;
                    else
                        j = 4;
                    end
                    QM(j) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    QMxls = {'Homomorphic Butterworth Ideal Filter',c,QM(j).M_SE,QM(j).PSNR,QM(j).SNR};
                    index_num = j+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 5, cell);%---Writing on Sheet 5 from cell A(j+1)
                end
                
                %-----------Wavelet Single Level Filtering----------------%
                %---Creating Cell Fields for passing it to an excel file
                Fields = {'Filter','Level','Band','MSE','PSNR','SNR'};
                xlsname = strcat(path,'\',FileName{1,i},' - ','Performance Metrics.xls');
                %---Excel file in which performance metrics has to be written
                xlswrite(xlsname, Fields, 6, 'A1');%---Writing on Sheet 6 from cell A1
                level = 1;%---Single Level Decomposition
                for c = [1 2 3 4]
                    if c == 1
                            bn = 'HL';
                            EI = NSRFilters(I{1,i},'wlet',bn,'db1',level);
                            FIName = strcat(path,'\',FileName{1,i},' - ','Wavelet Filter',...
                                 ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                            imwrite(EI,FIName);
                    elseif c == 2
                            bn = 'LH';
                            EI = NSRFilters(I{1,i},'wlet',bn,'db1',level);
                            FIName = strcat(path,'\',FileName{1,i},' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                            imwrite(EI,FIName);
                    elseif c == 3
                            bn = 'HH';
                            EI = NSRFilters(I{1,i},'wlet',bn,'db1',level);
                            FIName = strcat(path,'\',FileName{1,i},' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                            imwrite(EI,FIName);
                    else
                            bn = 'LH-HH';
                            EI = NSRFilters(I{1,i},'wlet',bn,'db1',level);
                            FIName = strcat(path,'\',FileName{1,i},' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                            imwrite(EI,FIName);
                    end
                    QM(c) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    QMxls = {'Wavelet Filter',level,bn,QM(c).M_SE,QM(c).PSNR,QM(c).SNR};
                    index_num = c+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 6, cell);%---Writing on Sheet 6 from cell A(c+1)
                end
                
                %-----------Wavelet Second Level Filtering----------------%
                %---Creating Cell Fields for passing it to an excel file
                Fields = {'Filter','Level','Band','MSE','PSNR','SNR'};
                xlsname = strcat(path,'\',FileName{1,i},' - ','Performance Metrics.xls');
                %---Excel file in which performance metrics has to be written
                xlswrite(xlsname, Fields, 7, 'A1');%---Writing on Sheet 7 from cell A1
                level = 2;%---Second Level Decomposition
                for c = [1 2 3 4]
                    if c == 1
                            bn = 'HL';
                            EI = NSRFilters(I{1,i},'wlet',bn,'db1',level);
                            FIName = strcat(path,'\',FileName{1,i},' - ','Wavelet Filter',...
                                 ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                            imwrite(EI,FIName);
                    elseif c == 2
                            bn = 'LH';
                            EI = NSRFilters(I{1,i},'wlet',bn,'db1',level);
                            FIName = strcat(path,'\',FileName{1,i},' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                            imwrite(EI,FIName);
                    elseif c == 3
                            bn = 'HH';
                            EI = NSRFilters(I{1,i},'wlet',bn,'db1',level);
                            FIName = strcat(path,'\',FileName{1,i},' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                            imwrite(EI,FIName);
                    else
                            bn = 'LH-HH';
                            EI = NSRFilters(I{1,i},'wlet',bn,'db1',level);
                            FIName = strcat(path,'\',FileName{1,i},' - ','Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                            imwrite(EI,FIName);
                    end
                    QM(c) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    QMxls = {'Wavelet Filter',level,bn,QM(c).M_SE,QM(c).PSNR,QM(c).SNR};
                    index_num = c+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 7, cell);%---Writing on Sheet 7 from cell A(c+1)
                end
                
                %-------Homomorphic Wavelet Single Level Filtering--------%
                %---Creating Cell Fields for passing it to an excel file
                Fields = {'Filter','Level','Band','MSE','PSNR','SNR'};
                xlsname = strcat(path,'\',FileName{1,i},' - ','Performance Metrics.xls');
                %---Excel file in which performance metrics has to be written
                xlswrite(xlsname, Fields, 8, 'A1');%---Writing on Sheet 8 from cell A1
                level = 1;%---Single Level Decomposition
                for c = [1 2 3 4]
                    if c == 1
                            bn = 'HL';
                            EI = NSRFilters(I{1,i},'hmp-wlet',bn,'db1',level);
                            FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Wavelet Filter',...
                                 ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                            imwrite(EI,FIName);
                    elseif c == 2
                            bn = 'LH';
                            EI = NSRFilters(I{1,i},'hmp-wlet',bn,'db1',level);
                            FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                            imwrite(EI,FIName);
                    elseif c == 3
                            bn = 'HH';
                            EI = NSRFilters(I{1,i},'hmp-wlet',bn,'db1',level);
                            FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                            imwrite(EI,FIName);
                    else
                            bn = 'LH-HH';
                            EI = NSRFilters(I{1,i},'hmp-wlet',bn,'db1',level);
                            FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                            imwrite(EI,FIName);
                    end
                    QM(c) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    QMxls = {'Homomorphic Wavelet Filter',level,bn,QM(c).M_SE,QM(c).PSNR,QM(c).SNR};
                    index_num = c+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 8, cell);%---Writing on Sheet 8 from cell A(c+1)
                end
                
                %-------Homomorphic Wavelet Second Level Filtering--------%
                %---Creating Cell Fields for passing it to an excel file
                Fields = {'Filter','Level','Band','MSE','PSNR','SNR'};
                xlsname = strcat(path,'\',FileName{1,i},' - ','Performance Metrics.xls');
                %---Excel file in which performance metrics has to be written
                xlswrite(xlsname, Fields, 9, 'A1');%---Writing on Sheet 9 from cell A1
                level = 2;%---Second Level Decomposition
                for c = [1 2 3 4]
                    if c == 1
                            bn = 'HL';
                            EI = NSRFilters(I{1,i},'hmp-wlet',bn,'db1',level);
                            FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Wavelet Filter',...
                                 ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                            imwrite(EI,FIName);
                    elseif c == 2
                            bn = 'LH';
                            EI = NSRFilters(I{1,i},'hmp-wlet',bn,'db1',level);
                            FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                            imwrite(EI,FIName);
                    elseif c == 3
                            bn = 'HH';
                            EI = NSRFilters(I{1,i},'hmp-wlet',bn,'db1',level);
                            FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                            imwrite(EI,FIName);
                    else
                            bn = 'LH-HH';
                            EI = NSRFilters(I{1,i},'hmp-wlet',bn,'db1',level);
                            FIName = strcat(path,'\',FileName{1,i},' - ','Homomorphic Wavelet Filter',...
                                ' [Level = ',num2str(level),', Band Eliminated = ',bn,']',Ext{1,i});
                            imwrite(EI,FIName);
                    end
                    QM(c) = MetricsMeasurement(PreI{1,i}.Ig,EI);%---Calculating Performance Metrics
                    QMxls = {'Homomorphic Wavelet Filter',level,bn,QM(c).M_SE,QM(c).PSNR,QM(c).SNR};
                    index_num = c+1;
                    cell = strcat('A',num2str(index_num));
                    xlswrite(xlsname, QMxls, 9, cell);%---Writing on Sheet 9 from cell A(c+1)
                end
                
            otherwise
                error('Unknown Filter: Try Again');
        end
    end
    winopen(path);%---Open Filtered Image folder in Windows Explorer
    
end
