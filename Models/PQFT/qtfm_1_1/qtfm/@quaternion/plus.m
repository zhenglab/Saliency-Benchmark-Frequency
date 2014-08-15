function q = plus(l, r)
% +   Plus.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(2, 2, nargin)), error(nargoutchk(0, 1, nargout)) 

% Three cases have to be handled:
%
% l is a quaternion, r is not,
% r is a quaternion, l is not,
% l and r are both quaternions.
%
% The complication here is that we can't call ispure() or s() etc
% for a parameter that is not a quaternion, so we have to handle
% these cases differently.

if isa(l, 'quaternion') && isa(r, 'quaternion')

  % The scalar part could be empty, and we have to handle this
  % specially, because [] + x is [] and not x, for some reason.

  pl = ispure_internal(l);
  pr = ispure_internal(r);
  if pl && pr
    q = class(compose(exe(l) + exe(r), ...
                      wye(l) + wye(r), ...
                      zed(l) + zed(r)), 'quaternion');
  elseif pl
    q = class(compose(ess(r), ...
                      exe(l) + exe(r), ...
                      wye(l) + wye(r), ...
                      zed(l) + zed(r)), 'quaternion');
  elseif pr
    q = class(compose(ess(l), ...
                      exe(l) + exe(r), ...
                      wye(l) + wye(r), ...
                      zed(l) + zed(r)), 'quaternion');
  else
    q = class(compose(ess(l) + ess(r), ...
                      exe(l) + exe(r), ...
                      wye(l) + wye(r), ...
                      zed(l) + zed(r)), 'quaternion');
  end

elseif isa(l, 'quaternion') && isa(r, 'numeric')

  if ispure_internal(l)
    q = class(compose(         r, exe(l), wye(l), zed(l)), 'quaternion');
  else
    q = class(compose(ess(l) + r, exe(l), wye(l), zed(l)), 'quaternion');
  end

elseif isa(l, 'numeric') && isa(r, 'quaternion')

  if ispure_internal(r)
    q = class(compose(l,          exe(r), wye(r), zed(r)), 'quaternion');
  else
    q = class(compose(l + ess(r), exe(r), wye(r), zed(r)), 'quaternion');
  end

else
  error('Unhandled parameter types in function +/plus')
end


