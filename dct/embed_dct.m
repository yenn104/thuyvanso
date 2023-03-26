%{
Thực hiện nhúng thủy vân bằng thuật toán DCT
Đầu vào:
- original_img: ảnh gốc cần nhúng thủy vân.
- watermark: thủy vân.
Đầu ra:
- watermarked: ảnh gốc đã chứa thủy vân
- time: thời gian thực hiện nhúng
%}

function [watermarked, time] = embed_dct(varargin)

%Chọn ảnh gốc cần nhúng thủy vân
cover_img = varargin{1};
cover_img = im2double(cover_img);
[p, q, r] = size(cover_img);

%Khởi tạo ma trận có cùng kích thước với ảnh gốc chỉ chứa giá trị 0 làm ảnh đã chứa thủy vân.
watermarkedImage = zeros(p,q);

%Chọn thủy vân
watermark = varargin{2};
watermark = imresize(watermark,[p/4 q/4]);
[R1, C1 , ~] = size(watermark);
watermark_img = im2double(watermark);

heso = 0.03;
bits = ceil((R1*C1)/(p/8*q/8));   %Chia đều mỗi khối 8x8 của ảnh gốc sẽ nhúng được `bits` bit thủy vân.
%ceil(X) trả về giá trị nguyên gần nhất lớn hơn hoặc bằng X: 0.3->1; -0.1->0; 1.1->2.

tic;
for x = 1:r
    wm = one_D(watermark_img(:,:,x),R1,C1); %Trải thủy vân thành véc-tơ 1 chiều ngang
    r1 = 1;
    r2 = 8;
    c1 = 1;
    c2 = 8;
    count = 1;
    for i = 1:p/8
        for j = 1:q/8
            block = cover_img(r1:r2,c1:c2,x); %Lấy ra 1 block con có kích thước 8x8 pixel
            f = dct2(block);    %Áp dụng phép biến đổi DCT cho khối ảnh
            f1 = one_D(f,8,8);  %Trải khối hệ số f thành véc-tơ 1 chiều ngang
            for k = 1:bits
                if(count<=length(wm))
                    f1(1,k+11) = wm(1,count)*heso;    %Nhúng các bit thủy vân vào véc-tơ hệ số bắt đầu từ hệ số thứ 11
                    count = count+1;
                end
            end
            out1 = two_D(f1,8,8);   %Biến đổi véc-tơ f1 thành khối ảnh 8x8
            out = idct2(out1);      %Biến đổi DCT nghịch
            watermarkedImage(r1:r2,c1:c2,x) = out;
            c1 = c1+8;
            c2 = c2+8;
        end
        r1 = r1+8;
        r2 = r2+8;
        c1 = 1;
        c2 = 8;
    end
    res(:,:,x) = im2uint8(watermarkedImage(:,:,x));
end
time = toc;

watermarked = res;

% Lưu file chứa hệ số thực của ảnh sau khi nhúng thủy vân
filter = {'*.fits';'*.xls';'*.mat';'*.*'};
[file, path] = uiputfile(filter, 'Lưu file giá trị ảnh đã nhúng thủy vân');
save_path = strcat(path,'/',file);
fitswrite(watermarkedImage, save_path);

end
