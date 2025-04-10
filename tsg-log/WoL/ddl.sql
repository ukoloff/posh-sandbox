CREATE TABLE arp (
  id int4 GENERATED ALWAYS AS IDENTITY NOT NULL,
  ctime timestamptz DEFAULT clock_timestamp() NOT NULL,
  mtime timestamptz NOT NULL,
  ip text NOT NULL,
  mac text NOT NULL,
  CONSTRAINT arp_pk PRIMARY KEY (id)
);

CREATE UNIQUE INDEX arp_ip_idx ON arp USING btree (ip);

GRANT SELECT ON TABLE arp TO "uxmR";
GRANT UPDATE, DELETE, INSERT ON TABLE arp TO "uxmW";
