# Design and Kinematic Analysis of a Dorsally Mounted Robotic Manipulator for Autonomous Underwater Vehicles

A Master of Science in Robotics capstone project by Andrew Centa, University of Minnesota (2026).

## Project Overview
Design and kinematic analysis of a novel dorsally mounted 6-DOF RRRRPR robotic manipulator 
for an Autonomous Underwater Vehicle (AUV) intended to support marine debris collection.

---

## Appendix 9.2 — MATLAB Code
Contains MATLAB scripts used for kinematic analysis of the manipulator.

### Appendix 9.2.1 — Reachable_Workspace_Graph.m
Plots the 3D reachable workspace for the collection and loading positions. For the stowed 
position, it plots the shape and orientation of all links. Also calculates the total volume 
of the reachable workspace.

### Appendix 9.2.2 — Manipulability_Analysis.m
Completes the forward kinematics to find the full transformation matrix T17. Calculates 
the Jacobian, positional Jacobian, and manipulability index using the Yoshikawa method. 
Plots the manipulability as a function of θ2 and θ3 to identify singularity regions.

---

## Appendix 9.3 — SOLIDWORKS CAD
Contains all SolidWorks CAD files for the AUV and manipulator assembly.

### Files
- **AUV Assembly.SLDASM** — Top-level assembly. Allows complete flexibility of links and 
joints to explore various configurations and investigate potential collisions.
- **Link_1_simple.SLDPRT** — Simplified Link 1 used for ROS simulation (bisected for 
visibility, auxiliary components removed)
- **Visual_Link_1.SLDPRT** — Visual reference of the complete Link 1 geometry
- **link_2.SLDPRT** — Base rotation link
- **Link_3.SLDPRT** — Stowage extraction link
- **Link_4.SLDPRT** — Bow clearance link
- **Link_5.SLDPRT** — Obstacle avoidance and approach link
- **Link_6.SLDPRT** — Prismatic range extension link
- **Link_7.SLDPRT** — End-effector wrist link
- **Cargo Hatch.SLDPRT** — Dorsal cargo hatch cover
- **Propeller shaft.SLDPRT** — Representative propulsion component
- **Stabilizers.SLDPRT** — Retractable seafloor stabilizers
- **P link outer.SLDPRT** — Outer profile of prismatic link

---

## Appendix 9.4 — ROS Simulation (see specific README and REQUIREMENTS files)
Contains all files required to recreate the ROS 2 kinematic simulation in RViz.

### Appendix 9.4.1 — animate_arm.py
Custom Python 3.10 script that drives the RViz animation. Defines joint states to command 
the linkage through the eight simulation steps across five unique positions: stowed, 
pre-collection, collection, pre-load, and loading.

### Appendix 9.4.2 — Animation
Video recording of the full RViz animation cycle. The simulation begins in the stowed 
position and travels through all positions before returning to stowed. Link 1 is bisected 
for a clear view of all internal links.

### Appendix 9.4.3 — ROS Simulation Files
Full ROS 2 package including:
- URDF robot description file
- STL mesh files for each link
- Config and launch files

See REQUIREMENTS.md for software setup instructions.
See README.md in the ROS2_Simulation folder for step-by-step installation and run instructions.

### Appendix 9.4.4 — ROS Specific .SLDPRT CAD Files
SolidWorks part files that were specifically prepared for ROS export, including the 
simplified and bisected Link 1 geometry used in the simulation.

---

## References
Full project report, kinematic derivations, and references are available in the capstone 
report submitted to the University of Minnesota Graduate School (2026).