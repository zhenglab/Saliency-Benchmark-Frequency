function U = orthogonal(V, W)
% ORTHOGONAL(V) constructs a unit pure quaternion perpendicular to V, and
% perpendicular to W,  if given. V (and W if given) must be pure quaternion
% scalar(s). W need not be perpendicular to V, but it must not be parallel
% (that is the scalar product of W and V must not have unit modulus).

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

% Modified 27 September 2005 by SJS to include comments on complexified
% case.

error(nargchk(1, 2, nargin)), error(nargoutchk(0, 1, nargout))

if ~isscalar(V)
    error('First argument must not be a vector or matrix.');
end

if ~isa(V, 'quaternion') || ~ispure(V)
    error('First argument must be a pure quaternion.')
end

V = unit(V); % Ensure that V is a unit pure quaternion.

if nargin == 2
    if ~isscalar(W)
        error('Second argument must not be a vector or matrix.');
    end
    
    if ~isa(W, 'quaternion') || ~ispure(W)
        error('Second argument must be a pure quaternion.')
    end
    
    % W must be distinct in direction from V, that is it must not be
    % parallel to V. We verify this by computing the scalar product
    % between V and unit(W), which will be +1 or -1 in the case where they
    % are parallel.
    %
    % Notice that, if the scalar product is complex, the abs function ensures
    % a real result before 1 is subtracted. Thus 'parallel' in the case of
    % complex quaternions means having a scalar product with a modulus of 1.
    % It is possible this restriction could be relaxed when it is better
    % understood, but since W is somewhat arbitrary, it is not difficult to
    % make a choice that satisfies the check below.
    
    if abs(abs(scalar_product(V, unit(W))) - 1) <= eps
        error('Arguments must not be parallel to each other.');    
    end
end

% Now compute the required vector. The method used was published in:
% 
% Ell, T. A. and Sangwine, S. J., "Decomposition of 2D Hypercomplex Fourier
% Transforms into Pairs of Complex Fourier Transforms", in: Gabbouj, M. and
% Kuosmanen (eds), "Signal Processing X, Theories and Applications",
% Proceedings of EUSIPCO 2000, Tenth European Signal Processing Conference,
% Tampere, Finland, 5-8 September 2000, Vol. II, 1061-1064, section 6.
% 
% In the paper, a specific case was shown.  Here we have a general method
% for choosing one of the three basis vectors qi, qj, qk, making the choice
% in such a way that if V is one of these vectors we will choose a
% different one.

% Note: This has not been thoroughly generalized to the complex case. If V
% is a pure multivector, the result will be a pure multivector (that is a
% complex pure quaternion), but if V is purely imaginary, the result will
% be purely real. Since this code is used only if no value is given for W,
% this is not a serious limitation, since the user is free to specify W and
% thus obtain a complex result if needed. However, this issue merits
% further study. SJS 27 September 2005.

% Note added 3 October 2005. Perhaps we should test here not for equality,
% but for parallelism, using the scalar product. The code would read something
% like: if scalar_product(V, qi) == 1 | scalar_product(V, qi) == i ?
% The problem is that if V is complex, the scalar product may be imaginary.
% What do we mean by parallel? Whatever we mean, we want to avoid it and make
% a different choice.

if nargin == 1
    
    % W was not given, so we have to choose an arbitrary vector not
    % parallel to V. We make this choice in such a way that if V is
    % in the set {qi, qj, qk}, the result of the function is the
    % next element of the set (cyclically). This is not essential,
    % but since the result is arbitary, it is neater to make a
    % sensible choice, rather than an arbitrary one.
    
    if V == qi
        W = -qk;
    elseif V == qj
        W = -qi;
    else
        W = -qj;
    end;
end

% Now compute the result. We have to normalise this, because W may not be
% perpendicular to V, and therefore the result may not have unit modulus.

U = unit(cross(V, W));
