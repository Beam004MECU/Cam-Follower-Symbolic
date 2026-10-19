# Documentation

## Setup and operation

ใช้ MATLAB R2026a Update 4 พร้อม Symbolic Math Toolbox 26.1 (สภาพแวดล้อมที่บันทึกผล: macOS) ดาวน์โหลด repository ทั้งชุด เปิดโฟลเดอร์หลักเป็น Current Folder แล้วรัน [RUN_ALL.m](../RUN_ALL.m) ไม่ต้องประกอบฮาร์ดแวร์หรือติดตั้ง firmware

ดูปุ่ม Play/Pause, Reset และ Playback speed ใน [README หลัก](../README.md#getting-started) รอให้บันทึก AVI เสร็จก่อนปิดหน้าต่าง ผลที่สร้างใหม่อยู่ใน `simulation/results/` ส่วนผลที่เก็บอ้างอิงอยู่ใน [experiments/](../experiments/)

## Troubleshooting and maintenance

หากหา function ไม่พบ ให้ตรวจว่าดาวน์โหลดโฟลเดอร์ simulation ครบและรันจากโฟลเดอร์หลัก หากใช้ symbolic ไม่ได้ ให้ตรวจการติดตั้งและสิทธิ์ใช้ Symbolic Math Toolbox เมื่อพบ error ให้เก็บข้อความผิดพลาดและ diagnostic ZIP ที่ RUN_ALL สร้างไว้เพื่อตรวจสอบ ก่อนเผยแพร่ log ให้ตรวจข้อมูลส่วนตัวและข้อมูล license

ใช้ Git commits เป็นประวัติการแก้ไข เมื่อแก้พารามิเตอร์หรือโค้ด ให้รันการตรวจสอบใหม่และบันทึกผลใน experiments พร้อมปรับวันที่และสถานะใน README หลัก

## Design and safety

[design.md](design.md) อธิบายเรขาคณิต หน่วย และการเลือกขนาดแคม; [ภาพกลไก](../media/links_joints.png) แสดง links และ joints งานนี้ไม่มีการใช้เครื่องจักร ผลจลนศาสตร์ยังไม่ใช่การรับรองความแข็งแรงหรือความปลอดภัยในการผลิตจริง
