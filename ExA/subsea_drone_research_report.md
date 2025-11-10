# Technical Feasibility Study: 250m Subsea Cable Inspection Drone

**Authors:** Jerry Liu (yhl63), Zihe Liu (zl559)  
**Institution:** Department of Engineering, University of Cambridge  
**Date:** November 2025

## Executive Summary

Your target specifications present an achievable but challenging design problem that requires careful trade-offs between speed, endurance, and mass constraints. The 4 m/s peak speed requirement drives power consumption to 1-1.2 kW, necessitating a ~500-660 Wh battery system that consumes 20-30% of your 25 kg mass budget. Commercial components exist for all subsystems, with complete build costs estimated at $15,000-25,000 versus $50,000-80,000 for comparable commercial AUVs.

**Critical finding:** Achieving 4 m/s in this weight class requires 4× Blue Robotics T200 thrusters and accepts reduced endurance to 1.5-2 hours under peak operation.

---

## 1. Power Budget Analysis

### 1.1 Hydrodynamic Drag Calculations

For a streamlined torpedo hull with diameter D = 0.324m and frontal area A = 0.082 m²:

**Drag force equation:**
$$F_D = \frac{1}{2} \rho v^2 C_D A$$

Where:
- ρ = 1027 kg/m³ (seawater density)
- v = velocity (m/s)
- C_D = drag coefficient (0.28-0.35 for torpedo shape)
- A = frontal area (m²)

**At 1 m/s cruise (C_D = 0.32):**
- F_D = 0.5 × 1027 × 1² × 0.32 × 0.082 = 13.5 N
- Power = F_D × v = 13.5 × 1 = 13.5 W propulsion

**At 4 m/s peak (C_D = 0.28):**
- F_D = 0.5 × 1027 × 16 × 0.28 × 0.082 = 188 N
- Power = F_D × v = 188 × 4 = 752 W propulsion

Adding thruster efficiency (η ≈ 0.7):
- **Cruise electrical power:** 13.5 / 0.7 = **19.3 W**
- **Peak electrical power:** 752 / 0.7 = **1,074 W**

### 1.2 Complete System Power Budget

| Component | Cruise (W) | Peak (W) | Notes |
|-----------|------------|----------|-------|
| **Propulsion** | 50 | 1,100 | 4× T200 thrusters |
| **Payload** | 17.5 | 20 | Camera + sonar + lights |
| **Navigation** | 5 | 5 | IMU, depth sensor, GPS |
| **Control** | 10 | 10 | Raspberry Pi 4 + Navigator |
| **Communications** | 2 | 2 | WiFi/Iridium (surface) |
| **Acoustic Modem** | 1.5 | 20 | Receive/transmit |
| **TOTAL** | **86 W** | **1,157 W** | |

### 1.3 Battery Sizing

**For 2-hour endurance at average power (215W):**
- Energy required = 215W × 2h = 430 Wh
- With 20% safety margin = 516 Wh

**Selected configuration: Blue Robotics 2× 18Ah batteries**
- Voltage: 14.8V (4S Li-ion)
- Capacity: 18Ah × 14.8V = 266 Wh each
- Total: 532 Wh (meets requirement)
- Mass: 1.35 kg each = 2.7 kg total
- Cost: $360 × 2 = $720

**Alternative for higher peak power: 3× 18Ah batteries**
- Total energy: 799 Wh
- Mass: 4.05 kg
- Cost: $1,080
- Enables sustained 4 m/s operation

---

## 2. Propulsion System Selection

### 2.1 Blue Robotics T200 Thruster Specifications

**Performance characteristics:**
- Forward thrust: 5.1 kgf (50 N) at 16V
- Reverse thrust: 4.1 kgf (40 N) at 16V  
- Power consumption: 350W maximum, ~100W at cruise
- Depth rating: 300m (12× requirement)
- Dimensions: Ø102mm × 113mm length
- Mass: 320g in air
- Price: **$259 each**

**Thrust vs voltage curve:**
- 12V: 3.7 kgf forward
- 14V: 4.4 kgf forward
- 16V: 5.1 kgf forward
- 20V: 6.5 kgf forward

**For 4 m/s operation:**
- Required thrust: 188 N total
- Selected: 4× T200 thrusters = 200 N combined
- Safety margin: 6%
- Total cost: $1,036

### 2.2 Electronic Speed Controllers

**Blue Robotics Basic ESC:**
- Continuous current: 30A
- Peak current: 40A for 10 seconds
- Voltage: 6-22V
- Firmware: BLHeli_S
- Features: Bidirectional, thermal protection, PWM control
- Mass: 33g
- Price: **$35-40 each**

**Required: 4× ESCs = $140-160 total**

---

## 3. Navigation and Control Systems

### 3.1 Flight Controller

**Blue Robotics Navigator + Raspberry Pi 4:**
- **Navigator specifications:**
  - 6-axis IMU (ICM-20602): ±2g accelerometer, ±2000°/s gyro
  - Dual magnetometers (AK09915)
  - Barometer (BMP388): 0.5m resolution
  - 16× PWM outputs
  - 4× UART ports
  - 2× I2C buses
  - Power: 5V, 8-10W typical
  - Mass: ~50g
  - Price: **$125**

- **Raspberry Pi 4 (4GB):**
  - Processor: ARM Cortex-A72 quad-core 1.5GHz
  - Runs ArduPilot or custom autonomy code
  - USB for cameras, Ethernet for high-bandwidth sensors
  - Power: 3-5W typical
  - Mass: 46g
  - Price: **$55-75**

**Total control system: $180-200**

### 3.2 Depth Sensor

**Bar30 High-Resolution Pressure Sensor:**
- Range: 0-30 bar (300m depth)
- Resolution: 2mm depth
- Accuracy: ±0.5% full scale
- Interface: I2C
- Power: <1mW
- Mass: 6g
- Depth rating: 300m
- Price: **$80-90**

**Note:** Requires periodic drying to maintain accuracy. Alternative industrial sensors from Keller or Honeywell offer superior stability at $200-500.

### 3.3 Doppler Velocity Log (Optional)

**Nortek DVL1000:**
- Accuracy: 0.8 cm/s single-ping
- Bottom track range: 75m
- Depth rating: 300m
- Power: 1.3W average, 15W peak
- Mass: ~2 kg
- Interface: Serial RS-232/422
- Update rate: 1-15 Hz
- Price: **$15,000-25,000** (quote required)

**Alternative: Dead reckoning with IMU** (acceptable for cable-following where visual/sonar tracking provides position updates)

---

## 4. Communication Systems

### 4.1 Underwater Acoustic Communication

**EvoLogics S2C M 18/34 Acoustic Modem:**
- Frequency: 18-34 kHz
- Data rate: 13.9 kbps
- Range: 2,000m
- Operating depth: 3,000m
- Power: 20W transmit, 1.5W receive
- Source level: 180 dB re 1μPa
- Dimensions: Ø80mm × 270mm
- Mass: 1.2 kg
- Price: **$10,000-15,000**

**Link budget verification (500m range):**
```
Transmission Loss = 20log₁₀(500) + 3×0.5 = 55.5 dB
Received Level = 180 - 55.5 + 10 (array gain) = 134.5 dB
SNR Margin = 134.5 - 60 (noise) - 10 (required) = 64.5 dB ✓
```

**Budget alternative: Water Linked M64**
- Data rate: 64 bps (command/control only)
- Range: 100m
- Price: **$2,300**

### 4.2 Surface Communication

**Iridium Satellite (RockBLOCK 9603):**
- Data: 340 byte messages
- Global coverage
- Power: 0.8W transmit, 0.04W idle
- Mass: 38g
- Hardware: **$260**
- Service: **$15-20/month**

**WiFi 2.4GHz (when surfaced):**
- Range: 500m line-of-sight to vessel
- Data rate: 1-50 Mbps
- Power: 0.1-0.5W
- Module cost: **$50**

---

## 5. Imaging Payload

### 5.1 Video Camera

**Blue Robotics Low-Light HD USB Camera:**
- Resolution: 1920×1080p @ 30fps
- Sensor: Sony IMX322
- Low-light sensitivity: 0.01 lux
- Depth rating: 300m
- Interface: USB 2.0
- Power: 2.5W typical
- Lens: 165° wide angle
- Mass: 90g
- Price: **$120**

**Professional alternative: SubC Rayfin Micro**
- Resolution: 4K video, 12.3MP stills
- Depth: 500m
- Power: 7.8W average, 13.56W peak
- Price: **$8,000-15,000**

### 5.2 Imaging Sonar

**Ping360 Scanning Imaging Sonar:**
- Frequency: 750 kHz
- Range: 2-50m adjustable
- Angular resolution: 0.9° at 25m
- Scan: 360° mechanical rotation
- Depth rating: 300m
- Power: 5W maximum
- Interface: Serial UART
- Mass: 375g
- Price: **$2,750**

### 5.3 Lighting

**Blue Robotics Lumen Light:**
- Output: 1500 lumens
- Power: 10W typical
- Depth: 300m
- Dimmable via PWM
- Mass: 85g
- Price: **$300**

**Recommended payload configuration:**
- Low-Light Camera: 2.5W, $120
- Ping360 Sonar: 5W, $2,750
- Lumen Light: 10W, $300
- **Total: 17.5W, $3,170**

---

## 6. Pressure Housing Design

### 6.1 Material Selection: Aluminum 6061-T6

**Properties:**
- Yield strength: 276 MPa
- Density: 2,700 kg/m³
- Corrosion resistance: Excellent (anodized)
- Cost: $7/kg raw material
- Machinability: Excellent

**Wall thickness calculation for 250m (25 bar external pressure):**

Using ASME Section VIII formula for external pressure:
$$t = \frac{P \cdot R}{S \cdot E - 0.6P} + C_A$$

Where:
- P = 7.5 MPa (25 bar × 3 safety factor)
- R = 50mm (for 100mm ID tube)
- S = 92 MPa (allowable stress = yield/3)
- E = 0.95 (weld efficiency, or 1.0 for seamless)
- C_A = 1.5-3mm (corrosion allowance)

**Result:** t = 4.5mm + 2mm = **6.5-8mm wall thickness**

**Blue Robotics 3" watertight enclosures:**
- Depth rating: 500m (2× requirement)
- Internal diameter: 74.7mm
- Lengths: 150-400mm available
- Material: 6061-T6 aluminum, hard anodized
- O-ring seals: Double redundant
- Price: **$200-300 complete with end caps**

### 6.2 Sealing and Penetrators

**WetLink Penetrators:**
- Depth rating: 1,000m (4× requirement)
- Sizes: 6-10mm cable diameter
- Installation: Tool-free, no potting
- Seal: Compression o-ring
- Price: **$13-17 each**

**Typical configuration: 8 penetrators = $104-136**

### 6.3 Alternative Materials Analysis

| Material | Yield (MPa) | Density (kg/m³) | Cost ($/kg) | Depth Rating | Notes |
|----------|-------------|-----------------|-------------|--------------|-------|
| Aluminum 6061-T6 | 276 | 2,700 | 7 | 250m+ | **Optimal choice** |
| Titanium Grade 5 | 880 | 4,430 | 30 | 1000m+ | 4× cost, minimal benefit |
| Acrylic | 70-75 | 1,180 | 4 | 70-150m | **Insufficient for 250m** |

**Conclusion:** Aluminum provides best cost/performance for 250m operation.

---

## 7. System Integration and Mass Budget

### 7.1 Component Mass Breakdown

| Component | Quantity | Unit Mass | Total Mass | % of Budget |
|-----------|----------|-----------|------------|-------------|
| **Propulsion** |  |  |  |  |
| T200 Thrusters | 4 | 0.32 kg | 1.28 kg | 5.1% |
| ESCs | 4 | 0.033 kg | 0.13 kg | 0.5% |
| **Power** |  |  |  |  |
| 18Ah Batteries | 2 | 1.35 kg | 2.70 kg | 10.8% |
| Battery Enclosure (3") | 1 | 0.80 kg | 0.80 kg | 3.2% |
| Power distribution | 1 | 0.10 kg | 0.10 kg | 0.4% |
| **Control & Nav** |  |  |  |  |
| RPi4 + Navigator | 1 | 0.10 kg | 0.10 kg | 0.4% |
| Electronics enclosure (4") | 1 | 1.20 kg | 1.20 kg | 4.8% |
| Depth sensor | 1 | 0.006 kg | 0.01 kg | 0.0% |
| **Payload** |  |  |  |  |
| Camera | 1 | 0.09 kg | 0.09 kg | 0.4% |
| Ping360 sonar | 1 | 0.38 kg | 0.38 kg | 1.5% |
| Lumen light | 1 | 0.085 kg | 0.09 kg | 0.3% |
| **Communications** |  |  |  |  |
| RockBLOCK Iridium | 1 | 0.038 kg | 0.04 kg | 0.2% |
| WiFi module | 1 | 0.020 kg | 0.02 kg | 0.1% |
| **Structure** |  |  |  |  |
| Frame (aluminum) | 1 | 2.00 kg | 2.00 kg | 8.0% |
| Buoyancy foam | 1 | 1.50 kg | 1.50 kg | 6.0% |
| Fairings/nose/tail | 1 | 1.00 kg | 1.00 kg | 4.0% |
| Hardware/fasteners | 1 | 0.50 kg | 0.50 kg | 2.0% |
| Cables/connectors | 1 | 0.30 kg | 0.30 kg | 1.2% |
| Penetrators | 8 | 0.015 kg | 0.12 kg | 0.5% |
| **SUBTOTAL** |  |  | **13.36 kg** | **53.4%** |
| **Contingency (15%)** |  |  | **2.00 kg** | **8.0%** |
| **TOTAL (no acoustic modem)** |  |  | **15.36 kg** | **61.4%** |
| Acoustic modem (optional) | 1 | 1.20 kg | 1.20 kg | 4.8% |
| **TOTAL (with acoustic)** |  |  | **16.56 kg** | **66.2%** |

**Remaining capacity: 8.4 kg (33.6%) for upgrades or DVL addition**

### 7.2 Buoyancy Analysis

**Required displaced volume for neutral buoyancy:**
$$V_{displaced} = \frac{m_{total}}{\rho_{seawater}} = \frac{15.36}{1027} = 0.01496 \text{ m}^3 = 14.96 \text{ liters}$$

**Component volumes:**
- Pressure housings: ~4 liters (displace water)
- Batteries: ~2 liters internal
- Thrusters: Negative buoyancy (~0.3 kg each)
- Electronics: Minimal volume

**Buoyancy foam requirement:**
- Syntactic foam density: 500-700 kg/m³
- Required foam mass: ~1.5 kg
- Foam volume: ~2.5 liters
- Cost: ~$200-300

**Adjustable ballast: ±500g for fine trim**

---

## 8. Cost Breakdown and Budget

### 8.1 Detailed Component Costs

| Category | Component | Qty | Unit Cost | Total Cost |
|----------|-----------|-----|-----------|------------|
| **Propulsion** |  |  |  |  |
|  | T200 Thruster | 4 | $259 | $1,036 |
|  | Basic ESC | 4 | $38 | $152 |
|  | Spare propellers | 1 set | $40 | $40 |
|  | **Subtotal** |  |  | **$1,228** |
| **Power System** |  |  |  |  |
|  | 18Ah Li-ion Battery | 2 | $360 | $720 |
|  | 3" Watertight Enclosure | 1 | $250 | $250 |
|  | Power distribution board | 1 | $100 | $100 |
|  | **Subtotal** |  |  | **$1,070** |
| **Control & Navigation** |  |  |  |  |
|  | Navigator Flight Controller | 1 | $125 | $125 |
|  | Raspberry Pi 4 (4GB) | 1 | $65 | $65 |
|  | MicroSD card (64GB) | 1 | $15 | $15 |
|  | 4" Watertight Enclosure | 1 | $300 | $300 |
|  | Bar30 Depth Sensor | 1 | $85 | $85 |
|  | GPS module | 1 | $80 | $80 |
|  | **Subtotal** |  |  | **$670** |
| **Communications** |  |  |  |  |
|  | RockBLOCK 9603 Iridium | 1 | $260 | $260 |
|  | WiFi module | 1 | $50 | $50 |
|  | Antennas | 2 | $25 | $50 |
|  | **Subtotal** |  |  | **$360** |
| **Payload** |  |  |  |  |
|  | Low-Light HD Camera | 1 | $120 | $120 |
|  | Ping360 Scanning Sonar | 1 | $2,750 | $2,750 |
|  | Lumen Light | 1 | $300 | $300 |
|  | **Subtotal** |  |  | **$3,170** |
| **Structure & Hardware** |  |  |  |  |
|  | Aluminum stock (frame) | 1 | $400 | $400 |
|  | Buoyancy foam (syntactic) | 1 | $250 | $250 |
|  | Fairings/nose cone | 1 | $300 | $300 |
|  | WetLink Penetrators | 8 | $15 | $120 |
|  | Fasteners/hardware | 1 | $150 | $150 |
|  | Cables/connectors | 1 | $200 | $200 |
|  | **Subtotal** |  |  | **$1,420** |
| **Tools & Consumables** |  |  |  |  |
|  | Epoxy, sealant, o-rings | 1 | $100 | $100 |
|  | Tools (if needed) | 1 | $150 | $150 |
|  | **Subtotal** |  |  | **$250** |
| **BASE SYSTEM TOTAL** |  |  |  | **$8,168** |
| **Contingency (20%)** |  |  |  | **$1,634** |
| **TOTAL (Core System)** |  |  |  | **$9,802** |
|  |  |  |  |  |
| **Optional Upgrades:** |  |  |  |  |
|  | EvoLogics Acoustic Modem | 1 | $12,500 | $12,500 |
|  | Nortek DVL1000 | 1 | $20,000 | $20,000 |
|  | SubC Rayfin 4K Camera | 1 | $10,000 | $10,000 |
|  |  |  |  |  |
| **Full Professional System** |  |  |  | **~$52,000** |

### 8.2 Comparison to Commercial Solutions

| Platform | Mass (kg) | Depth (m) | Speed (m/s) | Endurance (h) | Estimated Cost |
|----------|-----------|-----------|-------------|---------------|----------------|
| **Our Design (Base)** | 15.4 | 250 | 4.0 | 2 | **$10,000** |
| **Our Design (Full)** | 16.6 | 250 | 4.0 | 2 | **$52,000** |
| Iver3 Standard | 34 | 100 | 1.3 | 8-14 | $50,000+ |
| ecoSUB m-Power+ | 17 | 500 | ~2 | 8-10 | $70,000+ |
| Boxfish AUV | 25 | 600 | ~2 | 10 | $120,000+ |

**Key advantages of custom build:**
- 20-80% cost savings vs commercial
- Optimized for 4 m/s sprint capability
- Lighter weight (15.4 kg vs 17-34 kg)
- Modular design allows easy upgrades
- Full control over software/autonomy

**Key disadvantages:**
- Development time: 6-12 months
- No warranty or support
- Self-certification for depth rating
- Requires engineering expertise

---

## 9. Technical Feasibility Assessment

### 9.1 Hydrodynamic Feasibility

**Thrust requirement at 4 m/s:**
- Drag force: 188 N
- Available thrust: 200 N (4× T200 at 16V)
- **Safety margin: 6%** ✓

**Concern:** Minimal margin for real-world conditions. Actual drag may be 10-20% higher due to:
- Surface roughness
- Cable/sensor protrusions
- Turbulence effects
- Thruster interaction

**Mitigation:**
- Optimize hull streamlining (Cd target: 0.25-0.28)
- Recess sensors where possible
- Consider 5th thruster for reserve capacity
- Accept slightly lower top speed (3.5 m/s) if needed

### 9.2 Power and Endurance Feasibility

**Cruise operation (1 m/s):**
- Power consumption: 85W
- Battery capacity: 532 Wh
- **Endurance: 6.3 hours** ✓

**Mixed operation (70% cruise, 30% peak at 4 m/s):**
- Average power: 390W
- **Endurance: 1.4 hours** ⚠

**Peak operation (sustained 4 m/s):**
- Power consumption: 1,157W
- **Endurance: 0.46 hours (28 minutes)** ⚠

**Recommendations:**
1. **For 2-hour endurance at mixed speeds:** Upgrade to 3× 18Ah batteries (799 Wh, +1.35 kg, +$360)
2. **For cable inspection missions:** Operate primarily at 1-2 m/s cruise with brief 4 m/s sprints
3. **Consider mission profile optimization:** 90 minutes cruise + 30 minutes high-speed search

### 9.3 Mass Budget Feasibility

**Current mass allocation:**
- Used: 15.36 kg (61.4%)
- Remaining: 9.64 kg (38.6%)

**Feasibility: EXCELLENT** ✓

**Available margin enables:**
- Acoustic modem addition (+1.2 kg)
- Third battery (+1.35 kg)
- DVL upgrade (+2 kg)
- Heavier structural components if needed
- Additional sensors/payloads

### 9.4 Depth Rating Feasibility

**250m depth = 25 bar external pressure**

**Selected components all rated ≥300m:**
- T200 thrusters: 300m
- Blue Robotics enclosures: 400-500m
- Bar30 sensor: 300m
- Ping360 sonar: 300m
- Camera: 300m
- WetLink penetrators: 1000m

**Feasibility: EXCELLENT** ✓

**Safety margins: 1.2-4.0× on all pressure components**

### 9.5 Communication Feasibility

**Underwater acoustic (500m range):**
- Link budget margin: 64.5 dB
- **Feasibility: EXCELLENT** ✓

**Surface satellite (global):**
- Iridium SBD coverage: worldwide
- **Feasibility: EXCELLENT** ✓

**WiFi (500m to vessel):**
- Standard 2.4 GHz with directional antenna
- **Feasibility: GOOD** ✓

---

## 10. Risk Analysis and Mitigation

### 10.1 Technical Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| **Insufficient thrust for 4 m/s** | Medium | High | Add 5th thruster; optimize hull Cd; accept 3.5 m/s |
| **Battery endurance shortfall** | Medium | Medium | Add 3rd battery; optimize mission profile |
| **Pressure housing leak** | Low | Critical | Vacuum test all seals; redundant o-rings; leak sensors |
| **Acoustic modem failure** | Low | Medium | Operate autonomously; surface for comms |
| **IMU drift in dead reckoning** | High | Medium | Add DVL; use visual/sonar cable tracking |
| **Thruster fouling/damage** | Medium | High | Spare thrusters; protective guards; inspection protocol |
| **Software integration issues** | Medium | Medium | Use ArduPilot/ROS proven stacks; extensive testing |
| **Weight exceeds 25 kg** | Low | Medium | 38% margin; careful component selection |

### 10.2 Operational Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| **Lost vehicle (no recovery)** | Low | Critical | Surface locator beacon; backup GPS; emergency blow |
| **Mission abort (partial data)** | Medium | Low | Store data locally; autonomous return-to-base |
| **Weather delays deployment** | High | Low | Flexible mission scheduling; safe sea state limits |
| **Cable strikes vehicle** | Low | Medium | Collision avoidance; sonar obstacle detection |

### 10.3 Development Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| **Budget overrun** | Medium | Medium | 20% contingency; phased procurement |
| **Schedule delays** | High | Medium | Modular development; early testing |
| **Component unavailability** | Medium | Low | Multi-source components; early ordering |
| **Testing facility access** | Medium | Medium | Partner with marine labs; test tanks |

---

## 11. Development Roadmap

### Phase 1: Platform Development (Months 1-3)
**Budget: $4,000-6,000**

**Deliverables:**
- Structural frame and fairings
- Pressure housings with penetrators
- 4× T200 thrusters with ESCs
- Basic power system (2× batteries)
- Manual/tethered control

**Testing:**
- Pressure test housings to 30 bar
- Shallow water buoyancy verification
- Thruster performance measurement
- Speed vs. power characterization

### Phase 2: Autonomy and Navigation (Months 3-6)
**Budget: $2,000-4,000**

**Deliverables:**
- Navigator + RPi4 control system
- Depth sensor and GPS
- Basic waypoint navigation
- Surface communications (WiFi/Iridium)
- Data logging system

**Testing:**
- Autonomous depth holding
- Waypoint following accuracy
- Surface positioning accuracy
- Communication range tests

### Phase 3: Sensors and Integration (Months 6-9)
**Budget: $3,000-13,000**

**Deliverables:**
- Video camera and lighting
- Ping360 imaging sonar
- Cable detection algorithms
- Mission planning software
- Acoustic modem (optional)

**Testing:**
- Imaging quality at depth
- Cable detection performance
- Full mission profile simulation
- Endurance verification

### Phase 4: Field Trials (Months 9-12)
**Budget: $1,000**

**Activities:**
- Open water testing
- Deep water validation (250m)
- Cable inspection demonstration
- Performance optimization
- Documentation

**Deliverables:**
- Validated system specifications
- Operations manual
- Performance data
- Final report

---

## 12. Conclusions and Recommendations

### 12.1 Feasibility Summary

**The subsea cable inspection drone is TECHNICALLY FEASIBLE within the specified constraints:**

✓ **Depth rating (250m):** All components rated 300m+, 1.2-4× safety factor  
✓ **Mass constraint (<25 kg):** Design at 15.4 kg, 38% margin remaining  
⚠ **Speed requirement (4 m/s peak):** Achievable but with minimal thrust margin (6%)  
⚠ **Endurance (2 hours):** Requires mission profile optimization or battery upgrade  
✓ **Payload (30W):** 17.5W selected sensors, 12.5W margin  
✓ **Communications:** 64.5 dB link margin underwater, global satellite coverage  

### 12.2 Critical Success Factors

**1. Hydrodynamic optimization is essential**
- Target Cd ≤ 0.28 through streamlined hull design
- Minimize protrusions and fairings gaps
- CFD analysis or tow tank testing recommended
- Consider adding 5th thruster for safety margin

**2. Power management strategy required**
- Operate primarily at 1-2 m/s cruise (85-150W)
- Use 4 m/s only for short sprints or transit
- Consider 3× battery upgrade for extended high-speed operation
- Implement power monitoring and low-battery return-to-surface

**3. Staged development reduces risk**
- Phase 1 validates core platform (6 months, $6K)
- Phase 2 adds autonomy (3 months, $4K)
- Phase 3 integrates sensors (3 months, $3-13K)
- Total: 12 months, $13-23K

### 12.3 Recommended Configuration

**For optimal cost/performance balance:**

**Propulsion:**
- 4× Blue Robotics T200 thrusters @ $1,036
- 4× Basic ESCs @ $152

**Power:**
- 2× 18Ah batteries (532 Wh) @ $720
- Upgrade to 3× if sustained 4 m/s required

**Control:**
- Navigator + RPi4 @ $190
- Bar30 depth sensor @ $85
- GPS module @ $80

**Payload:**
- Low-Light HD Camera @ $120
- Ping360 Scanning Sonar @ $2,750
- Lumen Light @ $300

**Communications:**
- RockBLOCK Iridium @ $260
- WiFi module @ $50
- Acoustic modem: OPTIONAL based on mission requirements

**Total base system: $9,800 (without acoustic modem)**  
**With acoustic modem: $22,300**  
**Compare to commercial: $50,000-120,000**

### 12.4 Design Trade-offs

**Achieved:**
- 15.4 kg mass (38% under limit)
- 250m depth capability
- 6+ hour endurance at cruise
- Professional imaging payload
- Global communications

**Compromised:**
- Reduced to 1.4 hours at mixed-speed operation
- 6% thrust margin at 4 m/s (tight)
- No DVL (cost/complexity)
- Basic IMU vs tactical-grade

**If one specification must be relaxed:**
- **Option A:** Reduce peak speed to 3.5 m/s → 15% thrust margin, 2-hour endurance
- **Option B:** Increase mass limit to 30 kg → Add 3rd battery, 5th thruster, DVL
- **Option C:** Reduce endurance to 1.5 hours → Maintain 4 m/s, optimize weight

### 12.5 Academic Project Suitability

**Excellent fit for Cambridge Engineering Tripos Part IIA:**

**Strengths:**
- Multi-domain engineering (fluids, structures, power, control, signals)
- Clear requirements with quantifiable success criteria
- Buildable within academic timeframe/budget
- Mix of calculations, simulation, and practical work
- Real-world application relevance

**Challenges:**
- Pressure testing requires specialized facilities
- Deep water trials (250m) need marine partnerships
- Component lead times may affect schedule
- Hydrodynamic optimization complex but addressable

**Recommended scope:**
- Focus on Phases 1-2 for academic project
- Phase 3 as extension/continuation
- Emphasize calculations, design rationale, trade-off analysis
- Demonstrate pressure housing, basic propulsion, control system
- Simulate/model deep operation vs. expensive sea trials

---

## References

1. Blue Robotics Product Catalog, 2024-2025
2. Fossen, T.I. "Handbook of Marine Craft Hydrodynamics and Motion Control", Wiley, 2011
3. Antonelli, G. "Underwater Robots", Springer Tracts in Advanced Robotics, 2014
4. Department of Energy, "Powering the Blue Economy: Exploring Opportunities for Marine Renewable Energy", 2019
5. ASME Boiler and Pressure Vessel Code, Section VIII, Division 1
6. Underwater Acoustics: Analysis, Design and Performance of Sonar, Richard P. Hodges
7. L3Harris Iver3 AUV Specifications
8. Boxfish Robotics Product Documentation
9. ecoSUB m-Power+ Datasheet, Oceanscience Group
10. Nortek DVL1000 Technical Manual
11. EvoLogics Acoustic Modem Specifications
12. Various component datasheets from manufacturers

---

**End of Technical Feasibility Study**

**Report prepared by:**  
Jerry Liu (yhl63) & Zihe Liu (zl559)  
Department of Engineering  
University of Cambridge  
November 2025
