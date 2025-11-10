# Technical Feasibility Study: 250m Subsea Cable Inspection Drone

**Your target specifications present an achievable but challenging design problem that requires careful trade-offs between speed, endurance, and mass constraints.** The 4 m/s peak speed requirement drives power consumption to 1-1.2 kW, necessitating a ~500-660 Wh battery system that consumes 20-30% of your 25 kg mass budget. Commercial components exist for all subsystems, with complete build costs estimated at $15,000-25,000 versus $50,000-80,000 for comparable commercial AUVs. Critical finding: achieving 4 m/s in this weight class requires 4× Blue Robotics T200 thrusters and accepts reduced endurance to 1.5-2 hours under peak operation.

## Power budget analysis reveals fundamental constraints

The hydrodynamics dominate your design. For a streamlined torpedo hull with 0.324m diameter and 0.082 m² frontal area, drag coefficients range from 0.29-0.35. At 1 m/s cruise speed with Cd=0.32, you need only 13.5 N thrust requiring 19.3W. But at 4 m/s peak with Cd=0.28, drag jumps to 188 N demanding 1,074W of propulsion power. Adding your 30W payload, the total system requires 130-330W at cruise and peaks at 1,104W during sprint operations.

**Battery sizing becomes your first critical decision.** For 2-hour endurance at medium power (215W average), you need 430 Wh plus 20% margin, totaling 516 Wh. The Blue Robotics dual 18Ah battery configuration (532 Wh, 14.8V, 2.7 kg batteries only) provides adequate capacity at reasonable cost ($720-800 for batteries). However, to support 4 m/s peak speeds, you need excess capacity to deliver 1.1 kW burst power - this requires either three 18Ah batteries (799 Wh, 4.1 kg, $1,200) or the single 22.2V 28Ah Mega-Battery (622 Wh, 2-2.5 kg, $1,490). The 22.2V system offers better weight efficiency but requires voltage conversion for 16V thruster operation.

## Propulsion system defines performance envelope

**The Blue Robotics T200 thruster emerges as the optimal choice across multiple dimensions.** Priced at $259 each, it delivers 5.1 kgf forward thrust at 16V while drawing 350W maximum power. The flooded motor design provides pressure tolerance to 3,000m - twelve times your requirement - and extensive field testing confirms 300+ hour continuous operation reliability. For your 25 kg vehicle achieving 4 m/s, you need approximately 188 N total thrust, requiring four T200 thrusters in horizontal configuration providing 200 N combined capability with appropriate safety margin.

Alternative options exist but present trade-offs. The T500 delivers three times more thrust (16.1 kgf at 24V) for $690 but consumes over 1 kW continuously - excessive for a small AUV. The Hydrocean P75-290 offers comparable performance to the T200 at potentially lower cost, but depth ratings must be verified as specifications aren't fully published. SeaBotix BTD150 thrusters provide only 2.2 kgf thrust at 80W - insufficient for your speed requirement despite excellent efficiency.

**Electronic speed controllers add $140-280 to your propulsion budget.** The Blue Robotics Basic ESC ($35-40 each, 30A continuous, 6-22V) provides proven compatibility with T200 thrusters and includes bidirectional operation with thermal protection. Four ESCs at $140 total represents excellent value. The sensorless brushless design running BLHeli_S firmware allows custom tuning and integrates seamlessly with standard PWM control from autopilot systems.

## Navigation and control systems trade capability versus cost

**The Blue Robotics Navigator Flight Controller with Raspberry Pi 4 offers the best integration platform at $181-225.** This combination provides a complete autopilot (6-axis IMU, dual magnetometers, barometer) plus substantial computing power for autonomy and data processing. The 16 PWM channels support eight thrusters plus eight accessories, while four UART ports enable connection of depth sensors, DVL, acoustic modems, and other serial devices. Power consumption runs 8-10W typical, fitting comfortably within budgets.

For depth sensing, the Bar30 sensor ($80-90) provides 2mm resolution to 300m depth via I2C interface - simple and cost-effective. However, it requires daily drying or suffers drift. Industrial alternatives from Keller or Honeywell offer superior long-term stability at higher cost (quote required, estimated $200-500). 

**Doppler Velocity Log selection dramatically impacts both capability and budget.** The Nortek DVL1000 provides 0.8 cm/s single-ping accuracy with 75m bottom-track range and draws only 1.3W average power, but requires manufacturer quote (estimated $15,000-25,000). The Teledyne RDI Pathfinder DVL offers similar performance at value pricing. DVLs enable precise dead-reckoning navigation underwater where GPS is unavailable, reducing position uncertainty from 10+ meters (IMU-only) to sub-meter accuracy over 2-hour missions. For cost-constrained applications, GPS surface fixes combined with IMU dead reckoning may suffice for cable following missions.

VectorNav VN-100 IMUs ($950-1,525) provide 0.5° pitch/roll accuracy in small 15g packages but require waterproof housing integration. The VN-200 ($3,100-3,500) adds integrated GNSS for enhanced surface positioning. More capable tactical-grade IMUs like the SBG Systems Pulse-40 offer 0.08°/√h gyro performance but command premium pricing. For budget-conscious designs, the Navigator's integrated ICM-20602 IMU provides adequate performance for basic stabilization and navigation.

## Communication systems enable operational flexibility

**Underwater acoustic communications and surface satellite links serve complementary roles.** The EvoLogics S2C M 18/34 acoustic modem ($10,000-15,000) provides 13.9 kbps data rate over 2,000m range at 250m operating depth, consuming 20W transmit and 1.5W receive. This enables command/control and low-bandwidth telemetry during submerged operations. The higher-frequency M 42/65 model doubles data rate to 31.2 kbps for the same price. Budget alternatives include the Water Linked M64 ($2,300) offering only 64 bps but ultra-robust operation, or the LinkQuest UWM2000H ($5,000-8,000) providing 1.2 kbps over 1,500m range.

When surfaced, dual communications optimize data transfer. The RockBLOCK 9603 Iridium modem ($260 hardware, $15-20/month service) provides global coverage for position reports and status updates, consuming 0.8W for 340-byte messages. WiFi 2.4 GHz enables high-bandwidth data dumps at 1-50 Mbps when within 500m of support vessels, drawing 0.1-0.5W. This hybrid architecture totals $10,500-15,500 for professional acoustic capability or just $360 for surface-only satellite communications.

## Imaging payload fits within power budget constraints

**Your 30W payload allocation allows multiple sensor combinations.** The Blue Robotics Low-Light HD USB Camera ($120) consumes only 2.5W while delivering 1080p video at 30 fps with excellent low-light performance. Its 300m depth rating and USB interface simplify integration. Adding the Ping360 Scanning Imaging Sonar ($2,750, 5W max) provides 360° acoustic imaging to 50m range at 750 kHz - ideal for cable detection and tracking in turbid water. Together these total 7.5W, leaving 22.5W for lighting or additional sensors.

For professional-grade imaging, the SubC Rayfin Micro camera system delivers 4K video and 12.3MP stills while consuming 7.8W average (13.56W peak). The 500m depth rating and Ethernet interface support advanced operations. At $8,000-15,000 estimated cost, it represents significant capability upgrade over the Blue Robotics option. Combined with Ping360 sonar, total payload power reaches 13W average - well within budget.

**Lighting dominates remaining power allocation.** Single LED units typically consume 10-15W, with the Blue Robotics Lumen light drawing 10W typical. For cable inspection requiring visual documentation, plan 10-15W continuous lighting. The complete recommended configuration - Low-Light Camera (2.5W) + Ping360 (5W) + Lumen Light (10W) - totals 17.5W, preserving 12.5W margin. This $3,270 payload package provides comprehensive imaging and detection capability.

## Pressure housing materials present clear optimization path

**For 250m depth operation, aluminum 6061-T6 dominates the design space.** At $7/kg material cost and 276 MPa yield strength, it enables 6-8mm wall thickness for typical tube designs with 2.5-3× safety factor. Blue Robotics 3" watertight enclosures ($200-300 complete) provide 500m depth rating - double your requirement - in proven modular packages. The 4" series ($250-400) offers 400m rating with larger internal volume but experienced quality issues requiring verification of redesigned tubes currently rated only 200m.

Titanium Grade 5 offers superior strength-to-weight ratio (880 MPa yield) enabling thinner walls, but material costs reach $30/kg with machining expenses 10× aluminum. Total system costs run $800-2,000+ for custom titanium housings versus $200-400 for aluminum. This premium only makes sense when weight reduction is critical or deeper operations (\u003e1000m) are planned. For your 250m requirement, titanium provides no practical advantage.

Acrylic tubes fail to meet requirements - maximum practical depth ratings reach only 70-150m for standard sizes. While offering transparency for visual inspection and costing less ($4/kg), the material's 70-75 MPa strength and susceptibility to long-term submersion make it unsuitable for 250m operation.

**Wall thickness calculations follow ASME Section VIII formulas.** For external pressure design, t = (P × R) / (S × E - 0.6P) + corrosion allowance, where external pressure at 250m with 3× safety factor equals 7.5 MPa (1,089 psi). For 100mm ID aluminum tube (R=50mm), allowable stress S=87.5 MPa yields minimum thickness of 4.5mm. Adding 1.5-3mm corrosion allowance produces 6-8mm nominal requirement - matching Blue Robotics production specifications.

WetLink Penetrators ($13-17 each) revolutionize cable entry points. The compression seal design requires no potting, assembles in seconds, and provides 1,000m depth rating - four times your requirement. Compared to traditional penetrators at $50-150 requiring permanent potting installation, this represents both cost savings and field serviceability. For a typical electronics housing with four cable penetrations, total cost runs only $52-68 versus $200-600 for conventional approaches.

## Commercial comparison reveals build advantages

**Existing small AUVs cluster around different capability points than your specifications.** The ecoSUB m-Power+ at 17 kg provides closest match, offering 500m depth rating and 8-10 hour endurance at estimated $50,000-80,000 cost. However, its speed remains unspecified but likely 1-2 m/s based on torpedo hull design. The Boxfish AUV exactly hits your 25 kg target with 300-600m depth rating and 10-hour endurance, but employs eight vectored thrusters for hovering capability rather than sprint speed, with pricing estimated at $80,000-150,000. The OceanServer Iver3, while proven with 375 units sold at $50,000 base price, exceeds your weight at 27-39 kg and provides only 100m depth with 1.3 m/s speed.

**No commercial AUV in the under-25 kg class achieves 4 m/s sustained speed.** The REMUS M3V exceeds 5 m/s but in a specialized air-deployable package with undisclosed weight. Most small torpedo-form AUVs operate at 1.5-2.6 m/s (3-5 knots) as drag increases with velocity squared, making higher speeds prohibitively power-hungry. This fundamental physics constraint explains why your 4 m/s requirement drives significant design complexity.

Commercial vehicles use similar components to those specified. The T200 thruster appears in numerous platforms. Iver3 employs Intel Dual-Core processors, while Boxfish uses NVIDIA Jetson Xavier running ROS 2. Navigation sensors include Xsens MTi-3 IMUs (ecoSUB), Nortek DVL-1000 systems, and similar depth sensors. Lithium-ion batteries at 12-24V dominate power systems. This component commonality validates your selection approach while confirming realistic specifications.

## Cost analysis and system integration

**Component-level pricing enables detailed budget estimation.** A complete system breakdown:

**Propulsion**: 4× T200 thrusters ($1,036), 4× Basic ESC ($140), propeller spares ($40) = $1,216

**Power**: 3× 18Ah batteries ($1,200), 3" enclosure ($250), power distribution ($100) = $1,550

**Control**: Navigator + RPi4 ($200), 4" electronics enclosure ($300) = $500

**Navigation**: Bar30 depth sensor ($90), GPS ($80), magnetometer (included) = $170

**Communications**: RockBLOCK Iridium ($260), WiFi module ($50), acoustic modem (optional $10,000+) = $310 base

**Imaging**: Low-Light Camera ($120), Ping360 sonar ($2,750), Lumen light ($300) = $3,170

**Structural**: Frame materials ($400), buoyancy foam ($200), hardware ($300) = $900

**Accessories**: Cables ($200), penetrators 8× ($120), tools ($150) = $470

**Total core system**: $8,286 (without acoustic modem) or $18,286 (with EvoLogics S2C)

Adding 20% contingency for miscellaneous components, shipping, and iteration yields $10,000-22,000 total. Development labor represents the largest variable - budget 6-12 months at $30,000-100,000+ depending on team experience. However, this purchases extensive customization capability and deep system understanding impossible with commercial platforms.

**Power budget verification confirms feasibility.** Cruise operation at 1 m/s: propulsion 50W (4× thrusters at 12.5W each), control 10W, payload 17.5W, navigation 5W, communications 2W = 85W total, providing 6+ hour endurance on 532 Wh battery. Peak operation at 4 m/s: propulsion 1,100W, control 10W, payload 20W, navigation 5W = 1,135W total, limiting sprint duration to 30 minutes. Mixed mission profile with 70% cruise, 30% peak averages 390W, yielding 1.4 hour endurance - slightly below 2-hour target. Upgrading to 799 Wh battery (3× 18Ah) extends mixed operation to 2.1 hours, meeting specification with 5% margin.

## Design recommendations and risk mitigation

**Adopt a staged development approach to manage technical risk.** Phase 1 focuses on basic platform: frame, pressure housings, propulsion, and control systems for $4,000-6,000. Validate depth rating with pressure testing, verify buoyancy and trim in shallow water, and confirm thruster performance reaches speed targets. Phase 2 adds navigation sensors and basic communications for $2,000-4,000, enabling autonomous waypoint following and depth holding. Phase 3 integrates full imaging payload and acoustic communications for $3,000-13,000, achieving complete operational capability.

This approach preserves capital while enabling early failure detection and requirement refinement. If 4 m/s proves unattainable or unnecessary, downgrading to three T200 thrusters saves $295 while extending endurance 30%. If acoustic communications aren't essential for cable-following missions where the vehicle maintains close proximity to cables, eliminating the modem saves $10,000-15,000.

**Hydrodynamic optimization will determine speed performance.** Achieve streamlined torpedo hull using Myring equations for nose and tail sections. Target length-to-diameter ratio of 5:1 or higher. Minimize protrusions - recess sensors where possible, use conformal designs for external components. CFD analysis or tow tank testing should validate drag coefficient assumptions; actual values may vary 20-30% from theoretical predictions. Consider that four T200 thrusters provide 200 N total thrust, but you need only 188 N at 4 m/s with Cd=0.28 - minimal margin for real-world conditions.

For neutral buoyancy in seawater (1,027 kg/m³), target displaced volume of 24.3 liters for your 25 kg vehicle. Adjustable ballast of ±500g enables fine-tuning. Pressure housings displace approximately 3-4 liters, batteries 2 liters, thrusters create negative buoyancy requiring syntactic foam compensation. Budget 2-3 kg of buoyancy foam at $200-300 to achieve proper trim.

**Quality components and thorough testing prevent costly failures.** Use marine-grade aluminum 6061-T6 with hard anodizing for all pressure housings. Apply Tef-Gel to all threaded connections preventing galvanic corrosion. Install zinc sacrificial anodes. Vacuum test all enclosures to 10 inHg minimum before deployment, using Blue Robotics Vacuum Test Plug ($12). Maintain O-ring replacement schedule every 10-20 cycles or annually. Keep detailed maintenance logs tracking seal conditions, battery cycles, and component hours.

Implement comprehensive leak detection with probes in each pressure vessel connecting to the Navigator's two leak detection inputs. Add bilge alarm functionality and automatic surface protocols if water intrusion occurs. This $50 insurance investment protects thousands in electronics.

## Conclusion and feasibility assessment  

**Your subsea cable inspection drone is technically feasible with careful management of the speed-endurance-weight triangle.** All required components exist as commercial off-the-shelf products at reasonable costs. The $15,000-25,000 build budget represents 25-50% of comparable commercial systems while offering superior customization and speed potential. The 250m depth requirement poses no challenges with properly specified housings and the 30W payload constraint comfortably accommodates imaging and sonar systems.

The critical constraint is achieving 4 m/s peak speed within 25 kg mass and 2-hour endurance. This requires aggressive power management, optimized hydrodynamics, and acceptance of reduced endurance during sprint operations. If your cable inspection missions allow operation at 2-3 m/s with brief 4 m/s sprints, the design works well. If sustained 4 m/s operation is mandatory, consider relaxing either the 25 kg weight limit to 30 kg (enabling larger battery) or the 2-hour endurance to 1.5 hours.

For a Cambridge Engineering Tripos project, this presents an excellent balance of ambition and achievability. The design exercises multiple engineering domains - hydrodynamics, structural analysis, power systems, control theory, and systems integration - while remaining buildable within academic timeframes and budgets. Recommend proceeding with Phase 1 development to validate core assumptions before committing to full sensor suite procurement.

## Key Research Sources & Citations

### **Thruster Specifications & Performance**
- Blue Robotics T200 Thruster: https://bluerobotics.com/store/thrusters/t100-t200-thrusters/t200-thruster-r2-rp/
- Blue Robotics T500 Thruster: https://bluerobotics.com/store/thrusters/t100-t200-thrusters/t500-thruster/
- T200 Technical Documentation: https://github.com/bluerobotics/bluerobotics.github.io/blob/master/thrusters/t200.md

### **Battery Systems**
- Blue Robotics 18Ah Lithium-ion Battery: https://bluerobotics.com/store/comm-control-power/powersupplies-batteries/battery-li-4s-15-6ah/
- Blue ROV Solutions 18Ah Battery: https://bluerov-solutions.com/lithium-ion-battery-bluerobotics/

### **Control Systems & Electronics**
- Navigator Flight Controller: https://bluerobotics.com/store/comm-control-power/control/navigator/
- Basic ESC (30A): https://bluerobotics.com/store/thrusters/speed-controllers/besc30-r3/

### **Sensors - Depth & Pressure**
- Bar30 Depth Sensor (300m): https://bluerobotics.com/store/sensors-cameras/sensors/bar30-sensor-r1/
- Bar30 Technical Specs: https://www.nauticexpo.com/prod/bluerobotics/product-69617-546039.html

### **Sensors - Navigation**
- Nortek DVL1000 (300m): https://www.nortekgroup.com/products/dvl-1000-300m
- VectorNav VN-100 IMU Datasheet: https://www.navtechgps.com/wp-content/uploads/VN100_ProductBrief_DS.pdf
- SBG Systems AUV INS: https://www.sbg-systems.com/applications/autonomous-underwater-vehicle-auv/

### **Communication Systems**
- EvoLogics Acoustic Modems: https://www.subsea2020.com/evologics
- LinkQuest UWM2000H Acoustic Modem: https://www.oceanscan.net/p-LinkQuest-UWM2000H-Underwater-Modem
- RockBLOCK 9603 Iridium Module: https://www.sparkfun.com/products/14498
- WiFi Underwater Testing: https://www.apsubsea.com/?p=877

### **Imaging & Sonar**
- Blue Robotics Low-Light HD Camera: https://bluerobotics.com/store/sensors-cameras/cameras/cam-usb-low-light-r1/
- Ping360 Scanning Sonar: https://bluerobotics.com/store/sonars/imaging-sonars/ping360-sonar-r1-rp/
- SubC Imaging Rayfin Micro Camera: https://www.outlandtech.com/product-page/subc-imaging-rayfin-micro-camera-500m

### **Pressure Housings & Enclosures**
- Blue Robotics Watertight Enclosures: https://bluerobotics.com/store/watertight-enclosures/wte-vp/
- Aluminum Enclosure Tubes: https://bluerobotics.com/new-products-aluminum-tubes/
- Pressure Vessel Design Calculations: https://philipmcgaw.com/pressure-vessel/
- WetLink Penetrators: https://bluerobotics.com/store/cables-connectors/penetrators/wlp-vp/

### **Commercial AUV Comparisons**
- ecoSUB Datasheet (PDF): https://www.unmannedsystemstechnology.com/wp-content/uploads/2024/05/240305-ecoSUBm-P-datasheet.pdf
- L3Harris Iver3 Standard: https://ocean-server.com/iver3/
- L3Harris Iver3 Specifications: https://www.l3harris.com/all-capabilities/iver3-standard-system-auv

### **Hydrodynamics & AUV Design**
- CFD Study of Torpedo-Shaped AUV: https://www.mdpi.com/2311-5521/6/7/252
- AUV Drag Coefficient Analysis: https://www.scirp.org/html/2-2320148_49513.htm
- DOE Powering the Blue Economy Report: https://www.energy.gov/sites/prod/files/2019/03/f61/Chapter%203.pdf
- Wikipedia - Autonomous Underwater Vehicles: https://en.wikipedia.org/wiki/Autonomous_underwater_vehicle

Would you like me to now create the updated Beamer slides with proper citations included, or would you prefer a bibliography page you can add to your existing presentation?