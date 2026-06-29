# SRAM Architectures in Verilog

A collection of parameterized SRAM (Static Random Access Memory) architectures implemented in Verilog HDL. This repository demonstrates the design, simulation, and comparison of commonly used SRAM organizations, including single-port, pseudo dual-port, and true dual-port memories.

Simulation was performed using **Icarus Verilog**, and waveforms were analyzed using **GTKWave**.

---

## Features

- Parameterized SRAM designs
- Single-Port SRAM (Synchronous Read)
- Single-Port SRAM (Asynchronous Read)
- Pseudo Dual-Port SRAM
- True Dual-Port SRAM
- Collision detection for True Dual-Port SRAM
- Write-First Read-During-Write policy in Pseudo Dual-Port SRAM

---

## Repository Structure

```
SRAM/
│
├── Single_Port_Sync/
├── Single_Port_Async/
├── Dual_Port_Pseudo_Sync/
└── Dual_Port_True_Sync/
```

Each folder contains:
- Design (`.v`)
- Testbench (`_tb.v`)
- Simulation executable (`.vvp`)
- Waveform dump (`.vcd`)
- GTKWave screenshot (`.png`)

---

## SRAM Architectures

### Single-Port SRAM
Uses a single port for both read and write operations.

- **Synchronous Read:** Output updates only on the clock edge.
- **Asynchronous Read:** Output updates immediately after the address changes.

### Pseudo Dual-Port SRAM
Provides one dedicated write port and one dedicated read port sharing a common clock. This implementation supports **Write-First** behavior during simultaneous read and write to the same address.

### True Dual-Port SRAM
Provides two fully independent ports with separate clocks, addresses, and control signals. Collision detection prevents simultaneous writes to the same memory location.

---

## Simulation Results

### Single-Port Synchronous SRAM

<img width="1607" height="247" alt="sp_ram_sync" src="https://github.com/user-attachments/assets/55ac1bb4-b206-4548-a569-fd6854d94d33" />
sp_ram_sync.png


### Single-Port Asynchronous SRAM

<img width="1610" height="238" alt="sp_ram_async" src="https://github.com/user-attachments/assets/1ddce161-6550-4dcc-963e-d959584f7013" />
sp_ram_async.png


### Synchronous vs Asynchronous Read

| Feature | Synchronous | Asynchronous |
|----------|-------------|--------------|
| Read Timing | Clocked | Immediate |
| Latency | 1 Clock Cycle | Minimal |
| Stability | Higher | Lower |
| Typical Use | FPGA/ASIC Memory | LUTs, Small Memories |

---

### True Dual-Port SRAM

<img width="1626" height="381" alt="dp_ram_sync_true_1" src="https://github.com/user-attachments/assets/2b7ef539-4755-483d-bfb1-b1da8c7d0a91" />
dp_ram_sync_true_1.png


### Pseudo Dual-Port SRAM

<img width="1622" height="242" alt="dp_ram_sync_pseudo" src="https://github.com/user-attachments/assets/72628182-a427-4c88-ad55-f4cf324bbbfe" />
dp_ram_sync_pseudo.png

### True vs Pseudo Dual-Port

| Feature | Pseudo | True |
|----------|---------|------|
| Read/Write Ports | Separate | Independent |
| Number of Clocks | 1 | 2 |
| Simultaneous Writes | No | Yes |
| Complexity | Lower | Higher |

---

## Key Learning Outcomes

- Parameterized Verilog design
- SRAM memory architectures
- Synchronous vs asynchronous memories
- Single-Port vs Dual-Port SRAM
- Collision detection
- Read-During-Write handling
- Testbench development
- Simulation using Icarus Verilog
- Waveform analysis using GTKWave

---

## Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave

## Author
- Gaurish Juneja
