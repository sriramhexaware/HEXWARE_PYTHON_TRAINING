
db.collection("orders")

db.orders.insertMany([
    { orderId: 1, status: "Pending" },
    { orderId: 2, status: "Pending" },
    { orderId: 3, status: "Completed" },
    { orderId: 4, status: "Processing" },
    { orderId: 5, status: "Completed" }
]);

//Create MongoDB view

db.createView(
    "order_status_counts",
    "orders",
    [
        {
            $group: {
                _id: "$status",
                totalOrders: { $sum: 1 }
            }
        }
    ]
);

db.order_status_counts.find();