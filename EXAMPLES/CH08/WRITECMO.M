function write_c_model(model, dest, datatype)

%WRITE_C_MODEL  Write a C model of a discrete-time system using floating-point math.
%
%   WRITE_C_MODEL(MODEL) generates a C language implementation of
%   the discrete-time model MODEL using double precision math
%   and displays it on the screen.
%
%   WRITE_C_MODEL(MODEL, DEST) directs the C language output to
%   the file indicated by DEST. DEST is a character string name
%   of a file to be created or the integer handle of an already-
%   open output file. If DEST is an integer, the output file
%   remains open after this function completes.
%
%   WRITE_C_MODEL(MODEL, DEST, DATATYPE) uses the character string
%   typename indicated by DATATYPE instead of the 'double' type.
%
%   By Jim Ledin, 2003.

if nargin < 2
    dest = 1; % output to terminal
end

if nargin < 3
    datatype = 'double';
end

if isa(dest, 'char')
    iov = fopen(dest, 'wt');
    
    if iov == -1
        error(['Unable to open ' dest ' for output']);
    end
    
    do_close = 1;
else
    iov = dest;
    do_close = 0;
end

a = model.a;
b = model.b;
c = model.c;
d = model.d;

n = size(a, 1);
m = size(c, 1);
r = size(b, 2);

fprintf(iov, '/* Model: %s  */\n', inputname(1));
fprintf(iov, '/* Sampling period =  %f seconds */\n', get(model, 'Ts'));

cur_time = clock;
fprintf(iov, '/* Generated at %02d:%02d:%02d on %s */\n\n', ...
    fix(cur_time(4:6)), date);

model_name = inputname(1);

fprintf(iov, '/* n = #states, m = #outputs, r = #inputs */\n');
fprintf(iov, 'enum {n_%s = %d, m_%s = %d, r_%s = %d};\n\n', model_name, n, ...
    model_name, m, model_name, r);

fprintf(iov, 'void Initialize_%s(const %s* x0);\n', ...
    model_name, datatype);
fprintf(iov, 'void Update_%s(const %s* u);\n', model_name, datatype);
fprintf(iov, 'const %s *Output_%s();\n', datatype, model_name);
fprintf(iov, 'const %s *State_%s();\n\n', datatype, model_name);

fprintf(iov, 'static const %s a[n_%s*n_%s] =\n{\n    ', datatype, ...
    model_name, model_name);

for i=1:n
    for j=1:n
        fprintf(iov, '%17.9e', a(i, j));
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

fprintf(iov, 'static const %s b[n_%s*r_%s] =\n{\n    ', datatype, ...
    model_name, model_name);

for i=1:n
    for j=1:r
        fprintf(iov, '%17.9e', b(i, j));
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

fprintf(iov, 'static const %s c[m_%s*n_%s] =\n{\n    ', datatype, ...
    model_name, model_name);

for i=1:m
    for j=1:n
        fprintf(iov, '%17.9e', c(i, j));
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

fprintf(iov, 'static const %s d[m_%s*r_%s] =\n{\n    ', datatype, ...
    model_name, model_name);

for i=1:m
    for j=1:r
        fprintf(iov, '%17.9e', d(i, j));
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

fprintf(iov, 'static %s x[n_%s], y[m_%s];\n\n', datatype, model_name, ...
    model_name);

fprintf(iov, 'void Initialize_%s(const %s* x0)\n', ...
    model_name, datatype);
fprintf(iov, '{\n');
fprintf(iov, '    int i;\n');
fprintf(iov, '    \n');
fprintf(iov, '    /* Initialize x */\n');
fprintf(iov, '    for (i=0; i<n_%s; i++)\n', model_name);
fprintf(iov, '        x[i] = x0[i];\n');
fprintf(iov, '}\n\n');

fprintf(iov, 'void Update_%s(const %s* u)\n', model_name, datatype);
fprintf(iov, '{\n');
fprintf(iov, '    int i, j;\n');
fprintf(iov, '    %s x_next[n_%s];\n', datatype, model_name);
fprintf(iov, '    \n');
fprintf(iov, '    /* Evaluate x_next = A*x + B*u */\n');
fprintf(iov, '    for (i=0; i<n_%s; i++)\n', model_name);
fprintf(iov, '    {\n');
fprintf(iov, '        x_next[i] = 0;\n');
fprintf(iov, '        for (j=0; j<n_%s; j++)\n', model_name);
fprintf(iov, '            x_next[i] += a[i*n_%s+j]*x[j];\n', model_name);
fprintf(iov, '            \n');
fprintf(iov, '        for (j=0; j<r_%s; j++)\n', model_name);
fprintf(iov, '            x_next[i] += b[i*r_%s+j]*u[j];\n', model_name);
fprintf(iov, '    }\n');
fprintf(iov, '    \n');
fprintf(iov, '    /* Evaluate y = C*x + D*u */\n');
fprintf(iov, '    for (i=0; i<m_%s; i++)\n', model_name);
fprintf(iov, '    {\n');
fprintf(iov, '        y[i] = 0;\n');
fprintf(iov, '        for (j=0; j<n_%s; j++)\n', model_name);
fprintf(iov, '            y[i] += c[i*n_%s+j]*x[j];\n', model_name);
fprintf(iov, '            \n');
fprintf(iov, '        for (j=0; j<r_%s; j++)\n', model_name);
fprintf(iov, '            y[i] += d[i*r_%s+j]*u[j];\n', model_name);
fprintf(iov, '    }\n');
fprintf(iov, '    \n');
fprintf(iov, '    /* Update x to its next value */\n');
fprintf(iov, '    for (i=0; i<n_%s; i++)\n', model_name);
fprintf(iov, '        x[i] = x_next[i];\n');
fprintf(iov, '}\n\n');

fprintf(iov, 'const %s *Output_%s()\n', datatype, model_name);
fprintf(iov, '{\n');
fprintf(iov, '    return y;\n');
fprintf(iov, '}\n\n');

fprintf(iov, 'const %s *State_%s()\n', datatype, model_name);
fprintf(iov, '{\n');
fprintf(iov, '    return x;\n');
fprintf(iov, '}\n\n');

if do_close
    fclose(iov);
end