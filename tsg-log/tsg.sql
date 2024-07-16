CREATE TABLE tsg_log (
  id int generated always as identity NOT NULL,
  ctime timestamptz DEFAULT clock_timestamp() NOT NULL,
  CONSTRAINT tsg_log_pkey PRIMARY KEY (id)
);
CREATE INDEX tsg_log_ctime_idx ON tsg_log USING btree (ctime);

-- Permissions
GRANT SELECT ON TABLE tsg_log TO "uxmR";
GRANT UPDATE, DELETE, INSERT ON TABLE tsg_log TO "uxmW";
