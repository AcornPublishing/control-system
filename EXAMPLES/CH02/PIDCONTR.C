#include <math.h>

/* Select 'double' or 'float' here: */
typedef double real;

void PID_Initialize(real kp, real ki, real kd,
    real error_thresh, real step_time);
real PID_Update(real error);

static int m_started;
static real m_kp, m_ki, m_kd, m_h, m_inv_h, m_prev_error,
        m_error_thresh, m_integral;

void PID_Initialize(real kp, real ki,
    real kd, real error_thresh, real step_time)
{
    /* Initialize controller parameters */
    m_kp = kp;
    m_ki = ki;
    m_kd = kd;
    m_error_thresh = error_thresh;

    /* Controller step time and its inverse */
    m_h = step_time;
    m_inv_h = 1 / step_time;

    /* Initialize integral and derivative calculations */
    m_integral = 0;
    m_started = 0;
}

real PID_Update(real error)
{
    real q, deriv;

    /* Set q to 1 if the error magnitude is below
       the threshold and 0 otherwise */
    if (fabs(error) < m_error_thresh)
        q = 1;
    else
        q = 0;

    /* Update the error integral */
    m_integral += m_h*q*error;

    /* Compute the error derivative */
    if (!m_started)
    {
        m_started = 1;
        deriv = 0;
    }
    else
        deriv = (error - m_prev_error) * m_inv_h;

    m_prev_error = error;

    /* Return the PID controller actuator command */
    return m_kp*(error + m_ki*m_integral + m_kd*deriv);
}
