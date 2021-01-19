%QUANT  Quantize the input by rounding to the nearest LSB

function y = quant(x, lsb)

y = lsb * round(x/lsb);