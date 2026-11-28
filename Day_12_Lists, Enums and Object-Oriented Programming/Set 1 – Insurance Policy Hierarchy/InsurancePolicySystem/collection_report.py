monthly_collections = [

    [25000, 30000, 28000, 35000],  # North
    [40000, 42000, 38000, 45000],  # South
    [20000, 22000, 25000, 27000]   # East

]

regions = ["North", "South", "East"]

months = ["January", "February", "March", "April"]


# Row totals - Region-wise collection

print("REGION-WISE COLLECTION")

for i in range(len(monthly_collections)):

    total = sum(monthly_collections[i])

    print(f"{regions[i]}: ₹{total}")


# Column totals - Month-wise collection

print("\nMONTH-WISE COLLECTION")

for j in range(len(months)):

    total = 0

    for i in range(len(monthly_collections)):

        total += monthly_collections[i][j]

    print(f"{months[j]}: ₹{total}")


# Overall collection

overall_total = sum(sum(row) for row in monthly_collections)

print("\nOverall Collection:", overall_total)