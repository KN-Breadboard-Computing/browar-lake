# Browar Lake
16-bit (with 32-bit addressing) pipelined CPU from KN Breadboard Computing.

This is a successor to our [8-bit CPU](https://github.com/KN-Breadboard-Computing/computer/)

## Development
This project uses [FuseSoC](https://github.com/olofk/fusesoc/) as HDL build tool.

Example: running a CPU with Wishbone RAM:
```
fusesoc --cores-root cores run --target wb_sim cpu
```
