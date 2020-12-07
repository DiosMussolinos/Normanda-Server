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
    item_available 	BOOL,
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
    user_id 	INT,
    item_name 	VARCHAR (255),
    item_amount INT,
    item_rarity INT,
    item_available BOOL,
    FOREIGN KEY (user_id) REFERENCES player_info(user_id),
    FOREIGN KEY (item_id) REFERENCES war_store(item_id),
    FOREIGN KEY (item_id) REFERENCES bar_store(item_id)  
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

	SET @ReqEXP = 10 + (3 * @playerLevel) + (3 * (@playerLevel - 1)); 

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
	p.user_level as 'level', p.user_exp as 'experience', p.user_gold as 'gold', p.user_damage as 'damage' 
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
/*GET BAR MARKET*/
CREATE PROCEDURE BarMarket()
BEGIN

SELECT 
	* 
FROM 
	bar_store;

END$$


/*---------------------------------------------------------------------------------------------------------------------------------*/
/*GET WAR MARKET*/
CREATE PROCEDURE GetIngredients()
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
/*BUY ITEM*/
/*CREATE PROCEDURE BuyIngredient(IN inspec_userid INT, IN inspec_price INT, IN ingrdt_id VARCHAR(8), IN purchaseAmount INT)
BEGIN

SET @CheckIfEnoughMoney = (

SELECT COUNT(1)
FROM restaurant
WHERE user_id = inp_userid AND inp_price <= res_money
    
);

#Check if the user has enough gold
IF @CheckIfEnoughMoney > 0 THEN
	
	SET @CheckIfHasIngredient = (
    
    SELECT COUNT(1) 
    FROM ingredients_inventory 
    WHERE user_id = inp_userid AND ingredient_id = ingrdt_id
    
    );
	
    #Decrease the gold
    UPDATE restaurant SET res_money = res_money - inp_price WHERE user_id = inp_userid;
    
    #Check if he has the item
    IF @CheckIfHasIngredient > 0 THEN
		
        #Increase the amount
        UPDATE ingredients_inventory SET ingredient_amount = ingredient_amount + purchaseAmount 
        WHERE user_id = inp_userid AND ingredient_id = ingrdt_id;
        
        #Throw some feedback to the user
		SELECT CONCAT('You now have: ', ingredient_amount) AS 'output'
        FROM ingredients_inventory
        WHERE user_id = inp_userid AND ingredient_id = ingrdt_id;
	
    #if he never had this item
	ELSE
    
		#Create the ingredient and add the amount
		INSERT INTO ingredients_inventory (user_id, ingredient_id, ingredient_amount) 
        VALUES (inp_userid, ingrdt_id, purchaseAmount);
        
        #Throw some feedback to the user
		SELECT CONCAT('You now have: ', ingredient_amount) AS 'output'
        FROM ingredients_inventory
        WHERE user_id = inp_userid AND ingredient_id = ingrdt_id;		
        
    END IF;
	
ELSE

	#If gold <<
	SELECT 'Not eneough gold!' AS 'output';

END IF;

END$$*/

/*---------------------------------------------------------------------------------------------------------------------------------*/
/*ADD ITEM IN INVENTORY*/
CREATE PROCEDURE AddItemInventory(IN inspec_itemid VARCHAR(10), IN inspec_userid INT, IN inspec_itemamount INT)
BEGIN

INSERT INTO inventory(item_id, user_id, item_amount)
VALUES(inspec_itemid, inspec_userid, inspec_itemamount);

END$$ 