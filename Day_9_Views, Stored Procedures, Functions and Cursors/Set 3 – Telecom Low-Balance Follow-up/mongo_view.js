db.collection('notification_log')

// Create sample collection

db.notification_log.insertMany([
    {
        notificationId: 1,
        subscriberId: 1,
        message: "Your balance is below 50",
        isRead: false
    },
    {
        notificationId: 2,
        subscriberId: 1,
        message: "Recharge reminder",
        isRead: false
    },
    {
        notificationId: 3,
        subscriberId: 2,
        message: "Your balance is low",
        isRead: true
    },
    {
        notificationId: 4,
        subscriberId: 3,
        message: "Please recharge",
        isRead: false
    }
]);

// Create MongoDB view


db.createView(
    "unread_notification_summary",
    "notification_log",
    [
        {
            $match: {
                isRead: false
            }
        },
        {
            $group: {
                _id: "$subscriberId",
                unreadCount: { $sum: 1 }
            }
        },
        {
            $project: {
                _id: 0,
                subscriberId: "$_id",
                unreadCount: 1
            }
        }
    ]
);

// Verify the view

db.unread_notification_summary.find();
