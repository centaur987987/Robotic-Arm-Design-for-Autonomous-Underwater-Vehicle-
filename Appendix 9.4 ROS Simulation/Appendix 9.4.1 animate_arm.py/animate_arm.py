import rclpy
from rclpy.node import Node
from sensor_msgs.msg import JointState
import time
import math

class ArmAnimator(Node):
    def __init__(self):
        super().__init__('arm_animator')
        self.publisher = self.create_publisher(JointState, '/joint_states', 10)
        self.joint_names = ['joint_1', 'joint_2', 'joint_3', 'joint_4', 'joint_5', 'joint_6']

        # Three positions based on capstone report (angles in radians, prismatic in meters)
        # joint order: [base_rotation, link3_vertical, link4, link5, prismatic, wrist]
        self.positions = {
            'stowed':          [0.0,        0.0,       0.0,        0.0,        0.0,     0.0],
            'pre_collection':  [0.0,       -1.5708,    -0.357,        1.206,        0.0,     0.0],
            'collection':      [1.5,       -1.5708,     -0.5,       1.0,        0.3,     0.0],
            'pre_load':        [-3.142,    -1.5708,     -0.357,      1.206,      0.0,  0.0],
            'loading':         [-3.142,   -1.5708,    -0.357,      1.206,      0.085,  0.0],
            
        }

    
    def publish_position(self, position):
        msg = JointState() 
        msg.header.stamp = self.get_clock().now().to_msg()
        msg.name = self.joint_names
        msg.position = position
        self.publisher.publish(msg)


    def move(self, start, end, steps=50):
        """Smoothly interpolate between two joint positions."""
        for i in range(steps):
            t = i / steps
            interp = [s + (e - s) * t for s, e in zip(start, end)]
            self.publish_position(interp)
            time.sleep(0.05)

    # Helper function to make the sleep happen in new positions
    def hold(self, position, duration):
        """Hold a position for a given duration by continuously publishing."""
        end_time = time.time() + duration
        while time.time() < end_time:
            self.publish_position(position)
            time.sleep(0.05)

    def run(self):
        print("=== AUV Arm Animator Starting ===")
        print("Cycling through: Stowed -> Collection -> Loading")
        time.sleep(1.0)

        pos_stowed         = self.positions['stowed']
        pos_collection     = self.positions['collection']
        pos_loading        = self.positions['loading']
        pos_pre_collection = self.positions['pre_collection']
        pos_pre_load       = self.positions['pre_load']


        # Order of locations
        while rclpy.ok():
           
            print("\n1")
            self.move(pos_stowed, pos_pre_collection)
            self.hold(pos_pre_collection, 2.0)

            print("2")
            self.move(pos_pre_collection, pos_collection)
            self.hold(pos_collection, 2.0)

            print("3")
            self.move(pos_collection, pos_pre_collection)
            self.hold(pos_pre_collection, 2.0)


            print("4")
            self.move(pos_pre_collection, pos_pre_load)
            self.hold(pos_pre_load, 2.0)

            print("5")
            self.move(pos_pre_load, pos_loading)
            self.hold(pos_loading, 2.0)

            print("6")
            self.move(pos_loading, pos_pre_load)
            self.hold(pos_pre_load, 2.0)

            print("7")
            self.move(pos_pre_load, pos_pre_collection)
            self.hold(pos_pre_collection, 2.0)       

            print("8")
            self.move(pos_pre_collection, pos_stowed)
            self.hold(pos_stowed, 2.0)           


def main():
    rclpy.init()
    node = ArmAnimator()
    node.run()
    rclpy.shutdown()

if __name__ == '__main__':
    main()