#定义一个存储过程的sql脚本



delimiter $$
CREATE PROCEDURE delete_matches(IN p_playerno INTEGER)
BEGIN
DELETE FROM MATCHES
WHERE playerno = p_playerno;
END$$
delimiter ;


