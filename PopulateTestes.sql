USE Normanda;

SELECT * FROM users;
SELECT * FROM player_info;
SELECT * FROM inventory;
SELECT * FROM war_store;
 
CALL GetInventory(1);
CALL GetMarket();

CALL LoginAccount("Vergazri", "12345");
CALL GetUserHashPass("Victor");
SELECT * FROM player_info WHERE user_id = 1;
#INSERT 500 INTO user_exp FROM player_info WHERE user_id = 1;
#insert SUM(player_exp)(500) FROM player_info WHERE user_id = 1;
#REPLACE INTO player_info(user_hp) VALUES(25)  user_id = 1;
INSERT INTO player_info(user_hp) VALUES (25);

UPDATE player_info SET user_exp = 75 WHERE user_id = 1;