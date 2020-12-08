const mysql = require('mysql2');

const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    database: 'Normanda',
    password: 'Vergari1'

})


module.exports = connection;