
//__GET SOME STUFF__\\
const express = require('express');
const app = express();
const mysql = require('mysql2');
const path = require('path')
const bodyParser = require('body-parser');

//__Variables__\\
    //Ports
    const port = 3000;
    //Logic Drafts
    //const drafts = require(path.join(__dirname, "User_Pattern", "PatternsForUsers.js"))
    
    //Password for connections
    //const settings = require(path.join(__dirname, "settings.json"));

const connectMysql = () => {

    console.log("CONNECTED!");

    app.listen(port, () => {
        console.log(`Server connected and listening in${port}`);
    })

}

app.use(bodyParser.urlencoded({ extended: false}));

app.use(bodyParser.json());

const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    database: 'Normanda',
    password: 'Vergari1'

})

connection.connect((err) =>{

    if(err){
        console.log(err);
    }
    console.log(`Server connected and listening in${port}`);
    console.log("CONNECTED TO DATABASE");

})
