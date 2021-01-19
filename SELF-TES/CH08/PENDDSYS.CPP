// Model: dsys 
// Sampling period = 0.010000 seconds
// Generated at 05:51:12 on 02-Oct-2003

class dsys
{
public:
    // n = #states, m = #outputs, r = #inputs
    enum {n = 4, m = 1, r = 3};

    void Initialize(const double x0[n]);
    void Update(const double u[r]);
    const double* Output(void) { return y; }
    const double* State(void) { return x; }

private:
    static const double a[n*n], b[n*r], c[m*n], d[m*r];
    double x[n], y[m];
};

const double dsys::a[n*n] =
{
     1.622610500e-001,  0.000000000e+000,  5.168987941e-003,  0.000000000e+000,
     0.000000000e+000,  5.509340357e-001,  0.000000000e+000,  7.595642090e-003,
    -2.877058688e+001,  0.000000000e+000,  8.176887209e-001,  0.000000000e+000,
     0.000000000e+000, -5.604064734e+000,  0.000000000e+000,  9.692260456e-001
};

const double dsys::b[n*r] =
{
     5.315820724e-001,  0.000000000e+000, -1.095498283e-003,
    -1.648542429e-004,  3.644692283e-001,  2.246686143e-004,
     1.228423067e+001,  0.000000000e+000, -1.867930974e-001,
    -2.182722473e-002,  4.161943371e+000,  2.974683724e-002
};

const double dsys::c[m*n] =
{
     9.774000000e+001,  2.236000000e+002,  1.135000000e+001,  6.536000000e+001
};

const double dsys::d[m*r] =
{
     2.584858202e+002,  2.549000085e+002, -2.789436360e-001
};

void dsys::Initialize(const double x0[n])
{
    int i;
    
    // Initialize x
    for (i=0; i<n; i++)
        x[i] = x0[i];
}

void dsys::Update(const double u[r])
{
    int i, j;
    double x_next[n];
    
    // Evaluate x_next = A*x + B*u
    for (i=0; i<n; i++)
    {
        x_next[i] = 0;
        for (j=0; j<n; j++)
            x_next[i] += a[i*n+j]*x[j];
            
        for (j=0; j<r; j++)
            x_next[i] += b[i*r+j]*u[j];
    }
    
    // Evaluate y = C*x + D*u
    for (i=0; i<m; i++)
    {
        y[i] = 0;
        for (j=0; j<n; j++)
            y[i] += c[i*n+j]*x[j];
            
        for (j=0; j<r; j++)
            y[i] += d[i*r+j]*u[j];
    }
    
    // Update x to its next value
    for (i=0; i<n; i++)
        x[i] = x_next[i];
}
