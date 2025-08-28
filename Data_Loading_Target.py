
import os
import urllib
import re
import numpy as np
import pandas as pd
from sqlalchemy import create_engine, text
from datetime import datetime

def get_env_var(key: str) -> str:
    value = os.getenv(key)
    if not value:
        raise EnvironmentError(f"Missing required environment variable: {key}")
    return value

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
engine = create_engine(
    f"mssql+pyodbc:///?odbc_connect={params}",
    fast_executemany=True,
    pool_pre_ping=True
)

MISSING_TOKENS = {"", "na", "n/a", "null", "none", "?", "-", "nan"}

def _is_missing(x):
    if x is None: return True
    if isinstance(x, float) and pd.isna(x): return True
    if isinstance(x, str) and x.strip().lower() in MISSING_TOKENS: return True
    return False

def normalize_missing(df):
    return df.map(lambda x: np.nan if _is_missing(x) else x)

def strip_ws(df):
    return df.map(lambda x: re.sub(r"\s+", " ", x.strip()) if isinstance(x, str) else x)

def clean_dataframe(df):
    for col in df.columns:
        df[col] = normalize_missing(df[col])
        df[col] = strip_ws(df[col])
    return df

RESERVED_WORDS = {"FILE", "CURRENT"}

def safe_col(col):
    return f"[{col}]" if col.upper() in RESERVED_WORDS else col

def to_datetime(val):
    try: return pd.to_datetime(val)
    except: return None

def to_int(val):
    try: return int(val)
    except: return None

def to_float(val):
    try: return float(val)
    except: return None

def load_table(stg_table, tgt_table, pk_columns, type_map):
    with engine.begin() as conn:  
        df = pd.read_sql(f"SELECT * FROM {stg_table}", conn)
        if df.empty:
            print(f"No data found in {stg_table}")
            return

        df = clean_dataframe(df)
        for col, func in type_map.items():
            if col in df.columns:
                df[col] = df[col].apply(func)

        df = df.drop_duplicates(subset=pk_columns)

        temp_table = f"#{tgt_table.replace('.', '_')}_tmp"
        df.to_sql(temp_table.split('.')[-1], conn, if_exists='replace', index=False)

        on_conditions = " AND ".join([f"T.{safe_col(pk)} = S.{safe_col(pk)}" for pk in pk_columns])
        update_set = ", ".join([f"{safe_col(col)} = S.{safe_col(col)}" for col in df.columns if col not in pk_columns])
        insert_cols = ", ".join([safe_col(col) for col in df.columns])
        insert_vals = ", ".join([f"S.{safe_col(col)}" for col in df.columns])

        merge_sql = f"""
        MERGE {tgt_table} AS T
        USING {temp_table} AS S
        ON {on_conditions}
        WHEN MATCHED THEN 
            UPDATE SET {update_set}
        WHEN NOT MATCHED THEN 
            INSERT ({insert_cols}) VALUES ({insert_vals});
        """
        conn.execute(text(merge_sql))
        print(f"Upserted {len(df)} rows into {tgt_table}")

def main():
    latest_orbits_map = {
        "CREATION_DATE": to_datetime, "EPOCH": to_datetime, "MEAN_MOTION": to_float, "ECCENTRICITY": to_float,
        "INCLINATION": to_float, "RA_OF_ASC_NODE": to_float, "ARG_OF_PERICENTER": to_float, "MEAN_ANOMALY": to_float,
        "EPHEMERIS_TYPE": to_int, "NORAD_CAT_ID": to_int, "ELEMENT_SET_NO": to_int, "REV_AT_EPOCH": to_int,
        "BSTAR": to_float, "MEAN_MOTION_DOT": to_float, "MEAN_MOTION_DDOT": to_float, "SEMIMAJOR_AXIS": to_float,
        "PERIOD": to_float, "APOAPSIS": to_float, "PERIAPSIS": to_float, "FILE": to_int, "GP_ID": to_int,
        "LAUNCH_DATE": to_datetime, "DECAY_DATE": to_datetime
    }

    satellite_catalog_recent_map = {
        "NORAD_CAT_ID": to_int, "LAUNCH": to_datetime, "DECAY": to_datetime, "PERIOD": to_float,
        "INCLINATION": to_float, "APOGEE": to_int, "PERIGEE": to_int, "COMMENTCODE": to_int,
        "RCSVALUE": to_int, "FILE": to_int, "LAUNCH_YEAR": to_int, "LAUNCH_NUM": to_int, "OBJECT_NUMBER": to_int
    }

    predicted_decay_map = {
        "NORAD_CAT_ID": to_int, "OBJECT_NUMBER": to_int, "RCS": to_int, "MSG_EPOCH": to_datetime,
        "DECAY_EPOCH": to_datetime, "PRECEDENCE": to_int
    }

    recent_conjunctions_map = {
        "CDM_ID": to_int, "CREATED": to_datetime, "TCA": to_datetime,
        "MIN_RNG": to_float, "PC": to_float, "SAT_1_ID": to_int, "SAT_2_ID": to_int
    }

    load_table("DWH_STG.latest_orbits", "DWH_TGT.latest_orbits", ["NORAD_CAT_ID"], latest_orbits_map)
    load_table("DWH_STG.satellite_catalog_recent", "DWH_TGT.satellite_catalog_recent", ["NORAD_CAT_ID"], satellite_catalog_recent_map)
    load_table("DWH_STG.predicted_decay", "DWH_TGT.predicted_decay", ["NORAD_CAT_ID", "DECAY_EPOCH", "MSG_TYPE"], predicted_decay_map)
    load_table("DWH_STG.recent_conjunctions", "DWH_TGT.recent_conjunctions", ["CDM_ID"], recent_conjunctions_map)

if __name__ == "__main__":
    main()