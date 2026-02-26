// Memuat environment variable dari file .env
require('dotenv').config()

const express = require("express");
const app = express();

// Middleware untuk parsing request body dalam format JSON
const bp = require("body-parser");
app.use(bp.json());

// Library AMQP untuk koneksi ke RabbitMQ
const amqp = require("amqplib");
const amqpServer = process.env.AMQP_URL;
var channel, connection;

// Inisialisasi koneksi ke RabbitMQ saat service pertama kali berjalan
connectToQueue();

async function connectToQueue() {
    connection = await amqp.connect(amqpServer);
    channel = await connection.createChannel();
    try {
        const queue = "order";
        // Pastikan queue tersedia (durable: false = default)
        await channel.assertQueue(queue);
        console.log("Connected to the queue!")
    } catch (ex) {
        console.error(ex);
    }
}

// Endpoint POST /order: menerima data order dari client
app.post("/order", (req, res) => {
    const { order } = req.body;
    createOrder(order);
    // Langsung balas client tanpa menunggu shipping diproses (async)
    res.send(order);
});

// Fungsi untuk publish pesan order ke RabbitMQ queue
const createOrder = async order => {
    const queue = "order";
    // Kirim order sebagai JSON string ke queue
    await channel.sendToQueue(queue, Buffer.from(JSON.stringify(order)));
    console.log("Order succesfully created!")
    // Tangani signal shutdown: tutup koneksi RabbitMQ dengan bersih
    process.once('SIGINT', async () => { 
        console.log('got sigint, closing connection');
        await channel.close();
        await connection.close(); 
        process.exit(0);
    });
};

// Jalankan HTTP server di port yang ditentukan di .env
app.listen(process.env.PORT, () => {
    console.log(`Server running at ${process.env.PORT}`);
});
