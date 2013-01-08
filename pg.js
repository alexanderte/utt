var pg = require('pg');

var conString = "tcp://utt:utt@localhost:5433/utt";

var client = new pg.Client(conString);
client.connect();

var query = client.query('insert into message values (7, \'foobar\')');

query.on('end', function(result) {
    console.log(result);

    var query = client.query('select * from message');
    query.on('row', function(row) {
        console.log(row);
    });

    query.on('end', function(result) {
        console.log(result);
    });
});
