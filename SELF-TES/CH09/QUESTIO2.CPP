// Embedded Control Systems in C/C++
// by Jim Ledin
//
// Chapter 9 - Answers to Self-Test questions 4-6

#include "pend_dsys_fixpt.cpp"
#include "pend_model.cpp"

#include <cstdio>
#include <cassert>

void main()
{
    // Declare the plant and controller objects
    dsys_fixpt controller;
    pend_model plant;

    // Specify the initial states
    short controller_x0[4] = {0, 0, 0, 0};
    double plant_x0[4] = {0, 0, 0, 0};

    // Call the plant and controller intialization functions
    controller.Initialize(controller_x0);
    plant.Initialize(plant_x0);

    // Set up for the dynamic loop
    const short *controller_output = controller.Output();
    const double *plant_output = plant.Output();

    int n = 0;               // Loop counter
    double h = 0.01;         // Sampling interval, seconds
    const double r = 0.9;    // Reference input
    const double N = -223.6; // Feedforward gain
    const double short_max = 32768;

    const double us[dsys_fixpt::r] = {4, 2, 1000};
    const double ys[dsys_fixpt::m] = {1000};

    // Start the real time clock counting from zero

    // Open the data logging output file
    FILE *iov = fopen("pend.txt", "w");
    assert(iov);

    while (n < 71)
    {
        // Set up the controller inputs U
        short controller_u[3];
        for (int i=0; i<dsys_fixpt::r; i++)
            controller_u[i] = short(short_max * plant_output[i] /
                us[i]);

        // Call the controller's Update function
        controller.Update(controller_u);

        // Combine the controller output and the reference input
        double pend_u = (ys[0]*controller_output[0])/short_max +
            r*N;

        // Call the plant's Update function
        plant.Update(&pend_u);

        // Log the current plant and controller outputs
        fprintf(iov, "%lf %lf %lf %lf\n", n*h, 
            plant_output[0], plant_output[1], plant_output[2]);

        ++n;
        // Delay until time = n * h
    }

    fclose(iov);
}
