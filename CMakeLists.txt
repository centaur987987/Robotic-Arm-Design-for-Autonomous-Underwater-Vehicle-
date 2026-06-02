cmake_minimum_required(VERSION 3.5)
project(robot_arm_udrf)

find_package(ament_cmake REQUIRED)

install(DIRECTORY launch urdf meshes config textures
  DESTINATION share/${PROJECT_NAME}
)

ament_package()
