# # Biobank Database Management System (biobank_db)

A relational database for managing biobank operations: donors, informed consent,
biological samples, freezer storage, researchers, test requests, and sample usage.
Built for the Fundamentals of Databases biotechnology database project.

## DBMS Used

MySQL 8.0 (MariaDB 10.x is also compatible — the schema uses no MySQL-only syntax
beyond `AUTO_INCREMENT`, `ENUM`, and `DELIMITER`-based trigger/procedure blocks).

## Repository Structure

```
/README.md
/report.pdf
/presentation.pptx
/sql/create_tables.sql
/sql/load_data.sql
/sql/queries.sql
/sql/views.sql
/sql/triggers_procedures.sql
/diagrams/ERD.png
/src/app.py            (optional bonus UI)
```

## Execution Instructions

Run the scripts in this exact order against a clean MySQL/MariaDB instance:

```bash
mysql -u root -p < sql/create_tables.sql
mysql -u root -p < sql/load_data.sql
mysql -u root -p < sql/views.sql
mysql -u root -p < sql/triggers_procedures.sql
mysql -u root -p < sql/queries.sql
```

`create_tables.sql` creates the `biobank_db` database and all 8 tables with
constraints. `load_data.sql` inserts 10 sample records per main table.
`views.sql` and `triggers_procedures.sql` must run before `queries.sql` if you
want to exercise the views/trigger behavior interactively, since some of the
example queries assume the schema objects already exist.

### Optional: bonus UI

```bash
pip install streamlit mysql-connector-python pandas
streamlit run src/app.py
```

Update the `host`/`user`/`password` values in `src/app.py` to match your local
MySQL credentials before running.

## Notes

- `Sample.Volume_ml` is automatically decremented by `trg_deduct_sample_volume`
  whenever a row is inserted into `Sample_Usage`, so the "available volume"
  reflected in `view_sample_inventory` always reflects what is actually left
  after usage.
- `trg_check_sample_volume` blocks any `Sample_Usage` insert that would draw
  more volume than is currently available.
