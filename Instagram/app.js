var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var http = require('http');
var util = require('util');

var routes = require('./routes/index');
var users = require('./routes/users');

var app = express();

var ig = require('instagram-node').instagram();


// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', routes);
app.use('/users', users);



ig.use({access_token: '297266256.fe47d68.bb30e96cfded469b8191bde503bdce1f' });
//ig.use({ client_id: 'fe47d68a984f4fcfb52ae4c213769a5c',
  //       client_secret: '56303f61f4834898a9bb5859ac144bb9' });

// ig.user('297266256', function(err, user, remaining, limit) {

  // console.log(err);
  // console.log(user);
  // console.log(remaining);
  // console.log(limit);
  // console.log(ig.user);
// });

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

http.createServer(function (req, res) {
  
  ig.user_media_recent('297266256', function(err, medias, pagination, remaining, limit){

  //console.log(err);
  //console.log(medias);
  mediaObject = util.inspect(medias, false, null);


  
  var html = buildHtml(mediaObject);

  console.log(mediaObject);
  
  res.writeHead(200, {

    'Content-Type': 'text/html',
    'Content-Length': html.length,
    'Expires': new Date().toUTCString()
    
  });

  res.end(html);

  });

}).listen(3000);

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.render('error', {
    message: err.message,
    error: {}
  });
});

//app.listen(3000);

module.exports = app;

function buildHtml(med) {
  var header = 'HEY';
  var body = med;

  // concatenate header string
  // concatenate body string

  return '<!DOCTYPE html>'
       + '<html><header>' + header + '</header><body>' + body + '</body></html>';
};
