DROP SCHEMA IF EXISTS normanda;
CREATE DATABASE IF NOT EXISTS normanda;

use normanda;

CREATE TABLE users(
    user_id         	INT NOT NULL AUTO_INCREMENT,
    user_name         	VARCHAR(255) UNIQUE NOT NULL,
	user_password     	VARCHAR(255) NOT NULL,
    PRIMARY KEY (user_id)
);

CREATE TABLE player_info(
	user_id 		INT NOT NULL,
    user_hp			INT DEFAULT 100,
    user_level 		INT DEFAULT 1,
    user_exp 		INT DEFAULT 0,
    user_gold 		INT DEFAULT 0 DEFAULT 200, #POSSIBLE CHANGE IN THE FUTURE
	PRIMARY KEY (user_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id)
);

CREATE TABLE war_store(
	item_id 		VARCHAR(10),
    item_price 		INT,
    item_damage 	INT,
    item_shield 	INT,
    item_life		INT,
    PRIMARY KEY (item_id)
);

/*///////////////////////CREATE THE WAR_ITEMS HERE///////////////////////*/
#$ SWORDS $#
INSERT INTO  war_store(item_id, item_price, item_damage, item_shield, item_life) VALUES('SicSwo',10,5,0,0); #Basic Sword
INSERT INTO  war_store(item_id, item_price, item_damage, item_shield, item_life) VALUES('IerSwo',20,10,0,0); #Radier Sword
INSERT INTO  war_store(item_id, item_price, item_damage, item_shield, item_life) VALUES('ArdSwo',30,15,0,0); #Bastard Sword
INSERT INTO  war_store(item_id, item_price, item_damage, item_shield, item_life) VALUES('OreSwo',40,20,0,0); #Claymore Sword

#$ SHIELDS $#
INSERT INTO  war_store(item_id, item_price, item_damage, item_shield, item_life) VALUES('SicShi',10,0,5,0); #Basic Shield
INSERT INTO  war_store(item_id, item_price, item_damage, item_shield, item_life) VALUES('RilShi',20,0,10,0); #Nombril Shield
INSERT INTO  war_store(item_id, item_price, item_damage, item_shield, item_life) VALUES('EonShi',30,0,15,0); #Escucheon Shield
INSERT INTO  war_store(item_id, item_price, item_damage, item_shield, item_life) VALUES('MerShi',40,0,20,0); #Mortimer Shield

#$ POTION $#
INSERT INTO  war_store(item_id, item_price, item_damage, item_shield, item_life) VALUES('AllPot',5,0,0,5); #Tall Potion
INSERT INTO  war_store(item_id, item_price, item_damage, item_shield, item_life) VALUES('NtiPot',15,0,0,15); #Venti Potion
INSERT INTO  war_store(item_id, item_price, item_damage, item_shield, item_life) VALUES('NtaPot',50,0,0,30); #Tall Potion

#$TREASURE MAPS$#
INSERT INTO  war_store(item_id, item_price, item_damage, item_shield, item_life) VALUES('MapN2',0,0,0,0); #Map To N2
INSERT INTO  war_store(item_id, item_price, item_damage, item_shield, item_life) VALUES('MapN3',0,0,0,0); #Map To N3
/*///////////////////////CREATE THE WAR_ITEMS HERE///////////////////////*/

CREATE TABLE inventory(
	user_id 	INT,
	item_id		VARCHAR(10),
    item_amount INT,
    FOREIGN KEY (user_id) REFERENCES player_info(user_id),
    FOREIGN KEY (item_id) REFERENCES war_store(item_id)
);

/*Triggers*/
DELIMITER $$

/*Procedures*/
/*---------------------------------------------------------------------------------------------------------------------------------*/
/*LEVEL PROCEDURE*/

CREATE PROCEDURE CheckLevel(IN inspec_user_id INT)
BEGIN


SET @playerLevel = (
SELECT 
	user_level
FROM
	player_info
WHERE
	user_id = inspec_user_id
);

SET @playerExp = (
SELECT
	user_exp
FROM
	player_info
WHERE
	user_id = inspec_user_id
);

SET @ReqEXP = 0;

IF @playerLevel = 1 THEN

	SET @ReqEXP = 10 * @playerLevel;

ELSE

	SET @ReqEXP = 10 + (3 * @playerLevel) + (3 * (@playerLevel - 1)); ##FAZER NOVA

END IF;


IF @ReqEXP <= @playerExp THEN
	
	SELECT @playerLevel + 1 AS "yes";
	UPDATE player_info SET user_level = user_level + 1 WHERE user_id = inspec_user_id;
    UPDATE player_info SET user_level = user_level - @ReqEXP WHERE user_id = inspec_user_id;
    
    
ELSE

	SELECT @restaurantLevel AS "no";

END IF;

END$$

/*---------------------------------------------------------------------------------------------------------------------------------*/
/*GET PLAYER DATA*/
CREATE PROCEDURE GetPlayerInformation(IN inspec_user_id INT)
BEGIN
SELECT
	p.user_level as 'level', p.user_exp as 'experience', p.user_gold as 'gold' 
FROM
	player_info
WHERE
	user_id = inspec_user_id;
    
END$$


/*---------------------------------------------------------------------------------------------------------------------------------*/
/*NEW ACCOUNT*/
CREATE PROCEDURE CreateAccount(IN inspec_username VARCHAR(255), IN inspec_email VARCHAR(255), IN inspec_password VARCHAR(255))
BEGIN

SET @CheckIfUsernameExists = (

SELECT
	COUNT(1)
FROM
	users
WHERE
	user_name = inspec_username

);

		/*SET @CheckIfEmailExists = (

		SELECT
			COUNT(1)
		FROM
			users
		WHERE
			user_email = inp_email

		);*/

#First check if username already exists
IF @CheckIfUsernameExists > 0 THEN
	
    SELECT 'Username already exists!' as 'output';
		/*
		#Check if the email already exists		
		ELSEIF @CheckIfEmailExists > 0 THEN
				
			SELECT 'Email already exists!' as 'output';
		  */  
ELSE
	
    #Add into the database
	INSERT INTO Normanda.users(user_password, user_name)
    VALUES(inspec_password, inspec_username);
    SELECT 'done' as 'output', user_id as 'id'
    FROM users WHERE user_name = inspec_username;
    
END IF;

END$$


/*---------------------------------------------------------------------------------------------------------------------------------*/
/*LOGIN*/
CREATE PROCEDURE LoginAccount(IN inspec_username VARCHAR(255), IN inspec_password VARCHAR(255))
BEGIN

SET @CheckIfUsernameExists = (

SELECT
	COUNT(1)
FROM
	users
WHERE
	inspec_username = user_name

);

SET @CheckIfPasswordCorrect = (

SELECT
	COUNT(1)
FROM
	users
WHERE
	inspec_username = user_name AND inspec_password = user_password

);

#Check if the user exists
IF @CheckIfUsernameExists = 0 THEN

SELECT 'Username not found!' AS 'output';

#Check if the password is correct
ELSEIF @CheckIfPasswordCorrect = 0 THEN

SELECT 'The password is incorrect!' AS 'output';

ELSE

SELECT user_id AS 'output'
FROM 
	users
WHERE
	inspec_username = user_name AND inspec_password = user_password;

END IF;

END$$

/*---------------------------------------------------------------------------------------------------------------------------------*/
/*CRYPTO THE ACCOUNT --BEST HACKER*/
CREATE PROCEDURE GetUserHashPass(IN name_inspec VARCHAR(255))
BEGIN

SELECT 
	user_password AS "pass", user_id AS "id" 
FROM 
	users 
WHERE 
	user_name = name_inspec;

END$$

/*---------------------------------------------------------------------------------------------------------------------------------*/
/*GET WAR MARKET*/
CREATE PROCEDURE GetMarket()
BEGIN

SELECT 
	* 
FROM 
	war_store;

END$$

/*---------------------------------------------------------------------------------------------------------------------------------*/
/*GET INVENTORY BY ID*/
CREATE PROCEDURE GetInventory(IN inspec_userid INT)
BEGIN

SELECT 
	* 
FROM 
	inventory 
WHERE 
	user_id = inspec_userid;

END$$


/*---------------------------------------------------------------------------------------------------------------------------------*/


/*---------------------------------------------------------------------------------------------------------------------------------*/
/*ADD ITEM IN INVENTORY*/
CREATE PROCEDURE AddItemInventory(IN inspec_itemid VARCHAR(10), IN inspec_userid INT, IN inspec_itemamount INT)
BEGIN

INSERT INTO inventory(item_id, user_id, item_amount)
VALUES(inspec_itemid, inspec_userid, inspec_itemamount);

END$$ 