# Purpose of this software
This software is meant to be flashed on an esp8266, connected with an RGB LED strip.
It is able to drive all colors of the strip from 0 to 100% dimmable via multichannel
pwm.

## Homekit integration
No bridge is required. Instead, this project uses the esp-homekit implementation found
here: https://github.com/maximkulkin/esp-homekit to directly connect with homekit
controller devices.

# Installation
1. Install [esp-open-sdk](https://github.com/pfalcon/esp-open-sdk), build it with `make toolchain esptool libhal STANDALONE=n`, then edit your PATH and add the generated toolchain bin directory. The path will be something like /path/to/esp-open-sdk/xtensa-lx106-elf/bin.
2. Install [esptool.py](https://github.com/themadinventor/esptool) and make it available on your PATH. If you used esp-open-sdk then this is done already.
3. Checkout [esp-open-rtos](https://github.com/SuperHouse/esp-open-rtos) and set SDK_PATH environment variable pointing to it.
4. Clone [esp-homekit-demo](https://github.com/maximkulkin/esp-homekit-demo) (for archive purposes forked [here](https://github.com/DominikHorn/esp-homekit-demo))
   and initialize all submodules (recursively):
```shell
git clone https://github.com/maximkulkin/esp-homekit-demo
cd esp-homekit-demo
git submodule update --init --recursive
```
5. Copy wifi.h.sample -> wifi.h and edit it with correct WiFi SSID and password:
```shell
cp wifi.h.sample wifi.h
vi wifi.h
```
6. Clone this project into the examples subfolder and copy config.h.sample -> config.h. Set correct config options afterwards:
```shell
cd examples
git clone https://github.com/DominikHorn/esp8266-rgb-led-strip.git
cd esp8266-rgb-led-strip
cp config.h.sample config.h
vi config.h
```
7. Configure settings:
    1. If you use ESP8266 with 4MB of flash (32m bit), then you're fine. If you have
1MB chip, you need to set following environment variables:
    ```shell
    export FLASH_SIZE=8
    export HOMEKIT_SPI_FLASH_BASE_ADDR=0x7a000
    ```
    2. If you're debugging stuff, or have troubles and want to file issue and attach log, please enable DEBUG output:
    ```shell
    export HOMEKIT_DEBUG=1
    ```
    3. Depending on your device, it might be required to change the flash mode:
    ```shell
    export FLASH_MODE=dout
    ```
    (see issue #80)
8. Build:
```shell
cd esp-homekit-demo/examples/esp8266-rgb-led-strip
make -C . all
```
9. Set ESPPORT environment variable pointing to USB device your ESP8266 is attached
   to (assuming your device is at /dev/tty.SLAB_USBtoUART):
```shell
export ESPPORT=/dev/tty.SLAB_USBtoUART
```
10. To prevent any effects from previous firmware (e.g. firmware crashing right at
   start), highly recommend to erase flash:
```shell
    cd esp-homekit-demo/examples/esp8266-rgb-led-strip
    make -C . erase_flash
```
11. Upload firmware to ESP:
```shell
    cd esp-homekit-demo/examples/esp8266-rgb-led-strip
    make -C . test
```
  or
```shell
    cd esp-homekit-demo/examples/esp8266-rgb-led-strip
    make -C flash
    make -C monitor
```
  or
```shell
    cd esp-homekit-demo/examples/esp8266-rgb-led-strip
    ./build.sh
```
12. Open Home app on your device, and click '+'. If Home does not recognize the ESP8266,
proceed to adding device anyways by entering code.

# Troubleshooting
Try to monitor the ESP8266 while it's executing the software:
```shell
    cd esp-homekit-demo/examples/esp8266-rgb-led-strip
    make -C . monitor
```
It is often also a good idea to reset the ESP (cutoff power).

# Circuitry
Bare in mind that I'm not a trained professional. As far as I can tell my setup allows for max
3A at 12V, meaning with the LED Strip I used, 3m is the maximum possible length!

## My components/setup:
* 1x esp8266. I prefer the NodeMCU version because it's PCB comes with a USB controlling unit
  and port inbuilt. This allows for fast debugging and most importantly you may reflash easily
  even after soldering. Alternatively you can use a standard ESP8266 with a programmer unit,
  and solder only a mount to your custom pcb.
* 1x RGB LED Strip
* 1x DC Power Supply (12V, x Amps). Make sure this delivers enough power to drive you LED Strip length
  and doesn't exceed the maximum 3A at which the transistor, dc jack and step down module are rated! 
* 1x DC 12V 3A power jack female
* 1x DC DC step-down module for driving esp8266 from 12V power supply
* insulated electric wire (preferably multiple colors, makes your life easier)
* 3x IRF3205 TO220 Hexfet power mosfet transistors
* 1x prototype PCB 

Optional
* 1x SMD button if you wish to physically turn the strip on/off

I ordered my components from aliexpress.com. Bellow is a list of all things I ordered:
* [esp8266](https://www.aliexpress.com/item/New-Wireless-module-NodeMcu-Lua-WIFI-Internet-of-Things-development-board-based-ESP8266-with-pcb-Antenna/32656775273.html?spm=a2g0s.9042311.0.0.77c94c4dQ49BNu)
* [RGB LED Strip](https://www.aliexpress.com/item/EnwYe-LED-Strip-5050-Waterproof-DC12V-Flexible-LED-Light-60-leds-m-IP65-Waterproof-5m-lot/32359369314.html?spm=a2g0s.9042311.0.0.77c94c4dQ49BNu)
* [Power supply](https://www.aliexpress.com/item/1-x-AC-100V-240V-to-DC-12V-1A-2A-3A-5A-6A-8A-lighting-transformers/32672191071.html?spm=a2g0s.9042311.0.0.77c94c4dQ49BNu)
  **NOTE**: I've notived that this power supply makes a humming sound when the LED Strip draws power. This might be because of the PWM but I'm unsure. Maybe consider a different power supply or add a ferrite to the circuit.
* [Power Jack](https://www.aliexpress.com/item/10Pcs-3A-12v-For-DC-Power-Supply-Jack-Socket-Female-Panel-Mount-Connector-5-5mm-2/32802422987.html?spm=a2g0s.9042311.0.0.77c94c4dQ49BNu)
* [DC DC Stepdown](https://www.aliexpress.com/item/10PCS-XM1584-Ultra-small-size-DC-DC-step-down-power-supply-module-3A-adjustable-step-down/1342127513.html?spm=a2g0s.9042311.0.0.77c94c4dQ49BNu)
* [Wire](https://www.aliexpress.com/item/Tinned-copper-22AWG-electric-wire-UL1007-PVC-insulated-wire-Electric-cable-Electrical-and-electronic-equipment-internal/32803735198.html?spm=a2g0s.9042311.0.0.77c94c4dQ49BNu)
* [Transistors](https://www.aliexpress.com/item/10PCS-IRF3205PBF-TO220-IRF3205-TO-220-HEXFET-Power-MOSFET-new-and-original-IC-free-shippin/32517514473.html?spm=a2g0s.9042311.0.0.77c94c4dQ49BNu)
* [SMD Button](https://www.aliexpress.com/item/100PCS-Lot-SMD-Button-6x6x4-3mm-6-6-4-3mm-Plastic-Head-Tact-Switch-Push-Bottun/32703740198.html?spm=a2g0s.9042311.0.0.77c94c4dQ49BNu)
* [PCB](https://www.aliexpress.com/item/5PCS-Universal-PCB-Board-50x70-mm-2-54mm-Hole-Pitch-DIY-Prototype-Paper-Printed-Circuit-Board/32858951350.html?spm=a2g0s.9042311.0.0.77c94c4dQ49BNu) **NOTE**: I highly recommend you **order something different**, but this is what I used.
