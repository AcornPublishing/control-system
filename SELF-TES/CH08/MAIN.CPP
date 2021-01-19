#include <cstdio>
#include <cassert>

#include "pend_dsys.cpp"
#include "pend_dsys_fixpt.cpp"

int main()
{
    dsys pend_dsys;
    dsys_fixpt pend_dsys_fixpt;

    // Initialize the floating-point model
    const double x0[dsys::n] = {0, 0, 0, 0};
    const double u0[dsys::r] = {1, 0, 0};

    pend_dsys.Initialize(x0);

	// Scale the inputs & states and initialize the fixed-point model
    const double us[dsys::r] = {4, 2, 1000};
    const double xs[dsys::n] = {2, 1, 100, 20};
    const double ys[dsys::m] = {1000};
    const double short_max = 32768;

    short u0_fixpt[dsys::r], x0_fixpt[dsys::n];

    for (int i=0; i<dsys::r; i++)
    {
        long l_val = long(u0[i] * short_max / us[i]);
        if (l_val > 32767) l_val = 32767;
        u0_fixpt[i] = short(l_val);
    }

    for (i=0; i<dsys::n; i++)
    {
        long l_val = long(x0[i] * short_max / xs[i]);
        if (l_val > 32767) l_val = 32767;
        x0_fixpt[i] = short(l_val);
    }

    pend_dsys_fixpt.Initialize(x0_fixpt);

	// Iterate the model for 11 steps & save the outputs
    FILE *iov = fopen("dsys_output.txt", "w");
    assert(iov);

    const double *y = pend_dsys.Output();
    const short *y_fixpt = pend_dsys_fixpt.Output();

    for (int n=0; n<=10; n++)
    {
        pend_dsys.Update(u0);
        pend_dsys_fixpt.Update(u0_fixpt);

        fprintf(iov, "%.16lf %.16lf\n",
            y[0], y_fixpt[0]*ys[0]/short_max);
    }

    fclose(iov);
    return 0;
}