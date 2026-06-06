-- ==============================================================================
-- 数据库重置脚本 - 重置试题和试卷数据
-- 用途：清空所有试题、试卷及相关数据，让ID重新从1开始
-- ==============================================================================

USE need_to_do;

-- 警告提示
SELECT '================================================================' AS '';
SELECT '  数据库重置脚本 - 即将清空所有试题和试卷数据！' AS '警告';
SELECT '================================================================' AS '';

-- 禁用外键检查
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================
-- 1. 删除关联数据（按依赖关系顺序）
-- ============================================

-- 删除班级作业答题记录
DELETE FROM quiz_classassignmentrecord;
SELECT '已清空: quiz_classassignmentrecord (班级作业答题记录)' AS '';

-- 删除答题记录
DELETE FROM quiz_answerrecord;
SELECT '已清空: quiz_answerrecord (答题记录)' AS '';

-- 删除错题本
DELETE FROM quiz_wrongquestion;
SELECT '已清空: quiz_wrongquestion (错题本)' AS '';

-- 删除测试记录
DELETE FROM quiz_testrecord;
SELECT '已清空: quiz_testrecord (测试记录)' AS '';

-- 删除班级作业
DELETE FROM quiz_classassignment;
SELECT '已清空: quiz_classassignment (班级作业)' AS '';

-- 删除班级申请
DELETE FROM quiz_classapplication;
SELECT '已清空: quiz_classapplication (班级申请)' AS '';

-- 删除班级管理员
DELETE FROM quiz_classadmin;
SELECT '已清空: quiz_classadmin (班级管理员)' AS '';

-- 先清空用户班级关联（处理外键约束）
UPDATE quiz_profile SET class_obj_id = NULL;
SELECT '已清空: quiz_profile.class_obj_id (用户班级关联)' AS '';

-- 删除班级
DELETE FROM quiz_class;
SELECT '已清空: quiz_class (班级)' AS '';

-- 删除试卷（这个很重要！）
DELETE FROM quiz_testpaper;
SELECT '已清空: quiz_testpaper (试卷)' AS '';

-- 删除题目（这个最重要！）
DELETE FROM quiz_question;
SELECT '已清空: quiz_question (题目)' AS '';

-- 删除知识点
DELETE FROM quiz_knowledgepoint;
SELECT '已清空: quiz_knowledgepoint (知识点)' AS '';

-- 删除小节
DELETE FROM quiz_section;
SELECT '已清空: quiz_section (小节)' AS '';

-- 删除章节
DELETE FROM quiz_chapter;
SELECT '已清空: quiz_chapter (章节)' AS '';

-- 删除学科
DELETE FROM quiz_subject;
SELECT '已清空: quiz_subject (学科)' AS '';

-- ============================================
-- 2. 重置自增ID（让ID重新从1开始）
-- ============================================

ALTER TABLE quiz_answerrecord AUTO_INCREMENT = 1;
ALTER TABLE quiz_wrongquestion AUTO_INCREMENT = 1;
ALTER TABLE quiz_testrecord AUTO_INCREMENT = 1;
ALTER TABLE quiz_classassignmentrecord AUTO_INCREMENT = 1;
ALTER TABLE quiz_classassignment AUTO_INCREMENT = 1;
ALTER TABLE quiz_classapplication AUTO_INCREMENT = 1;
ALTER TABLE quiz_classadmin AUTO_INCREMENT = 1;
ALTER TABLE quiz_class AUTO_INCREMENT = 1;
ALTER TABLE quiz_testpaper AUTO_INCREMENT = 1;
ALTER TABLE quiz_question AUTO_INCREMENT = 1;
ALTER TABLE quiz_knowledgepoint AUTO_INCREMENT = 1;
ALTER TABLE quiz_section AUTO_INCREMENT = 1;
ALTER TABLE quiz_chapter AUTO_INCREMENT = 1;
ALTER TABLE quiz_subject AUTO_INCREMENT = 1;

SELECT '已重置所有自增ID为1' AS '';

-- 重新启用外键检查
SET FOREIGN_KEY_CHECKS = 1;

SELECT '================================================================' AS '';
SELECT '  数据库重置完成！' AS '完成';
SELECT '  所有试题和试卷数据已清空，ID已重置为1' AS '提示';
SELECT '================================================================' AS '';

-- 显示确认信息
SELECT '确认删除的数据统计：' AS '';
SELECT COUNT(*) AS '试题数量' FROM quiz_question;
SELECT COUNT(*) AS '试卷数量' FROM quiz_testpaper;
SELECT COUNT(*) AS '答题记录数量' FROM quiz_answerrecord;
