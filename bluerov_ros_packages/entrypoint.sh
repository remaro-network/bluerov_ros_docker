#!/bin/bash
set -e

# setup ros2 environment
source "/bluerov_ws/install/setup.bash"
exec "$@"
