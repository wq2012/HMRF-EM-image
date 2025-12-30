function retval = is_octave
%IS_OCTAVE Return true if the environment is Octave.
%   RETVAL = IS_OCTAVE returns 1 if running in Octave, and 0 otherwise.

%   Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>
%
%   Please cite: Quan Wang. HMRF-EM-image: Implementation of the 
%   Hidden Markov Random Field Model and its Expectation-Maximization 
%   Algorithm. arXiv:1207.3510 [cs.CV], 2012.

  retval = exist('OCTAVE_VERSION', 'builtin') ~= 0;
end
