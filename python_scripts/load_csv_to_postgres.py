import csv
import psycopg2
import os

def load_csv_to_postgres(csv_path, table_name, conn_config, schema="STAGING"):
    conn = psycopg2.connect(**conn_config)
    cur = conn.cursor()
    
    cur.execute(f"CREATE SCHEMA IF NOT EXISTS {schema};")

    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        headers = next(reader)

        column_defs = ', '.join([f'"{col}" TEXT' for col in headers])
        create_sql = f'CREATE TABLE IF NOT EXISTS {schema}.{table_name} ({column_defs});'
        cur.execute(create_sql)

        f.seek(0)
        next(f)
        cur.copy_expert(f"COPY {schema}.{table_name} FROM STDIN WITH CSV HEADER DELIMITER ','", f)

    conn.commit()
    cur.close()
    conn.close()
    print(f"✅ Loaded: {csv_path} → {schema}.{table_name}")

def load_all_csvs_in_folder(folder_path, conn_config, table_prefix="raw_", schema="STAGING" ):
    for file in os.listdir(folder_path):
        if file.endswith(".csv"):
            csv_path = os.path.join(folder_path, file)
            base_name = os.path.splitext(file)[0]
            table_name = f"{table_prefix}{base_name}"
            load_csv_to_postgres(csv_path, table_name, conn_config, schema)

# --- Usage ---
if __name__ == "__main__":
    csv_folder = SEED_DIR = os.path.join(ROOT_DIR, "seeds")  # Folder containing .csv files

    connection_config = {
        "dbname": "sumup",
        "user": "postgres",
        "password": "admin",
        "host": "localhost",
        "port": 5432
    }

    load_all_csvs_in_folder(csv_folder, connection_config, schema="staging")
