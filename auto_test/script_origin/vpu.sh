#!/bin/sh

V="../video/1.mp4"

gst-launch-1.0  filesrc location=$V ! decodebin ! imxvideoconvert_g2d ! autovideosink

echo -e "\033[32m[VPU] Test Passed.\033[0m"
