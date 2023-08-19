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
