//create collections

db.collections("usage_events")

//Insert sample usage events
db.usage_events.insertMany([
  {
    subscriber_id: 1,
    event_time: ISODate("2026-10-10T09:15:00Z"),
    session_start: ISODate("2026-10-10T09:15:00Z"),
    session_end: ISODate("2026-10-10T09:35:00Z"),
    data_used_mb: 250,
    cell_tower: "Tower_A"
  },
  {
    subscriber_id: 2,
    event_time: ISODate("2026-10-10T09:30:00Z"),
    session_start: ISODate("2026-10-10T09:30:00Z"),
    session_end: ISODate("2026-10-10T10:00:00Z"),
    data_used_mb: 400,
    cell_tower: "Tower_B"
  },
  {
    subscriber_id: 3,
    event_time: ISODate("2026-10-10T10:10:00Z"),
    session_start: ISODate("2026-10-10T10:10:00Z"),
    session_end: ISODate("2026-10-10T10:25:00Z"),
    data_used_mb: 150,
    cell_tower: "Tower_A"
  },
  {
    subscriber_id: 4,
    event_time: ISODate("2026-10-10T10:45:00Z"),
    session_start: ISODate("2026-10-10T10:45:00Z"),
    session_end: ISODate("2026-10-10T11:15:00Z"),
    data_used_mb: 500,
    cell_tower: "Tower_C"
  },
  {
    subscriber_id: 5,
    event_time: ISODate("2026-10-10T11:20:00Z"),
    session_start: ISODate("2026-10-10T11:20:00Z"),
    session_end: ISODate("2026-10-10T11:40:00Z"),
    data_used_mb: 200,
    cell_tower: "Tower_A"
  },
  {
    subscriber_id: 6,
    event_time: ISODate("2026-10-10T11:50:00Z"),
    session_start: ISODate("2026-10-10T11:50:00Z"),
    session_end: ISODate("2026-10-10T12:30:00Z"),
    data_used_mb: 600,
    cell_tower: "Tower_B"
  }
]);

//view inserted records
db.usage_events.find();

//Aggregation 1: Hourly usage
db.usage_events.aggregate([
  {
    $group: {
      _id: {
        $dateToString: {
          format: "%Y-%m-%d %H:00",
          date: "$event_time"
        }
      },
      total_data_mb: {
        $sum: "$data_used_mb"
      },
      total_events: {
        $sum: 1
      }
    }
  },
  {
    $sort: {
      _id: 1
    }
  }
]);

//Aggregation 2: Average session length
db.usage_events.aggregate([
  {
    $project: {
      subscriber_id: 1,
      session_length_minutes: {
        $divide: [
          {
            $subtract: ["$session_end", "$session_start"]
          },
          60000
        ]
      }
    }
  },
  {
    $group: {
      _id: null,
      average_session_minutes: {
        $avg: "$session_length_minutes"
      }
    }
  }
]);

//Aggregation 3: Busiest cell tower
db.usage_events.aggregate([
  {
    $group: {
      _id: "$cell_tower",
      total_events: {
        $sum: 1
      },
      total_data_mb: {
        $sum: "$data_used_mb"
      }
    }
  },
  {
    $sort: {
      total_events: -1
    }
  },
  {
    $limit: 1
  }
]);
