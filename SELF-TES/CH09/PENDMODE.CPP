// Model: pend_model 
// Sampling period = 0.010000 seconds
// Generated at 06:55:29 on 17-Mar-2003

class pend_model
{
public:
    // n = #states, m = #outputs, r = #inputs
    enum {n = 4, m = 3, r = 1};

    void Initialize(const double x0[n]);
    void Update(const double u[r]);
    const double* Output(void) { return y; }
    const double* State(void) { return x; }

private:
    static const double a[n*n], b[n*r], c[m*n], d[m*r];
    double x[n], y[m];
};

const double pend_model::a[n*n] =
{
     1.004530917e+000,  0.000000000e+000,  1.001509850e-002,  0.000000000e+000,
    -1.130852937e-004,  1.000000000e+000, -3.768372393e-007,  1.000000000e-002,
     9.068671693e-001,  0.000000000e+000,  1.004530917e+000,  0.000000000e+000,
    -2.263412261e-002,  0.000000000e+000, -1.130852937e-004,  1.000000000e+000
};

const double pend_model::b[n*r] =
{
    -2.313229468e-003,
     3.081305201e-004,
    -2.320207355e-001,
     3.083046783e-002
};

const double pend_model::c[m*n] =
{
     1.000000000e+000,  0.000000000e+000,  0.000000000e+000,  0.000000000e+000,
     0.000000000e+000,  1.000000000e+000,  0.000000000e+000,  0.000000000e+000,
     0.000000000e+000,  0.000000000e+000,  0.000000000e+000,  0.000000000e+000
};

const double pend_model::d[m*r] =
{
    -3.848408621e-004,
     5.133768100e-005,
     1.000000000e+000
};

void pend_model::Initialize(const double x0[n])
{
    int i;
    
    // Initialize x
    for (i=0; i<n; i++)
        x[i] = x0[i];
}

void pend_model::Update(const double u[r])
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
