http = require('http');

server = http.createServer(
    (request, response) =>
        console.log(request)
        res.writeHead(200, {'Content-Type': 'text/plain'});
        res.end('Ok!\n');
);

server.listen(40000, '127.0.0.1');
console.log("Server is go!");