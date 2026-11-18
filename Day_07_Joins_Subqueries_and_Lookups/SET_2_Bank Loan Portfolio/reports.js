//Task 5 – MongoDB $lookup pipelines

//create collections

db.collections("customers")
db.collections("loans")
db.collections("repayment")

//insert records
db.customers.insertMany([
  {_id:101, name:"Arun", city:"Chennai"},
  {_id:102, name:"Kiran", city:"Coimbatore"},
  {_id:103, name:"Priya", city:"Bangalore"},
  {_id:104, name:"Rahul", city:"Hyderabad"},
  {_id:105, name:"Divya", city:"Mumbai"}
])

db.loans.insertMany([
  {_id:1001, customer_id:101, branch_id:1, amount:500000},
  {_id:1002, customer_id:102, branch_id:2, amount:800000},
  {_id:1003, customer_id:103, branch_id:3, amount:300000},
  {_id:1004, customer_id:101, branch_id:2, amount:400000},
  {_id:1005, customer_id:104, branch_id:4, amount:1000000}
])

db.repayments.insertMany([
  {_id:1, loan_id:1001, amount:15000, date:ISODate("2026-11-10")},
  {_id:2, loan_id:1002, amount:20000, date:ISODate("2026-10-01")},
  {_id:3, loan_id:1002, amount:20000, date:ISODate("2026-11-05")},
  {_id:4, loan_id:1003, amount:10000, date:ISODate("2026-09-15")},
  {_id:5, loan_id:1005, amount:25000, date:ISODate("2026-11-12")}
])

//pipelines

//Loans with customer details
db.loans.aggregate([
  {
    $lookup: {
      from: "customers",
      localField: "customer_id",
      foreignField: "_id",
      as: "customer"
    }
  }
])

//Loans with repayment details
db.loans.aggregate([
  {
    $lookup: {
      from: "repayments",
      localField: "_id",
      foreignField: "loan_id",
      as: "repayments"
    }
  }
])

//Latest repayment for each loan
db.loans.aggregate([
  {
    $lookup: {
      from: "repayments",
      let: { id: "$_id" },
      pipeline: [
        { $match: { $expr: { $eq: ["$loan_id", "$$id"] } } },
        { $sort: { date: -1 } },
        { $limit: 1 }
      ],
      as: "last_repayment"
    }
  }
])
