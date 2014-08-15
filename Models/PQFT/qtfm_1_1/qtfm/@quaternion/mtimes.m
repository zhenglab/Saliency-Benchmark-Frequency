function q = mtimes(l, r)
% *   Matrix multiply.
% (Quaternion overloading of standard Matlab function.)
 
% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(2, 2, nargin)), error(nargoutchk(0, 1, nargout)) 

if isa(l, 'quaternion') && isa(r, 'quaternion')
    
    % Both arguments are quaternions. There are four cases to handle,
    % dependent on whether the arguments are pure or full.
    
    pl = ispure_internal(l);
    pr = ispure_internal(r);
    
    if pl && pr
        q = -mdot(l, r) + mcross(l, r);
    elseif pl
        q = l * ess(r) + l * vee(r);
    elseif pr
        q = ess(l) * r  + vee(l) * r;
    else
        q = ess(l) * ess(r) + vee(l) * ess(r) + ...
            ess(l) * vee(r) + vee(l) * vee(r);
    end
   
else
    % One of the arguments is not a quaternion. If it is numeric, we can
    % handle it, and we must because the code above requires us to multiply
    % scalar parts by vector parts using a recursive call to this function.
    
    if isa(l, 'quaternion') && isa(r, 'numeric')
        if ispure_internal(l)
            q = class(compose(exe(l) * r, ...
                              wye(l) * r, ...
                              zed(l) * r), 'quaternion');
        else
            q = class(compose(ess(l) * r, exe(l) * r, ...
                              wye(l) * r, zed(l) * r), 'quaternion');
        end
    elseif isa(l, 'numeric') && isa(r, 'quaternion')
        if ispure_internal(r)
            q = class(compose(l * exe(r), ...
                              l * wye(r), ...
                              l * zed(r)), 'quaternion');
        else
            q = class(compose(l * ess(r), l * exe(r), ...
                              l * wye(r), l * zed(r)), 'quaternion');
        end
    else
        error('Matrix multiplication of a quaternion by a non-numeric is not implemented.')
    end
end



