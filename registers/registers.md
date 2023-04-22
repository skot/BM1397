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
```
BIT[31:16]  CHIP_ID
BIT[15:8]   CORE_NUM
BIT[7:0]    ADDR
```
## Hash Rate
Address = 0x04

Reset value = 0x80000000
```
BIT[31]    LONG
BIT[30:0]  HASHRATE
```
## PLL0 Parameter
Address = 0x08

Reset value = 0xC0600161
```
BIT[31]     LOCKED
BIT[30]     PLLEN
BIT[29:28]  Reserved
BIT[27:16]  FBDIV
BIT[15:14]  Reserved
BIT[13:8]   REFDIV
BIT[7]      Reserved
BIT[6:4]    POSTDIV1
BIT[3]      Reserved
BIT[2:0]    POSTDIV2
```
## Chip Nonce Offset
Address = 0x0C

Reset value = 0x00000000
```
BIT[31]     CNOV
BIT[30:16]  Reserved
BIT[2:0]    CNO
```
## Hash Counting Number
Address = 0x10

Reset value = 0x00000000
```
BIT[31:0]  HCN
```
## Ticket Mask
Address = 0x14

Reset value = 0x00000000
```
BIT[31:24]  TM3
BIT[23:16]  TM2
BIT[15:8]   TM1
BIT[7:0]    TM0
```
## Misc Control
Address = 0x18

Reset value = 0x00003A01
```
BIT[31:23]  Reserved
BIT[27:24]  BT8D_8_5
BIT[23]     Reserved
BIT[22]     CORE_SRST
BIT[21]     SPAT_NOD
BIT[20]     RVS_K0
BIT[19:18]  DSCLK_SEL
BIT[17]     TOPCLK_SEL
BIT[16]     BCLK_SEL (Baudrate CLOck SELect)
BIT[15]     RET_ERR_NONCE
BIT[14]     RFS
BIT[13]     INV_CLKO
BIT[12:8]   BT8D_4_0
BIT[7]      RET_WORK_ERR_FLAG
BIT[6:4]    TFS
BIT[3:2]    Reserved
BIT[1:0]    HASHRATE_TWS
```

BT8D is a 9bits divider to determine actual Baudrate. It is composed by BT8D_8_5 and BT8D_4_0.

* BCLK_SEL = 0: Baudrate base clock is CLKI (external clock)
* BCLK_SEL = 1: Baudrate base clock is PLL3

## SOME_TEMP_RELATED
Address = 0x1C

Reset value = 0x??
```
BIT[31]     ?
BIT[30:25]  ?
BIT[24]     ?
BIT[23:17]  ?
BIT[16]     ?
BIT[15:8]   SOME_TEMP_RELATED_REG
BIT[7:0]    TEMP_SENSOR_TYPE
```
## Ordered Clock Enable
Address = 0x20

Reset value = 0x0000FFFF
```
BIT[31:16]  Reserved
BIT[15:0]   CLKEN
```
## fast UART configuration
Address = 0x28

Reset value = 0x0600000F
```
BIT[31:30] DIV4_ODDSET
BIT[29:28] Reserved
BIT[27:24] PLL3_DIV4
BIT[23:22] USRC_ODDSET
BIT[21:16] USRC_DIV
BIT[15]    ForceCoreEn
BIT[14]    CLKO_SEL
BIT[13:12] CLKO_ODDSET
BIT[11,8]  Reserved
BIT[7:0]   CLKO_DIV
```
## UART relay
Address = 0x2C

Reset value = 0x000F0000
```
BIT[31:16] GAP_CNT
BIT[15:2]  Reserved
BIT[1]     RO_RELAY_EN
BIT[0]     CO_RELAY_EN
```
## Ticket Mask2
Address = 0x38

Reset value = 0x00000000
```
BIT[31:0]  TM
```
## Core Register Control
Address = 0x3C

Reset value = 0x??
```
BIT[31]    WR_RD#_MSB?
BIT[30:16] Always0x7e00?
BIT[15]    WR_RD#_LSB?
BIT[14:12] Always3?
BIT[11:8]  CORE_REG_ID
BIT[7:0]   CORE_REG_VAL
```
## Core Register Value
Address = 0x40

Reset value = 0x??
```
BIT[31:16] CORE_ID (1 byte should be enough...)
BIT[15:0]  CORE_REG_VAL
```
## External Temperature Sensor Read
Address = 0x44

Reset value = 0x00000100
```
BIT[31:24]  LOCAL_TEMP_ADDR
BIT[23:16]  LOCAL_TEMP_DATA
BIT[15:8]   EXTERNAL_TEMP_ADDR
BIT[7:0]    EXTERNAL_TEMP_DATA
```
## Error Flag
Address = 0x48

Reset value = 0xFF000000
```
BIT[31:24]  CMD_ERR_CNT
BIT[23:16]  WORK_ERR_CNT
BIT[15:8]   Reserved
BIT[7:0]    CORE_RESP_ERR
```
## Nonce Error Counter
Address = 0x4C

Reset value = 0x00000000
```
BIT[31:0]  ERR_CNT
```
## Nonce Overflow Counter
Address = 0x50

Reset value = 0x00000000
```
BIT[31:0]  OVRF_CNT
```
## Analog Mux Control
Address = 0x54

Reset value = 0x00000000
```
BIT[31:3]  Reserved
BIT[2:0]   DIODE_VDD_MUX_SEL
```
## Io Driver Strenght Configuration
Address = 0x58

Reset value = 0x02112111
```
BIT[31:28]  Reserved
BIT[27:24]  RF_DS
BIT[23]     D3RS_DISA
BIT[22]     D2RS_DISA
BIT[21]     D1RS_DISA
BIT[20]     D0RS_EN
BIT[19:16]  R0_DS
BIT[15:12]  CLKO_DS
BIT[11:8]   NRSTO_DS
BIT[7:4]    BO_DS
BIT[3:0]    CO_DS
```
## Time Out
Address = 0x5C

Reset value = 0x0000FFFF
```
BIT[31:16]  Reserved
BIT[15:0]   TMOUT
```
## PLL1 Parameter
Address = 0x60

Reset value = 0x00640111

See [Pll0 Parameter](#pll0-parameter)
## PLL2 Parameter
Address = 0x64

Reset value = 0x00680111

See [Pll0 Parameter](#pll0-parameter)
## PLL3 Parameter
Address = 0x68

Reset value = 0x00700111

See [Pll0 Parameter](#pll0-parameter)
## Ordered Clock Monitor
Address = 0x6C

Reset value = 0x00000000
```
BIT[31]     START
BIT[30:28]  Reserved
BIT[27:24]  CLK_SEL
BIT[23:16]  Reserved
BIT[15:0]   CLK_COUNT
```
## Pll0 Divider
Address = 0x70

Reset value = 0x03040607
```
BIT[31:28]  Reserved
BIT[27:24]  PLL_DIV3
BIT[23:20]  Reserved
BIT[19:16]  PLL_DIV2
BIT[15:12]  Reserved
BIT[11:8]   PLL_DIV1
BIT[7:4]    Reserved
BIT[3:0]    PLL_DIV0
```
## Pll1 Divider
Address = 0x74

Reset value = 0x03040506

See [Pll0 Divider](#pll0-divider)
## Pll2 Divider
Address = 0x78

Reset value = 0x03040506

See [Pll0 Divider](#pll0-divider)
## Pll3 Divider
Address = 0x7C

Reset value = 0x03040506

See [Pll0 Divider](#pll0-divider)
## Clock Order Control0
Address = 0x80

Reset value = 0xD95C8410
```
BIT[31:28]  CLK7_SEL
BIT[27:24]  CLK6_SEL
BIT[23:20]  CLK5_SEL
BIT[19:16]  CLK4_SEL
BIT[15:12]  CLK3_SEL
BIT[11:8]   CLK2_SEL
BIT[7:4]    CLK1_SEL
BIT[3:0]    CLK0_SEL
```
## Clock Order Control1
Address = 0x84

Reset value = 0xFB73EA62
```
BIT[31:28]  CLK15_SEL
BIT[27:24]  CLK14_SEL
BIT[23:20]  CLK13_SEL
BIT[19:16]  CLK12_SEL
BIT[15:12]  CLK11_SEL
BIT[11:8]   CLK10_SEL
BIT[7:4]    CLK9_SEL
BIT[3:0]    CLK8_SEL
```
## Clock Order Status
Address = 0x8C

Reset value = 0x00000000
```
BIT[31:0]  CLOCK_ORDER_STATUS
```
## Frequency Sweep Control1
Address = 0x90

Reset value = 0x00000070
```
BIT[31:27]  Reserved
BIT[26:24]  SWEEP_STATE
BIT[23:21]  Reserved
BIT[20:16]  SWEEP_ST_ADDR
BIT[15:14]  Reserved
BIT[13]     ALL_CORE_CLK_SEL_CHANGE_ST
BIT[12]     SWEEP_FAIL_LOCK_EN
BIT[11]     SWEEP_RESET
BIT[10:8]   CURR_PAT_ADDR
BIT[7]      SWP_ONE_PAT_DONE
BIT[6:4]    SWP_PAD_ADDR
BIT[3]      SWP_DONE_ALL
BIT[2]      SWP_ONGOING
BIT[1]      SWP_TRIG
BIT[0]      SWP_EN
```
## Golden Nonce For Sweep Return
Address = 0x94

Reset value = 0x00376400
```
BIT[31:0]  GNOSWR
```
## Returned Group Pattern Status
Address = 0x98

Reset value = 0x30303030
```
BIT[31:0]  RGTS
```
## Nonce Returned Timeout
Address = 0x9C

Reset value = 0x0000FFFF
```
BIT[31:16]  Reserved
BIT[15:0]   SWEEP_TIMEOUT
```
## Returned Single Pattern Status
Address = 0xA0

Reset value = 0x00000000
```
BIT[31:0]  RSTS
```
# BM1397 Core Registers map

## Clock Delay Ctrl
ID = 0
```
BIT[15:8] Reserved
BIT[7:6]  CCDLY_SEL
BIT[5:4]  PWTH_SEL
BIT[3]    HASH_CLKEN
BIT[2]    MMEN
BIT[1]    Reserved
BIT[0]    SWPF_MODE
```
## Process Monitor Ctrl
ID = 1
```
BIT[15:3] Reserved
BIT[2]    PM_START
BIT[1:0]  PM_SEL
```
## Process Monitor Data
ID = 2
```
BIT[15:0]  FREQ_CNT
```
## Core Error
ID = 3
```
BIT[15:5] Reserved
BIT[4]    INI_NONCE_ERR
BIT[3:0]  CMD_ERR_CNT
```
## Core Enable
ID = 4
```
BIT[15:8] Reserved
BIT[7:0]  CORE_EN_I
```
## Hash Clock Control
ID = 5
```
BIT[15:8] Reserved
BIT[7:0]  CLOCK_CTRL
```
## Hash Clock Counter
ID = 6
```
BIT[15:8] Reserved
BIT[7:0]  CLOCK_CNT
```
## Sweep Clock Control
ID = 7
```
BIT[15:8] Reserved
BIT[7]    SWPF_MODE
BIT[6:4]  Reserved
BIT[3:0]  CLK_SEL
```
