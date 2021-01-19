// Model: dsys_fixpt 
// Sampling period = 0.010000 seconds
//
// Input scaling:  [4    2 1000]
// State scaling:  [2   1 100  20]
// Output scaling: [1000]
//
// Generated at 05:51:12 on 02-Oct-2003

class dsys_fixpt
{
public:
    // n = #states, m = #outputs, r = #inputs
    enum {n = 4, m = 1, r = 3};

    void Initialize(const short x0[n]);
    void Update(const short u[r]);
    const short* Output(void) const { return y; }
    const short* State(void) const { return x; }

private:
    static const short a[n*n], b[n*r], c[m*n], d[m*r];
    short x[n], y[m];
};

const short dsys_fixpt::a[n*n] =
{
      1417,      0,   2257,      0,
         0,   4811,      0,   1327,
     -5025,      0,   7140,      0,
         0,  -2447,      0,   8464
};

const short dsys_fixpt::b[n*r] =
{
      9284,      0,  -4783,
        -6,   6365,   1962,
      4291,      0, -16311,
       -38,   3634,  12988
};

const short dsys_fixpt::c[m*n] =
{
      1367,   1564,   7940,   9145
};

const short dsys_fixpt::d[m*r] =
{
      7233,   3566,  -1951
};

void dsys_fixpt::Initialize(const short x0[n])
{
    int i;
    
    // Initialize x
    for (i=0; i<n; i++)
        x[i] = x0[i];
}

void dsys_fixpt::Update(const short u[r])
{
    int i, j, n_offset = 0, r_offset = 0;
    short x_next[n];
    long accum;
    
    // Evaluate x_next = A*x + B*u
    for (i=0; i<n; i++)
    {
        accum = 0;

        for (j=0; j<n; j++)
            accum += (long) a[n_offset+j]*x[j];
            
        for (j=0; j<r; j++)
            accum += (long) b[r_offset+j]*u[j];
        
        accum = (accum >> 15) * 122955;
        x_next[i] = (short) (accum >> 15);

        n_offset += n;
        r_offset += r;
    }
    
    n_offset = 0;
    r_offset = 0;
    
    // Evaluate y = C*x + D*u
    for (i=0; i<m; i++)
    {
        accum = 0;

        for (j=0; j<n; j++)
            accum += (long) c[n_offset+j]*x[j];
            
        for (j=0; j<r; j++)
            accum += (long) d[r_offset+j]*u[j];
            
        accum = (accum >> 15) * 153480;
        y[i] = (short) (accum >> 15);

        n_offset += n;
        r_offset += r;
    }
    
    // Update x to its next value
    for (i=0; i<n; i++)
        x[i] = x_next[i];
}

