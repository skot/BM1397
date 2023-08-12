# Prelude

Many registers described below are common with other BM13xx chips. Here we focus mainly on BM1397 as this register map has been reverse engineered from the 'bmminer' of T17 original Firmware from Bitmain.

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

# BM1397 Registers map

## Chip Address

Address = 0x00

Reset value = 0x13971800

![chip_address](images/chip_address.svg)

### CHIP_ID

On BM1397, CHIP_ID = 0x1397

### CORE_NUM

On BM1397, CORE_NUM = 0x18 which should be multiplied by 28, to find the actual Core Number : 672.

### ADDR

This is the Chip Address of the particular chip, see [Set Chip Address](#set-chip-address) for details.

## Hash Rate

Address = 0x04

Reset value = 0x80000000

![hash_rate](images/hash_rate.svg)

### HASHRATE

Hash rate value in 2^24 unit.

## PLL0 Parameter

Address = 0x08

Reset value = 0xC0600161

![pll_parameter](images/pll_parameter.svg)

PLL0 is used as base clock for hash rate calculation.

PLL0 frequency is calculated with the formula :

`
fPLL0 = fCLKI * FBDIV / (REFDIV * POSTDIV1 * POSTDIV2)
`

POSTDIV1 must be greater than or equal to POSTDIV2.

## Chip Nonce Offset

Address = 0x0C

Reset value = 0x00000000

![chip_nonce_offset](images/chip_nonce_offset.svg)

## Hash Counting Number

Address = 0x10

Reset value = 0x00000000

![hash_counting_number](images/hash_counting_number.svg)

## Ticket Mask

Address = 0x14

Reset value = 0x00000000

![ticket_mask](images/ticket_mask.svg)

The chip will provide only solutions that are <= target based on this difficulty.

TICKET_MASK is bitmask that is used to mask the bits of bytes 0..31 of the reversed SHA hash.

Chip sends the nonce only if
   ```revhash[0..3] == 0 && (revhash[4..7] & reverse_bytes ticket_mask)) == 0```

The weird mask format came about probably because they did comparison on bit-reversed SHA hash, not just byte-reversed SHA hash.

## Misc Control

Address = 0x18

Reset value = 0x00003A01

![misc_control](images/misc_control.svg)

### BT8D

It is a 9-bit divider to determine actual Baudrate. It is composed by BT8D_8_5 and BT8D_4_0.

### BCLK_SEL
<!-- cspell:disable-next-line -->
**B**audrate **CL**oc**K** **SEL**ect

* BCLK_SEL = 0: Baudrate base clock is CLKI (external clock)
* BCLK_SEL = 1: Baudrate base clock is PLL3

### RFS (RF pin Selector)

* RFS = 0: Open Drain
* RFS = 1: SDA0

### TFS (TF pin Selector)

* TFS = 0: Hash Doing
* TFS = 1: UART RX
* TFS = 2: UART TX
* TFS = 3: SCL0

## I2C Control

Address = 0x1C

Reset value = 0x01000000

![i2c_control](images/i2c_control.svg)

## Ordered Clock Enable

Address = 0x20

Reset value = 0x0000FFFF

![ordered_clock_enable](images/ordered_clock_enable.svg)

## Fast UART Configuration

Address = 0x28

Reset value = 0x0600000F

![fast_uart_configuration](images/fast_uart_configuration.svg)

## UART Relay

Address = 0x2C

Reset value = 0x000F0000

![uart_relay](images/uart_relay.svg)

## Ticket Mask2

Address = 0x38

Reset value = 0x00000000

![ticket_mask2](images/ticket_mask2.svg)

## Core Register Control

Address = 0x3C

Reset value = 0x00004000

![core_register_control](images/core_register_control.svg)

Reverse engineering on this register is still ongoing.

### RD#_WR

* RD#_WR = 0: Read operation on Core Register. [CORE_REG_VAL](#core_reg_val) must be = 0xFF.
* RD#_WR = 1: Write operation on Core Register. [CORE_REG_VAL](#core_reg_val) must contain the value we want to write into the Core Register.

### CORE_ID

Note: in T17 FW, this CORE_ID value is actually the wanted Core ID divided by 2 (at least when doing check_clock_counter() function).

### CORE_REG_ID

Identifier of the Core Register.

### CORE_REG_VAL

Value of the Core Register with ID = [CORE_REG_ID](#core_reg_id)

## Core Register Value

Address = 0x40

Reset value = 0x00000000

![core_register_value](images/core_register_value.svg)

Reverse engineering on this register is still ongoing.

## External Temperature Sensor Read

Address = 0x44

Reset value = 0x00000100

![external_temperature_sensor_read](images/external_temperature_sensor_read.svg)

## Error Flag

Address = 0x48

Reset value = 0xFF000000

![error_flag](images/error_flag.svg)

## Nonce Error Counter

Address = 0x4C

Reset value = 0x00000000

![nonce_error_counter](images/nonce_error_counter.svg)

## Nonce Overflow Counter

Address = 0x50

Reset value = 0x00000000

![nonce_overflow_counter](images/nonce_overflow_counter.svg)

## Analog Mux Control

Address = 0x54

Reset value = 0x00000000

![analog_mux_control](images/analog_mux_control.svg)

## Io Driver Strength Configuration

Address = 0x58

Reset value = 0x02112111

![io_driver_strenght_configuration](images/io_driver_strenght_configuration.svg)

## Time Out

Address = 0x5C

Reset value = 0x0000FFFF

![time_out](images/time_out.svg)

## PLL1 Parameter

Address = 0x60

Reset value = 0x00640111

![pll_parameter](images/pll_parameter.svg)

PLL1 frequency is calculated with the formula :

`
fPLL1 = fCLKI * FBDIV / (REFDIV * POSTDIV1 * POSTDIV2)
`
POSTDIV1 must be greater than or equal to POSTDIV2.

## PLL2 Parameter

Address = 0x64

Reset value = 0x00680111

![pll_parameter](images/pll_parameter.svg)

PLL2 frequency is calculated with the formula :

`
fPLL2 = fCLKI * FBDIV / (REFDIV * POSTDIV1 * POSTDIV2)
`
POSTDIV1 must be greater than or equal to POSTDIV2.

## PLL3 Parameter

Address = 0x68

Reset value = 0x00700111

![pll_parameter](images/pll_parameter.svg)

PLL3 is used as a base clock for baud rate generation with baud rate higher than 3.125 MHz (see [Set Baudrate](#set-baudrate)).

PLL3 frequency is calculated with the formula :

`
fPLL3 = fCLKI * FBDIV / (REFDIV * POSTDIV1 * POSTDIV2)
`
POSTDIV1 must be greater than or equal to POSTDIV2.

## Ordered Clock Monitor

Address = 0x6C

Reset value = 0x00000000

![ordered_clock_monitor](images/ordered_clock_monitor.svg)

## PLL0 Divider

Address = 0x70

Reset value = 0x03040607

![pll_divider](images/pll_divider.svg)

### PLLDIV3/2/1

in T17 FW, written to 0xF and seems to not affect ASIC frequency.

### PLLDIV0

in T17 FW, is called "user divider", set to 0 by default and divide by 1 the ASIC frequency.

## PLL1 Divider

Address = 0x74

Reset value = 0x03040506

![pll_divider](images/pll_divider.svg)

## PLL2 Divider

Address = 0x78

Reset value = 0x03040506

![pll_divider](images/pll_divider.svg)

## PLL3 Divider

Address = 0x7C

Reset value = 0x03040506

![pll_divider](images/pll_divider.svg)

## Clock Order Control0

Address = 0x80

Reset value = 0xD95C8410

![clock_order_control0](images/clock_order_control0.svg)

## Clock Order Control1

Address = 0x84

Reset value = 0xFB73EA62

![clock_order_control1](images/clock_order_control1.svg)

## Clock Order Status

Address = 0x8C

Reset value = 0x00000000

![clock_order_status](images/clock_order_status.svg)

## Frequency Sweep Control1

Address = 0x90

Reset value = 0x00000070

![frequency_sweep_control1](images/frequency_sweep_control1.svg)

## Golden Nonce For Sweep Return

Address = 0x94

Reset value = 0x00376400

![golden_nonce_for_sweep_return](images/golden_nonce_for_sweep_return.svg)

## Returned Group Pattern Status

Address = 0x98

Reset value = 0x30303030

![returned_group_pattern_status](images/returned_group_pattern_status.svg)

## Nonce Returned Timeout

Address = 0x9C

Reset value = 0x0000FFFF

![nonce_returned_timeout](images/nonce_returned_timeout.svg)

## Returned Single Pattern Status

Address = 0xA0

Reset value = 0x00000000

![returned_single_pattern_status](images/returned_single_pattern_status.svg)

# BM1397 Core Registers map

## Clock Delay Ctrl

ID = 0

![clock_delay_ctrl](images/clock_delay_ctrl.svg)

### CCDLY_SEL and PWTH_SEL

These are related to "Frequency Tunning". By default the values are ccdly_sel = 2 and pwth_sel = 3 in T17 FW.

### MMEN (Multi Midstate ENable)

Enable AsicBoost.

## Process Monitor Ctrl

ID = 1

![process_monitor_ctrl](images/process_monitor_ctrl.svg)

### PM_START (Process Monitor START)

When written to 1 the Core Process Monitor parameter selected with PM_SEL will be read into Process Monitor Data.

### PM_SEL (Process Monitor SELect)

* PM_SEL=0 : LVT delay chain
* PM_SEL=1 : SVT delay chain
* PM_SEL=2 : HVT delay chain
* PM_SEL=3 : Critical path chain

## Process Monitor Data

ID = 2

![process_monitor_data](images/process_monitor_data.svg)

## Core Error

ID = 3

![core_error](images/core_error.svg)

## Core Enable

ID = 4

![core_enable](images/core_enable.svg)

## Hash Clock Control

ID = 5

![hash_clock_control](images/hash_clock_control.svg)

## Hash Clock Counter

ID = 6

![hash_clock_counter](images/hash_clock_counter.svg)

### Example

in T17 FW (pseudo C code, very simplified):

```c
int check_clock_counter(int freq) {
   for (int asic_id = 5; asic_id < 9; asic_id++) {
      for (int core_id = 0; core_id < 5; core_id++) {
         if (quick_dump_core_hash_clock_counter(asic_id, core_id, freq) != 0) {
            return 1;
         }
      }
   }
   for (int asic_id = 20; asic_id < 24; asic_id++) {
      for (int core_id = 105; core_id < 110; core_id++) {
         if (quick_dump_core_hash_clock_counter(asic_id, core_id, freq) != 0) {
            return -1;
         }
      }
   }
}
int quick_dump_core_hash_clock_counter(int asic_id, int core_id, int freq) {
   int ret = 0;
   // Write Core Register Hash Clock Control = 1
   // Read Core Register Hash Clock Counter
   if (clock_counter >= ((freq << 3) / 50) * 0.8)
      ret = 0xff;
   // Write Core Register Hash Clock Control = 0
   return ret;
}
```

## Sweep Clock Control

ID = 7

![sweep_clock_control](images/sweep_clock_control.svg)

# Protocol
<!-- cspell:disable-next-line -->
NRSTI (**N**egated **R**e**S**e**T** **I**nput) does a hardware reset on BM1397 when signal is Low.

<!-- cspell:disable-next-line -->
CLKI (**CL**oc**K** **I**nput) pin must have a 25MHz clock signal, it will be propagated to the CLKO (**CL**oc**K** **O**utput) pin.

<!-- cspell:disable-next-line -->
BI (**B**usy **I**nput) signal must be pulled-down in order to let the BM1397 communicate.

<!-- cspell:disable-next-line -->
Communication with BM1397 is done by UART on its CI (**C**command **I**nput) pin and RO (**R**esponse **O**utput). Default baudrate is 115200 bps. UART has 8 bits of data, no parity, 1 stop bit (usually represented as 115200 8N1).

## Command

![command](images/command.svg)

### Preamble

All commands have a fixed 2 byte preamble: 0x55 0xAA

### TYPE

* TYPE = 1: send Job
* TYPE = 2: send Command

### ALL

* ALL = 0: send to a single Chip
* ALL = 1: send to all Chips on the Chain

### CMD

if TYPE == 1:

* CMD = 1: send Job

if TYPE == 2:

* CMD = 0: set Chip Address
* CMD = 1: write Register
* CMD = 2: read Register
* CMD = 3: chain Inactive

### Frame Length

Total Frame Length excluding preamble.

### Data

Depends on TYPE/CMD, see detailed frames below.

### CRC

Can be CRC5 or CRC16 depending on TYPE/CMD, see detailed frames below.

## Response

![response](images/response.svg)

All Responses have fixed length : 9 bytes.

### Preamble

All commands have a fixed 2 byte preamble: 0xAA 0x55

### TYPE

* TYPE = 0: respond to a command
* TYPE = 4: respond to a job (nonce)

### Data

Depends on TYPE, see detailed frames below.

### CRC5

CRC 5 bits with polynomial 0x05, initial value 0x1F, no reflection, no final XOR of the full Frame excluding preamble.

## Set Chip Address

On reset, all chips have a logical address of 0. In order to access to a specific chip later, we must give them different addresses.

**Warning**: Chip Address is different from chip index on the chain. It is a logical concept configurable by software.

To set Chip Address of all chips one by one, we **must not** send commands to ALL chips, just to the chip with Address = 0, so the first chip on the chain will get the command and not propagate it downward.

The Set Chip Address Command format is:

![set_chip_address](images/set_chip_address.svg)

No Response is returned by the chip.

## Write Register

The Write Register Command format is:

![write_register](images/write_register.svg)

No Response is returned by the chip.

## Read Register

The Read Register Command format is:

![read_register](images/read_register.svg)

Sending a Read Register Command to ALL chips on the chain is very useful to enumerate them (usually with the [Chip Address](#chip-address) register), every chip on the chain will send a Response that will be propagated upward.

## Register Value

The Register Value Response format is:

![register_value](images/register_value.svg)

Warning: sometimes a Register Value can be sent spontaneously by a chip (usually the [Core Register Value](#core-register-value) register).

## Chain Inactive

The Chain Inactive Command format is:

![chain_inactive](images/chain_inactive.svg)

No Response is returned by the chip.

## Send Job

The Send Job Command format is:

![send_job](images/send_job.svg)

## Nonce

Once hashing, when a nonce is found by a chip on the chain, it is sent on the RO pin (and propagated upward) with this format:

![nonce](images/nonce.svg)

## Write Core Register

In order to write values to a Core Register, a [Write Register](#write-register) Command shall be done to the [Core Register Control](#core-register-control) Register with the [RD#_WR](#rd_wr) fields = 1.

## Read Core Register

In order to read the value of a Core Register, a [Write Register](#write-register) Command shall be done to the [Core Register Control](#core-register-control) Register with the [RD#_WR](#rd_wr) fields = 0.

Then the chip will reply a [Register Value](#register-value) Response for the [Core Register Value](#core-register-value) Register.

## Enumerate Chips on the Chain

With the original firmware of the control board, an enumeration of all chips on the chain (physically on a hash board) is done at the beginning. It is a [Read Register](#read-register) Command on [Chip Address](#chip-address) Register with [ALL](#all) = 1. Then all chips on the chain reply a [Register Value](#register-value) Response.

During this enumeration, we see that all chips on the chain have a [ADDR](#addr) = 0. So the FW affect new Chip Address by first sending a [Chain Inactive](#chain-inactive) Command, so chips stop relaying command to the chain, then using the [Set Chip Address](#set-chip-address) Command which sill be accepted only by the first chip on the chain. Then the next [Set Chip Address](#set-chip-address) Command will be ignored by the first chip and relayed to the second chip on the chain, which will accept this Command and set it's own Chip Address. And so on up to the last chip on the chain.

On S9k (BM1393), FW also perform a [Write Regsiter](#write-register) Command to [Chip Address](#chip-address) Register with the wanted [ADDR](#addr) in addition to the [Set Chip Address](#set-chip-address) Command. I am not sure if it is usefull on BM1393, but on BM1397 the full [Chip Address](#chip-address) Register seems to be Read Only.

The [ADDR](#addr) given don't have to be contiguous on a chain, for instance they are given with increment of 8 on T17 original FW and 4 on S9k original FW. It is used to divide evenly the total nonce space between chips on the chain. Indeed, all chips will add their own [ADDR](#addr) to the Nonce they are hashing.

For instance a T17 hash board has 30 chips on a chain, so with an increment of 8, the last Chip Address will be 232 (actually the FW send 32 [Set Chip Address](#set-chip-address) Command, so the last 2 Commands should be useless).

Same for S9k hash board with physically 60 chip on the chain, FW send 64 [Set Chip Address](#set-chip-address) Command.

This should be the reason why the full 32 bits Nonce space is never fully hashed by miners with chip number on chain not aligned to a power of 2. See [The Mystery Of The Bitcoin Nonce Pattern](https://blog.bitmex.com/the-mystery-of-the-bitcoin-nonce-pattern)

## Set Baudrate

In order to get a higher hash rate, we need to increase the communication Baudrate because at 115200bps (default baudrate) a [Send Job](#send-job) Command with 4 midstate would take 15.2ms which could be longer than the time the full chain would take to Hash the complete Nonce space of the previous job.

BaudRate = fBase / ((BT8D + 1) * 8)

At chip reset, in [Misc Control](#misc-control) Register :

* [BCLK_SEL](#bclk_sel) = 0

fBase = fCLKI = 25MHz.

* [BT8D](#bt8d) = 26 (0x1A)

So the default BaudRate = fCLKI / ((BT8D + 1) * 8) = 115740 bps with reset values (0.47% error with target 115200 bps).

This is possible up to 3.125Mbps BaudRate with [BT8D](#bt8d) = 0.

For higher baud rates, here are the necessary steps (numeric example below is for 6.25 Mbps BaudRate):

1. enabling and configuring PLL3 using [PLL3 Parameter](#pll3-parameter) for example writing 0xC0700111 will result of a PLL3 with frequency equal to :
`
fPLL3 = fCLKI * FBDIV / (REFDIV * POSTDIV1 * POSTDIV2) = 25MHz*112/(1*1*1) = 2.8 GHz
`
2. setting PLL3_DIV4 in [Fast UART Configuration](#fast-uart-configuration) for example writing 0x0600000F give a PLL3_DIV4 = 6
3. setting [BCLK_SEL](#bclk_sel) to 1
`
fBase = fPLL3 / (PLL3_DIV4 + 1) = 2.8 GHz / (6 + 1) = 400 MHz
`
4. setting [BT8D](#bt8d) to 7

BaudRate = fBase / ((BT8D + 1) *8) = 400 MHz / ((7 + 1)* 8) = 6.25 MBps
