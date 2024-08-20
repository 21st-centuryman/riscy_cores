<div align="center">

## Riscy Cores
#### Very much riscy cores, written in SystemVerilog

[![Verilog](https://img.shields.io/badge/SystemVerilog-00599C.svg?style=for-the-badge&logoColor=white&logo=systemverilog)]()
[![RISC](https://img.shields.io/badge/risc--v-283272.svg?style=for-the-badge&logoColor=white&logo=riscv)]()

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/21st-centuryman/riscy_cores/main.yaml?branch=main&style=for-the-badge&logo=github&logoColor=white&label=TestBenches&labelColor=black)
</div>


## ⇁  Welcome
This is a collection of cores and chips I've built.

Each project is split in the cores folder, with the testbench and design in the tests and src folders respectively.

Below is a tree structure of the current files:
```bash
├── README.md
├── assets
└── cores
    ├── conway        # Conway's Game of Life
    │   ├── src
    │   └── tests
    └── riscy32_single # 32 Bit Single Cycle RISC-V Cpu
        ├── src
        └── tests

```

#### ⇁  Riscy 32 single
Single cycle 32 bit RISC-V CPU. Plan is to use this as a base to make a pipelined 64 bit CPU. 

Then I have plans to combine this with a DSP for machine learning.


#### ⇁  Conway's game of life
In case anyone searches how to implement this in SystemVerilog, below is a gif of my Conway's game of life attempt.
Note I couldn't make it as square as I wanted it to be, its a bit vertical. And idk why 0,0 is rendered. This is stuff I will investigate later.
![Conway](./assets/conway.gif)
