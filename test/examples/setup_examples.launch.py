from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription, ExecuteProcess
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory
import os

def generate_launch_description():
    ld = LaunchDescription()
    # TF static transform publisher
    tf_publisher = Node(
        package='tf2_ros',
        executable='static_transform_publisher',
        arguments=['0', '0', '0', '0', '0', '0', 'world', 'turtle1']
    )
    ld.add_action(tf_publisher)
    
    # # TF2 web republisher
    # tf2_web_republisher = Node(
    #     package='tf2_web_republisher',
    #     executable='tf2_web_republisher'
    # )
    # ld.add_action(tf2_web_republisher)
    
    # Example service server (replacement for add_two_ints_server)
    add_two_ints_server = Node(
        package='examples_rclpy_minimal_service',
        executable='service'
    )
    ld.add_action(add_two_ints_server)
    
    # Example publisher (replacement for hello_world_publisher)
    hello_publisher = Node(
        package='demo_nodes_cpp',
        executable='talker'
    )
    ld.add_action(hello_publisher)
    
    return ld
