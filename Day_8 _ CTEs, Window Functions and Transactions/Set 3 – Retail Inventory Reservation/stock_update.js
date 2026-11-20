

db.products.updateOne(
    { productId: 1 },
    {
        $setOnInsert: {
            productName: "Laptop",
            stock: 10
        }
    },
    { upsert: true }
);

db.products.updateOne(
    {
        productId: 1,
        stock: { $gte: 2 }
    },
    {
        $inc: { stock: -2 }
    }
);


db.products.findOne({ productId: 1 });