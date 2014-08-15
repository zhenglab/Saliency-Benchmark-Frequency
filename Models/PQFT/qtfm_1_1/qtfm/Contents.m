% Quaternion Toolbox
% Version 1.1 15-May-2007
% ---------------------------------------------------------------------
% Copyright © 2005-7  Stephen J. Sangwine         (S.Sangwine@IEEE.org)
%                     Nicolas Le Bihan   (nicolas.le-bihan@lis.inpg.fr)
%                     See the file Copyright.m for further details.
% ---------------------------------------------------------------------
%
% quaternion is a Matlab class library designed to extend Matlab in as
% natural a way as possible to handle quaternions. Many standard Matlab
% features have been implemented, including standard operators such as
% the arithmetic operators, matrix and elementwise products, indexing
% and indexed assignment using the colon operator, concatenation, end
% indexing, transpose and conjugate transpose, raising to a power, etc.
%
% A major objective has been to make it possible to write code that can
% work unchanged for real, complex, quaternion, and even complexified
% quaternion arrays, and for this reason standard Matlab functions have
% been overloaded for quaternion arrays.
%
% A quaternion object, as implemented by this class, has a private
% implementation based on a structure array storing the four components
% of the quaternion. As with any standard Matlab type, a quaternion is by
% default a matrix. A single quaternion is simply a matrix of one element.
%
% Quaternions may be pure or full. Pure quaternions have no scalar part
% and operations that attempt to access the scalar part will result in an
% error. The quaternions in a vector or matrix are either all pure or all
% full -- it is not possible to construct a vector or matrix with a mix
% of the two. A full quaternion with a scalar part which is zero differs
% from a pure quaternion, which has no scalar part.
%
% Quaternion matrices can be constructed either by using a constructor
% function, like this:
%
% q = quaternion(eye(5,5), zeros(5,5), randn(5,5), ones(5,5))
%
% or by using the three quaternion operators, named q1, q2 and q3, (these
% three operators are also available under the names qi, qj and qk) like this:
%
% q = eye(5,5) + zeros(5,5) * q1 + randn(5,5) * q2 + ones(5,5) * q3
%
% The components of the quaternion so constructed will have a type determined
% by the type supplied for the components (e.g. double, uint8, int16 ....).
% The components may be REAL or COMPLEX. A complex quaternion can also be
% constructed like this:
%
% q = complex(quaternion(1,2,3,4), 3)
%
% or using the Matlab value i:
%
% q = quaternion(1,2,3,4) + quaternion(5,6,7,8) .* i
%
% The components of a quaternion can be extracted using the five functions:
%
%   scalar         - Scalar part of a quaternion.
%   vector, v      - Vector part of a quaternion (synonyms).
%   s, x, y, z     - Components of a quaternion.
%
%   real           - Real part of a (complex) quaternion.
%   imag           - Imaginary part of a (complex) quaternion.
%   complex        - Construct a complex quaternion from real quaternions.
%   quaternion     - Construct a quaternion from real or complex values.
%
% Other functions implemented are:
%
%   abs            - Modulus of a quaternion.
%   conj           - Conjugate (quaternion, complex or total).
%   unit           - Normalise a quaternion.
%   sign           - Equivalent to unit, cf Matlab sign.m.
%   inv            - Matrix and quaternion inverse.
%   axis           - Axis of a quaternion.
%   angle          - Angle or argument of a quaternion.
%
%   ceil, floor    - Round elements of quaternion towards plus or minus 
%   fix, round       infinity, zero, or nearest integer.
%
%   display        - Display array (does not show values)
%   disp           - Display without array name.
%   displayall     - Display components of quaternion.
%   show           - Shorter synonym for displayall.
%   char           - Convert quaternion to string.
%   fprintf        - Output quaternions to file.
%   write          - Write a quaternion array   to a text file.
%   read           - Read  a quaternion array from a text file.
%
%   convert        - Convert components of quaternion to a different type.
%
%   scalar_product - Scalar (dot) product (elementwise).
%   cross          - Vector (cross) product (elementwise).
%   vector_product - Synonym for cross.
%
%   exp            - Exponential function.
%   log            - Natural logarithm.
%
%   sqrt           - Square root.
%
%   sin, cos, tan  - Trigonometric functions.
%   asin, acos,
%         atan     - Inverse trigonometric functions.
%   sinh, cosh,
%         tanh     - Hyperbolic functions.
%   asinh, acosh,
%          atanh   - Inverse hyperbolic functions.
%
%   diag           - Extract or construct a diagonal.
%   triu/tril      - Extract upper or lower triangular.
%   norm           - Vector and matrix norms.
%   sum            - Sum elements or columns.
%   mean           - Mean of elements or columns.
%
%   ispure         - Test whether a quaternion (array) is pure.
%   isempty        - Test whether a quaternion (array) is empty.
%   isfinite       - Test whether a quaternion (array) is finite.
%   isinf          - Test whether a quaternion (array) is infinite.
%   isnan          - Test whether a quaternion (array) is NaN.
%   isreal         - Test whether a quaternion (array) is real.
%   ishermitian    - Test whether a quaternion (array) is Hermitian.
%   isunitary      - Test whether a quaternion (array) is unitary.
%
%   length         - Length of a quaternion vector.
%   size           - Size of a quaternion array.
%   numel          - Number of elements in a quaternion array.
%   repmat         - Replicate and tile a quaternion array.
%   cat            - Concatenate arrays.
%
%   det            - Determinant.
%   svd            - Singular value decomposition.
%   eig            - Eigenvalue decomposition.
%
%   adjoint        - The adjoint matrix of a quaternion matrix.
%   unadjoint      - Construct a quaternion matrix from its adjoint.
%
%   conv, conv2    - Convolution.
%
%   fft            - One dimensional (default) quaternion Fourier transform.
%   fft2           - Two dimensional (default) quaternion Fourier transform.
%   qfft           - One dimensional left or right one-dimensional QFFT.
%   qdft           - One dimensional left or right one-dimensional QDFT.
%   qfft2          - Two dimensional left or right two-dimensional QFFT.
%   qdft2          - Two dimensional left or right two-dimensional QDFT.
%   fftshift       - Quaternion overloading of the standard Matlab function.
%   .............  - All of the above have inverses, prefixed with 'i'.
%
% The following builtin Matlab functions also work for quaternion arrays:
%
%   flipud, fliplr, rot90, ndims, trace, isequal, isscalar, isvector
%
% The following Matlab functions also work for quaternion arrays:
%
%   cov, dot, princomp, rank, var (there may be others)
%
% The following function is not yet usable: reshape.
%
% There are some auxiliary functions which are used to compute some of the
% more elaborate functions above, such as svd, eig and qdft. These are:
%
% change_basis, orthonormal_basis, orthogonal.
% householder_vector, householder_matrix, bidiagonalize, tridiagonalize.
%
% Some test code is provided in the directory 'test'. To run it set the
% working directory to 'test' and type 'test'. This runs all the test
% code.
%
% For more information, use help.

