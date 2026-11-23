// Task 5 – MongoDB Change Stream for Fraud Alerts


db.createCollection("fraud_alerts")

db.fraud_alerts.insertMany([
    {
        alert_id: 101,
        account_id: 1001,
        alert_type: "Suspicious Withdrawal",
        amount: 50000,
        status: "Pending",
        created_at: new Date()
    },
    {
        alert_id: 102,
        account_id: 1002,
        alert_type: "Unusual Transaction",
        amount: 75000,
        status: "Under Review",
        created_at: new Date()
    }
]);

db.fraud_alerts.find();

//  the change-stream script

const database = db.getSiblingDB("BankSecurity");

// Monitor only INSERT operations
const changeStream = database.fraud_alerts.watch([
    {
        $match: {
            operationType: "insert"
        }
    }
]);

print("Monitoring fraud_alerts collection...");
print("Waiting for new fraud alerts...");

// Continuously listen for new alerts
while (changeStream.hasNext()) {

    const change = changeStream.next();

    print("NEW FRAUD ALERT DETECTED!");

    printjson(change.fullDocument);
}

// Test the change stream

db.fraud_alerts.insertOne({
    alert_id: 103,
    account_id: 1003,
    alert_type: "Multiple Failed Transactions",
    amount: 90000,
    status: "Pending",
    created_at: new Date()
});

