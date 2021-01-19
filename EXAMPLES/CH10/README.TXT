Embedded Control Systems in C/C++
by Jim Ledin

Chapter 10 - Helicopter control system example

This file describes the procedures for setup and operation of
the 6DOF helicopter model and control system simulation.

The helicopter is modeled as a 6DOF system composed of three
rigid bodies: the helicopter body, the main rotor, and the tail
rotor. The dynamic behavior of this mechanical system is modeled
using SimMechanics. The aerodynamic modeling is very simple,
with forces and moments modeled as proportional to control
actuator deflection. This is a reasonable approximation for
small control deflections about an equilibrium hover condition.
Aerodynamic drag force is modeled as proportional to the square
of the helicopter velocity.

The plant actuators are the normal helicopter controls: main
rotor collective, main rotor cyclic, and rudder actuators.
Sensors are assumed to provide perfect measurements of the
helicopter position, velocity, angular orientation, and body
rotation rates. This simplified sensor modeling provides a
reasonable approximation of a modern GPS/INS navigation system.

-------------------------------------------------------------
Simulation Operation
-------------------------------------------------------------

To run this simulation, the following products are required:
MATLAB, Simulink, Stateflow, SimMechanics, Virtual Reality
Toolbox, Control System Toolbox, and Dials & Gauges Blockset.

The following steps describe how to run the simulation:

1)  Start Matlab and change the current Matlab directory to
    the directory containing the helicopter model files.
    
2)  Open the Simulink model named Helicopter.mdl.

3)  Navigate to the following subsystem:
    "Helicopter/Displays/Display Subsystem/Instruments". The
    dials & gauges should be visible.
    
4)  Start the simulation running. The dials & gauges will
    begin to update, the VR helicopter display will show the
    flight of the helicopter, and a 2-D trajectory display
    will open and begin plotting the helicopter flight path.
    Scopes will be visible that display the helicopter position,
    velocity, and Euler angles.
    
-------------------------------------------------------------
Waypoint Definition
-------------------------------------------------------------

The set of waypoints that define the helicopter's flight path
is contained in the MATLAB matrix variable named waypoint.
You can modify the helicopter's trajectory by changing the
contents of this matrix.

Each row in the waypoint matrix describes a single waypoint.
There are six columns in this matrix. Columns 1-3 are the North,
East, and Altitude coordinates of the waypoint in meters. Column
4 contains the yaw Euler angle (in degrees relative to North)
that the helicopter will assume when hovering at this waypoint.
Column 5 contains the number of seconds to hover at this waypoint.
If column 5 contains a zero, the value in column 4 is not used.
Column 6 contains the waypoint number (row index) of the waypoint
to head toward after this waypoint is reached and any hover time
has expired. To simply continue on to the waypoint in the next
row of the matrix, set the value in column 6 to zero. Column 6
provides an easy way to make an infinite loop of waypoints. To do
this, set the value in column 6 to zero for all waypoints except
for the last waypoint. In the last row of the matrix set the
value in column 6 to one. This will repeatedly execute the entire
sequence of waypoints as long as the simulation runs.

The default waypoint matrix is shown below. Waypoint number 1 is
the first waypoint the helicopter flies to when controller
execution begins.

Waypoint   North    East   Altitude  Hover Yaw	Hover Time Next Waypoint
Number   Position Position          Angle (deg) (seconds)      Number
-------- -------- -------- -------- ----------- ---------- -------------
    1      -100        0      25         0          0            0
    2      -100     -100      25         0          0            0
    3         0     -100      25         0          0            0
    4         0        0      25         0          0            0
    5      -100        0      25         0          0            0
    6      -100     -200      50         0          0            0
    7      -200     -200      50         0          0            0
    8      -200     -100      50         0          0            0
    9      -100     -100      50         0          0            0
   10      -100     -200      50         0          0            0
   11      -200     -200      50         0          0            0
   12      -200     -100      50         0          0            0
   13         0     -100      25         0          0            0
   14         0        0      25         0          0            1

   
The list below describes the files enclosed in this Zip file.

Jim Ledin, Ledin Engineering, 7/18/03

------------------------------      - -----------------------------------------
File name                             Description
------------------------------      - -----------------------------------------

Readme.txt                          - This file, which describes the simulation

Helicopter.mdl                      - Simulink helicopter/controller simulation
HelicopterBlockset.mdl              - Shared plant & controller blocks

Helicopter@*.ax (6 files)           - Dials & Gauges settings for Simulink model

HelicopterData.mat                  - Helicopter parameters (auto-loaded by model)

design_orientation_controllers.m    - Design Euler angle controllers
model_params.m                      - Parameters for the helicopter plant
lin_models.m                        - Linearized models for controller design
make_lin_model.m                    - Extracts linear models from nonlinear model

helicopter_runway.wrl               - VR world including the helicopter
