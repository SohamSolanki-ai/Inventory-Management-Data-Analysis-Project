import pandas as pd
import urllib.parse
from sqlalchemy import create_engine

# ✅ PostgreSQL connection settings (update only your password if needed)
DB_NAME = "Inventory_db"  # Your PostgreSQL database name
DB_USER = "postgres"  # Your PostgreSQL username
DB_PASSWORD = "Soham@2411"  # Your PostgreSQL password (with special characters)
DB_HOST = "localhost"  # Keep as localhost if running locally
DB_PORT = "5432"  # PostgreSQL default port

# ✅ Encode the password to handle special characters
encoded_password = urllib.parse.quote(DB_PASSWORD, safe="")

# ✅ Create a safe database connection string
engine = create_engine(f"postgresql+psycopg2://{DB_USER}:{encoded_password}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

# ✅ Define file paths (ensuring correct loading order)
file_paths = {
    "customer": "/Users/sohamsolanki/Downloads/InventoryProject/Customer.csv",
    "warehouse": "/Users/sohamsolanki/Downloads/InventoryProject/Warehouse.csv",
    "region": "/Users/sohamsolanki/Downloads/InventoryProject/Region.csv",
    "product": "/Users/sohamsolanki/Downloads/InventoryProject/Product.csv",
    "orders": "/Users/sohamsolanki/Downloads/InventoryProject/Orders.csv",
    "orderdetails": "/Users/sohamsolanki/Downloads/InventoryProject/OrderDetails.csv",
    "employee": "/Users/sohamsolanki/Downloads/InventoryProject/Employee.csv"
}

# ✅ Load each CSV file into its respective PostgreSQL table (ensuring Customer first)
for table_name, file_path in file_paths.items():
    try:
        # Load CSV file
        df = pd.read_csv(file_path)

        # ✅ Convert column names to lowercase
        df.columns = map(str.lower, df.columns)

        # ✅ Handle Orders table separately to check valid Customer IDs
        if table_name == "orders":
            valid_customers = pd.read_sql("SELECT customerid FROM customer", engine)
            df = df[df["customerid"].isin(valid_customers["customerid"])]
        
        # ✅ Handle OrderDetails table separately to check valid Order IDs
        if table_name == "orderdetails":
            valid_orders = pd.read_sql("SELECT orderid FROM orders", engine)
            df = df[df["orderid"].isin(valid_orders["orderid"])]
        
        # ✅ Insert data into PostgreSQL (forcing lowercase table names)
        df.to_sql(table_name, engine, if_exists="append", index=False)
        
        print(f"✅ Successfully loaded {table_name} into PostgreSQL!")
    except Exception as e:
        print(f"❌ Failed to load {table_name}: {e}")

print("🎉 Data import completed successfully!")
