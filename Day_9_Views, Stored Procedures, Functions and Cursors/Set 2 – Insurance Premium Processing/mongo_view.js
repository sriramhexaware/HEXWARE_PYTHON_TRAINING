db.collection('customer_communication')

// Create sample collection

db.customer_communications.insertMany([
    {
        communicationId: 1,
        customerName: "Arun",
        message: "Premium amount is incorrect",
        type: "Complaint",
        status: "Unresolved"
    },
    {
        communicationId: 2,
        customerName: "Kumar",
        message: "Policy renewed successfully",
        type: "Feedback",
        status: "Resolved"
    },
    {
        communicationId: 3,
        customerName: "Ravi",
        message: "Claim processing is delayed",
        type: "Complaint",
        status: "Unresolved"
    }
]);

// Create MongoDB view

db.createView(
    "unresolved_complaints",
    "customer_communications",
    [
        {
            $match: {
                type: "Complaint",
                status: "Unresolved"
            }
        },
        {
            $project: {
                _id: 0,
                communicationId: 1,
                customerName: 1,
                message: 1,
                status: 1
            }
        }
    ]
);

// Verify the view

db.unresolved_complaints.find();