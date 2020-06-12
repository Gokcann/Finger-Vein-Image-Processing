function convoluted_image = convolution(image,sigma2)

[n_rows,n_columns] = size(image);


image = [image,image(:,end:-1:1); 
    image(end:-1:1,:),image(end:-1:1,end:-1:1)];


fft_image = fftshift(fft2(image(:,:)));


[frequencies_x,frequencies_y] = meshgrid(1:2*n_columns,1:2*n_rows);
frequencies_x = frequencies_x - (n_columns+1);
frequencies_y = frequencies_y - (n_rows+1);
frequencies_x = frequencies_x*pi/n_columns;
frequencies_y = frequencies_y*pi/n_rows;
fft_gaussian = exp(-(frequencies_x.^2+frequencies_y.^2)/2*sigma2^2);
product_fft = fft_image.*fft_gaussian;

convoluted_image = real(ifft2(ifftshift(product_fft)));

convoluted_image = convoluted_image(1:n_rows,1:n_columns);
