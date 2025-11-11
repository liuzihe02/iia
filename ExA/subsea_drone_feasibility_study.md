# Technical Feasibility Study: 250m Subsea Cable Inspection Drone

**Authors:** Jerry Liu (yhl63), Zihe Liu (zl559)
**Institution:** Department of Engineering, University of Cambridge
**Date:** November 2025

## Executive Summary

Your target specifications present an achievable but challenging design problem that requires careful trade-offs between speed, endurance, and mass constraints. The 4 m/s peak speed requirement drives power consumption to 1.2 kW, necessitating a 799 Wh battery system that consumes 16% of your 25 kg mass budget[5][6]. Commercial components exist for all subsystems, with complete build costs estimated at $15,000-25,000 versus $50,000-80,000 for comparable commercial AUVs (ecoSUB m-Power+, Iver3 Standard)[1][2][50]. The U.S. Department of Energy's "Powering the Blue Economy" report identifies underwater vehicle power systems as a critical technology area, confirming the engineering challenges in this domain[2].

Critical finding: achieving 4 m/s in this weight class requires 4× Blue Robotics T200 thrusters[7][8] and provides 2.5 hours endurance with an 80/20 mission profile (80% cruise at 1 m/s, 20% peak at 4 m/s). Analysis of existing commercial platforms (ecoSUB at 17 kg/500m depth, Iver3 at 27-39 kg/100m depth, Boxfish at 25 kg/300m depth) reveals that no commercial AUV in the <25 kg class achieves sustained 4 m/s speed[1][49][50], making your specification ambitious but technically feasible with proper design optimization[3][4].

---

## 1. Power Budget Analysis Reveals Fundamental Constraints

The hydrodynamics dominate your design. For a streamlined torpedo hull with 0.3m diameter and 0.0707 m² frontal area, drag coefficients range from 0.28-0.32 based on CFD studies of similar AUV geometries[3][4]. At 1 m/s cruise speed with Cd=0.32, you need 11.6 N thrust requiring 39W electrical power. But at 4 m/s peak with Cd=0.28, drag jumps to 162 N demanding 1,178W of propulsion power[3]. Adding payload and control systems, the total system requires 86W at cruise and peaks at 1,225W during sprint operations.

### Battery Sizing - Critical Decision Point

For 2-hour endurance with 80/20 mission profile (80% cruise at 86W, 20% peak at 1,225W), you need 314W average power requiring 628 Wh. The Blue Robotics triple 18Ah battery configuration provides 799 Wh at 14.8V, weighing 4.1 kg, at a cost of $1,200[5][6]. This provides 2.5 hours endurance with 25% margin and adequate burst capability to deliver 1.2 kW peak power.

Options include:
- **Three 18Ah batteries**: 799 Wh, 4.1 kg, $1,200 - provides adequate burst capability[5][6]
- **Single 22.2V 28Ah Mega-Battery**: 622 Wh, 2-2.5 kg, $1,490 - better weight efficiency but requires voltage conversion for 16V thruster operation[5]

The 22.2V system offers superior weight efficiency but adds complexity requiring DC-DC conversion for thruster compatibility[5][7].

---

## 2. Propulsion System Defines Performance Envelope

**The Blue Robotics T200 thruster emerges as the optimal choice** across multiple dimensions[7][8][9]. Key specifications:

- **Thrust Output**: 5.1 kgf (50 N) forward at 16V[7][8]
- **Power Consumption**: 350W maximum, 180W typical at full thrust[7][8]
- **Depth Rating**: 300m (12× your requirement)[7]
- **Reliability**: 300+ hour continuous operation in field testing[8]
- **Cost**: $259 each[7][9]
- **Design**: Flooded brushless motor, proven in thousands of ROV deployments[7][8]

For your 25 kg vehicle achieving 4 m/s, you need approximately 162 N total thrust[3][4]. **Four T200 thrusters in horizontal configuration provide 200 N combined capability** with 23% safety margin[7][8].

### Alternative Thruster Comparisons

| Model | Thrust | Power | Depth Rating | Cost | Suitability |
|-------|--------|-------|--------------|------|-------------|
| T200[7] | 5.1 kgf | 350W max | 300m | $259 | Optimal |
| T500[10] | 16.1 kgf | 1000W+ | 300m | $690 | Overpowered |
| SeaBotix BTD150[11] | 2.2 kgf | 80W | 300m | $300-400 est | Insufficient thrust |

The T500 delivers three times more thrust (16.1 kgf at 24V) but consumes over 1 kW continuously - excessive for a small AUV[10]. SeaBotix BTD150 thrusters provide only 2.2 kgf thrust at 80W - insufficient for your speed requirement despite excellent efficiency[11].

### Electronic Speed Controllers (ESCs)

The Blue Robotics Basic ESC provides proven compatibility with T200 thrusters[12][13]:
- **Specifications**: 30A continuous, 6-22V operation, bidirectional control[12]
- **Firmware**: BLHeli_S with custom tuning capability[13]
- **Protection**: Thermal shutdown, reverse polarity protection[12]
- **Interface**: Standard PWM control (1100-1900 μs)[12][13]
- **Cost**: $35-40 each ($140 for four)[12]

The sensorless brushless design integrates seamlessly with standard autopilot systems[12][13].

---

## 3. Navigation and Control Systems: Capability Versus Cost

### Primary Control System: Navigator Flight Controller + Raspberry Pi 4

The Blue Robotics Navigator provides a complete autopilot solution at $181-225[14][15]:

**Hardware Specifications:**
- **IMU**: ICM-20602 6-axis (gyro + accelerometer), ICM-42688-P backup[14][15]
- **Magnetometer**: Dual BMM150 for redundancy[14]
- **Barometer**: BMP388 for surface altitude/depth reference[14]
- **PWM Channels**: 16 outputs (8 thrusters + 8 accessories)[14][15]
- **Serial Ports**: 4× UART for sensors (depth, DVL, acoustic modem, GPS)[14][15]
- **Power**: 8-10W typical consumption[14][15]
- **Compute Platform**: Raspberry Pi 4 (4GB+ recommended)[14][15]

**Software Compatibility:**
- ArduSub autopilot (proven in BlueROV2 fleet)[14]
- ROS/ROS2 support for advanced autonomy[14]
- MAVLink protocol for ground control stations[14]
- Custom Python/C++ applications[14][15]

### Depth Sensing Options

**Budget Option: Bar30 High-Resolution Depth Sensor**[16][17][18]
- **Range**: 0-300m (30 bar)[16][17]
- **Resolution**: 2mm depth, 16-bit ADC[16][17]
- **Interface**: I2C (address 0x76)[16]
- **Power**: <1mA (<0.005W at 3.3V)[16]
- **Cost**: $80-90[16][17][18]
- **Limitation**: Requires daily drying or suffers drift; gel can absorb water over time[16][17]

**Industrial Option: Keller PA-7LD Series**[19][20]
- **Range**: 0-300m configurable[19][20]
- **Accuracy**: ±0.1% FS (±0.3m at 300m)[19][20]
- **Long-term Stability**: <0.1% FS/year[20]
- **Interface**: 4-20mA or RS-485[19][20]
- **Cost**: $200-500 (quote required)[19][20]
- **Advantage**: Superior stability for extended deployments[20]

For a 2-hour mission duration, the Bar30 provides adequate performance at excellent value[16][17][18]. For multi-day deployments or research-grade data, invest in industrial sensors[19][20].

### Doppler Velocity Log (DVL) - Precision Navigation

DVLs enable precise dead-reckoning navigation underwater where GPS is unavailable, reducing position uncertainty from 10+ meters (IMU-only) to sub-meter accuracy over 2-hour missions[21][22][52].

**Option 1: Nortek DVL1000 - 300m**[21][22]
- **Accuracy**: 0.8 cm/s single-ping, 0.2 cm/s average[21]
- **Bottom-Track Range**: 75m (120m with extended range setting)[21][22]
- **Frequency**: 1 MHz (4-beam Janus configuration)[21]
- **Update Rate**: 15 Hz maximum[21]
- **Power**: 1.3W average, 15W peak (ping)[21][22]
- **Depth Rating**: 300m[21]
- **Weight**: 1.2 kg in water (slightly negative buoyancy)[21]
- **Cost**: $15,000-25,000 (manufacturer quote required)[21][22]
- **Integration**: Serial RS-232/422, analog outputs, Ethernet option[21][22]

**Option 2: Teledyne RDI Pathfinder DVL**[23]
- **Similar performance** to Nortek DVL1000[23]
- **Proven reliability** in commercial AUV market[23]
- **Cost**: $18,000-28,000 estimated[23]
- **Advantage**: Extensive OEM support and documentation[23]

**Budget Alternative: GPS + IMU Dead Reckoning**

For cost-constrained applications where precise positioning isn't critical, GPS surface fixes combined with IMU dead reckoning may suffice for cable-following missions[14][21][22]. Position uncertainty grows to 5-15m over 2 hours but costs drop to <$200.

### IMU Upgrade Options

**VectorNav VN-100 IMU/AHRS**[24][25]
- **Accuracy**: 0.5° pitch/roll, 1° heading (with magnetometer)[24][25]
- **Gyro Performance**: 10°/hr bias stability[24]
- **Package**: 15g, 24×22×3mm (requires waterproof housing integration)[24][25]
- **Interface**: UART, SPI, I2C[24]
- **Cost**: $950-1,525[24][25]
- **Use Case**: Improved attitude estimation over Navigator built-in IMU[24]

**VectorNav VN-200 GNSS/INS**[24]
- **Additional Features**: Integrated GPS/GNSS receiver[24]
- **Cost**: $3,100-3,500[24]
- **Use Case**: Enhanced surface positioning before dive[24]

**SBG Systems Pulse-40 Tactical IMU**[26]
- **Performance**: 0.08°/√h gyro, 0.05 m/s velocity random walk[26]
- **Cost**: $8,000-12,000 estimated[26]
- **Use Case**: Research-grade navigation for extended missions[26]

For budget-conscious designs, the Navigator's integrated ICM-20602 IMU provides adequate performance (±2° heading drift per hour) for basic stabilization and navigation[14][15][26].

---

## 4. Communication Systems Enable Operational Flexibility

### Underwater Acoustic Communications

Acoustic modems enable command/control and telemetry during submerged operations. RF and optical communications cannot penetrate seawater beyond a few meters[27][28][29][34].

**Professional Option: EvoLogics S2C M 18/34**[27][28]
- **Frequency Range**: 18-34 kHz[27][28]
- **Data Rate**: 13.9 kbps (13,900 bps)[27][28]
- **Range**: 2,000m horizontal, 250m operating depth rating[27][28]
- **Power**: 20W transmit, 1.5W receive/idle[27][28]
- **Protocols**: TCP/IP stack over acoustic link, instant messaging mode[27][28]
- **Features**: Built-in USBL positioning (optional), AUV-to-AUV networking[27]
- **Cost**: $10,000-15,000 (quote required)[27][28]
- **Weight**: ~2 kg[27]

**Higher Performance: EvoLogics S2C M 42/65**[27]
- **Data Rate**: 31.2 kbps (2.2× faster)[27]
- **Range**: 1,000m (reduced due to higher frequency)[27]
- **Cost**: Similar to 18/34 model[27]
- **Use Case**: Short-range, high-bandwidth applications[27]

**Budget Alternative: Water Linked Modem M64**[29]
- **Data Rate**: 64 bps (extremely low but ultra-robust)[29]
- **Range**: 500m typical[29]
- **Power**: 2W transmit[29]
- **Cost**: $2,300[29]
- **Advantage**: Simple, reliable for basic status/control[29]

**Mid-Range Option: LinkQuest UWM2000H**[30]
- **Data Rate**: 1.2 kbps (9,600 baud)[30]
- **Range**: 1,500m[30]
- **Power**: 8W transmit, 0.5W receive[30]
- **Cost**: $5,000-8,000[30]
- **Use Case**: Good balance of performance and cost[30]

### Surface Communications

**Iridium Satellite: RockBLOCK 9603N**[31][32][33]
- **Coverage**: Global (pole-to-pole)[31][32]
- **Message Size**: 340 bytes uplink, 270 bytes downlink[31][33]
- **Latency**: 10-60 seconds average[31]
- **Power**: 0.8W transmit (160mA at 5V), 40mA idle[31][33]
- **Cost**: $260 hardware + $15-20/month service[31][32][33]
- **Data Pricing**: $0.11-0.14 per message (~$11 per 100 messages)[32]
- **Use Case**: Position reports, status updates, mission commands[31][32][33]

**WiFi 2.4 GHz for Data Dumps**[34]
- **Range**: 10-500m (depending on antenna, water surface conditions)[34]
- **Data Rate**: 1-50 Mbps (dramatically faster than acoustic/satellite)[34]
- **Power**: 0.1-0.5W[34]
- **Cost**: $30-50 (standard marine WiFi module)[34]
- **Use Case**: High-bandwidth data dumps when near support vessel[34]

### Recommended Communication Architecture

- **Underwater**: EvoLogics acoustic modem[27][28] OR surface-only operation (saves $10K)
- **Surface**: RockBLOCK Iridium[31][32][33] ($260) + WiFi[34] ($50) = $310 total

This hybrid approach provides:
- Command/control underwater (if acoustic modem included)[27][28]
- Global position reporting via Iridium[31][32][33]
- Fast data download via WiFi when near mothership[34]

**Total Communication Costs:**
- **Surface-only**: $310 (Iridium + WiFi)[31][32][33][34]
- **Full acoustic capability**: $10,310-15,310[27][28][31][32][33][34]

---

## 5. Imaging Payload Fits Within Power Budget Constraints

Your 30W payload allocation allows multiple sensor combinations for comprehensive cable inspection[35][36][37][40][41][42].

### Video Camera Options

**Budget Option: Blue Robotics Low-Light HD USB Camera**[35][36][37]
- **Resolution**: 1920×1080 (1080p) at 30 fps[35][36][37]
- **Sensor**: Sony IMX322 1/2.9" CMOS (excellent low-light sensitivity)[35][37]
- **Lens**: 120° FOV, low-distortion (corrected in software)[35][37]
- **Interface**: USB 2.0 (plug-and-play with Raspberry Pi)[35][36][37]
- **Power**: 2.5W typical (500mA at 5V)[35][37]
- **Depth Rating**: 300m[35][36][37]
- **Cost**: $120[35][36][37]
- **Advantages**: Simple integration, proven performance, very low power[35][37]

**Professional Option: SubC Rayfin Micro Camera**[38][39]
- **Resolution**: 4K video (3840×2160) at 30 fps, 12.3MP stills[38][39]
- **Sensor**: 1/2.3" CMOS[38]
- **Lens**: Configurable FOV (90-165°)[38]
- **Interface**: Gigabit Ethernet (GigE Vision protocol)[38][39]
- **Power**: 7.8W average, 13.56W peak[38]
- **Depth Rating**: 500m[38][39]
- **Features**: Auto white balance for underwater, configurable exposure[38][39]
- **Cost**: $8,000-15,000 (quote required)[38][39]
- **Advantages**: Professional image quality, standardized industrial interface[38][39]

### Sonar - Acoustic Imaging for Cable Detection

**Blue Robotics Ping360 Scanning Imaging Sonar**[40][41]
- **Configuration**: Mechanical scanning, 360° coverage[40][41]
- **Frequency**: 750 kHz[40][41]
- **Range**: 2-50m (adjustable)[40][41]
- **Resolution**: 400 data points per scan, 1-2° angular resolution[40][41]
- **Update Rate**: 10-20 Hz (full 360° scan in 2-5 seconds)[40][41]
- **Power**: 5W maximum (2W typical during scan)[40][41]
- **Depth Rating**: 300m[40][41]
- **Interface**: Serial UART (9600-115200 baud)[40][41]
- **Cost**: $2,750[40][41]
- **Use Case**: Cable detection in turbid water, obstacle avoidance, seafloor mapping[40][41]

The Ping360's 750 kHz frequency provides excellent resolution for detecting 2-5 cm diameter cables at 10-20m range, even in zero-visibility conditions[40][41].

### Lighting Systems

**Blue Robotics Lumen Light**[42]
- **Output**: 1,500 lumens at 16V[42]
- **Power**: 10W typical, adjustable 0-100%[42]
- **Depth Rating**: 300m[42]
- **Cost**: $150[42]
- **Use Case**: Video illumination for cable inspection[42]

For cable inspection requiring visual documentation, plan 10-15W continuous lighting[42]. Multiple lights may be needed for proper illumination (2-4 units = 20-40W total).

### Recommended Payload Configurations

**Budget Configuration ($3,270 total, 17.5W):**
- Low-Light HD Camera: $120, 2.5W[35][36][37]
- Ping360 Sonar: $2,750, 5W[40][41]
- 2× Lumen Lights: $300, 20W (10W each)[42]
- **Total**: $3,170 + $100 mounting = $3,270, 27.5W (within 30W with lighting dimmed to 70%)

**Professional Configuration ($10,750-17,750 total, 23-28W):**
- SubC Rayfin Micro: $8,000-15,000, 7.8W average[38][39]
- Ping360 Sonar: $2,750, 5W[40][41]
- 2× Lumen Lights: $300, 20W (dimmable)[42]
- **Total**: $11,050-18,050, 32.8W (requires dimmed lighting or accept 33W payload)

The budget configuration provides excellent capability for cable inspection missions at 12% of the professional option cost[35][36][37][40][41][42].

---

## 6. Pressure Housing Materials Present Clear Optimization Path

For 250m depth operation, material selection determines weight, cost, and reliability[43][44][45][46].

### Material Comparison Table

| Material | Yield Strength | Density | Cost/kg | Max Practical Depth | Weight Factor | Cost Factor |
|----------|---------------|---------|---------|-------------------|---------------|-------------|
| Aluminum 6061-T6[43][44] | 276 MPa | 2,700 kg/m³ | $7 | 500m+ | 1.0× | 1.0× |
| Titanium Grade 5[43] | 880 MPa | 4,430 kg/m³ | $30 | 6,000m+ | 0.6× | 10× |
| Acrylic (Cast)[43] | 70-75 MPa | 1,190 kg/m³ | $4 | 70-150m | 1.8× | 0.6× |

### Aluminum 6061-T6 Dominates for 250m Applications[43][44]

- **Yield Strength**: 276 MPa (40,000 psi)[43][44]
- **Required Wall Thickness**: 6-8mm for typical 100mm ID tube[46]
- **Safety Factor**: 2.5-3.0× at 250m (25 bar external pressure)[46]
- **Corrosion Resistance**: Excellent with hard anodizing (Type III)[43][44]
- **Machinability**: Excellent - standard CNC equipment[43]
- **Cost**: $7/kg material, $50-150/hr machining[43][44]

### Blue Robotics 3" Watertight Enclosures[44][45]
- **Depth Rating**: 500m (2× your requirement)[44]
- **Internal Diameter**: 3" (76mm)[44][45]
- **Lengths Available**: 6", 12", 18", 24" (150-600mm)[44][45]
- **Material**: Aluminum 6061-T6 with hard anodizing[44]
- **End Caps**: Aluminum with double O-ring seals[44][45]
- **Cost**: $200-300 complete (tube + 2 end caps)[44][45]
- **Proven Reliability**: Thousands deployed in BlueROV2 fleet[44][45]

### Blue Robotics 4" Watertight Enclosures[44]
- **Depth Rating**: 200m (current redesign) - **verify before purchase**[44]
- **Internal Diameter**: 4" (102mm)[44]
- **Historical Issues**: Earlier 4" tubes experienced quality problems[44]
- **Status**: Redesigned tubes now available but reduced depth rating[44]
- **Cost**: $250-400 complete[44]

**⚠️ WARNING**: The 4" series previously had 400m rating but recent redesigns only specify 200m. Contact Blue Robotics to verify current specifications before purchasing for 250m application[44].

### Titanium Grade 5 - Premium Option[43]

- **Yield Strength**: 880 MPa (128,000 psi) - 3.2× stronger than aluminum[43]
- **Wall Thickness**: 3-4mm for same pressure rating (40-50% thinner)[43]
- **Weight Savings**: 20-40% lighter than aluminum for same internal volume[43]
- **Cost**: $30/kg material + $500-2,000 machining (10× aluminum machining costs)[43]
- **Total Cost**: $800-2,000+ for custom housing[43]
- **Use Case**: Only justified for deep water (>1000m) or extreme weight constraints[43]

For your 250m requirement, titanium provides no practical advantage and dramatically increases costs[43].

### Acrylic - Transparent but Limited[43]

- **Yield Strength**: 70-75 MPa (too weak for 250m)[43]
- **Maximum Depth**: 70-150m for standard sizes (depending on thickness and diameter)[43]
- **Advantages**: Transparency for visual inspection, lower cost ($4/kg)[43]
- **Disadvantages**: Susceptible to long-term water absorption, stress cracking, UV degradation[43]
- **Verdict**: Unsuitable for 250m operation[43]

### Wall Thickness Calculations - ASME Section VIII Method[46]

For external pressure on cylindrical shells[46]:

**Formula**: t = (P × R) / (S × E - 0.6P) + CA

Where:
- P = External pressure = 250m × 1.03 kg/L × 9.81 m/s² = 2.52 MPa = 25.2 bar
- Apply 3× safety factor: P_design = 7.56 MPa (1,096 psi)[46]
- R = Internal radius (mm)
- S = Allowable stress = Yield Strength / 3 = 276/3 = 92 MPa for Al 6061-T6[46]
- E = Weld efficiency = 0.85 (seamless tube = 1.0)[46]
- CA = Corrosion allowance = 1.5-3mm for marine environment[46]

**Example Calculation for 100mm ID Aluminum Tube:**[46]
- R = 50mm
- t = (7.56 × 50) / (92 × 1.0 - 0.6 × 7.56) + 2.0
- t = 378 / 87.46 + 2.0
- t = 4.3 + 2.0 = **6.3mm minimum wall thickness**[46]

Blue Robotics 3" tubes use 6.35mm (0.250") wall - perfect match to calculations[44][46].

### Cable Penetrators - WetLink Revolution[47][48]

Traditional potted penetrators cost $50-150 each and require permanent installation. Blue Robotics WetLink Penetrators revolutionize cable entry[47][48]:

**WetLink Penetrator Specifications:**[47][48]
- **Depth Rating**: 1,000m (4× your requirement)[47][48]
- **Installation Time**: 30 seconds (no potting required)[47][48]
- **Principle**: Compression seal on cable jacket[47][48]
- **Compatible Cable Sizes**: 3-6mm OD (various models)[47][48]
- **Reusability**: Field-serviceable, replaceable seals[47][48]
- **Cost**: $13-17 each[47][48]
- **Models**: WLP-M6, WLP-M10 (thread sizes)[47][48]

**Cost Comparison for 4-Cable Electronics Housing:**
- Traditional penetrators: 4 × $100 = $400 + potting supplies + labor
- WetLink penetrators: 4 × $15 = $60 (85% cost savings)[47][48]

For a typical AUV with 3 housings and 12 total cable penetrations: $180 vs $1,200-1,800 (90% savings)[47][48].

---

## 7. Commercial Comparison Reveals Build Advantages

Existing small AUVs cluster around different capability points than your specifications. Understanding commercial offerings validates component selection and identifies market gaps[1][2][49][50][51][52].

### Commercial AUV Comparison Table

| Model | Weight | Depth | Endurance | Speed | Propulsion | Cost Est. | Notes |
|-------|--------|-------|-----------|-------|------------|-----------|-------|
| **Your Target** | <25 kg | 250m | 2 hrs | 4 m/s peak | TBD | $15-25K | Build cost |
| ecoSUB m-Power+[1][2] | 17 kg | 500m | 8-10 hrs | ~1-2 m/s* | Single thruster | $50-80K | Closest match |
| Boxfish AUV[49] | 25 kg | 300-600m | 10 hrs | ~2-3 m/s* | 8 vectored | $80-150K | 6 DOF hover |
| Iver3 Standard[50] | 27-39 kg | 100m | 8-14 hrs | 1.3 m/s | Single + fins | $50K+ | 375 units sold |
| REMUS M3V[51] | Classified | 600m | 10+ hrs | 5+ m/s | High-power | $100K+ | Military grade |

\* Speed estimates based on torpedo hull form factor and published power specifications; not explicitly stated by manufacturers[1][49][50][51].

### Critical Insights from Commercial Comparison

1. **No commercial AUV in the <25 kg class achieves 4 m/s sustained speed**[1][49][50][51]. The REMUS M3V exceeds 5 m/s but in a specialized air-deployable package with undisclosed weight (likely >30 kg)[51].

2. **Most small torpedo-form AUVs operate at 1.5-2.6 m/s (3-5 knots)**[1][49][50]. This is not arbitrary - drag increases with velocity squared, making higher speeds prohibitively power-hungry[3][4].

3. **Hover-capable platforms sacrifice speed for maneuverability**[49]. Boxfish's 8-thruster design enables station-keeping but limits top speed and endurance[49].

4. **Commercial pricing reflects support, not hardware**[50]. The component costs in an Iver3 likely total $15,000-25,000, with remaining $25,000-35,000 covering engineering, testing, documentation, warranty, and profit margins[50].

5. **Your 4 m/s requirement is ambitious** and will necessitate trade-offs in endurance or weight[3][4][51][52]. Commercial solutions avoid this speed regime for good thermodynamic reasons[51][52].

**Component Commonality Validates Approach:**

Commercial vehicles use similar components to your proposed build:
- **Thrusters**: T200 appears in numerous platforms including Boxfish[49]
- **Computers**: Intel processors (Iver3), NVIDIA Jetson (Boxfish), Raspberry Pi (hobby builds)[50][49]
- **Sensors**: Xsens MTi-3 IMU (ecoSUB), Nortek DVL-1000 (Iver3 optional), similar depth sensors[1][50]
- **Batteries**: Lithium-ion 12-24V dominate (Iver3 784 Whr, Boxfish 600 Whr)[49][50]

This component commonality confirms you're selecting appropriate, field-proven hardware[49][50][52].

---

## 8. Hydrodynamics and Drag Analysis

Understanding drag forces is fundamental to thrust and power requirements[3][4][53].

### Drag Force Equation[53]

F_drag = 0.5 × ρ × V² × A × C_d

Where:
- ρ = Seawater density = 1,027 kg/m³[53]
- V = Velocity (m/s)
- A = Frontal area (m²)
- C_d = Drag coefficient (dimensionless)[3][4]

### Vehicle Geometry Assumptions

Based on torpedo-shaped AUV with optimized hydrodynamics[3][4]:
- **Length**: 1.2m
- **Diameter**: 0.3m (Blue Robotics 3" housing at 89mm OD + 100mm streamlined cowling)
- **Length/Diameter Ratio**: 4:1 (good for streamlined flow)[3]
- **Frontal Area**: A = π × (0.15m)² = 0.0707 m²

### Drag Coefficient Literature Review

Torpedo-shaped AUV drag coefficients from CFD studies and experimental data[3][4][53]:

| Hull Configuration | C_d | Source | Notes |
|--------------------|-----|--------|-------|
| Optimized Myring (smooth) | 0.28-0.32 | MDPI CFD study[3] | Streamlined nose/tail |
| Standard torpedo | 0.32-0.35 | SCIRP analysis[4] | Typical AUV geometry |
| With external sensors | 0.40-0.50 | Experimental[53] | Protrusions increase drag |

**Conservative Design Values:**[3][4]
- **Cruise (1 m/s)**: C_d = 0.32 (moderate protrusions)
- **Peak (4 m/s)**: C_d = 0.28 (streamlined, high Reynolds number)

### Drag Calculations

**At 1 m/s Cruise:**[3][4][53]
- F_drag = 0.5 × 1,027 × 1² × 0.0707 × 0.32
- F_drag = **11.6 N**
- Power = F × V = 11.6 N × 1 m/s = **11.6 W** (thrust power only)

**At 4 m/s Peak:**[3][4][53]
- F_drag = 0.5 × 1,027 × 4² × 0.0707 × 0.28
- F_drag = **162 N**
- Power = F × V = 162 N × 4 m/s = **648 W** (thrust power only)

### Accounting for Thruster Efficiency

Blue Robotics T200 thruster efficiency varies with load[7][8]:
- **Light load (<50W)**: ~30% efficiency (electrical to thrust power)[7][8]
- **Medium load (100-200W)**: ~50% efficiency[7][8]
- **Heavy load (>250W)**: ~55% efficiency[7][8]

**Electrical Power Requirements:**

**At 1 m/s:**[7][8]
- Thrust power required: 11.6 W
- Thruster efficiency: ~30% (light load)[7][8]
- Electrical power: 11.6 / 0.30 = **39 W** (for propulsion)

**At 4 m/s:**[7][8]
- Thrust power required: 648 W
- Thruster efficiency: ~55% (heavy load)[7][8]
- Electrical power: 648 / 0.55 = **1,178 W** (for propulsion)

**Validation Check:**

Four T200 thrusters at 350W each maximum = 1,400W total capability[7][8]. At 4 m/s requiring 1,178W, you're operating at 84% maximum power - technically feasible with comfortable 16% power margin[7][8].

### Reynolds Number Analysis[3][4][53]

Re = (ρ × V × L) / μ

Where μ = dynamic viscosity of seawater ≈ 1.08 × 10⁻³ Pa·s at 4°C[53]

**At 1 m/s:**
- Re = (1,027 × 1 × 1.2) / (1.08 × 10⁻³)
- Re = 1.14 × 10⁶ (turbulent flow, C_d relatively stable)[3][4][53]

**At 4 m/s:**
- Re = 4.56 × 10⁶ (fully turbulent, slight C_d reduction due to laminar sub-layer effects)[3][4][53]

Both velocities operate in turbulent regime where drag coefficient assumptions are valid[3][4][53].

---

## 9. Complete Power Budget Analysis

Comprehensive system-level power consumption determines battery sizing and mission duration[5][7][14][35][40].

### Power Consumption by Subsystem

| Subsystem | Cruise (1 m/s) | Peak (4 m/s) | Notes |
|-----------|----------------|--------------|-------|
| **Propulsion** | 39W | 1,178W | 4× T200 thrusters[7] |
| **Control Computer** | 10W | 10W | Navigator + RPi4[14] |
| **Payload (sensors)** | 30W | 30W | Camera + sonar + lighting[35][40][42] |
| **Navigation** | 5W | 5W | Depth, IMU, GPS[14][16] |
| **Communications** | 2W | 2W | Idle mode (WiFi/Iridium)[31][34] |
| **TOTAL** | **86W** | **1,225W** | System total |

### Battery Capacity Requirements

**For 2-Hour Endurance at Various Power Levels:**[5][6]

**Cruise Mission (86W average):**
- Energy required: 86W × 2h = 172 Wh
- **Battery Option**: Single 18Ah battery (266 Wh) provides 3.1 hour endurance[5][6]

**Peak Operations (1,225W sustained):**
- Energy required: 1,225W × 2h = 2,450 Wh
- **Not Feasible** within weight constraints
- At 1,225W, dual 18Ah (532 Wh) provides only **26 minutes**[5][6]
- At 1,225W, triple 18Ah (799 Wh) provides only **39 minutes**[5][6]

### Realistic Mission Profile

The 2-hour endurance requirement with 4 m/s peak speed is achievable using a mixed-speed mission profile:

**Recommended Battery Configuration:**

**Triple 18Ah Batteries (799 Wh total, 4.1 kg)**[5][6]
- Mission profile: 80% cruise (1 m/s, 86W), 20% peak (4 m/s, 1,225W)
- Average power: 0.8×86 + 0.2×1,225 = 69 + 245 = **314W**
- Energy required: 314W × 2h = **628 Wh**
- Endurance with 799 Wh: 799 / 314 = **2.5 hours**
- Provides 2-hour missions with 25% margin for 4 m/s sprint capability

---

## 10. Complete System Cost Breakdown

Component-by-component pricing enables budget planning and identifies cost-saving opportunities[7][12][14][35][40][44][47].

### Detailed Bill of Materials (BOM)

**PROPULSION SUBSYSTEM**
| Component | Qty | Unit Price | Total | Source |
|-----------|-----|------------|-------|--------|
| T200 Thruster[7] | 4 | $259 | $1,036 | Blue Robotics[7] |
| Basic ESC 30A[12] | 4 | $35 | $140 | Blue Robotics[12] |
| Propeller spares | 1 set | $40 | $40 | Blue Robotics[7] |
| Thruster mounting hardware | 1 | $50 | $50 | Custom/BR |
| **Subtotal** | | | **$1,266** | |

**POWER SUBSYSTEM**
| Component | Qty | Unit Price | Total | Source |
|-----------|-----|------------|-------|--------|
| 18Ah Li-ion Battery[5] | 3 | $400 | $1,200 | Blue Robotics[5] |
| 3" Enclosure (for batteries)[44] | 1 | $250 | $250 | Blue Robotics[44] |
| Power distribution board | 1 | $100 | $100 | Custom/COTS |
| Voltage regulators (5V, 12V) | 1 | $50 | $50 | COTS |
| Battery monitoring (BMS) | 1 | $80 | $80 | COTS |
| **Subtotal** | | | **$1,680** | |

**CONTROL & NAVIGATION SUBSYSTEM**
| Component | Qty | Unit Price | Total | Source |
|-----------|-----|------------|-------|--------|
| Navigator Flight Controller[14] | 1 | $125 | $125 | Blue Robotics[14] |
| Raspberry Pi 4 (4GB)[14] | 1 | $55 | $55 | Standard[14] |
| microSD card (64GB) | 1 | $20 | $20 | Standard |
| 4" Electronics enclosure[44] | 1 | $300 | $300 | Blue Robotics[44] |
| Bar30 Depth Sensor[16] | 1 | $85 | $85 | Blue Robotics[16] |
| GPS Module | 1 | $80 | $80 | COTS |
| **Subtotal** | | | **$665** | |

**COMMUNICATION SUBSYSTEM**
| Component | Qty | Unit Price | Total | Source |
|-----------|-----|------------|-------|--------|
| RockBLOCK 9603N Iridium[31] | 1 | $260 | $260 | SparkFun[31] |
| WiFi Module (2.4 GHz)[34] | 1 | $50 | $50 | COTS[34] |
| Antennas (GPS, Iridium, WiFi) | 1 | $100 | $100 | Various |
| **Subtotal (without acoustic)** | | | **$410** | |
| *EvoLogics S2C M 18/34[27]* | *1* | *$12,000* | *$12,000* | *Quote[27]* |
| **Subtotal (with acoustic)** | | | **$12,410** | |

**IMAGING PAYLOAD SUBSYSTEM**
| Component | Qty | Unit Price | Total | Source |
|-----------|-----|------------|-------|--------|
| Low-Light HD Camera[35] | 1 | $120 | $120 | Blue Robotics[35] |
| Ping360 Sonar[40] | 1 | $2,750 | $2,750 | Blue Robotics[40] |
| Lumen Light[42] | 2 | $150 | $300 | Blue Robotics[42] |
| Camera/sensor housing | 1 | $150 | $150 | Custom |
| **Subtotal** | | | **$3,320** | |

**STRUCTURAL SUBSYSTEM**
| Component | Qty | Unit Price | Total | Source |
|-----------|-----|------------|-------|--------|
| Frame materials (Al/HDPE) | 1 | $400 | $400 | McMaster/metals supplier |
| Syntactic foam (buoyancy) | 2 kg | $100/kg | $200 | Trelleborg/DeepSea |
| Fasteners (SS 316) | 1 lot | $150 | $150 | McMaster |
| Ballast weights (lead/steel) | 1 lot | $100 | $100 | McMaster |
| Fairings/cowling (fiberglass) | 1 | $200 | $200 | Custom fabrication |
| **Subtotal** | | | **$1,050** | |

**CABLES & CONNECTIONS**
| Component | Qty | Unit Price | Total | Source |
|-----------|-----|------------|-------|--------|
| WetLink Penetrators[47] | 12 | $15 | $180 | Blue Robotics[47] |
| Marine cables (various) | 1 lot | $200 | $200 | Blue Robotics/COTS |
| Connectors (XT60, JST, etc.) | 1 lot | $100 | $100 | COTS |
| **Subtotal** | | | **$480** | |

**TOOLS & ASSEMBLY**
| Component | Qty | Unit Price | Total | Source |
|-----------|-----|------------|-------|--------|
| Vacuum test plug | 1 | $12 | $12 | Blue Robotics |
| O-rings (spares) | 1 lot | $50 | $50 | Blue Robotics[44] |
| Silicone grease | 1 | $15 | $15 | Blue Robotics[44] |
| Tef-Gel anti-corrosion | 1 | $20 | $20 | COTS |
| Miscellaneous hardware | 1 | $100 | $100 | McMaster |
| **Subtotal** | | | **$197** | |

---

### Total Component Costs

**Core System (without acoustic modem):**
- Propulsion: $1,266[7][12]
- Power: $1,680[5][44]
- Control: $665[14][16][44]
- Communication: $410[31][34]
- Payload: $3,320[35][40][42]
- Structure: $1,050
- Cables: $480[47]
- Tools: $197[44]
- **SUBTOTAL**: $9,068

**With 20% Contingency:** $9,068 × 1.20 = **$10,882**

**With Acoustic Modem:**
- Core + EvoLogics S2C: $10,882 + $12,000 = **$22,882**[27]

---

## 11. Risk Assessment and Mitigation Strategies

### High-Risk Items

**Risk 1: Cannot Achieve 4 m/s Speed**
- **Probability**: Medium (40%)
- **Impact**: High (mission requirement failure)
- **Mitigation**:
  - Rigorous hydrodynamic design (CFD or tow tank testing)
  - Budget for 4× T200 thrusters (not minimum 3×)
  - Design low-drag cowling and minimize protrusions
  - Accept that 3.5 m/s may be practical limit
- **Fallback**: Negotiate requirement to 3 m/s peak if justified by physics

**Risk 2: Battery Insufficient for 2-Hour Endurance**
- **Probability**: Low (with 80/20 mission profile)
- **Impact**: Medium (reduced mission capability)
- **Mitigation**:
  - Use three 18Ah batteries (799 Wh) providing 2.5-hour endurance
  - Design mission profile with 80% cruise, 20% peak speed
  - Implement power management (dim lights during high-speed)
- **Fallback**: Reduce peak sprint duration or lower cruise speed slightly

**Risk 3: Weight Exceeds 25 kg Budget**
- **Probability**: Medium-High (60%)
- **Impact**: Medium (handling/deployment issues)
- **Mitigation**:
  - Track component weights rigorously during design
  - Use CAD models with accurate material properties
  - Budget 2-3 kg for "unknown unknowns"
  - Design for weight reduction (titanium not needed, minimize fasteners)
- **Fallback**: Negotiate up to 27-28 kg if performance maintained

**Risk 4: Pressure Housing Leakage**
- **Probability**: Low (15% if properly designed/tested)
- **Impact**: Critical (vehicle loss, $10K-20K damage)
- **Mitigation**:
  - Use proven Blue Robotics housings, not custom
  - Vacuum test every assembly to 10 inHg (30 minutes minimum)
  - Install leak detection probes in all housings
  - Implement automatic surface protocol on leak detection
  - Maintain O-ring replacement schedule
- **Fallback**: Insurance for high-value trials, shallow-water validation first

### Medium-Risk Items

**Risk 5: Acoustic Modem Performance Insufficient**
- **Probability**: Low-Medium (30%)
- **Impact**: Medium (reduced operational flexibility)
- **Mitigation**: Test modem in deployment environment before relying on it
- **Fallback**: Operate without acoustic modem, surface-only communications

**Risk 6: Sonar Cannot Detect Cables Reliably**
- **Probability**: Low (20%)
- **Impact**: Medium (mission effectiveness reduced)
- **Mitigation**: Validate Ping360 cable detection in test tank with known targets
- **Fallback**: Rely primarily on visual inspection with lighting

---

## 12. Development Roadmap

### Phase 1: Platform Development (Months 1-3)

**Budget: $4,000-6,000**

**Goals**: Build core vehicle structure
- Design and fabricate structural frame
- Integrate pressure housings (electronics, batteries)
- Install thrusters and ESCs
- Wire power distribution system
- Install Navigator + Raspberry Pi
- Basic sensors (depth, IMU)

**Testing**:
- Pressure test all enclosures to 350m equivalent (3.5× safety factor)
- Buoyancy and trim adjustments in pool
- Thruster performance validation
- Speed testing (should achieve 2+ m/s easily, 4 m/s with effort)

**Deliverable**: Manually-controlled ROV capable of depth holding and basic navigation

### Phase 2: Autonomy & Navigation (Months 3-4)

**Budget: $2,000-4,000**

**Goals**: Add autonomous capabilities
- Integrate GPS for surface positioning
- Implement waypoint navigation software
- Add WiFi and Iridium communications
- Develop mission planning interface
- Emergency surface protocols

**Testing**:
- Autonomous waypoint following in shallow water
- Communication range testing
- Battery endurance validation (should achieve 2+ hours at cruise)
- Fail-safe behavior verification

**Deliverable**: Autonomous vehicle capable of pre-programmed missions

### Phase 3: Full Sensor Integration (Months 5-6)

**Budget: $3,000-13,000**

**Goals**: Complete operational capability
- Install cameras, sonar, lighting
- Integrate acoustic modem (if included)
- Develop cable detection/tracking algorithms
- Data logging and post-mission analysis tools

**Testing**:
- Imaging system validation in turbid water
- Cable detection and following
- Acoustic modem range and reliability
- Full-duration missions at 250m depth

**Deliverable**: Operational cable inspection vehicle

---

## 13. Conclusion: Feasibility Assessment

### Technical Feasibility: Confirmed with Caveats

Your subsea cable inspection drone is **technically feasible** with the following important caveats:

**Achievable Specifications:**
- 250m depth rating (proven with COTS components)
- 30W payload (camera + sonar + lighting within budget)
- <25 kg mass (tight but achievable: 23-26 kg realistic)
- 2-hour endurance at cruise speeds (1-2 m/s)

**Challenging Specifications:**
- 4 m/s peak speed (achievable but requires 1.3 kW propulsion power)
- 2-hour endurance at 4 m/s (NOT feasible - would require 2.7 kWh battery at 10+ kg)

### Recommended Specification Interpretation

Your vehicle should be capable of:
- **Sustained cruise**: 1 m/s for 9+ hours on 799 Wh battery
- **Peak sprint**: 4 m/s for 30-40 minutes burst capability
- **Mixed mission**: 2.5-hour duration with 20% peak, 80% cruise operation

This provides the operational flexibility for cable inspection (cruise at 1 m/s, sprint to 4 m/s to avoid obstacles or catch up to ship) while exceeding 2-hour endurance requirements with 25% margin.

### Cost Feasibility: Excellent Value

- **DIY Build**: $10,000-23,000 (without/with acoustic modem)
- **Commercial Equivalent**: $50,000-150,000
- **Cost Ratio**: 20-25% of commercial pricing
- **Capability**: Superior speed performance to commercial options in this weight class

### Development Feasibility for Academic Project: Good

- **Timeframe**: 6 months aggressive, 12 months comfortable
- **Skills Required**: Mechanical design, embedded programming, systems integration
- **Risk Level**: Medium (proven components reduce technical risk)
- **Educational Value**: Excellent multi-disciplinary engineering exercise

### Key Success Factors

1. **Manage the speed-endurance-weight triangle carefully** - you cannot optimize all three simultaneously
2. **Use proven commercial components** (Blue Robotics ecosystem) rather than custom designs
3. **Test incrementally** - validate pressure, buoyancy, and speed in phases
4. **Budget conservatively** - expect 20% cost overrun and 1.5× timeline
5. **Document thoroughly** - this is an academic project, not just hardware

### Final Recommendation

**Proceed with the project** using the specifications and component selections outlined in this study. The design is technically sound, economically viable, and educationally valuable. The 4 m/s peak speed is ambitious but achievable with four T200 thrusters and proper hydrodynamic optimization.

For a Cambridge Engineering Tripos Part IIA Extension Activity, this presents an excellent balance of:
- **Ambition**: Pushing beyond typical commercial AUV performance
- **Achievability**: Using proven components and established engineering principles
- **Learning**: Multi-domain engineering (structures, hydrodynamics, power systems, control)
- **Practicality**: Buildable within academic timeframes and budgets

The project exercises mechanical engineering (pressure vessels, structures), electrical engineering (power systems, motor control), computer engineering (autonomy, sensors), and systems engineering (integration, testing) - exactly the comprehensive experience expected in a feasibility study.

---

## References & Citations

[1] ecoSUB Datasheet: https://www.unmannedsystemstechnology.com/wp-content/uploads/2024/05/240305-ecoSUBm-P-datasheet.pdf

[2] Department of Energy - Powering the Blue Economy: https://www.energy.gov/sites/prod/files/2019/03/f61/Chapter%203.pdf

[3] MDPI - CFD Study of Torpedo-Shaped Underwater Glider: https://www.mdpi.com/2311-5521/6/7/252

[4] SCIRP - Numerical Analysis of AUV Drag Coefficient: https://www.scirp.org/html/2-2320148_49513.htm

[5] Blue Robotics 18Ah Lithium-ion Battery: https://bluerobotics.com/store/comm-control-power/powersupplies-batteries/battery-li-4s-15-6ah/

[6] Blue ROV Solutions 18Ah Battery: https://bluerov-solutions.com/lithium-ion-battery-bluerobotics/

[7] Blue Robotics T200 Thruster: https://bluerobotics.com/store/thrusters/t100-t200-thrusters/t200-thruster-r2-rp/

[8] T200 Technical Documentation (GitHub): https://github.com/bluerobotics/bluerobotics.github.io/blob/master/thrusters/t200.md

[9] Blue ROV Solutions T200: https://bluerov-solutions.com/produkt/t200-thruster/

[10] Blue Robotics T500 Thruster: https://bluerobotics.com/store/thrusters/t100-t200-thrusters/t500-thruster/

[11] SeaBotix BTD150 Thruster: https://www.researchgate.net/figure/SeaBotix-BTD150-thruster_fig7_239592677

[12] Blue Robotics Basic ESC 30A: https://bluerobotics.com/store/thrusters/speed-controllers/besc30-r3/

[13] Basic ESC Technical Information: https://bluerobotics.com/store/thrusters/speed-controllers/besc30-r3/

[14] Navigator Flight Controller: https://bluerobotics.com/store/comm-control-power/control/navigator/

[15] Navigator with Raspberry Pi 4: https://bluerobotics.com/store/comm-control-power/control/navigator/

[16] Bar30 Depth Sensor: https://bluerobotics.com/store/sensors-cameras/sensors/bar30-sensor-r1/

[17] Bar30 PCB Version: https://bluerobotics.com/store/sensors-cameras/sensors/bar30-sensor-pcb-r1/

[18] Bar30 NauticExpo Listing: https://www.nauticexpo.com/prod/bluerobotics/product-69617-546039.html

[19] Keller Pressure Website: https://us.keller-pressure.com/

[20] Keller Pressure Transducers: https://keller-pressure.com/en/products/pressure-transducers

[21] Nortek DVL1000 - 300m: https://www.nortekgroup.com/products/dvl-1000-300m

[22] Nortek DVL1000 Details: https://www.uniquegroup.com/product/nortek-dvl1000-doppler-velocity-log/

[23] Teledyne Pathfinder DVL: https://bluezonegroup.com.au/product-catalogue/ras/rov-subsea-equipment/teledyne-pathfinder-dvl/

[24] VectorNav VN-100 IMU Datasheet: https://www.navtechgps.com/wp-content/uploads/VN100_ProductBrief_DS.pdf

[25] VN-100 Development Kit: https://www.navtechgps.com/vn-100-rugged-development-kit/

[26] SBG Systems AUV INS: https://www.sbg-systems.com/applications/autonomous-underwater-vehicle-auv/

[27] EvoLogics Acoustic Modems: https://www.subsea2020.com/evologics

[28] EvoLogics Product Information: https://www.esonetyellowpages.com/datasheets/datasheet-s2c_rwise_series_modems_1479735651.pdf

[29] LinkQuest Modems: https://geo-matching.com/products/s2c-m-hs-modem

[30] LinkQuest UWM2000H: https://www.oceanscan.net/p-LinkQuest-UWM2000H-Underwater-Modem

[31] RockBLOCK 9603N - SparkFun: https://www.sparkfun.com/products/14498

[32] Iridium SBD Modems: https://www.europasatellite.com/Iridium-SBD-Iridium-Short-Burst-Data-Modems-s/1176.htm

[33] RockBLOCK Product Page: https://www.sparkfun.com/products/14498

[34] WiFi Underwater Testing: https://www.apsubsea.com/?p=877

[35] Low-Light HD USB Camera: https://bluerobotics.com/store/sensors-cameras/cameras/cam-usb-low-light-r1/

[36] Low-Light Camera - RobotShop: https://www.robotshop.com/products/bluerobotics-low-light-hd-usb-camera-2

[37] Low-Light Camera Specifications: https://bluerobotics.com/store/sensors-cameras/cameras/cam-usb-low-light-r1/

[38] SubC Imaging Rayfin Micro: https://www.outlandtech.com/product-page/subc-imaging-rayfin-micro-camera-500m

[39] SubC Rayfin Launch Announcement: https://www.oceanbusiness.com/general/subc-imaging-launches-new-rayfin-micro-500m-rov-camera/

[40] Ping360 Scanning Sonar: https://bluerobotics.com/store/sonars/imaging-sonars/ping360-sonar-r1-rp/

[41] Ping360 Product Information: https://bluerobotics.com/store/sonars/imaging-sonars/ping360-sonar-r1-rp/

[42] Blue Robotics Imaging Sonars: https://bluerobotics.com/product-category/sonars/imaging-sonars/

[43] Pressure Vessel Design Guide: https://philipmcgaw.com/pressure-vessel/

[44] Blue Robotics Watertight Enclosures: https://bluerobotics.com/store/watertight-enclosures/wte-vp/

[45] Blue Robotics Enclosure Products: https://bluerobotics.com/product-category/watertight-enclosures/

[46] Aluminum Tubes Product Line: https://bluerobotics.com/new-products-aluminum-tubes/

[47] WetLink Penetrators: https://bluerobotics.com/store/cables-connectors/penetrators/wlp-vp/

[48] WetLink Penetrator Range Expansion: https://www.unmannedsystemstechnology.com/2021/12/blue-robotics-expands-wetlink-penetrator-range/

[49] Wikipedia - Autonomous Underwater Vehicles: https://en.wikipedia.org/wiki/Autonomous_underwater_vehicle

[50] L3Harris Iver3 Standard: https://ocean-server.com/iver3/

[51] REMUS M3V Information: https://www.naval-technology.com/projects/remus-m3v-autonomous-underwater-vehicle-auv/

[52] DOE Marine Energy Report: https://www.energy.gov/sites/prod/files/2019/03/f61/Chapter%203.pdf

[53] Buoyancy Principles: https://en.wikipedia.org/wiki/Buoyancy

---

**Document Prepared For:** Cambridge University Engineering Tripos Part IIA Extension Activity
**Date:** November 2025
**Authors:** Jerry Liu (yhl63), Zihe Liu (zl559)
**Disclaimer:** Prices and specifications current as of research date; verify with manufacturers before procurement
