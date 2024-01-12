#!/bin/bash

# pip install bit_field

for reg in \
  chip_address \
  pll_parameter \
  misc_control \
  fast_uart_configuration \
  version_rolling \
  reg_a8
  # hash_rate \
  # chip_nonce_offset \
  # hash_counting_number \
  # ticket_mask \
  # i2c_control \
  # ordered_clock_enable \
  # uart_relay \
  # ticket_mask2 \
  # core_register_control \
  # core_register_value \
  # external_temperature_sensor_read \
  # error_flag \
  # nonce_error_counter \
  # nonce_overflow_counter \
  # analog_mux_control \
  # io_driver_strenght_configuration \
  # time_out \
  # ordered_clock_monitor \
  # pll_divider \
  # clock_order_control0 \
  # clock_order_control1 \
  # clock_order_status \
  # frequency_sweep_control1 \
  # golden_nonce_for_sweep_return \
  # returned_group_pattern_status \
  # nonce_returned_timeout \
  # returned_single_pattern_status \
do
  echo $reg
  bit_field --bits 32 --lanes 2 $reg.json | sed -e 's/viewbox="0 0 800 160.5"/viewbox="0 0 800 160.5" style="background-color:white"/g' > $reg.svg
done

# for core_reg in \
#   clock_delay_ctrl \
#   process_monitor_ctrl \
#   process_monitor_data \
#   core_error \
#   core_enable \
#   hash_clock_control \
#   hash_clock_counter \
#   sweep_clock_control
# do
#   echo $core_reg
#   bit_field --bits 8 $core_reg.json | sed -e 's/viewbox="0 0 800 80"/viewbox="0 0 800 80" style="background-color:white"/g' > $core_reg.svg
# done