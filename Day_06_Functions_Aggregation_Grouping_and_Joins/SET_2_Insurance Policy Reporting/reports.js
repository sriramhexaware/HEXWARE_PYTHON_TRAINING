//Create the collection
db.createCollection("claims_notes")

//Insert sample claim documents
db.claims_notes.insertMany([
  {
    claim_id: 1,
    status: "Settled",
    claim_date: ISODate("2026-02-10"),
    settlement_date: ISODate("2026-02-20"),
    damage_category: "Accidental Damage"
  },
  {
    claim_id: 2,
    status: "Settled",
    claim_date: ISODate("2026-04-15"),
    settlement_date: ISODate("2026-04-25"),
    damage_category: "Hospitalization"
  },
  {
    claim_id: 3,
    status: "Settled",
    claim_date: ISODate("2026-05-20"),
    settlement_date: ISODate("2026-06-05"),
    damage_category: "Vehicle Accident"
  },
  {
    claim_id: 4,
    status: "Settled",
    claim_date: ISODate("2026-07-01"),
    settlement_date: ISODate("2026-07-20"),
    damage_category: "Critical Illness"
  },
  {
    claim_id: 5,
    status: "Pending",
    claim_date: ISODate("2026-11-10"),
    settlement_date: null,
    damage_category: "Fire Damage"
  },
  {
    claim_id: 6,
    status: "Approved",
    claim_date: ISODate("2026-08-05"),
    settlement_date: ISODate("2026-08-12"),
    damage_category: "Vehicle Accident"
  },
  {
    claim_id: 7,
    status: "Under Review",
    claim_date: ISODate("2026-09-01"),
    settlement_date: null,
    damage_category: "Hospitalization"
  },
  {
    claim_id: 8,
    status: "Settled",
    claim_date: ISODate("2026-10-10"),
    settlement_date: ISODate("2026-10-18"),
    damage_category: "Accidental Damage"
  },
  {
    claim_id: 9,
    status: "Settled",
    claim_date: ISODate("2026-10-15"),
    settlement_date: ISODate("2026-10-28"),
    damage_category: "Fire Damage"
  },
  {
    claim_id: 10,
    status: "Pending",
    claim_date: ISODate("2026-11-01"),
    settlement_date: null,
    damage_category: "Hospitalization"
  }
])

//Verify the documents
db.claims_notes.find()

//MongoDB Aggregation 1: Claims per status
db.claims_notes.aggregate([
  {
    $group: {
      _id: "$status",
      total_claims: { $sum: 1 }
    }
  },
  {
    $sort: {
      total_claims: -1
    }
  }
])

//MongoDB Aggregation 2: Average settlement time
db.claims_notes.aggregate([
  {
    $match: {
      settlement_date: { $ne: null }
    }
  },
  {
    $project: {
      settlement_days: {
        $dateDiff: {
          startDate: "$claim_date",
          endDate: "$settlement_date",
          unit: "day"
        }
      }
    }
  },
  {
    $group: {
      _id: null,
      average_settlement_days: {
        $avg: "$settlement_days"
      }
    }
  }
])

//MongoDB Aggregation 3: Top three damage categories
db.claims_notes.aggregate([
  {
    $group: {
      _id: "$damage_category",
      total_claims: { $sum: 1 }
    }
  },
  {
    $sort: {
      total_claims: -1
    }
  },
  {
    $limit: 3
  }
])