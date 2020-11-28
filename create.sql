DROP SCHEMA IF EXISTS normanda;
CREATE DATABASE IF NOT EXISTS normanda;

use normanda;

CREATE TABLE users(
    user_id         	INT NOT NULL AUTO_INCREMENT,
    user_name         	VARCHAR(255) UNIQUE NOT NULL,
	user_password     	VARCHAR(255) NOT NULL,
    PRIMARY KEY (user_id)
);

CREATE TABLE user_info(
	user_id 		INT NOT NULL,
    user_level 		INT DEFAULT 1,
    user_exp 		INT DEFAULT 0,
    user_gold 		INT DEFAULT 0, #POSSIBLE CHANGE IN THE FUTURE
    user_damage 	INT,
	PRIMARY KEY (user_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id)
);

CREATE TABLE monsters(
	user_id 		INT NOT NULL,
    monster_id	 	INT NOT NULL,
    monsters_killed INT NOT NULL,
    PRIMARY KEY (user_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id)
);

CREATE TABLE war_store(
	item_id 		VARCHAR(10),
    item_price 		INT,
    item_rarity 	INT,
    item_damage 	INT,
    item_defense 	INT,
    PRIMARY KEY (item_id)
);

/*CREATE THE WAR_ITEMS HERE*/
/*CREATE THE WAR_ITEMS HERE*/

CREATE TABLE bar_store(
	item_id 	VARCHAR(10), #3 letters for the the name + 3 for the size
	item_price 	INT,
    item_rarity INT,
    item_health INT,
    PRIMARY KEY (item_id)   
);

/*CREATE THE BAR_ITEMS HERE*/
/*CREATE THE BAR_ITEMS HERE*/

CREATE TABLE inventory(
	item_id		VARCHAR(10),
    item_name 	VARCHAR (255),
	user_id 	INT,
    item_rarity INT,
    FOREIGN KEY (user_id) REFERENCES user_info(user_id),
    FOREIGN KEY (item_id) REFERENCES war_store(item_id),
    FOREIGN KEY (item_id) REFERENCES bar_store(item_id)  
);

/*Triggers*/
DELIMITER $$

/*Procedures*/
/*---------------------------------------------------------------------------------------------------------------------------------*/
/*LEVEL PROCEDURE*/
CREATE PROCEDURE CheckLevel(IN inp_user_id INT)
BEGIN


SET @playerLevel = (
SELECT 
	user_level
FROM
	user_info
WHERE
	user_id = inp_user_id
);

SET @playerExp = (
SELECT
	user_exp
FROM
	user_info
WHERE
	user_id = inp_user_id
);

SET @ReqEXP = 0;

IF @playerLevel = 1 THEN

	SET @ReqEXP = 10 * @playerLevel;

ELSE

	SET @ReqEXP = 10 + (10 * @playerLevel) + (10 * (@playerLevel - 1)); ##FAZER NOVA

END IF;


IF @ReqEXP <= @playerExp THEN
	
	SELECT @playerLevel + 1 AS "yes";
	UPDATE user_info SET user_level = user_level + 1 WHERE user_id = inp_user_id;
    UPDATE user_info SET user_level = user_level - @ReqEXP WHERE user_id = inp_user_id;
    
    
ELSE

	SELECT @restaurantLevel AS "no";

END IF;

END$$

/*---------------------------------------------------------------------------------------------------------------------------------*/
/*GET PLAYER DATA*/

/*---------------------------------------------------------------------------------------------------------------------------------*/
/*GET INVENTORY*/

/*---------------------------------------------------------------------------------------------------------------------------------*/
/*BUY ITEM*/

/*---------------------------------------------------------------------------------------------------------------------------------*/
/*GIVE MONEY TO THE PLAYER*/

/*---------------------------------------------------------------------------------------------------------------------------------*/
/*ADD ITEM IN INVENTORY*/

/*---------------------------------------------------------------------------------------------------------------------------------*/
/*GET PLAYER STATS*/

/*---------------------------------------------------------------------------------------------------------------------------------*/
/*NEW ACCOUNT*/

/*---------------------------------------------------------------------------------------------------------------------------------*/
/*LOGIN*/