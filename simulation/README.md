# Simulation

MATLAB พร้อม Symbolic Math Toolbox → [RUN_ALL.m](../RUN_ALL.m)

| ไฟล์ | หน้าที่ |
|---|---|
| `cam_model.m` | สร้างสมการ symbolic และผิวแคม |
| `run_main.m` | งานหลัก: ระยะยก 20 mm รัศมีฐาน 40 mm |
| `run_bonus.m` | Synthesis: ระยะยก 0 → 10 → 25 → 0 mm มุมกดไม่เกิน 30° |
| `render_cam.m` | แสดงกลไก กราฟ s/v/a และบันทึกภาพกับวิดีโอ |
| `install_cam_controls.m` | ปุ่มเล่น–หยุด เริ่มใหม่ และปรับความเร็วเล่น |
| `validate_cam.m`, `recover_lift.m` | ตรวจผลคำนวณและการเคลื่อนที่จากผิวแคม |

ผลที่สร้างใหม่อยู่ใน `simulation/results/` และ `RETURN_TO_REVIEW_*.zip` ที่โฟลเดอร์หลัก
ผล revision 2 ที่ตรวจผ่านแล้วอยู่ใน [experiments/](../experiments/) และ [media/](../media/)
