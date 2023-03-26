key = 17021215;

rng(key);       % the seed is any non-negative integer < 2^32
%rng sẽ thay đổi trạng thái của generator giúp việc sinh ra các dãy
%random trả về cùng 1 kết quả khi có cùng seed (ở đây chính là key)
keyfile = fopen('key.txt', 'w');
fprintf(keyfile,'%d',key);
fclose(keyfile);

cover_image = imread('dataset/lena.png');     %Ảnh cover là input thứ 1
%[xc,yc,~] = size(cover_image);

watermark_image = imread('dataset/watermark_qr.png'); %Ảnh thủy vân là input thứ 2
[xw,yw,~] = size(watermark_image);
if(xw > 180 && yw > 180)
    watermark_image = imresize(watermark_image, [180 180]); % Kiểm tra kích thước của thủy vân, nếu lớn quá thì resize
end

dim = size(watermark_image);

infofile = fopen('watermark_info.txt', 'w');
fprintf(infofile,'%d\t',dim);
fclose(infofile);

p = randperm(32);       %Khởi tạo một vec-tơ chỉ mục cho 32 pixel đầu tiên được sửa đổi
%p = randperm(n) returns a row vector containing a random permutation of the integers from 1 to n without repeating elements.

if(prod(size(cover_image)) >= (prod(dim)*8+32))             %Kiểm tra nếu kích thước của ảnh gốc có thể chứa được thủy vân
        im_w = watermark_image(:);                         %Đưa thủy vân về vector 1 chiều (dạng cột)
        %disp(size(im_w));          %[49152 1]
        im = cover_image(:);                               %Đưa ảnh gốc về vector 1 chiều (dạng cột)
        %disp(size(im));            %[786432 1] - 786432 hang - 1 cot
        
        x = ones(length(im),1);     %Tạo ra vector 1 chiều cùng kích thước với ảnh cover chỉ chứa số 1
        y = uint8(x*254);           %Tạo ra vector 1 chiều cùng kích thước với ảnh cover chỉ chứa số 254
        im = bitand(im,y);          %Septum 0 to the least significant bits của ảnh gốc
        %disp(size(im));            %[786432 1]

        p = randperm(length(im_w)*8);            %Calculating the pseudo-random indexes for subsequent pixels
        
        k = 0;
        len = prod(dim);
        %Bắt đầu quá trình nhúng thủy vân vào ảnh cover
        while k < len                                 %Xét từng bit của thủy vân trên 1 pixel ảnh cover (trừ 4 pixel đầu)
            k = k+1;                                  %Tăng k lên 1
            for j = 1:8                               %Với mỗi bit thứ j trên pixel thứ k của thủy vân
               index = (k-1)*8 + j;                   %Với mỗi pixel thứ index trên ảnh cover
               b = bitget(im_w(k),j);               %Lấy bit thứ j của pixel thứ k của thủy vân
               if(b == 1)                             %Nếu bit đó = 1
                   im(p(index)) = bitset(im(p(index)),1);
               end
            end
        end
        %Kết thúc quá trình nhúng thủy vân

        [x,y,z] = size(cover_image);
        watermarked = reshape(im,x,y,z);
        save_image('Lưu ảnh đã nhúng thủy vân', watermarked);
else
        disp('Thủy vân quá lớn');
end