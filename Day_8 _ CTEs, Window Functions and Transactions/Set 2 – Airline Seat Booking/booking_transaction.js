db.collections("seats")
db.collections("bookings")

db.seats.insertMany([
    { seatId: 1, flightId: 101, seatNumber: "A1", status: "AVAILABLE" },
    { seatId: 2, flightId: 101, seatNumber: "A2", status: "AVAILABLE" },
    { seatId: 3, flightId: 101, seatNumber: "A3", status: "BOOKED" }
]);

db.bookings.insertOne({
    bookingId: 1001,
    passengerName: "Arun",
    flightId: 101,
    seatId: 3,
    fare: 5000
});


async function bookSeat() {

    try {

        try {
            await session.withTransaction(async () => {

                const seat = await seats.findOne(
                    { seatId: 1, status: "AVAILABLE" },
                    { session }
                );

                if (!seat)
                    throw new Error("Seat unavailable");

                await seats.updateOne(
                    { seatId: 1, status: "AVAILABLE" },
                    { $set: { status: "BOOKED" } },
                    { session }
                );

                await bookings.insertOne(
                    {
                        bookingId: 1002,
                        passengerName: "Rahul",
                        flightId: 101,
                        seatId: 1,
                        fare: 4500,
                        bookingDate: new Date()
                    },
                    { session }
                );

            });

            console.log("Seat booked successfully");

        } finally {
            await session.endSession();
        }

    } catch (error) {
        console.log("Booking failed:", error.message);

    } finally {
        await client.close();
    }
}

bookSeat();