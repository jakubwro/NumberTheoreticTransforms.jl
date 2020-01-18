using BenchmarkTools
using NumberTheoreticTransforms, FFTW

const x = mod.(rand(Int, 4096), 65537);
@btime fnt($x, $169, $65537);
@btime fft($x);

const x2 = mod.(rand(Int, 8192), 65537);
@btime fnt($x2, $225, $65537);
@btime fft($x2);
