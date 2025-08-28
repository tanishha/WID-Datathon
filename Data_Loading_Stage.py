import requests
import pandas as pd
import os
from sqlalchemy import create_engine, text
import urllib


def get_env_var(key: str) -> str:
    value = os.getenv(key)
    if not value:
        raise EnvironmentError(f"Missing required environment variable: {key}")
    return value

USERNAME = get_env_var("APIUsername")
PASSWORD = get_env_var("APIPassword")

AZURE_SQL_SERVER = get_env_var("Azure_DB_server")
AZURE_SQL_DATABASE = get_env_var("Azure_DB_name")
AZURE_SQL_USERNAME = get_env_var("Azure_DB_Username")
AZURE_SQL_PASSWORD = get_env_var("Azure_DB_Password")

connection_string = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    f"SERVER={AZURE_SQL_SERVER},1433;"
    f"DATABASE={AZURE_SQL_DATABASE};"
    f"UID={AZURE_SQL_USERNAME};"
    f"PWD={AZURE_SQL_PASSWORD};"
    "Encrypt=yes;"
    "TrustServerCertificate=no;"
    "Connection Timeout=30;"
)

params = urllib.parse.quote_plus(connection_string)
engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}",fast_executemany=True, pool_pre_ping=True)

BASE_URL = "https://www.space-track.org"
LOGIN_URL = f"{BASE_URL}/ajaxauth/login"

# ten_years_ago = (datetime.utcnow() - timedelta(days=10*365)).strftime("%Y-%m-%d")
# today = datetime.utcnow().strftime("%Y-%m-%d")

# API_ENDPOINTS = {
#     "latest_orbits": f"{BASE_URL}/basicspacedata/query/class/gp/epoch/>{ten_years_ago}/orderby/norad_cat_id/format/json",
#     "satellite_catalog_recent": f"{BASE_URL}/basicspacedata/query/class/satcat/launch/>{ten_years_ago}/current/Y/orderby/launch desc/format/json",
#     "recent_conjunctions": f"{BASE_URL}/basicspacedata/query/class/cdm_public/TCA/>{ten_years_ago}/orderby/TCA%20desc/format/json",
#     "predicted_decay": f"{BASE_URL}/basicspacedata/query/class/decay/decay_epoch/>{ten_years_ago}/orderby/norad_cat_id,precedence/format/json"
# }

API_ENDPOINTS = {
    "latest_orbits": f"{BASE_URL}/basicspacedata/query/class/gp/epoch/>now-7/orderby/norad_cat_id/format/json",
    # "orbits_history": f"{BASE_URL}/basicspacedata/query/class/gp_history/epoch/>now-30/orderby/norad_cat_id,epoch/format/json",
    "satellite_catalog_recent": f"{BASE_URL}/basicspacedata/query/class/satcat/launch/>now-7/current/Y/orderby/launch desc/format/json",
    "recent_conjunctions": f"{BASE_URL}/basicspacedata/query/class/cdm_public/TCA/>now-7/orderby/TCA%20desc/format/json",
    "predicted_decay": f"{BASE_URL}/basicspacedata/query/class/decay/decay_epoch/>now-7/orderby/norad_cat_id,precedence/format/json"
}

def login(session):
    """Login to Space-Track API"""
    response = session.post(LOGIN_URL, data={"identity": USERNAME, "password": PASSWORD})
    if response.status_code == 200:
        print("Successfully logged in.")
    else:
        raise Exception("Login failed!")

def fetch_and_load(session, url, schema, table_name):
    """Fetch JSON from API and load into Azure SQL (truncate then load)."""
    response = session.get(url)
    if response.status_code == 200:
        data = response.json()
        if data:
            df = pd.DataFrame(data)

            with engine.begin() as conn:
                conn.execute(text(f"TRUNCATE TABLE {schema}.{table_name}"))

            print(f"Loading {len(df)} rows into {schema}.{table_name} ...")
            ncols = len(df.columns)
            safe_chunk = max(1, 2000 // ncols) 
            df.to_sql(
                name=table_name,
                schema=schema,
                con=engine,
                index=False,
                if_exists="append", 
                chunksize=safe_chunk
            )
            print(f"Done loading {schema}.{table_name}")
        else:
            print(f"No data returned for {schema}.{table_name}")
    else:
        print(f"Failed request ({response.status_code}) for {schema}.{table_name}")
def main():
    with requests.Session() as session:
        login(session)
        fetch_and_load(session, API_ENDPOINTS["latest_orbits"], "DWH_STG", "latest_orbits")
        fetch_and_load(session, API_ENDPOINTS["satellite_catalog_recent"], "DWH_STG", "satellite_catalog_recent")
        fetch_and_load(session, API_ENDPOINTS["recent_conjunctions"], "DWH_STG", "recent_conjunctions")
        fetch_and_load(session, API_ENDPOINTS["predicted_decay"], "DWH_STG", "predicted_decay")

if __name__ == "__main__":
    main()
