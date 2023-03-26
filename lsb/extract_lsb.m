function varargout = extract_lsb(varargin)

key = varargin{2};
rng(key);

watermarked_image = varargin{1};
watermarked_array = watermarked_image(:);	%Đưa ảnh về vector 1 chiều

%Lấy thông tin của thủy vân
keyfile = fopen('watermark_info.txt', 'r'); 
watermark_size = fscanf(keyfile, '%d');
fclose(keyfile);

len = prod(watermark_size);                 %Biến len có kích thước bằng với thủy vân đã nhúng
im_log(prod(watermark_size)) = 0;           %Tạo mảng có kích thước bằng với thủy vân đã nhúng để lưu thủy vân

k = 0;
p = randperm(prod(watermark_size)*8);       %Sinh chuỗi ngẫu nhiên trùng với chuỗi của quá trình nhúng

while k < len
    k = k+1;
    for j = 1:8
        index = (k-1)*8 + j;	%Xét 8 pixel một lúc của ảnh chứa để lấy ra 1 pixel của thủy vân
        b = bitget(watermarked_array(p(index)),1);  %Lấy ra bit ở vị trí thứ 1 (LSB) của pixel j của ảnh chứa
        if(b == 1)                                  %Nếu bit đó = 1
            im_log(k) = bitset(im_log(k),j);        %Set giá trị cho bit j của pixel k của thủy vân là 1 (ngược lại là 0)
        end
    end
end

im_log = uint8(im_log);
varargout{1} = reshape(im_log,watermark_size(1),watermark_size(2),watermark_size(3));

end
