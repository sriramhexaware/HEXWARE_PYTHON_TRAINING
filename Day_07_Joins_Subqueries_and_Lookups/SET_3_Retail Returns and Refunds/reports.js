//create database and collection

db.collections("returns_feedback")

//insert records
db.returns_feedback.insertMany([
  {return_id:1, rating:5, feedback:"Good service"},
  {return_id:2, rating:3, feedback:"Average service"},
  {return_id:3, rating:4, feedback:"Quick refund"},
  {return_id:4, rating:2, feedback:"Poor experience"},
  {return_id:5, rating:5, feedback:"Excellent"},
  {return_id:6, rating:4, feedback:"Good"},
  {return_id:7, rating:3, feedback:"Average"}
])

//Task - 5 MongoDB Aggregation Pipelines using $lookup
//Query 1 – Join Returns with Feedback

db.returns.aggregate([
  {
    $lookup:{
      from:"returns_feedback",
      localField:"return_id",
      foreignField:"return_id",
      as:"feedback"
    }
  }
])

//Query 2 – Find products with their return feedback
db.returns.aggregate([
  {
    $lookup:{
      from:"returns_feedback",
      localField:"return_id",
      foreignField:"return_id",
      as:"feedback"
    }
  },
  {$unwind:"$feedback"},
  {
    $group:{
      _id:"$product_id",
      avg_rating:{$avg:"$feedback.rating"},
      total_returns:{$sum:1}
    }
  }
])

//Query 3 – Find returns with feedback rating below 4
db.returns.aggregate([
  {
    $lookup:{
      from:"returns_feedback",
      localField:"return_id",
      foreignField:"return_id",
      as:"feedback"
    }
  },
  {$unwind:"$feedback"},
  {$match:{"feedback.rating":{$lt:4}}}
])
