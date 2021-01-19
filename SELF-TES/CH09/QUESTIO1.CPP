// Embedded Control Systems in C/C++
// by Jim Ledin
//
// Chapter 9 - Answers to Self-Test question 2

#include "pend_dsys_fixpt.cpp"

void main()
{
    // Determine initial states
    short x0[4] = {0, 0, 0, 0};

    // Call the controller's Initialize function
    dsys_fixpt controller;
    controller.Initialize(x0);

    int n = 0; // Update counter
    double h = 0.01; // Sampling interval, seconds

    // Start the real time clock counting from zero

    for (;;)
    {
        // Read the controller inputs U
        short u[3];

        // Call the controller's Update function
        controller.Update(u);

        // Write the controller outputs Y

        ++n;
        // Delay until time = n * h
    }
}
