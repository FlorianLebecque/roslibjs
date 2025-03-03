#! /usr/bin/env bash

if command -v ros2 2>/dev/null
then
    echo "Shutting everything down"
    pgrep -f "[r]os" | xargs kill -9
    sleep 1

    echo "Starting rosbridge and various examples in background processes"

    ros2 launch rosbridge_server rosbridge_websocket_launch.xml port:=9090 
    ros2 launch rosbridge_server rosbridge_websocket_launch.xml port:=9091 namespace:="hello"
    ros2 launch rosbridge_server rosbridge_websocket_launch.xml port:=9092 namespace:="hello/world"

    # Launch the ROS2 launch file that contains all the nodes
    ros2 launch $(dirname "$0")/setup_examples.launch.py &
    
    LAUNCHED=false
    for i in {1..10}
    do
        echo "Waiting for topic publishers...$i"
        sleep 1
        # Check if the talker node's topic is active
        ros2 topic info /chatter > /dev/null 2>&1 && LAUNCHED=true && break
    done
    if [ $LAUNCHED == true ]
    then
        echo "Ready for lift off"
        exit 0
    else
        echo "Publishers not launched"
        exit 1
    fi
else
    echo "Couldn't find ROS2 on path (try to source it)"
    # shellcheck disable=SC2016
    echo 'source /opt/ros/$ROS_DISTRO/setup.bash'
    exit 1
fi
