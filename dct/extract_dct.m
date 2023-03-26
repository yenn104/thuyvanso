%{
Thực hiện trích xuất thủy vân bằng thuật toán DCT
Đầu vào:
- watermarkedImage: ảnh chứa thủy vân và cần trích xuất.
- originalImage: ảnh gốc của ảnh cần trích xuất thủy vân.
Đầu ra:
- recover_watermark: thủy vân trích xuất được.
%}

function [recover_watermark] = extract_dct(varargin)

watermarked_img =  varargin{1};

origin_img = varargin{2};
inputImage = im2double(origin_img);
[p, q, r] = size(inputImage);

watermark_h = p/4; %Chiều dài (height) của thủy vân đã nhúng
watermark_w = q/4; %Chiều rộng (width) của thủy vân đã nhúng

bits = ceil((watermark_h*watermark_w)/(p/8*q/8));
weight = 0.03;

for x = 1:r
    % Tạo ma trận có cùng kích thước thủy vân đã nhúng để lưu thủy vân
    W1 = zeros(watermark_h,watermark_w);
    w = one_D(W1,watermark_h,watermark_w);
    
    r1 = 1;
    r2 = 8;
    c1 = 1;
    c2 = 8;
    count = 1;
    for i = 1:p/8
        for j = 1:q/8
            block = watermarked_img(r1:r2,c1:c2,x);
            f = dct2(block);
            f1 = one_D(f,8,8);
            for k = 1:bits
                if(count<=(watermark_h*watermark_w))
                    w(1,count) = f1(1,k+11)/weight;
                    count = count+1;
                end
            end
            c1 = c1+8;
            c2 = c2+8;
        end
        r1 = r1+8;
        r2 = r2+8;
        c1 = 1;
        c2 = 8;
    end
    op(:,:,x) = im2uint8(two_D(w,watermark_h,watermark_w));
end

recover_watermark = op;

end
