db.collection("accounts")
db.accounts.insertMany([
    { accountId: 101, balance: 10000, status: "ACTIVE" },
    { accountId: 102, balance: 5000, status: "ACTIVE" },
    { accountId: 103, balance: 2000, status: "INACTIVE" }
]);


async function transferMoney() {
    
    try {
        await client.connect();
        const db = client.db("BankDB");
        const accounts = db.collection("accounts");
        try {
            await session.withTransaction(async () => {
                const from = await accounts.findOne(
                    { accountId: 101, status: "ACTIVE" },
                    { session }
                );
                const to = await accounts.findOne(
                    { accountId: 102, status: "ACTIVE" },
                    { session }
                );

                const amount = 2000;

                if (!from || !to)
                    throw new Error("Invalid account");
                if (from.balance < amount)
                    throw new Error("Insufficient balance");
                await accounts.updateOne(
                    { accountId: 101, status: "ACTIVE" },
                    { $inc: { balance: -amount } },
                    { session }
                );

                await accounts.updateOne(
                    { accountId: 102, status: "ACTIVE" },
                    { $inc: { balance: amount } },
                    { session }
                );
            });
            console.log("Transfer completed successfully");
        } finally {
            await session.endSession();
        }
    } catch (error) {
        console.log("Transfer failed:", error.message);
    } finally {
        await client.close();
    }
}

transferMoney();