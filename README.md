# thuyvanso
bảo vệ bản quyền ảnh bằng thủy vân số (LSB-DCT-DWT)


1. Trang chủ
-- Có 2 lựa chọn là nhúng thủy vấn và trích xuất thủy vân
![1](https://user-images.githubusercontent.com/104709491/227768008-6d8e7001-21f0-4de9-942b-f9e493681332.png)

2. Nhúng thủy vân
2.1 LSB
----- đầu vào sẽ là ảnh gốc, ảnh nhúng và từ khóa bạn muốn nhúng vào
![2](https://user-images.githubusercontent.com/104709491/227768057-e6f0da31-61ed-421b-9d13-f6ccd336b381.png)
----- đầu ra là ảnh đã được nhúng thủy vân cùng các chỉ số về thời gian nhúng là tỉ số psnr

2.2 DCT
----- đầu vào sẽ là ảnh gốc và ảnh nhúng
![4](https://user-images.githubusercontent.com/104709491/227768169-b9e82f4d-ed46-4766-9042-7b49a9c78b3f.png)
----- đầu ra tương tự 

2.3 DCT
----- đầu vào sẽ là ảnh gốc và ảnh nhúng
![6](https://user-images.githubusercontent.com/104709491/227768229-91c85d2b-eb19-433d-8656-2b3a4760ccc4.png)
----- đầu ra tương tự 

3. Trích xuất thủy vân
3.1 LSB
----- đầu vào sẽ là ảnh đã nhúng và khóa đã nhúng
![3](https://user-images.githubusercontent.com/104709491/227768299-2ca349ce-4492-4a95-b2bf-103699f676a1.png)
----- đầu ra là ảnh thủy vân cùng các chỉ số về thời gian trích xuất

3.2 DCT
----- đầu vào sẽ là ảnh đã nhúng và ảnh gốc
![5](https://user-images.githubusercontent.com/104709491/227768351-6c7a388d-244a-49a0-b779-205cc927d701.png)
----- đầu ra tương tự 

3.3 DCT
----- đầu vào sẽ là ảnh đã nhúng và ảnh gốc
![7](https://user-images.githubusercontent.com/104709491/227768355-29cebd0c-fe1b-4296-9ead-0adff4ccf475.png)
----- đầu ra tương tự 
