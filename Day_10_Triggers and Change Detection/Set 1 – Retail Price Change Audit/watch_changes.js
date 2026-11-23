

db.products.insertMany([
    {
        product_id: 1,
        product_name: "Laptop",
        price: 50000
    },
    {
        product_id: 2,
        product_name: "Keyboard",
        price: 800
    },
    {
        product_id: 3,
        product_name: "Mouse",
        price: 350
    }
])

db.products.find()

const { MongoClient } = require("mongodb");

const uri = process.env.MONGODB_URI;

if (!uri) {
    throw new Error("Please configure MONGODB_URI");
}

const client = new MongoClient(uri);

async function watchPriceChanges() {

    try {

        await client.connect();

        console.log("Connected to MongoDB");

        const database = client.db("retail_db");

        const collection = database.collection("products");

        // Open Change Stream
        const changeStream = collection.watch([], {
            fullDocument: "updateLookup"
        });

        console.log("Watching for product price changes...");

        // Listen for changes
        changeStream.on("change", (change) => {

            if (
                change.operationType === "update" &&
                change.updateDescription.updatedFields.price !== undefined
            ) {

                console.log("\nPrice Change Detected!");

                console.log("Product ID:", change.documentKey._id);

                console.log(
                    "New Price:",
                    change.updateDescription.updatedFields.price
                );

                console.log("Full Document:", change.fullDocument);
            }

            else if (change.operationType === "replace") {

                console.log("\nProduct Document Replaced!");

                console.log("Product ID:", change.documentKey._id);

                console.log("Current Price:", change.fullDocument?.price);
            }

        });

        // Handle errors
        changeStream.on("error", (error) => {
            console.error("Change Stream Error:", error);
        });

    }

    catch (error) {

        console.error("MongoDB Error:", error);

        await client.close();

    }

}

watchPriceChanges();

db.products.updateOne(
    { product_id: 1 },
    { $set: { price: 55000 } }
)