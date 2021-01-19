/* Model: dsys  */
/* Sampling period =  0.100000 seconds */
/* Generated at 19:17:17 on 26-Feb-2003 */

/* n = #states, m = #outputs, r = #inputs */
enum {n_dsys = 2, m_dsys = 1, r_dsys = 1};

void Initialize_dsys(const double* x0);
void Initialize_double(const void Update_dsys(const double* u);
const double *Output_dsys();
const double *State_dsys();

static const double a[n_dsys*n_dsys] =
{
     8.143536762e-001, -2.262093545e-002,
     3.619349672e-001,  9.953211598e-001
};

static const double b[n_dsys*r_dsys] =
{
     4.524187090e-002,
     9.357680321e-003
};

static const double c[m_dsys*n_dsys] =
{
     0.000000000e+000,  5.000000000e-001
};

static const double d[m_dsys*r_dsys] =
{
     0.000000000e+000
};

static double x[n_dsys], y[m_dsys];

void Initialize_dsys(const double* x0)
{
    int i;
    
    /* Initialize x */
    for (i=0; i<n_dsys; i++)
        x[i] = x0[i];
}

void Update_dsys(const double* u)
{
    int i, j;
    double x_next[n_dsys];
    
    /* Evaluate x_next = A*x + B*u */
    for (i=0; i<n_dsys; i++)
    {
        x_next[i] = 0;
        for (j=0; j<n_dsys; j++)
            x_next[i] += a[i*n_dsys+j]*x[j];
            
        for (j=0; j<r_dsys; j++)
            x_next[i] += b[i*r_dsys+j]*u[j];
    }
    
    /* Evaluate y = C*x + D*u */
    for (i=0; i<m_dsys; i++)
    {
        y[i] = 0;
        for (j=0; j<n_dsys; j++)
            y[i] += c[i*n_dsys+j]*x[j];
            
        for (j=0; j<r_dsys; j++)
            y[i] += d[i*r_dsys+j]*u[j];
    }
    
    /* Update x to its next value */
    for (i=0; i<n_dsys; i++)
        x[i] = x_next[i];
}

const double *Output_dsys()
{
    return y;
}

const double *State_dsys()
{
    return x;
}

