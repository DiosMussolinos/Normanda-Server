//Variables\\
    const express = require('express');
    const router = express.Router();
    const dbase = require('./../../database/database');
    
//Variables\\

//Password encryption\\
    const bcrypt = require('bcrypt');
    const saltRounds = 10;
//Password encryption\\

router.post('/login', (req, res, next) => {

    const UserInfo = req.body;

    dbase.query('CALL GetUserHashPass("' + UserInfo.user + '");', (err, results, fields) =>{
        if(err)throw err;

        //Check if the user exists
        if(results[0][0] == undefined){

            res.send([{output: 'Username not found!'}]);

        }else{
            bcrypt.compare(UserInfo.password, results[0][0].pass, function(err, result) {

                if(result){
                    res.send([{output: 'Success', id: results[0][0].id }]);
                }else{
                    res.send([{output: 'The password is incorrect!'}]);
                };

            });
        };



    });
    
});

router.post('/signup', (req, res, next) => {

    //Received information
    let LocalInfo = req.body;

    //Encrypt the password
    bcrypt.genSalt(saltRounds, function(err, salt) {
        bcrypt.hash(LocalInfo.password, salt, function(err, hash) {

            //Call the database
            dbase.query('CALL CreateAccount("' + LocalInfo.username + '", "' + LocalInfo.email + '", "' + hash  + '");' ,(err, results, fields)=>{
                
                //Send feedback to the client
                res.send(results[0]);

            });

        });
    });



       
});
module.exports = router;