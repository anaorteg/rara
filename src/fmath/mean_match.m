function outI = mean_match(inputI, m)
% inputI is the image in format double.
% m is the mean value of your image type. (1/2, 255/2, 65535/2, ...)

    O = double(ones(size(inputI)));

    M = mean(inputI(:));
    outI = inputI+(m-M).*O;

end
