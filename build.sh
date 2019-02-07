#!/bin/bash

cd ../../
#make -C examples/esp8266_led_rgb_strip clean
#make -C examples/esp8266_led_rgb_strip all
make -C examples/esp8266_led_rgb_strip erase_flash
make -C examples/esp8266_led_rgb_strip flash
