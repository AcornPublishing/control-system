function write_c_fixpt_model(model, us, xs, ys, dest)

%WRITE_CPP_FIXPT_MODEL  Write a C++ model of a discrete-time system using fixed-point math.
%
%   WRITE_CPP_FIXPT_MODEL(MODEL, US, XS, YS) generates a C++
%   language implementation of the discrete-time model MODEL
%   using fixed-point math and displays it on the screen. US,
%   XS, and YS are vectors containing the maximum absolute
%   values to use for scaling the corresponding elements of
%   the model U, X, and Y vectors. The data types used in the
%   model are 'short' and 'long', which are assumed to be 16
%   and 32 bits long respectively.
%
%   WRITE_CPP_FIXPT_MODEL(MODEL, US, XS, YS, DEST) directs the C++
%   language output to the file indicated by DEST. DEST is a
%   character string name of a file to be created or the integer
%   handle of an already-open output file. If DEST is an integer,
%   the output file remains open after this function completes.
%
%   By Jim Ledin, 2003.

if nargin < 5
    dest = 1; % output to terminal
end

% Adjust these definitions as needed for your compiler and target
% system
short_datatype = 'short';
long_datatype = 'long';
short_bits = 16;
long_bits = 32;

if isa(dest, 'char')
    % Set up the output file
    iov = fopen(dest, 'wt');
    
    if iov == -1
        error(['Unable to open ' dest ' for output']);
    end
    
    do_close = 1;
else
    iov = dest;
    do_close = 0;
end

% Scale the matrices
a = model.a;
b = model.b;
c = model.c;
d = model.d;

Us = diag(us);
Xs = diag(xs);
Ys = diag(ys);

a = inv(Xs) * a * Xs;
b = inv(Xs) * b * Us;
c = inv(Ys) * c * Xs;
d = inv(Ys) * d * Us;

as = 1 / max(sum(abs([a b]), 2));
cs = 1 / max(sum(abs([c d]), 2));

a = as * a;
b = as * b;
c = cs * c;
d = cs * d;

short_max = 2^(short_bits-1) - 1;

a = round(short_max * a);
b = round(short_max * b);
c = round(short_max * c);
d = round(short_max * d);

n = size(a, 1);
m = size(c, 1);
r = size(b, 2);

% Write the model
fprintf(iov, '// Model: %s \n', inputname(1));
fprintf(iov, '// Sampling period = %f seconds\n', get(model, 'Ts'));
fprintf(iov, '//\n');
fprintf(iov, ['// Input scaling:  [' num2str(us(:)') ']\n']);
fprintf(iov, ['// State scaling:  [' num2str(xs(:)') ']\n']);
fprintf(iov, ['// Output scaling: [' num2str(ys(:)') ']\n']);
fprintf(iov, '//\n');

cur_time = clock;
fprintf(iov, '// Generated at %02d:%02d:%02d on %s\n\n', ...
    fix(cur_time(4:6)), date);

class_name = inputname(1);

fprintf(iov, 'class %s\n{\npublic:\n', class_name);
fprintf(iov, '    // n = #states, m = #outputs, r = #inputs\n');
fprintf(iov, '    enum {n = %d, m = %d, r = %d};\n\n', n, m, r);

fprintf(iov, '    void Initialize(const %s x0[n]);\n', short_datatype);
fprintf(iov, '    void Update(const %s u[r]);\n', short_datatype);
fprintf(iov, '    const %s* Output(void) const { return y; }\n', short_datatype);
fprintf(iov, '    const %s* State(void) const { return x; }\n\n', short_datatype);

fprintf(iov, 'private:\n');
fprintf(iov, '    static const %s a[n*n], b[n*r], c[m*n], d[m*r];\n', short_datatype);
fprintf(iov, '    %s x[n], y[m];\n', short_datatype);

fprintf(iov, '};\n\n');

fprintf(iov, 'const %s %s::a[n*n] =\n{\n    ', short_datatype, class_name);

for i=1:n
    for j=1:n
        fprintf(iov, '%6d', a(i, j));
        if j < n
            fprintf(iov, ', ');
        end
    end
    
    if i < n
        fprintf(iov, ',\n    ');
    else
        fprintf(iov, '\n};\n\n');
    end
end

fprintf(iov, 'const %s %s::b[n*r] =\n{\n    ', short_datatype, class_name);

for i=1:n
    for j=1:r
        fprintf(iov, '%6d', b(i, j));
        if j < r
            fprintf(iov, ', ');
        end
    end
    
    if i < n
        fprintf(iov, ',\n    ');
    else
        fprintf(iov, '\n};\n\n');
    end
end

fprintf(iov, 'const %s %s::c[m*n] =\n{\n    ', short_datatype, class_name);

for i=1:m
    for j=1:n
        fprintf(iov, '%6d', c(i, j));
        if j < n
            fprintf(iov, ', ');
        end
    end
    
    if i < m
        fprintf(iov, ',\n    ');
    else
        fprintf(iov, '\n};\n\n');
    end
end

fprintf(iov, 'const %s %s::d[m*r] =\n{\n    ', short_datatype, class_name);

for i=1:m
    for j=1:r
        fprintf(iov, '%6d', d(i, j));
        if j < r
            fprintf(iov, ', ');
        end
    end
    
    if i < m
        fprintf(iov, ',\n    ');
    else
        fprintf(iov, '\n};\n\n');
    end
end

fprintf(iov, 'void %s::Initialize(const %s x0[n])\n', ...
    class_name, short_datatype);
fprintf(iov, '{\n');
fprintf(iov, '    int i;\n');
fprintf(iov, '    \n');
fprintf(iov, '    // Initialize x\n');
fprintf(iov, '    for (i=0; i<n; i++)\n');
fprintf(iov, '        x[i] = x0[i];\n');
fprintf(iov, '}\n\n');

fprintf(iov, 'void %s::Update(const %s u[r])\n', class_name, short_datatype);
fprintf(iov, '{\n');
fprintf(iov, '    int i, j, n_offset = 0, r_offset = 0;\n');
fprintf(iov, '    %s x_next[n];\n', short_datatype);
fprintf(iov, '    %s accum;\n', long_datatype);
fprintf(iov, '    \n');
fprintf(iov, '    // Evaluate x_next = A*x + B*u\n');
fprintf(iov, '    for (i=0; i<n; i++)\n');
fprintf(iov, '    {\n');
fprintf(iov, '        accum = 0;\n\n');
fprintf(iov, '        for (j=0; j<n; j++)\n');
fprintf(iov, '            accum += (%s) a[n_offset+j]*x[j];\n', long_datatype);
fprintf(iov, '            \n');
fprintf(iov, '        for (j=0; j<r; j++)\n');
fprintf(iov, '            accum += (%s) b[r_offset+j]*u[j];\n', long_datatype);
fprintf(iov, '        \n');
fprintf(iov, '        accum = (accum >> %d) * %d;\n', short_bits-1, round(short_max / as));
fprintf(iov, '        x_next[i] = (%s) (accum >> %d);\n\n', short_datatype, short_bits-1);
fprintf(iov, '        n_offset += n;\n');
fprintf(iov, '        r_offset += r;\n');
fprintf(iov, '    }\n');
fprintf(iov, '    \n');
fprintf(iov, '    n_offset = 0;\n');
fprintf(iov, '    r_offset = 0;\n');
fprintf(iov, '    \n');
fprintf(iov, '    // Evaluate y = C*x + D*u\n');
fprintf(iov, '    for (i=0; i<m; i++)\n');
fprintf(iov, '    {\n');
fprintf(iov, '        accum = 0;\n\n');
fprintf(iov, '        for (j=0; j<n; j++)\n');
fprintf(iov, '            accum += (%s) c[n_offset+j]*x[j];\n', long_datatype);
fprintf(iov, '            \n');
fprintf(iov, '        for (j=0; j<r; j++)\n');
fprintf(iov, '            accum += (%s) d[r_offset+j]*u[j];\n', long_datatype);
fprintf(iov, '            \n');
fprintf(iov, '        accum = (accum >> %d) * %d;\n', short_bits-1, round(short_max / cs));
fprintf(iov, '        y[i] = (%s) (accum >> %d);\n\n', short_datatype, short_bits-1);
fprintf(iov, '        n_offset += n;\n');
fprintf(iov, '        r_offset += r;\n');
fprintf(iov, '    }\n');
fprintf(iov, '    \n');
fprintf(iov, '    // Update x to its next value\n');
fprintf(iov, '    for (i=0; i<n; i++)\n');
fprintf(iov, '        x[i] = x_next[i];\n');
fprintf(iov, '}\n\n');

if do_close
    fclose(iov);
end