// Model: dsys 
// Sampling period = 0.100000 seconds
//
// Input scaling:  [2]
// State scaling:  [0.5           4]
// Output scaling: [2]
//
// Generated at 19:17:18 on 26-Feb-2003

class dsys
{
public:
    // n = #states, m = #outputs, r = #inputs
    enum {n = 2, m = 1, r = 1};

    void Initialize(const short x0[n]);
    void Update(const short u[r]);
    const short* Output(void) const { return y; }
    const short* State(void) const { return x; }

private:
    static const short a[n*n], b[n*r], c[m*n], d[m*r];
    short x[n], y[m];
};

const short dsys::a[n*n] =
{
     22685,  -5041,
      1260,  27726
};

const short dsys::b[n*r] =
{
      5041,
       130
};

const short dsys::c[m*n] =
{
         0,  32767
};

const short dsys::d[m*r] =
{
         0
};

void dsys::Initialize(const short x0[n])
{
    int i;
    
    // Initialize x
    for (i=0; i<n; i++)
        x[i] = x0[i];
}

void dsys::Update(const short u[r])
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
        
        accum = (accum >> 15) * 38543;
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
            
        accum = (accum >> 15) * 32767;
        y[i] = (short) (accum >> 15);

        n_offset += n;
        r_offset += r;
    }
    
    // Update x to its next value
    for (i=0; i<n; i++)
        x[i] = x_next[i];
}

