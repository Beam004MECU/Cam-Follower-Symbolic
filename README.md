# Cam and Follower — Symbolic Analysis and Synthesis

นายภูริณัฐ ไชยขาว (Phurinat Chaikaow) · Mechanical Engineering, Chulalongkorn University

วิเคราะห์กลไกแคม–ตัวตามด้วย Symbolic Mathematics และสังเคราะห์แคมยกสองระดับ ผ่านการรัน MATLAB และตรวจผลอิสระแล้วทั้งสองงาน (revision 2, 23 ต.ค. 2026)

## Symbolic Analysis

![MATLAB symbolic analysis](media/main_matlab.png)

[ภาพเคลื่อนไหวจาก MATLAB (AVI)](media/main_mechanism.avi)

แคมหมุนตามเข็มนาฬิกา ขับตัวตามลูกกลิ้งให้เลื่อนในแนวดิ่งผ่านศูนย์แคม ระยะยก 20 mm รัศมีฐาน 40 mm รัศมีลูกกลิ้ง 5 mm ความเร็ว 60 rpm รอบหนึ่งแบ่งเป็นยก–ค้างบน–ลดลง–ค้างล่าง ช่วงละ 90°

โค้ดอินทิเกรตความเร่งไซน์และแก้ค่าคงที่ด้วย symbolic จากนั้นหาอนุพันธ์และสร้างผิวแคมด้วยแนวปกติของเส้นพิตช์ ภาพเคลื่อนไหวใช้พิกัดจากแบบจำลองเดียวกัน

```math
F(u)=u-\frac{\sin(2\pi u)}{2\pi},\quad s=hF(u),\quad v=\omega\frac{ds}{d\theta},\quad a=\omega^2\frac{d^2s}{d\theta^2}.
```

สูตร $s=hF(u)$ ใช้ช่วงยก ช่วงลดใช้ $s=h[1-F(u)]$ โดย $u$ เริ่มจาก 0 ใหม่ในแต่ละช่วง ความเร็วและความเร่งต่อเนื่องกับช่วงค้าง แต่ jerk มีการกระโดดแบบค่าจำกัด

![Links and joints](media/links_joints.png)

| จุดต่อ | ชิ้นส่วน | ประเภท |
|---|---|---|
| J1 | 1 ฐาน – 2 แคม | Revolute |
| J2 | 1 ฐาน – 3 ก้านตัวตาม | Prismatic |
| J3 | 3 ก้านตัวตาม – 4 ลูกกลิ้ง | Revolute |
| J4 | 2 แคม – 4 ลูกกลิ้ง | Higher pair: contact |

**DOF:** แบบเต็มมี $n=4$, $j_1=3$, $j_2=1$ จึงได้ $M=3(n-1)-2j_1-j_2=2$ โดยหนึ่งตัวแปรเป็นการหมุนอิสระของลูกกลิ้ง ซึ่งไม่เปลี่ยนระยะยก เมื่อละตัวแปร passive นี้ แบบจำลองอินพุต–เอาต์พุตมี **DOF = 1** กำหนดมุมแคมแล้วหาระยะยกได้ ภาพเคลื่อนไหวไม่กำหนดการหมุนรอบตัวเองของลูกกลิ้ง และไม่ได้อ้างว่ากลิ้งไม่ไถล

ช่วงทำงานของศูนย์ลูกกลิ้งในงานหลัก: $x=0$, $45\le y\le65$ mm

## โค้ดและการรัน

| ไฟล์ | หน้าที่ |
|---|---|
| [cam_model.m](simulation/cam_model.m) | สร้างกฎการเคลื่อนที่ด้วย symbolic และคำนวณผิวแคม |
| [run_main.m](simulation/run_main.m) | วิเคราะห์และแสดงกลไกงานหลัก |
| [run_bonus.m](simulation/run_bonus.m) | สังเคราะห์แคมยกสองระดับจากข้อจำกัดมุมกด |
| [RUN_ALL.m](RUN_ALL.m) | รันทั้งสองงาน |

**การรัน:** MATLAB พร้อม Symbolic Math Toolbox → `RUN_ALL.m` แสดงกลไกกับกราฟ s, v, a และบันทึกวิดีโอ ปุ่ม Play/Pause, Reset และ Playback speed ใช้ดูผลต่อได้; ความเร็วเล่นไม่เปลี่ยนค่า 60 rpm ที่ใช้คำนวณ

## Synthesis

ออกแบบแคมหนึ่งตัวให้ตัวตามยกสองระดับต่อหนึ่งรอบตามตาราง โดยใช้รัศมีลูกกลิ้ง 5 mm ความเร็ว 60 rpm และกฎ Cycloidal ในแต่ละช่วงยก–ลด

| มุมแคม | การเคลื่อนที่ |
|---|---|
| 0–60° | ยกจาก 0 ถึง 10 mm |
| 60–100° | ค้างที่ 10 mm |
| 100–180° | ยกจาก 10 ถึง 25 mm |
| 180–220° | ค้างที่ 25 mm |
| 220–320° | ลดจาก 25 ถึง 0 mm |
| 320–360° | ค้างที่ 0 mm |

สังเคราะห์ผิวแคมและหารัศมีฐานจากข้อจำกัดมุมกดไม่เกิน 30° แล้วตรวจรัศมีความโค้งนูนของเส้นพิตช์ไม่น้อยกว่า 7 mm เลือกขนาดเพิ่มทีละ 0.5 mm

```math
R_b \ge \max_\theta\left(\frac{|s_\theta|}{\tan30^\circ}-R_r-s\right).
```

ผลจาก MATLAB สอดคล้องกับการคำนวณอิสระ ให้รัศมีฐานขั้นต่ำจากมุมกด 33.385 mm เลือก **33.5 mm** มุมกดสูงสุดประมาณ **29.941°** ช่วงค้างและช่วงยกต่อกันด้วยความเร็วและความเร่งเป็นศูนย์ที่รอยต่อ

![MATLAB stepped synthesis](media/bonus_matlab.png)

[ภาพเคลื่อนไหวจาก MATLAB (AVI)](media/bonus_mechanism.avi) · [ผลตรวจ](experiments/README.md)

## ไฟล์ประกอบ

| โฟลเดอร์ | เนื้อหา |
|---|---|
| [simulation/](simulation/) | โค้ด symbolic และภาพเคลื่อนไหว |
| [docs/](docs/) | สมการและหลักการออกแบบ |
| [media/](media/) | ภาพและวิดีโอผล MATLAB |
| [experiments/](experiments/) | ผล MAT และหลักฐานการตรวจสอบ |

**ขอบเขต:** แบบจำลองจลนศาสตร์ ชิ้นส่วนแข็งเกร็ง คงสัมผัส และความเร็วแคมคงที่; ไม่ได้วิเคราะห์แรง ความแข็งแรง หรือการหลุดสัมผัส หน่วย mm, s และ rad

## อ้างอิง

- [Carnegie Mellon University — Cams](https://www.cs.cmu.edu/~rapidproto/mechanisms/chpt6.html): กลไกแคม การกลับการเคลื่อนที่ และ passive roller DOF
- [METU — Basic Cam Motion Curves](https://ocw.metu.edu.tr/pluginfile.php/6886/mod_resource/content/1/ch8/8-3.htm): กฎการเคลื่อนที่ไซคลอยด์
- [METU — Cam Size Determination](https://ocw.metu.edu.tr/pluginfile.php/5791/mod_resource/content/8/ch8/8-4a.htm): มุมกดและขนาดแคม โดยจุดวิกฤตในโครงงานหาเองจากอนุพันธ์
