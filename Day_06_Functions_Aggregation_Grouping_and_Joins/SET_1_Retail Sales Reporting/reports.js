
// create collection

db.createCollection("order_items")

//insert items

db.order_items.insertMany([
  {
    order_id: 1,
    order_date: ISODate("2026-11-01"),
    customer_city: "Chennai",
    product_name: "Laptop",
    category: "Electronics",
    quantity: 1,
    unit_price: 50000
  },
  {
    order_id: 1,
    order_date: ISODate("2026-11-01"),
    customer_city: "Chennai",
    product_name: "Headphones",
    category: "Accessories",
    quantity: 2,
    unit_price: 2000
  },
  {
    order_id: 2,
    order_date: ISODate("2026-11-05"),
    customer_city: "Coimbatore",
    product_name: "Mobile",
    category: "Electronics",
    quantity: 2,
    unit_price: 20000
  },
  {
    order_id: 3,
    order_date: ISODate("2026-10-15"),
    customer_city: "Chennai",
    product_name: "Keyboard",
    category: "Accessories",
    quantity: 3,
    unit_price: 1500
  },
  {
    order_id: 4,
    order_date: ISODate("2026-10-20"),
    customer_city: "Bangalore",
    product_name: "Chair",
    category: "Furniture",
    quantity: 2,
    unit_price: 5000
  },
  {
    order_id: 5,
    order_date: ISODate("2026-11-10"),
    customer_city: "Coimbatore",
    product_name: "Monitor",
    category: "Electronics",
    quantity: 1,
    unit_price: 12000
  },
  {
    order_id: 6,
    order_date: ISODate("2026-09-12"),
    customer_city: "Madurai",
    product_name: "Mouse",
    category: "Accessories",
    quantity: 4,
    unit_price: 800
  }
]);

//Verify inserted documents
db.order_items.find()

//Check total document count
db.order_items.countDocuments()

//MongoDB Pipeline 1: Month-wise Sales
db.order_items.aggregate([
  {
    $group: {
      _id: {
        $dateToString: {
          format: "%Y-%m",
          date: "$order_date"
        }
      },
      total_sales: {
        $sum: {
          $multiply: ["$quantity", "$unit_price"]
        }
      }
    }
  },
  {
    $sort: { _id: 1 }
  }
]);

//MongoDB Pipeline 2: Top Products by Revenue
db.order_items.aggregate([
  {
    $group: {
      _id: "$product_name",
      total_revenue: {
        $sum: {
          $multiply: ["$quantity", "$unit_price"]
        }
      }
    }
  },
  {
    $sort: { total_revenue: -1 }
  },
  {
    $limit: 5
  }
]);

//MongoDB Pipeline 3: Average Basket Value per City
db.order_items.aggregate([
  {
    $group: {
      _id: {
        order_id: "$order_id",
        city: "$customer_city"
      },
      order_total: {
        $sum: {
          $multiply: ["$quantity", "$unit_price"]
        }
      }
    }
  },
  {
    $group: {
      _id: "$_id.city",
      average_basket_value: {
        $avg: "$order_total"
      }
    }
  },
  {
    $sort: { average_basket_value: -1 }
  }
]);



