// Model: dsys 
// Sampling period = 0.100000 seconds
// Generated at 19:17:17 on 26-Feb-2003

class dsys
{
public:
    // n = #states, m = #outputs, r = #inputs
    enum {n = 2, m = 1, r = 1};

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
     8.143536762e-001, -2.262093545e-002,
     3.619349672e-001,  9.953211598e-001
};

const double dsys::b[n*r] =
{
     4.524187090e-002,
     9.357680321e-003
};

const double dsys::c[m*n] =
{
     0.000000000e+000,  5.000000000e-001
};

const double dsys::d[m*r] =
{
     0.000000000e+000
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
