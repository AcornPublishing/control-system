/* Model: dsys
 * Sampling period =  0.100000 seconds
 *
 * Input scaling:  [2]
 * State scaling:  [0.5           4]
 * Output scaling: [2]
 *
 * Generated at 19:17:18 on 26-Feb-2003
 */

/* n = #states, m = #outputs, r = #inputs */
enum {n_dsys = 2, m_dsys = 1, r_dsys = 1};

void Initialize_dsys(const short* x0);
void Update_dsys(const short* u);
const short *Output_dsys();
const short *State_dsys();

static const short a[n_dsys*n_dsys] =
{
     22685,  -5041,
      1260,  27726
};

static const short b[n_dsys*r_dsys] =
{
      5041,
       130
};

static const short c[m_dsys*n_dsys] =
{
         0,  32767
};

static const short d[m_dsys*r_dsys] =
{
         0
};

static short x[n_dsys], y[m_dsys];

void Initialize_dsys(const short* x0)
{
    int i;
    
    /* Initialize x */
    for (i=0; i<n_dsys; i++)
        x[i] = x0[i];
}

void Update_dsys(const short* u)
{
    int i, j, n_offset = 0, r_offset = 0;
    short x_next[n_dsys];
    long accum;
    
    /* Evaluate x_next = A*x + B*u */
    for (i=0; i<n_dsys; i++)
    {
        accum = 0;

        for (j=0; j<n_dsys; j++)
            accum += (long) a[n_offset+j]*x[j];
            
        for (j=0; j<r_dsys; j++)
            accum += (long) b[r_offset+j]*u[j];
        
        accum = (accum >> 15) * 38543;
        x_next[i] = (short) (accum >> 15);

        n_offset += n_dsys;
        r_offset += r_dsys;
    }
    
    n_offset = 0;
    r_offset = 0;
    
    /* Evaluate y = C*x + D*u */
    for (i=0; i<m_dsys; i++)
    {
        accum = 0;

        for (j=0; j<n_dsys; j++)
            accum += (long) c[n_offset+j]*x[j];
            
        for (j=0; j<r_dsys; j++)
            accum += (long) d[r_offset+j]*u[j];
            
        accum = (accum >> 15) * 32767;
        y[i] = (short) (accum >> 15);

        n_offset += n_dsys;
        r_offset += r_dsys;
    
    /* Update x to its next value */
    for (i=0; i<n_dsys; i++)
        x[i] = x_next[i];
    }
}

const short *Output_dsys()
{
    return y;
}

const short *State_dsys()
{
    return x;
}

