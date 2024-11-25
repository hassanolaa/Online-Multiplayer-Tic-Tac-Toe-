


const http = require('http');

const server = http.createServer((req, res) => {
    res.write('<h1>Hello World</h1>');
}  );

server.listen(8080,() =>{
    console.log('Server is running on port 8080');
});