%Nhúng thủy vân bằng thuật toán DWT
%Đầu vào:
%   - img: Ảnh gốc
%   - watermark_img: Thủy vân sử dụng để nhúng
%Đầu ra:
%   - watermarked: Ảnh gốc sau khi nhúng thủy vân
%   - time: Thời gian thực hiện

function [watermarked, time] = embed_dwt(varargin)

%Lấy ảnh gốc từ đầu vào
img = varargin{1};
img = double(img);
[p, q, r] = size(img);

%Lấy thủy vân từ đầu vào
watermark_img = varargin{2};
watermark = imresize(watermark_img,[p/2 q/2]);
watermark = double(watermark);

heso   = 0.01; %Hệ số nhúng
height = p/4;
width  = q/4;

tic;
for channel = 1:r
    [ca,ch,cv,cd] = dwt2(img(:,:,channel),'haar');  %Biến đổi wavelet mức 1 cho channel thứ r của ảnh gốc (R-G-B)
    [ca2,ch2,cv2,cd2] = dwt2(ca,'haar');            %Biến đổi wavelet mức 2 cho dải tần phụ ca
    y = [ca2 ch2;cv2 cd2];
    %disp(size(y));    %[256 256] %Cùng kích thước với thủy vân
    Watermarked = y + heso*watermark(:,:,channel);
    for i = 1:height
        for j = 1:width
            marked_ca2(i,j) = Watermarked(i,j);
            marked_ch2(i,j) = Watermarked(i,j+width);
            marked_cv2(i,j) = Watermarked(i+height,j);
            marked_cd2(i,j) = Watermarked(i+height,j+height);
        end
    end
    marked_ca = idwt2(marked_ca2,marked_ch2,marked_cv2,marked_cd2,'haar');
    watermarked_img(:,:,channel) = (idwt2(marked_ca,ch,cv,cd,'haar'));
end
time = toc;

watermarked = uint8(watermarked_img);

filter = {'*.fits';'*.xls';'*.mat';'*.*'};
[file, path] = uiputfile(filter, 'Lưu file giá trị số thực của ảnh đã nhúng thủy vân');
save_path = strcat(path,'/',file);
fitswrite(watermarked_img, save_path);

end
