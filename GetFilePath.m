function [FilePath Pathstr Name Ext Index] = GetFilePath()

% This function GetFilePath builds up filepath along with its parts for an 
% image(s) selected by the user.
%
%   INPUT:
%   OUTPUTS:
%           filepath = String Cell containing the complete path of the
%                      filename
%           pathstr  = String Cell containing the path of the filename
%               name = String Cell containing the name of files
%                ext = String Cell containing the extension of the files
%              index = Single element Vector containing the total number of
%                      files selected by the user

% ASHISH MESHRAM meetashish85@gmail.com

[FileName,PathName,FilterIndex] = uigetfile(...
                                  {'*.jpg;*.tif;*.png;*.gif','All Image Files';...
                                   '*.*','All Files'},...
                                   'Select Images','MultiSelect','on');
                               
if FilterIndex == 0
    disp(msgbox('Image(s) not selected! Try Again'));
else
    [~, Index] = size(FileName);
    for i=1:Index
        if iscell(FileName) == 1 %---On selecting multiple files FileName is a Cell
            FilePath(1,i) = strcat(PathName,FileName(1,i));%---Concatening filename and pathname
            [Pathstr, Name{1,i}, Ext{1,i}] = fileparts(FilePath{1,i});
        else %---On selecting single file FileName is a vector
            Index = 1;
            FilePath = strcat(PathName,FileName);%---Concatening filename and pathname
            [Pathstr, Name, Ext] = fileparts(FilePath);
        end
    end
end









                                 