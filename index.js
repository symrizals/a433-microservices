// Memuat environment variable dari file .env
require('dotenv').config()

const express = require("express");
const app = express();

const bp = require("body-parser");

// Library AMQP untuk koneksi ke RabbitMQ
const amqp = require("amqplib");
const amqpServer = process.env.AMQP_URL;
var channel, connection;

// Inisialisasi koneksi ke RabbitMQ dan mulai consume pesan
connectToQueue();

async function connectToQueue() {
    try {
        connection = await amqp.connect(amqpServer);
        channel = await connection.createChannel();
        // Pastikan queue "order" tersedia sebelum consume
        await channel.assertQueue("order");
        // Mulai mendengarkan pesan yang masuk ke queue "order"
        channel.consume("order", data => {
            // Tampilkan isi pesan order yang diterima
            console.log(`Order received: ${Buffer.from(data.content)}`);
            console.log("** Will be shipped soon! **\n")
            // Kirim acknowledgement: pesan berhasil diproses
            channel.ack(data);
        });
    } catch (ex) {
        console.error(ex);
    }
}

// Jalankan HTTP server di port yang ditentukan di .env
app.listen(process.env.PORT, () => {
    console.log(`Server running at ${process.env.PORT}`);
});
