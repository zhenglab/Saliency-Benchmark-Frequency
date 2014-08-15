function q = times(l, r)
% .*  Array multiply.
% (Quaternion overloading of standard Matlab function.)
 
% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(2, 2, nargin)), error(nargoutchk(0, 1, nargout)) 

if isa(l, 'quaternion') && isa(r, 'quaternion')
    
    % Both arguments are quaternions. There are four cases to handle,
    % dependent on whether the arguments are pure or full.
    
    if ispure_internal(l) && ispure_internal(r)
        %q = -scalar_product(l, r) + vector_product(l, r);
        xl = exe(l); xr = exe(r);
        yl = wye(l); yr = wye(r);
        zl = zed(l); zr = zed(r);
        q = class(compose(-(xl .* xr + yl .* yr + zl .* zr), ... 
                            yl .* zr - zl .* yr, ...
                            zl .* xr - xl .* zr, ...
                            xl .* yr - yl .* xr), 'quaternion');
    elseif ispure_internal(l)
        q = l .* ess(r) + l .* vee(r);
    elseif ispure_internal(r)
        q = ess(l) .* r  + vee(l) .* r;
    else
        sl = ess(l); vl = vee(l);
        sr = ess(r); vr = vee(r);
        q = sl .* sr + vl .* sr + sl .* vr + vl .* vr;
    end
   
else
    % One of the arguments is not a quaternion. If it is numeric, we can
    % handle it, and we must because the code above requires us to multiply
    % scalar parts by vector parts using a recursive call to this function.
    
    if isa(l, 'quaternion') && isa(r, 'numeric')
        if ispure_internal(l)
            q = class(compose(exe(l) .* r, wye(l) .* r, zed(l) .* r), 'quaternion');
        else
            q = class(compose(ess(l) .* r, ...
                              exe(l) .* r, wye(l) .* r, zed(l) .* r), 'quaternion');
        end
    elseif isa(l, 'numeric') && isa(r, 'quaternion')
        if ispure_internal(r)
            q = class(compose(l .* exe(r), l .* wye(r), l .* zed(r)), 'quaternion');
        else
            q = class(compose(l .* ess(r), ...
                              l .* exe(r), l .* wye(r), l .* zed(r)), 'quaternion');
        end
    else
        error('Multiplication of a quaternion by a non-numeric is not implemented.')
    end
end
