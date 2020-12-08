//Importing libs\\
//const http = require('http');
const http = require('http');
const express = require('express');
const app = express();
const path = require('path');
const bodyParser = require('body-parser');

////////////////////CODE FOR CONNECTION TO DATABASE\\\\\\\\\\\\\\\\\\\\\\
const mysql = require('mysql2');

const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    database: 'Normanda',
    password: 'Vergari1'

})

connection.connect((err)=>{
      
    if (err){
        console.log(err);
    };

    console.log('database.js : Database: "NORMANDA" has been conected! ')

});
////////////////////CODE FOR CONNECTION TO DATABASE\\\\\\\\\\\\\\\\\\\\\\

//////////VARIABLES\\\\\\\\\\\
const DefaultPort = 3000;
//////////VARIABLES\\\\\\\\\\\

//Middleware\\
app.use(bodyParser.urlencoded({ extended: false }));

//Login\\
const Login = require("routes","accountServices.js");
app.use('/login', Login);


//Gets\\
//const GetsRoute = require(path.join(__dirname,"Get", "Gets.js"))
//app.use('/get', GetsRoute); 

////Request listener\\\\
app.listen(DefaultPort);