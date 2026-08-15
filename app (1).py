import streamlit as st
import mysql.connector
import pandas as pd

st.set_page_config(page_title="Biobank Management", layout="wide")
st.title("🧪 Biobank Inventory & Sample Manager")

def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="your_password",
        database="biobank_db"
    )

st.header("Available Sample Inventory")
try:
    conn = get_connection()
    df = pd.read_sql("SELECT * FROM view_sample_inventory;", conn)
    st.dataframe(df, use_container_width=True)
    conn.close()
except Exception as e:
    st.error(f"Database connection error: {e}")
