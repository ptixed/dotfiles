#!/bin/bash

touchpad=$(xinput list | grep -Po 'Touchpad.*id=\K[0-9]+')
prop=$(xinput list-props $touchpad | grep -Po 'Tapping Button Mapping Enabled \(\K[0-9]+')
xinput set-prop $touchpad $prop 1 0

exec i3
