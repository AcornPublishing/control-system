// Embedded Control Systems in C/C++
// by Jim Ledin
//
// Chapter 9 - Answers to Self-Test question 1

void main()
{
    // Determine initial states

    // Call the controller's Initialize function

    int n = 0; // Update counter

    // Start the real time clock counting from zero

    for (;;)
    {
        // Read the controller inputs U

        // Call the controller's Update function

        // Write the controller outputs Y

        ++n;
        // Delay until time = n * h
    }
}