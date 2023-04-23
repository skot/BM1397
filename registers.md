# Prelude

Many registers described hereunder are common with other BM13xx chips. Here we focus mainly on BM1397 as this registers map has been reverse engineered from the 'bmminer' of T17 original Firmware from Antminer.

# Full process step by step

1. Download the official T17 Firmware from [Antminer website](https://shop.bitmain.com/support/download).
2. Run these commands one by one:
```bash
tar -xvzf ANTMINER-T17-user-OM-202004231629-sig_5828.tar.gz
tar -xvzf fw.tar.gz
tail -c+65 < uramdisk.image.gz > uramdisk.image.cut.gz
gunzip -c -d uramdisk.image.cut.gz > uramdisk.image
mkdir uramdisk
sudo mount -ro loop uramdisk.image uramdisk
```
3. Mess with [Ghidra](https://ghidra-sre.org/) onto the bmminer ELF file.

## About x19 Firmware

The above methods will not work with x19 generation Firmware (for BM1398 chip) because they are packed in a BMU file format which is totally different.

First BMU files must be Unmerged using this [UnmergeTool](https://github.com/VladTheJunior/UnmergeTool).

Then how to extract the bmminer ELF file ???

# BM1397 Registers map

## Chip Address
Address = 0x00

Reset value = 0x13971800

![](images/chip_address.svg)
## Hash Rate
Address = 0x04

Reset value = 0x80000000

![](images/hash_rate.svg)
## PLL0 Parameter
Address = 0x08

Reset value = 0xC0600161

![](images/pll_parameter.svg)
## Chip Nonce Offset
Address = 0x0C

Reset value = 0x00000000

![](images/chip_nonce_offset.svg)
## Hash Counting Number
Address = 0x10

Reset value = 0x00000000

![](images/hash_counting_number.svg)
## Ticket Mask
Address = 0x14

Reset value = 0x00000000

![](images/ticket_mask.svg)
## Misc Control
Address = 0x18

Reset value = 0x00003A01

![](images/misc_control.svg)
### BT8D
It is a 9bits divider to determine actual Baudrate. It is composed by BT8D_8_5 and BT8D_4_0.
### BCLK_SEL
**B**audrate **CL**oc**K** **SEL**ect
* BCLK_SEL = 0: Baudrate base clock is CLKI (external clock)
* BCLK_SEL = 1: Baudrate base clock is PLL3
## Some Temp Related
Address = 0x1C

Reset value = 0x??

![](images/some_temp_related.svg)

Reverse engineering on this register is still ongoing.
## Ordered Clock Enable
Address = 0x20

Reset value = 0x0000FFFF

![](images/ordered_clock_enable.svg)
## Fast UART Configuration
Address = 0x28

Reset value = 0x0600000F

![](images/fast_uart_configuration.svg)
## UART Relay
Address = 0x2C

Reset value = 0x000F0000

![](images/uart_relay.svg)
## Ticket Mask2
Address = 0x38

Reset value = 0x00000000

![](images/ticket_mask2.svg)
## Core Register Control
Address = 0x3C

Reset value = 0x??

![](images/core_register_control.svg)

Reverse engineering on this register is still ongoing.
## Core Register Value
Address = 0x40

Reset value = 0x??

![](images/core_register_value.svg)

Reverse engineering on this register is still ongoing.
## External Temperature Sensor Read
Address = 0x44

Reset value = 0x00000100

![](images/external_temperature_sensor_read.svg)
## Error Flag
Address = 0x48

Reset value = 0xFF000000

![](images/error_flag.svg)
## Nonce Error Counter
Address = 0x4C

Reset value = 0x00000000

![](images/nonce_error_counter.svg)
## Nonce Overflow Counter
Address = 0x50

Reset value = 0x00000000

![](images/nonce_overflow_counter.svg)
## Analog Mux Control
Address = 0x54

Reset value = 0x00000000

![](images/analog_mux_control.svg)
## Io Driver Strenght Configuration
Address = 0x58

Reset value = 0x02112111

![](images/io_driver_strenght_configuration.svg)
## Time Out
Address = 0x5C

Reset value = 0x0000FFFF

![](images/time_out.svg)
## PLL1 Parameter
Address = 0x60

Reset value = 0x00640111

![](images/pll_parameter.svg)
## PLL2 Parameter
Address = 0x64

Reset value = 0x00680111

![](images/pll_parameter.svg)
## PLL3 Parameter
Address = 0x68

Reset value = 0x00700111

![](images/pll_parameter.svg)
## Ordered Clock Monitor
Address = 0x6C

Reset value = 0x00000000

![](images/ordered_clock_monitor.svg)
## Pll0 Divider
Address = 0x70

Reset value = 0x03040607

![](images/pll_divider.svg)
## Pll1 Divider
Address = 0x74

Reset value = 0x03040506

![](images/pll_divider.svg)
## Pll2 Divider
Address = 0x78

Reset value = 0x03040506

![](images/pll_divider.svg)
## Pll3 Divider
Address = 0x7C

Reset value = 0x03040506

![](images/pll_divider.svg)
## Clock Order Control0
Address = 0x80

Reset value = 0xD95C8410

![](images/clock_order_control0.svg)
## Clock Order Control1
Address = 0x84

Reset value = 0xFB73EA62

![](images/clock_order_control1.svg)
## Clock Order Status
Address = 0x8C

Reset value = 0x00000000

![](images/clock_order_status.svg)
## Frequency Sweep Control1
Address = 0x90

Reset value = 0x00000070

![](images/frequency_sweep_control1.svg)
## Golden Nonce For Sweep Return
Address = 0x94

Reset value = 0x00376400

![](images/golden_nonce_for_sweep_return.svg)
## Returned Group Pattern Status
Address = 0x98

Reset value = 0x30303030

![](images/returned_group_pattern_status.svg)
## Nonce Returned Timeout
Address = 0x9C

Reset value = 0x0000FFFF

![](images/nonce_returned_timeout.svg)
## Returned Single Pattern Status
Address = 0xA0

Reset value = 0x00000000

![](images/returned_single_pattern_status.svg)
# BM1397 Core Registers map

## Clock Delay Ctrl
ID = 0

![](images/clock_delay_ctrl.svg)
## Process Monitor Ctrl
ID = 1

![](images/process_monitor_ctrl.svg)
## Process Monitor Data
ID = 2

![](images/process_monitor_data.svg)
## Core Error
ID = 3

![](images/core_error.svg)
## Core Enable
ID = 4

![](images/core_enable.svg)
## Hash Clock Control
ID = 5

![](images/hash_clock_control.svg)
## Hash Clock Counter
ID = 6

![](images/hash_clock_counter.svg)
## Sweep Clock Control
ID = 7

![](images/sweep_clock_control.svg)
