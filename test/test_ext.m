
key = 17021215;

rng(key);

watermarked_image = imread('result/test_lsb.png');   %Ảnh đã nhúng thủy vân và cần trích xuất là input thứ 1

watermarked_array = watermarked_image(:);       %Đưa ảnh về vector 1 chiều
p = randperm(32);

keyfile = fopen('watermark_info.txt', 'r');
key = fscanf(keyfile, '%d');
watermark_size = key;
fclose(keyfile);

%watermark_size = [180 180 3];

len = prod(watermark_size);                    %Biến len có kích thước bằng với thủy vân đã nhúng + 4 bytes (chứa header)
im_log(prod(watermark_size)) = 0;                  %Tạo mảng có kích thước bằng với thủy vân đã nhúng để lưu thủy vân

k = 0;      %Tạo biến k = 4 (số bytes đã sử dụng để lưu header)
            %Control if you are using a key:
p = randperm(prod(watermark_size)*8);                %Calculating the pseudo-random indexes for subsequent pixels

%Thực hiện quá trình trích xuất thủy vân
while k < len                                     %Chạy từ k đến len - kích thước của thủy vân đã nhúng
    k = k+1;
    for j = 1:8                                   %Với mỗi bit của pixel thứ k-4 của thủy vân đã nhúng
       index = (k-1)*8 + j;                       %với mỗi pixel thứ index của ảnh chứa thủy vân
       b = bitget(watermarked_array(p(index)),1);
       if(b == 1)                                 %Nếu bit đó có giá trị là 1
           im_log(k) = bitset(im_log(k),j);   %Set giá trị cho từng bit của pixel thứ k-4 của thủy vân
       end
    end
end
%Kết thúc quá trình trích xuất thủy vân

im_log = uint8(im_log);     %Convert the values of im_log in whole
watermark_recover = reshape(im_log,watermark_size(1),watermark_size(2),watermark_size(3));  %reconstruct arrays image watermark
save_image('Lưu thủy vân', watermark_recover);
