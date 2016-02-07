var Twitter = require('twitter');
 
var client = new Twitter({
  consumer_key: 'C0QDJqIUikCx5sMITrBonF0do',
  consumer_secret: 'ixiAiJkDH0R5mOyawFyCXarJJ1gd6l7G6q7VzWV7fRw5tVdYSC',
  access_token_key: '33072442-pgFQXsJW5Yexp7G1VtDvuU5n0tia7OxTbspLudvEq',
  access_token_secret: 'IozDWwtyUug1Sx0WaLQq5XHOI7tKBMEXgBIKMRR2mGj43'
});







client.stream('statuses/filter', {track: 'Worldstar'},  function(stream){
  stream.on('data', function(tweet) {
    console.log(tweet.text);
  });

  stream.on('error', function(error) {
    console.log(error);
  });
});



