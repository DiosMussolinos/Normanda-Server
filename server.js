//Importing libs\\
const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const mysql = require('mysql2');

//////////VARIABLES\\\\\\\\\\\
const port = 3909;
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

//GET USERS --WORKING
app.get('/users', function(req, res){
    let sql = `SELECT * FROM users`;
    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
        res.json({results})
        console.log(results);
    })
});

//GET PLAYER INFO - life - level - exp - gold --TESTAR 
app.post('/playerInfo', function(req, res){
    let sql = "SELECT * FROM player_info WHERE user_id = " + req.body.user_id +";"
    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
        res.json({results})
        console.log(results);
    })
});

//GET INVENTORY --TESTAR
app.get('/callInvetory', function(req, res, next){
    let sql = "CALL GetInventory("+ req.body.user_id + ");"
    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
        res.send(results[0])
        console.log(results);
    })
});

//BUY -- TESTAR
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
            message: item_id + " Added"
        })
    })
});

//GET PLAYER INFO - life - level - exp - gold --TESTAR 
app.post('/playerInfo', function(req, res){
    let sql = "SELECT * FROM player_info WHERE user_id = " + req.body.user_id +";"
    dbase.query(sql, function(err, results, fields){
        if(err) throw err;
        res.json({results})
        console.log(results);
    })
});

//Register\\ -- WORKING
app.post('/newPlayer', function(req, res){
    let sql = 'INSERT INTO users(user_name, user_password) VALUES (?);'
    let values = [
        req.body.user_name,
        req.body.user_password
    ];

    dbase.query(sql, [values], function(err, data, fields){
        if(err) throw err;
        res.json({
            message: "New Player Added Successfully"
        })
    })
});


//Login\\ -- WORKING
app.post('/login', function(req, res){
    let sql = 'SELECT * FROM users WHERE user_name ="' + req.body.user_name + '" AND user_password = "' + req.body.user_password +'";'
    let values = [
        req.body.user_name,
        req.body.user_password
    ]

    dbase.query(sql, function(err, data, fields){
        if(err) throw err;
        res.json({
            message: "loged as "+ values[0] +" with password "+ values[1]
        })
    })

})


// -- Add Assincronos TIMER do app
// Timer = true Pega Valor do timer e transforma em ms
