vlib work
vlog spi_wrapper.v spi_wrapper_tb.v RAM.v spi.v
vsim -voptargs=+acc spi_wrapper_tb
add wave *
add wave -position insertpoint  \
sim:/spi_wrapper_tb/dut/rx_data \
sim:/spi_wrapper_tb/dut/tx_data \
sim:/spi_wrapper_tb/dut/rx_valid \
sim:/spi_wrapper_tb/dut/tx_valid \
sim:/spi_wrapper_tb/dut/u1/mem \
sim:/spi_wrapper_tb/dut/u2/tx_reg \
sim:/spi_wrapper_tb/dut/u2/start_out \
sim:/spi_wrapper_tb/dut/u2/cs \
sim:/spi_wrapper_tb/dut/u2/ns

run -all
#quit -sim