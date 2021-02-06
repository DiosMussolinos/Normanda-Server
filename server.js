//Importing libs\\
const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const mysql = require('mysql2');

//////////VARIABLES\\\\\\\\\\\
const port = 3909;

//Challenge Variable -- Starting Points
var Challenge = false;
var ChallengeTime = 0;
var EnemiesMustKill = 0;
var EnemiesKilled = 0;
//////////VARIABLES\\\\\\\\\\\

app.use(bodyParser.urlencoded({ extended:false}))

app.use(bodyParser.json())

////////////////////CODE FOR CONNECTION TO DATABASE\\\\\\\\\\\\\\\\\\\\\\
const dbase = mysql.createConnection({
    host: "localhost",
    port: "3999",
    user: 'root',
    database: 'Normanda',
    password: 'Vergari1'
});

dbase.connect((err)=>{
    if (err){
        console.log(err);
    };
    console.log('database.js : Database: "NORMANDA" has been conected! ')
});
////////////////////CODE FOR CONNECTION TO DATABASE\\\\\\\\\\\\\\\\\\\\\\

////Request listener\\\\
app.listen(port, function(){console.log(`Listening at ${port}`)});



////////////////////GETS && POSTS\\\\\\\\\\\\\\\\\\\\\\
///////////////USERS RELATED\\\\\\\\\\\\\\\\\
//GET USERS --WORKING
app.get('/users', function(req, res){
    let sql = `SELECT * FROM users`;
    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
        res.json({results})
    })
});

//GET PLAYER INFO - life - level - exp - gold --WORKING 
app.post('/playerInfo', function(req, res){
    console.log(req.body);
    let sql = `SELECT * FROM player_info WHERE user_id = ` + req.body.user_id +`;`
    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
        //res.send({results})
        console.log(results);
        res.end(JSON.stringify(results[0]))
    })
});

//Life Points
app.post('/playerInfoLife', function(req, res){
    let sql = "SELECT player_info.user_hp FROM player_info WHERE user_id = " + req.body.user_id +";"
    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
        //res.json({results})
        //console.log(results);
        res.end(JSON.stringify(results[0].user_hp))
    })
});

//Level
app.post('/playerInfoLevel', function(req, res){
    let sql = "SELECT player_info.user_level FROM player_info WHERE user_id = " + req.body.user_id +";"
    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
        //res.json({results})
        res.end(JSON.stringify(results[0].user_level))
    })
});

//Exp
app.post('/playerInfoExp', function(req, res){
    let sql = "SELECT player_info.user_exp FROM player_info WHERE user_id = " + req.body.user_id +";"
    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
        res.end(JSON.stringify(results[0].user_exp))
    })
});

//Gold
app.post('/playerInfoGold', function(req, res){
    let sql = "SELECT player_info.user_gold FROM player_info WHERE user_id = " + req.body.user_id +";"
    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
        res.end(JSON.stringify(results[0].user_gold))
    })
});


///////////////UPDATE INFORMATION - LIFE, GOLD, EXP, LEVEL\\\\\\\\\\\\\\\\\
app.post('/updateLife', function(req, res){
    let sql = "UPDATE player_info SET user_hp = "+ req.body.user_hp +" WHERE user_id = " + req.body.user_id + ";"
 
    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
    })
});

app.post('/updateLevel', function(req, res){
    let sql = "UPDATE player_info SET user_level = "+ req.body.user_level +" WHERE user_id = " + req.body.user_id + ";"

    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
    })
});

app.post('/updateExp', function(req, res){
    let sql = "UPDATE player_info SET user_exp = "+ req.body.user_exp +" WHERE user_id = " + req.body.user_id + ";"
    
    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
    })
});

app.post('/updateGold', function(req, res){
    let sql = "UPDATE player_info SET user_gold = "+ req.body.user_gold +" WHERE user_id = " + req.body.user_id + ";"
    
    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
    })
});

///////////////UPDATE INFORMATION - LIFE, GOLD, EXP, LEVEL\\\\\\\\\\\\\\\\\


///////////////LOGIN/REGISTER RELATED\\\\\\\\\\\\\\\\\
//Register\\ -- WORKING
app.post('/newPlayer', function(req, res){
    let sql = "CALL CreateAccount(?);"
    let values = [
        req.body.user_name,
        req.body.user_password
    ];

    dbase.query(sql, [values], function(err, results, fields){
        if(err) throw err;
        res.json({
            message: "New Player Added Successfully"
        })
    })

    
});

//Login\\ -- WORKING
app.post('/login', function(req, res){
    let sql = "SELECT * FROM users WHERE user_name ='" + req.body.user_name + "' AND user_password = '" + req.body.user_password + "';"

    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
    
        if(results.length <= 0)
        {
            //res.send(null);
            res.send({message: "Senha errada"})
        }
        else
        {
            res.end(JSON.stringify(results[0]))
        } 
    })
})

//Login\\ -- WORKING
app.post('/loginUnity', function(req, res){
    let sql = "SELECT * FROM users WHERE user_name ='" + req.body.user_name + "' AND user_password = '" + req.body.user_password + "';"

    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
    
        if(results.length <= 0)
        {
            res.send(null);
            res.send({message: "Senha errada"})
        }
        else
        {
            res.end(JSON.stringify(results[0].user_id))
        } 
    })
})
///////////////LOGIN/REGISTER RELATED\\\\\\\\\\\\\\\\\

///////////////ITEMS RELATED RELATED\\\\\\\\\\\\\\\\\
//GET INVENTORY -- WORKING
app.post('/callItemId', function(req, res, next){
    let sql = "CALL GetInventory("+ req.body.user_id + ");"
    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
        res.send(results[0].item_id)
        //res.json({message: "ITEM" + req.body[0].item_id})
        res.end(JSON.stringify(results[0].item_id))
    })
});

app.post('/callItemAmount', function(req, res, next){
    let sql = "CALL GetInventory("+ req.body.user_id + ");"
    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
        res.send(results)
        res.end(JSON.stringify(results.item_amount))
    })
});

//BUY -- WORKING
app.post('/buyItem', function(req, res, next){ 
    let sql = `INSERT INTO inventory(user_id, item_id, item_amount) VALUES (?);`;
    let values = [
        req.body.user_id,
        req.body.item_id,
        req.body.item_amount
    ];
    dbase.query(sql, [values], function(err, results, fields){
        if(err) throw err;
        res.json({
            message: req.body.item_id + " Added"
        })
        res.send({results})
    })
});

app.post('/ChallengeToTrue', function(req, res, next){
        Challenge = req.body.Challenge;
        ChallengeTime = req.body.ChallengeTime;
        EnemiesMustKill = req.body.EnemiesKilled;

        if(err) throw err;
        res.json({

            message: ChallengeTime + " minutes to finish"
        })

})

app.get('/ChallengeAnswer', function (req, res, next){
        Challenge = req.body.Challenge;
        ChallengeTime = req.body.ChallengeTime;
        EnemiesMustKill = req.body.EnemiesKilled;
        if(err) throw err;
        res.json({

            message: ChallengeTime + " minutes to finish"
        })
})



///////////////CHALLENGE\\\\\\\\\\\\\\\\\
if(Challenge = true && ChallengeTime > 0)
{
    EnemiesMustKill = ChallengeTime * 2;

    setTimeout(function () {     
        if(EnemiesKilled >= EnemiesMustBeKilled){
            app.post('/ChallengeWin', function(req, res, nest){
                let sql ="UPDATE player_info SET user_exp = "+ req.body.user_exp +" WHERE user_id = " + req.body.user_id + ";"

                dbase.query(sql, function(err, results, fields){
                    if(err) throw err;
                })

            })
        }
        
    }, ChallengeTime * 1000 * 60);

}
else
{
    Challenge = false;
    EnemiesMustKill = 0;
}