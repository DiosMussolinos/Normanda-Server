USE Normanda;

INSERT INTO users(user_name ,user_password) VALUES ( 'printerMLG' , '$2b$10$0Q/ARI.ZVuNCOs5JNWRYi.JabTEqMkHtW0DDV1p9RaYykZsYmCYZK');
INSERT INTO users(user_name ,user_password) VALUES ( '12313' , '$2b$10$0Q/ARI.ZVuNCOs5JNWRYi.JabTEqMkHtW0DDV1p9RaYykZsYmCYZK');
INSERT INTO users(user_name ,user_password) VALUES ( 'prin2131233terMLG' , '$2b$10$0Q/ARI.ZVuNCOs5JNWRYi.JabTEqMkHtW0DDV1p9RaYykZsYmCYZK');
INSERT INTO users(user_name ,user_password) VALUES ( 'prin312312terMLG' , '$2b$10$0Q/ARI.ZVuNCOs5JNWRYi.JabTEqMkHtW0DDV1p9RaYykZsYmCYZK');
INSERT INTO users(user_name ,user_password) VALUES ( 'prin2311323terMLG' , '$2b$10$0Q/ARI.ZVuNCOs5JNWRYi.JabTEqMkHtW0DDV1p9RaYykZsYmCYZK');
INSERT INTO users(user_name ,user_password) VALUES ( '13221312132' , '$2b$10$0Q/ARI.ZVuNCOs5JNWRYi.JabTEqMkHtW0DDV1p9RaYykZsYmCYZK');

INSERT INTO player_info(user_id, user_level, user_exp, user_gold) VALUES (1,2,5500,200);
INSERT INTO inventory(user_id, item_id, item_amount) VALUES (1,'SicShi',200);
INSERT INTO inventory(user_id, item_id, item_amount) VALUES (1,'MapN2',200);
INSERT INTO inventory(user_id, item_id, item_amount) VALUES (1,'MapN3',200);

SELECT * users WHERE user_name ="Vergari" AND user_password = "SomeShit";

SELECT * FROM users;
SELECT * FROM player_info;
SELECT * FROM inventory;
SELECT * FROM war_store;

CALL GetInventory(1);

SELECT * FROM inventory where user_id = 1;