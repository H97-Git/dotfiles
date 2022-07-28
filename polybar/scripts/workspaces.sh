#!/bin/sh
names=(www default notes chat music video)
current=$(xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}');
echo ${names[$current]}
