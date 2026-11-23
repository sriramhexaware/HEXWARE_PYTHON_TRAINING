// Task 5 – MongoDB Change Stream for Critical Ward Alerts

db.createCollection("ward_alerts");

db.ward_alerts.insertMany([
    {
        alert_id: 101,
        ward: "General Ward",
        severity: "critical",
        message: "Bed capacity exceeded",
        alert_time: new Date()
    },
    {
        alert_id: 102,
        ward: "ICU Ward",
        severity: "normal",
        message: "One bed available",
        alert_time: new Date()
    },
    {
        alert_id: 103,
        ward: "Emergency Ward",
        severity: "critical",
        message: "No beds available",
        alert_time: new Date()
    }
]);

db.ward_alerts.find();

// Create the change-stream script

// Select the database
const database = db.getSiblingDB("HospitalDB");

// Monitor only newly inserted critical alerts
const changeStream = database.ward_alerts.watch([
    {
        $match: {
            operationType: "insert",
            "fullDocument.severity": "critical"
        }
    }
]);

print("Monitoring ward_alerts collection...");
print("Waiting for critical ward alerts...");

// Continuously listen for new alerts
while (changeStream.hasNext()) {

    const change = changeStream.next();

    const alert = change.fullDocument;

    print("CRITICAL WARD ALERT DETECTED!");

    print("Ward: " + alert.ward);
    print("Severity: " + alert.severity);
    print("Alert Time: " + alert.alert_time);

    print("--------------------------------");
}

// Test the change stream

db.ward_alerts.insertOne({
    alert_id: 104,
    ward: "ICU Ward",
    severity: "critical",
    message: "All ICU beds occupied",
    alert_time: new Date()
});

// Test that normal alerts are ignored

db.ward_alerts.insertOne({
    alert_id: 105,
    ward: "General Ward",
    severity: "normal",
    message: "Bed available",
    alert_time: new Date()
});