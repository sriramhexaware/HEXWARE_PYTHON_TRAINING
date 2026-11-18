//create collections


db.createCollection("customers")
db.createCollection("carriers")
db.createCollection("shipments")
db.createCollection("deliveryEvents")

//insert records
db.customers.insertMany([
    { customer_id: 101, customer_name: "Arun", city: "Chennai" },
    { customer_id: 102, customer_name: "Kiran", city: "Coimbatore" },
    { customer_id: 103, customer_name: "Priya", city: "Bangalore" },
    { customer_id: 104, customer_name: "Rahul", city: "Hyderabad" },
    { customer_id: 105, customer_name: "Divya", city: "Mumbai" }
])

db.carriers.insertMany([
    { carrier_id: 201, carrier_name: "BlueDart" },
    { carrier_id: 202, carrier_name: "DTDC" },
    { carrier_id: 203, carrier_name: "Delhivery" },
    { carrier_id: 204, carrier_name: "FedEx" },
    { carrier_id: 205, carrier_name: "DHL" }
])

db.shipments.insertMany([
    {
        shipment_id: 1001,
        customer_id: 101,
        carrier_id: 201,
        shipping_cost: 500,
        expected_delivery_date: ISODate("2026-11-03"),
        actual_delivery_date: ISODate("2026-11-03")
    },
    {
        shipment_id: 1002,
        customer_id: 102,
        carrier_id: 202,
        shipping_cost: 750,
        expected_delivery_date: ISODate("2026-11-04"),
        actual_delivery_date: ISODate("2026-11-08")
    },
    {
        shipment_id: 1003,
        customer_id: 103,
        carrier_id: 203,
        shipping_cost: 900,
        expected_delivery_date: ISODate("2026-11-05"),
        actual_delivery_date: ISODate("2026-11-09")
    },
    {
        shipment_id: 1004,
        customer_id: 101,
        carrier_id: 201,
        shipping_cost: 650,
        expected_delivery_date: ISODate("2026-11-06"),
        actual_delivery_date: ISODate("2026-11-06")
    },
    {
        shipment_id: 1005,
        customer_id: 104,
        carrier_id: 202,
        shipping_cost: 800,
        expected_delivery_date: ISODate("2026-11-07"),
        actual_delivery_date: ISODate("2026-11-12")
    }
])

db.deliveryEvents.insertMany([
    {
        event_id: 1,
        shipment_id: 1001,
        event_type: "Picked Up",
        description: "Shipment collected"
    },
    {
        event_id: 2,
        shipment_id: 1001,
        event_type: "Delivered",
        description: "Delivered successfully"
    },
    {
        event_id: 3,
        shipment_id: 1002,
        event_type: "Delayed",
        description: "Weather conditions"
    },
    {
        event_id: 4,
        shipment_id: 1003,
        event_type: "Delivered",
        description: "Delivered late"
    },
    {
        event_id: 5,
        shipment_id: 1005,
        event_type: "Delivered",
        description: "Delivered late"
    }
])

//MongoDB $lookup Pipeline

//Find shipments along with their delivery events
db.shipments.aggregate([
    {
        $lookup: {
            from: "deliveryEvents",
            localField: "shipment_id",
            foreignField: "shipment_id",
            as: "delivery_events"
        }
    }
])

//Find customers along with their shipments
db.customers.aggregate([
    {
        $lookup: {
            from: "shipments",
            localField: "customer_id",
            foreignField: "customer_id",
            as: "shipments"
        }
    }
])

//Find carriers with their shipment delay statistics
db.carriers.aggregate([
    {
        $lookup: {
            from: "shipments",
            localField: "carrier_id",
            foreignField: "carrier_id",
            as: "shipments"
        }
    },
    {
        $unwind: "$shipments"
    },
    {
        $group: {
            _id: "$carrier_name",
            total_shipments: { $sum: 1 },
            average_delay: {
                $avg: {
                    $divide: [
                        {
                            $subtract: [
                                "$shipments.actual_delivery_date",
                                "$shipments.expected_delivery_date"
                            ]
                        },
                        86400000
                    ]
                }
            }
        }
    }
])




