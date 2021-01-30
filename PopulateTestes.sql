USE Normanda;

SELECT * FROM users;
SELECT * FROM player_info;
SELECT * FROM inventory;
SELECT * FROM war_store;

CALL GetInventory(1);
CALL GetMarket();

CALL LoginAccount("Vergari", "12345");
CALL GetUserHashPass("Victor");

SELECT * FROM inventory where user_id = 1;