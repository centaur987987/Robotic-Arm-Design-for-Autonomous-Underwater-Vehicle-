# Dorsally Mounted Robotic Manipulator for AUV - ROS 2 Simulation

This repository contains the ROS 2 simulation package for a dorsally mounted robotic manipulator designed for an Autonomous Underwater Vehicle (AUV) intended to support marine debris collection.

This work was completed as a Master of Science in Robotics capstone project at the University of Minnesota by Andrew Centa (2026).

## Project Overview
The manipulator is a 6-DOF RRRRPR mechanism designed to:
- Collect marine debris from the seafloor or elevated surfaces
- Load collected samples into an onboard cargo compartment
- Stow compactly during transit to minimize hydrodynamic drag

The simulation demonstrates three primary operating positions:
1. **Stowed** — compact transit configuration
2. **Collection** — extended debris collection position
3. **Loading** — cargo compartment loading position

## Repository Contents
- `urdf/` — Robot description file (URDF)
- `meshes/` — STL mesh files for each link
- `launch/` — ROS 2 launch files
- `config/` — Configuration files
- `scripts/animate_arm.py` — Animation script cycling through operating positions
- `CMakeLists.txt` — ROS 2 build instructions
- `package.xml` — Package dependencies

## Requirements
See `REQUIREMENTS.md` for full software requirements.

## Setup Instructions

### 1. Install Ubuntu 22.04 via WSL2 (Windows 11)
```bash
wsl --install -d Ubuntu-22.04
wsl --update
```

### 2. Install ROS 2 Humble
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install software-properties-common curl -y
curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | sudo tee /usr/share/keyrings/ros-archive-keyring.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list
sudo apt update
sudo apt install ros-humble-desktop ros-humble-gazebo-ros-pkgs -y
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
source ~/.bashrc
```

### 3. Create ROS 2 Workspace and Clone Repository
```bash
mkdir -p ~/ros2_ws/src
cd ~/ros2_ws/src
git clone https://github.com/centaur987987/Robotic-Arm-Design-for-Autonomous-Underwater-Vehicle-.git robot_arm_udrf
```

### 4. Fix URDF Encoding (SW2URDF exports ROS 1 format)
```bash
sed -i '1s///' ~/ros2_ws/src/robot_arm_udrf/urdf/robot_arm_udrf.urdf
```

### 5. Build the Workspace
```bash
cd ~/ros2_ws
colcon build
echo "source ~/ros2_ws/install/setup.bash" >> ~/.bashrc
source ~/.bashrc
```

### 6. Launch RViz Visualization
```bash
ros2 launch urdf_tutorial display.launch.py model:=/home/$USER/ros2_ws/install/robot_arm_udrf/share/robot_arm_udrf/urdf/robot_arm_udrf.urdf
```

### 7. Run Position Animation
In a second terminal:
```bash
source ~/.bashrc
python3 ~/ros2_ws/src/robot_arm_udrf/scripts/animate_arm.py
```

### 8. Launch Gazebo Simulation
In a second terminal:
```bash
export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/home/$USER/ros2_ws/install/robot_arm_udrf/share
ros2 launch gazebo_ros gazebo.launch.py
```

In a third terminal:
```bash
ros2 run gazebo_ros spawn_entity.py -file /home/$USER/ros2_ws/install/robot_arm_udrf/share/robot_arm_udrf/urdf/robot_arm_udrf.urdf -entity robot_arm
```

## References
Full project report and MATLAB analysis available in the repository.