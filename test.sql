-- =====================================================
-- 高校公寓管理系统 测试数据脚本（30+学生，多表关联覆盖）
-- 依赖顺序：用户 → 楼栋 → 房间 → 床位 → 入住 → 调宿/报修/晚归/访客
-- 所有关联均使用子查询定位，不依赖自增ID
-- =====================================================

USE dormitory_management;
SET NAMES utf8mb4;

-- =====================================================
-- 1. 补充宿管账号
-- =====================================================
INSERT INTO sys_user (username, password, real_name, role_type, gender, phone, status)
VALUES
    ('dorm003', 'e10adc3949ba59abbe56e057f20f883e', '王丽',   2, 2, '13800138003', 1),
    ('dorm004', 'e10adc3949ba59abbe56e057f20f883e', '赵强',   2, 1, '13800138004', 1);

-- =====================================================
-- 2. 补充楼栋（3号楼/西区男生，4号楼/南区女生）
-- =====================================================
INSERT INTO dorm_building (building_no, building_name, floor_count, area, manager_id, remark)
SELECT '3号楼', '西区3号学生公寓', 5, '西区', user_id, '男生公寓'
FROM sys_user WHERE username = 'dorm003';

INSERT INTO dorm_building (building_no, building_name, floor_count, area, manager_id, remark)
SELECT '4号楼', '南区4号学生公寓', 5, '南区', user_id, '女生公寓'
FROM sys_user WHERE username = 'dorm004';

-- =====================================================
-- 3. 扩展1/2号楼房间并插入所有床位（每房间4床）
-- =====================================================
-- 为 1 号楼增加 301~502 共6间
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '301', building_id, 3, 4, 1 FROM dorm_building WHERE building_no = '1号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');

INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '302', building_id, 3, 4, 1 FROM dorm_building WHERE building_no = '1号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');

INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '401', building_id, 4, 4, 1 FROM dorm_building WHERE building_no = '1号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');

INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '402', building_id, 4, 4, 1 FROM dorm_building WHERE building_no = '1号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');

INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '501', building_id, 5, 4, 1 FROM dorm_building WHERE building_no = '1号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');

INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '502', building_id, 5, 4, 1 FROM dorm_building WHERE building_no = '1号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');

-- 为 2 号楼增加 201~502 共8间
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '201', building_id, 2, 4, 1 FROM dorm_building WHERE building_no = '2号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');

INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '202', building_id, 2, 4, 1 FROM dorm_building WHERE building_no = '2号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');

INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '301', building_id, 3, 4, 1 FROM dorm_building WHERE building_no = '2号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');

INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '302', building_id, 3, 4, 1 FROM dorm_building WHERE building_no = '2号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');

INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '401', building_id, 4, 4, 1 FROM dorm_building WHERE building_no = '2号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');

INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '402', building_id, 4, 4, 1 FROM dorm_building WHERE building_no = '2号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');

INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '501', building_id, 5, 4, 1 FROM dorm_building WHERE building_no = '2号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');

INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '502', building_id, 5, 4, 1 FROM dorm_building WHERE building_no = '2号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');

-- 为 3 号楼创建房间 101~502（每层2间，共10间）
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '101', building_id, 1, 4, 1 FROM dorm_building WHERE building_no = '3号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '102', building_id, 1, 4, 1 FROM dorm_building WHERE building_no = '3号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '201', building_id, 2, 4, 1 FROM dorm_building WHERE building_no = '3号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '202', building_id, 2, 4, 1 FROM dorm_building WHERE building_no = '3号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '301', building_id, 3, 4, 1 FROM dorm_building WHERE building_no = '3号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '302', building_id, 3, 4, 1 FROM dorm_building WHERE building_no = '3号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '401', building_id, 4, 4, 1 FROM dorm_building WHERE building_no = '3号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '402', building_id, 4, 4, 1 FROM dorm_building WHERE building_no = '3号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '501', building_id, 5, 4, 1 FROM dorm_building WHERE building_no = '3号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '502', building_id, 5, 4, 1 FROM dorm_building WHERE building_no = '3号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');

-- 为 4 号楼创建房间 101~502
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '101', building_id, 1, 4, 1 FROM dorm_building WHERE building_no = '4号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '102', building_id, 1, 4, 1 FROM dorm_building WHERE building_no = '4号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '201', building_id, 2, 4, 1 FROM dorm_building WHERE building_no = '4号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '202', building_id, 2, 4, 1 FROM dorm_building WHERE building_no = '4号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '301', building_id, 3, 4, 1 FROM dorm_building WHERE building_no = '4号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '302', building_id, 3, 4, 1 FROM dorm_building WHERE building_no = '4号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '401', building_id, 4, 4, 1 FROM dorm_building WHERE building_no = '4号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '402', building_id, 4, 4, 1 FROM dorm_building WHERE building_no = '4号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '501', building_id, 5, 4, 1 FROM dorm_building WHERE building_no = '4号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');
INSERT INTO dorm_room (room_no, building_id, floor_num, bed_total, room_type)
SELECT '502', building_id, 5, 4, 1 FROM dorm_building WHERE building_no = '4号楼';
SET @room = LAST_INSERT_ID();
INSERT INTO dorm_bed (bed_no, room_id, bed_status, remark) VALUES
                                                               ('1号床',@room,0,'上铺'),('2号床',@room,0,'下铺'),('3号床',@room,0,'上铺'),('4号床',@room,0,'下铺');

-- =====================================================
-- 4. 插入30名新学生（学号 2024004 ~ 2024033）
-- =====================================================
INSERT INTO sys_user (username, password, real_name, role_type, gender, phone, grade, major, class_name, status)
VALUES
    ('2024004','e10adc3949ba59abbe56e057f20f883e','陈六',  3,1,'13900139004','2024级','计算机科学与技术','计科1班',1),
    ('2024005','e10adc3949ba59abbe56e057f20f883e','赵七',  3,1,'13900139005','2024级','计算机科学与技术','计科1班',1),
    ('2024006','e10adc3949ba59abbe56e057f20f883e','孙八',  3,2,'13900139006','2024级','计算机科学与技术','计科2班',1),
    ('2024007','e10adc3949ba59abbe56e057f20f883e','周九',  3,2,'13900139007','2024级','软件工程','软工1班',1),
    ('2024008','e10adc3949ba59abbe56e057f20f883e','吴十',  3,1,'13900139008','2024级','软件工程','软工1班',1),
    ('2024009','e10adc3949ba59abbe56e057f20f883e','郑十一',3,1,'13900139009','2024级','软件工程','软工2班',1),
    ('2024010','e10adc3949ba59abbe56e057f20f883e','王十二',3,2,'13900139010','2024级','网络工程','网工1班',1),
    ('2024011','e10adc3949ba59abbe56e057f20f883e','冯十三',3,2,'13900139011','2024级','网络工程','网工1班',1),
    ('2024012','e10adc3949ba59abbe56e057f20f883e','陈十四',3,1,'13900139012','2024级','数据科学','数据1班',1),
    ('2024013','e10adc3949ba59abbe56e057f20f883e','褚十五',3,2,'13900139013','2024级','数据科学','数据1班',1),
    ('2024014','e10adc3949ba59abbe56e057f20f883e','卫十六',3,1,'13900139014','2023级','计算机科学与技术','计科1班',1),
    ('2024015','e10adc3949ba59abbe56e057f20f883e','蒋十七',3,1,'13900139015','2023级','计算机科学与技术','计科2班',1),
    ('2024016','e10adc3949ba59abbe56e057f20f883e','沈十八',3,2,'13900139016','2023级','软件工程','软工1班',1),
    ('2024017','e10adc3949ba59abbe56e057f20f883e','韩十九',3,2,'13900139017','2023级','软件工程','软工2班',1),
    ('2024018','e10adc3949ba59abbe56e057f20f883e','杨二十',3,1,'13900139018','2023级','网络工程','网工1班',1),
    ('2024019','e10adc3949ba59abbe56e057f20f883e','朱二十一',3,1,'13900139019','2023级','数据科学','数据1班',1),
    ('2024020','e10adc3949ba59abbe56e057f20f883e','秦二十二',3,2,'13900139020','2022级','计算机科学与技术','计科1班',1),
    ('2024021','e10adc3949ba59abbe56e057f20f883e','尤二十三',3,2,'13900139021','2022级','软件工程','软工1班',1),
    ('2024022','e10adc3949ba59abbe56e057f20f883e','许二十四',3,1,'13900139022','2022级','网络工程','网工1班',1),
    ('2024023','e10adc3949ba59abbe56e057f20f883e','何二十五',3,1,'13900139023','2022级','数据科学','数据1班',1),
    ('2024024','e10adc3949ba59abbe56e057f20f883e','吕二十六',3,2,'13900139024','2024级','计算机科学与技术','计科2班',1),
    ('2024025','e10adc3949ba59abbe56e057f20f883e','施二十七',3,1,'13900139025','2024级','软件工程','软工2班',1),
    ('2024026','e10adc3949ba59abbe56e057f20f883e','张二十八',3,2,'13900139026','2023级','计算机科学与技术','计科2班',1),
    ('2024027','e10adc3949ba59abbe56e057f20f883e','孔二十九',3,1,'13900139027','2023级','网络工程','网工1班',1),
    ('2024028','e10adc3949ba59abbe56e057f20f883e','曹三十',3,2,'13900139028','2022级','软件工程','软工2班',1),
    ('2024029','e10adc3949ba59abbe56e057f20f883e','严三十一',3,1,'13900139029','2022级','计算机科学与技术','计科1班',1),
    ('2024030','e10adc3949ba59abbe56e057f20f883e','华三十二',3,1,'13900139030','2024级','数据科学','数据1班',1),
    ('2024031','e10adc3949ba59abbe56e057f20f883e','金三十三',3,2,'13900139031','2023级','网络工程','网工1班',1),
    ('2024032','e10adc3949ba59abbe56e057f20f883e','魏三十四',3,1,'13900139032','2022级','数据科学','数据1班',1),
    ('2024033','e10adc3949ba59abbe56e057f20f883e','陶三十五',3,2,'13900139033','2023级','计算机科学与技术','计科1班',1);

-- =====================================================
-- 5. 办理入住（为所有已有和新学生分配床位）
-- =====================================================
-- 辅助：获取床位ID的通用模式（楼栋号 + 房间号 + 床位号）
-- 男生安排至1或3号楼，女生至2或4号楼，并更新床位状态

-- 2024001 张三 (男) → 1号楼 101 1号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='1号楼') AND room_no='101') AND bed_no='1号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024001'), @bed, '2025-08-25 09:30:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024002 李四 (男) → 1号楼 101 2号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='1号楼') AND room_no='101') AND bed_no='2号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024002'), @bed, '2025-08-25 09:35:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024003 王五 (女) → 2号楼 101 1号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='2号楼') AND room_no='101') AND bed_no='1号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024003'), @bed, '2025-08-25 09:40:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024004 陈六 (男) → 1号楼 102 1号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='1号楼') AND room_no='102') AND bed_no='1号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024004'), @bed, '2025-08-25 10:00:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024005 赵七 (男) → 1号楼 102 2号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='1号楼') AND room_no='102') AND bed_no='2号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024005'), @bed, '2025-08-25 10:05:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024006 孙八 (女) → 2号楼 101 2号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='2号楼') AND room_no='101') AND bed_no='2号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024006'), @bed, '2025-08-25 10:10:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024007 周九 (女) → 2号楼 102 1号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='2号楼') AND room_no='102') AND bed_no='1号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024007'), @bed, '2025-08-25 10:15:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024008 吴十 (男) → 1号楼 102 3号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='1号楼') AND room_no='102') AND bed_no='3号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024008'), @bed, '2025-08-25 10:20:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024009 郑十一 (男) → 1号楼 201 1号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='1号楼') AND room_no='201') AND bed_no='1号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024009'), @bed, '2025-08-25 10:25:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024010 王十二 (女) → 2号楼 102 2号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='2号楼') AND room_no='102') AND bed_no='2号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024010'), @bed, '2025-08-25 10:30:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024011 冯十三 (女) → 2号楼 201 1号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='2号楼') AND room_no='201') AND bed_no='1号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024011'), @bed, '2025-08-25 10:35:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024012 陈十四 (男) → 3号楼 101 1号床 (西区男生)
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='3号楼') AND room_no='101') AND bed_no='1号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024012'), @bed, '2025-08-25 11:00:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024013 褚十五 (女) → 4号楼 101 1号床 (南区女生)
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='4号楼') AND room_no='101') AND bed_no='1号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024013'), @bed, '2025-08-25 11:05:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024014 卫十六 (男) → 3号楼 101 2号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='3号楼') AND room_no='101') AND bed_no='2号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024014'), @bed, '2025-08-25 11:10:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024015 蒋十七 (男) → 3号楼 102 1号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='3号楼') AND room_no='102') AND bed_no='1号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024015'), @bed, '2025-08-25 11:15:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024016 沈十八 (女) → 4号楼 101 2号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='4号楼') AND room_no='101') AND bed_no='2号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024016'), @bed, '2025-08-25 11:20:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024017 韩十九 (女) → 4号楼 102 1号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='4号楼') AND room_no='102') AND bed_no='1号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024017'), @bed, '2025-08-25 11:25:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024018 杨二十 (男) → 3号楼 102 2号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='3号楼') AND room_no='102') AND bed_no='2号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024018'), @bed, '2025-08-25 11:30:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024019 朱二十一 (男) → 3号楼 201 1号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='3号楼') AND room_no='201') AND bed_no='1号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024019'), @bed, '2025-08-25 11:35:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024020 秦二十二 (女) → 2号楼 201 2号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='2号楼') AND room_no='201') AND bed_no='2号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024020'), @bed, '2025-08-26 08:30:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024021 尤二十三 (女) → 4号楼 102 2号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='4号楼') AND room_no='102') AND bed_no='2号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024021'), @bed, '2025-08-26 08:35:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024022 许二十四 (男) → 1号楼 201 2号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='1号楼') AND room_no='201') AND bed_no='2号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024022'), @bed, '2025-08-26 08:40:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024023 何二十五 (男) → 1号楼 202 1号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='1号楼') AND room_no='202') AND bed_no='1号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024023'), @bed, '2025-08-26 08:45:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024024 吕二十六 (女) → 4号楼 201 1号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='4号楼') AND room_no='201') AND bed_no='1号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024024'), @bed, '2025-08-26 08:50:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024025 施二十七 (男) → 3号楼 201 2号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='3号楼') AND room_no='201') AND bed_no='2号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024025'), @bed, '2025-08-26 08:55:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024026 张二十八 (女) → 2号楼 202 1号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='2号楼') AND room_no='202') AND bed_no='1号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024026'), @bed, '2025-08-26 09:00:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024027 孔二十九 (男) → 1号楼 202 2号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='1号楼') AND room_no='202') AND bed_no='2号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024027'), @bed, '2025-08-26 09:05:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024028 曹三十 (女) → 4号楼 201 2号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='4号楼') AND room_no='201') AND bed_no='2号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024028'), @bed, '2025-08-26 09:10:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024029 严三十一 (男) → 3号楼 202 1号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='3号楼') AND room_no='202') AND bed_no='1号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024029'), @bed, '2025-08-26 09:15:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024030 华三十二 (男) → 1号楼 301 1号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='1号楼') AND room_no='301') AND bed_no='1号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024030'), @bed, '2025-08-26 09:20:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024031 金三十三 (女) → 2号楼 202 2号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='2号楼') AND room_no='202') AND bed_no='2号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024031'), @bed, '2025-08-26 09:25:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024032 魏三十四 (男) → 3号楼 202 2号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='3号楼') AND room_no='202') AND bed_no='2号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024032'), @bed, '2025-08-26 09:30:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 2024033 陶三十五 (女) → 4号楼 202 1号床
SET @bed = (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='4号楼') AND room_no='202') AND bed_no='1号床');
INSERT INTO dorm_checkin_record (student_id, bed_id, checkin_time, operator_id) VALUES ((SELECT user_id FROM sys_user WHERE username='2024033'), @bed, '2025-08-26 09:35:00', 1);
UPDATE dorm_bed SET bed_status=1 WHERE bed_id=@bed;

-- 部分学生已退宿（用于测试历史记录）
-- 2024005 赵七 退宿
UPDATE dorm_checkin_record SET checkout_time = '2026-01-15 10:00:00', checkin_status = 2 WHERE student_id = (SELECT user_id FROM sys_user WHERE username='2024005');
UPDATE dorm_bed SET bed_status = 0 WHERE bed_id = (SELECT bed_id FROM dorm_checkin_record WHERE student_id = (SELECT user_id FROM sys_user WHERE username='2024005'));

-- 2024010 王十二 退宿
UPDATE dorm_checkin_record SET checkout_time = '2026-02-20 11:00:00', checkin_status = 2 WHERE student_id = (SELECT user_id FROM sys_user WHERE username='2024010');
UPDATE dorm_bed SET bed_status = 0 WHERE bed_id = (SELECT bed_id FROM dorm_checkin_record WHERE student_id = (SELECT user_id FROM sys_user WHERE username='2024010'));

-- 2024020 秦二十二 退宿
UPDATE dorm_checkin_record SET checkout_time = '2026-03-01 12:00:00', checkin_status = 2 WHERE student_id = (SELECT user_id FROM sys_user WHERE username='2024020');
UPDATE dorm_bed SET bed_status = 0 WHERE bed_id = (SELECT bed_id FROM dorm_checkin_record WHERE student_id = (SELECT user_id FROM sys_user WHERE username='2024020'));

-- =====================================================
-- 6. 调宿申请数据（各种状态）
-- =====================================================
-- 申请1：张三(2024001) 申请从 1号楼101-1号床 调到 1号楼102-4号床（空闲） → 待审批
INSERT INTO dorm_move_apply (student_id, original_bed_id, target_bed_id, apply_reason, apply_time, audit_status)
SELECT
    (SELECT user_id FROM sys_user WHERE username='2024001'),
    (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='1号楼') AND room_no='101') AND bed_no='1号床'),
    (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='1号楼') AND room_no='102') AND bed_no='4号床'),
    '作息习惯不同，申请调换', NOW(), 0;

-- 申请2：李四(2024002) 申请从 1号楼101-2号床 调到 3号楼101-3号床（空闲） → 已通过
INSERT INTO dorm_move_apply (student_id, original_bed_id, target_bed_id, apply_reason, apply_time, audit_status, auditor_id, audit_time, audit_opinion)
SELECT
    (SELECT user_id FROM sys_user WHERE username='2024002'),
    (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='1号楼') AND room_no='101') AND bed_no='2号床'),
    (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='3号楼') AND room_no='101') AND bed_no='3号床'),
    '希望与同班同学同住', DATE_SUB(NOW(), INTERVAL 7 DAY), 1,
    (SELECT user_id FROM sys_user WHERE username='admin'), DATE_SUB(NOW(), INTERVAL 5 DAY), '同意调宿';

-- 申请3：陈六(2024004) 申请从 1号楼102-1号床 调到 1号楼102-3号床（已入住吴十） → 已驳回
INSERT INTO dorm_move_apply (student_id, original_bed_id, target_bed_id, apply_reason, apply_time, audit_status, auditor_id, audit_time, audit_opinion)
SELECT
    (SELECT user_id FROM sys_user WHERE username='2024004'),
    (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='1号楼') AND room_no='102') AND bed_no='1号床'),
    (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='1号楼') AND room_no='102') AND bed_no='3号床'),
    '下铺不方便，想换上铺', DATE_SUB(NOW(), INTERVAL 3 DAY), 2,
    (SELECT user_id FROM sys_user WHERE username='dorm001'), DATE_SUB(NOW(), INTERVAL 2 DAY), '目标床位已有人，请重新选择';

-- 申请4：孙八(2024006) 申请从 2号楼101-2号床 调到 4号楼101-3号床（空闲） → 待审批
INSERT INTO dorm_move_apply (student_id, original_bed_id, target_bed_id, apply_reason, apply_time, audit_status)
SELECT
    (SELECT user_id FROM sys_user WHERE username='2024006'),
    (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='2号楼') AND room_no='101') AND bed_no='2号床'),
    (SELECT bed_id FROM dorm_bed WHERE room_id = (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='4号楼') AND room_no='101') AND bed_no='3号床'),
    '希望与好友同楼', NOW(), 0;

-- =====================================================
-- 7. 报修数据
-- =====================================================
-- 报修1：张三 报修房间1号楼101 水电故障 待处理
INSERT INTO dorm_repair (student_id, room_id, repair_type, repair_content, contact_phone, submit_time, repair_status)
SELECT
    (SELECT user_id FROM sys_user WHERE username='2024001'),
    (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='1号楼') AND room_no='101'),
    1, '卫生间水龙头漏水，已渗到楼下', '13900139001', NOW(), 0;

-- 报修2：陈六 报修房间1号楼102 家具损坏 处理中
INSERT INTO dorm_repair (student_id, room_id, repair_type, repair_content, contact_phone, submit_time, repair_status, handler_id)
SELECT
    (SELECT user_id FROM sys_user WHERE username='2024004'),
    (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='1号楼') AND room_no='102'),
    2, '椅子腿断裂，无法使用', '13900139004', DATE_SUB(NOW(), INTERVAL 2 DAY), 1,
    (SELECT user_id FROM sys_user WHERE username='dorm001');

-- 报修3：周九 报修房间2号楼102 门窗故障 已完成
INSERT INTO dorm_repair (student_id, room_id, repair_type, repair_content, contact_phone, submit_time, repair_status, handler_id, handle_result, finish_time)
SELECT
    (SELECT user_id FROM sys_user WHERE username='2024007'),
    (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='2号楼') AND room_no='102'),
    3, '阳台门锁卡死，打不开', '13900139007', DATE_SUB(NOW(), INTERVAL 10 DAY), 2,
    (SELECT user_id FROM sys_user WHERE username='dorm002'), '已更换门锁，恢复正常', DATE_SUB(NOW(), INTERVAL 7 DAY);

-- 报修4：陈十四 报修房间3号楼101 其他 待处理
INSERT INTO dorm_repair (student_id, room_id, repair_type, repair_content, contact_phone, submit_time, repair_status)
SELECT
    (SELECT user_id FROM sys_user WHERE username='2024012'),
    (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='3号楼') AND room_no='101'),
    4, '空调不制冷，夏季急需', '13900139012', NOW(), 0;

-- 报修5：沈十八 报修房间4号楼101 水电故障 处理中
INSERT INTO dorm_repair (student_id, room_id, repair_type, repair_content, contact_phone, submit_time, repair_status, handler_id)
SELECT
    (SELECT user_id FROM sys_user WHERE username='2024016'),
    (SELECT room_id FROM dorm_room WHERE building_id = (SELECT building_id FROM dorm_building WHERE building_no='4号楼') AND room_no='101'),
    1, '洗手池下水堵塞', '13900139016', DATE_SUB(NOW(), INTERVAL 1 DAY), 1,
    (SELECT user_id FROM sys_user WHERE username='dorm004');

-- =====================================================
-- 8. 晚归记录数据
-- =====================================================
-- 晚归1：郑十一 1号楼 晚归
INSERT INTO dorm_late_return (student_id, building_id, late_time, late_reason, registrar_id, record_time)
SELECT
    (SELECT user_id FROM sys_user WHERE username='2024009'),
    (SELECT building_id FROM dorm_building WHERE building_no='1号楼'),
    '2026-06-20 23:35:00', '实验室项目加班',
    (SELECT user_id FROM sys_user WHERE username='dorm001'), NOW();

-- 晚归2：蒋十七 3号楼 晚归
INSERT INTO dorm_late_return (student_id, building_id, late_time, late_reason, registrar_id, record_time)
SELECT
    (SELECT user_id FROM sys_user WHERE username='2024015'),
    (SELECT building_id FROM dorm_building WHERE building_no='3号楼'),
    '2026-06-21 23:50:00', '校外兼职',
    (SELECT user_id FROM sys_user WHERE username='dorm003'), NOW();

-- 晚归3：冯十三 2号楼 晚归
INSERT INTO dorm_late_return (student_id, building_id, late_time, late_reason, registrar_id, record_time)
SELECT
    (SELECT user_id FROM sys_user WHERE username='2024011'),
    (SELECT building_id FROM dorm_building WHERE building_no='2号楼'),
    '2026-06-22 00:15:00', '同学聚会',
    (SELECT user_id FROM sys_user WHERE username='dorm002'), NOW();

-- 晚归4：何二十五 1号楼 未填原因
INSERT INTO dorm_late_return (student_id, building_id, late_time, registrar_id, record_time)
SELECT
    (SELECT user_id FROM sys_user WHERE username='2024023'),
    (SELECT building_id FROM dorm_building WHERE building_no='1号楼'),
    '2026-06-23 23:45:00',
    (SELECT user_id FROM sys_user WHERE username='dorm001'), NOW();

-- 晚归5：陶三十五 4号楼 晚归
INSERT INTO dorm_late_return (student_id, building_id, late_time, late_reason, registrar_id, record_time)
SELECT
    (SELECT user_id FROM sys_user WHERE username='2024033'),
    (SELECT building_id FROM dorm_building WHERE building_no='4号楼'),
    '2026-06-23 23:20:00', '医院陪护',
    (SELECT user_id FROM sys_user WHERE username='dorm004'), NOW();

-- =====================================================
-- 9. 访客登记数据
-- =====================================================
-- 访客1：访问张三(1号楼) 已离开
INSERT INTO dorm_visitor (visitor_name, id_card, student_id, building_id, visit_time, leave_time, visit_reason, registrar_id)
SELECT
    '李华', '410102200001011234',
    (SELECT user_id FROM sys_user WHERE username='2024001'),
    (SELECT building_id FROM dorm_building WHERE building_no='1号楼'),
    '2026-06-20 14:00:00', '2026-06-20 17:00:00', '家长探望',
    (SELECT user_id FROM sys_user WHERE username='dorm001');

-- 访客2：访问孙八(2号楼) 未离开
INSERT INTO dorm_visitor (visitor_name, id_card, student_id, building_id, visit_time, visit_reason, registrar_id)
SELECT
    '王芳', '410102199905054321',
    (SELECT user_id FROM sys_user WHERE username='2024006'),
    (SELECT building_id FROM dorm_building WHERE building_no='2号楼'),
    '2026-06-21 09:30:00', '同学来访',
    (SELECT user_id FROM sys_user WHERE username='dorm002');

-- 访客3：访问陈十四(3号楼) 已离开
INSERT INTO dorm_visitor (visitor_name, id_card, student_id, building_id, visit_time, leave_time, visit_reason, registrar_id)
SELECT
    '张伟', '410102199806152233',
    (SELECT user_id FROM sys_user WHERE username='2024012'),
    (SELECT building_id FROM dorm_building WHERE building_no='3号楼'),
    '2026-06-21 15:00:00', '2026-06-21 18:00:00', '项目讨论',
    (SELECT user_id FROM sys_user WHERE username='dorm003');

-- 访客4：访问褚十五(4号楼) 未离开
INSERT INTO dorm_visitor (visitor_name, id_card, student_id, building_id, visit_time, visit_reason, registrar_id)
SELECT
    '赵静', '410102200112113344',
    (SELECT user_id FROM sys_user WHERE username='2024013'),
    (SELECT building_id FROM dorm_building WHERE building_no='4号楼'),
    '2026-06-22 10:00:00', '送材料',
    (SELECT user_id FROM sys_user WHERE username='dorm004');

-- 访客5：访问韩十九(4号楼) 已离开
INSERT INTO dorm_visitor (visitor_name, id_card, student_id, building_id, visit_time, leave_time, visit_reason, registrar_id)
SELECT
    '刘洋', '410102199707075566',
    (SELECT user_id FROM sys_user WHERE username='2024017'),
    (SELECT building_id FROM dorm_building WHERE building_no='4号楼'),
    '2026-06-23 13:00:00', '2026-06-23 15:30:00', '社团活动',
    (SELECT user_id FROM sys_user WHERE username='dorm004');

-- =====================================================
-- 测试数据生成完毕
-- =====================================================
SELECT '测试数据插入成功！当前共', COUNT(*), '名学生' FROM sys_user WHERE role_type=3;