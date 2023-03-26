%Trích xuất thủy vân bằng thuật toán DWT
%Đầu vào:
%   - img: Ảnh gốc ban đầu
%   - watermarked_img: Ảnh đã chứa thủy vân cần trích xuất
%Đầu ra:
%   - recover_watermark: Thủy vân trích xuất được

function [recover_watermark] = extract_dwt(varargin)

watermarked_img = varargin{1};

%Lẩy ảnh gốc và thực hiện biến đổi
img = varargin{2};
img = double(img);
[~, ~, r] = size(img); % r: số channel màu của ảnh - (RGB : 3)

weight = 0.01;

for channel = 1:r
    [ca,~,~,~] = dwt2(img(:,:,channel),'haar'); %Thực hiện biến đổi wavelet mức 1 cho ảnh gốc
    [caa,cha,cva,cda] = dwt2(ca,'haar');        %Chọn dải tần phụ ca và thực hiện biến đổi wavelet mức 2
    y = [caa cha;cva cda];
    
    %Áp dụng phép biến đổi wavelet tương tự cho ảnh chứa thủy vân cần trích xuất
    [w_ca,~,~,~] = dwt2(watermarked_img(:,:,channel),'haar');
    [w_caa,w_cha,w_cva,w_cda] = dwt2(w_ca,'haar');
    n1(:,:,channel) = [w_caa,w_cha;w_cva,w_cda];

    recover(:,:,channel) = n1(:,:,channel) - y;
    recover(:,:,channel) = recover(:,:,channel)/weight;
end

recover_watermark = uint8(recover);

end
