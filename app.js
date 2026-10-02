const express = require('express');
const app = express();

const PORT = 3001;

app.get('/', (req, res) => {
    res.send('Node.js application running with PM2 and Nginx new updated script to check');
});

app.get('/health', (req, res) => {
    res.json({ status: 'OK' });
});

app.listen(PORT, '127.0.0.1', () => {
    console.log(`App running on port ${PORT}`);
});
