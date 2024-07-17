CREATE TABLE tsg_log (
  id int generated always as identity NOT NULL,
  ctime timestamptz DEFAULT clock_timestamp() NOT NULL,
  CONSTRAINT tsg_log_pkey PRIMARY KEY (id)
);
CREATE INDEX tsg_log_ctime_idx ON tsg_log USING btree (ctime);
CLUSTER tsg_log using tsg_log_pkey;

-- Permissions
GRANT SELECT ON TABLE tsg_log TO "uxmR";
GRANT UPDATE, DELETE, INSERT ON TABLE tsg_log TO "uxmW";

CREATE TABLE tsg (
	id int generated always as identity NOT NULL,
	rec_id int NOT NULL,
	"start" timestamptz NOT NULL,
	"end" timestamptz NOT NULL,
	duration int4 NOT NULL,
	log_id int4 NULL,
	guid text NOT NULL,
	ip text NOT NULL,
	"user" text NOT NULL,
	host text NOT NULL,
	proto text NOT NULL,
	inb int8 NOT NULL,
	outb int8 NOT NULL,
	CONSTRAINT tsg_pkey PRIMARY KEY (id)
);
CREATE INDEX tsg_start_idx ON tsg USING btree (start);
CREATE INDEX tsg_end_idx ON tsg USING btree ("end");
CREATE INDEX tsg_user_idx ON tsg USING btree ("user", start);
ALTER TABLE tsg ADD CONSTRAINT tsg_tsg_log_fk FOREIGN KEY (log_id) REFERENCES tsg_log(id);
CLUSTER tsg using tsg_pkey;

-- Permissions
GRANT SELECT ON TABLE public.tsg TO "uxmR";
GRANT UPDATE, DELETE, INSERT ON TABLE public.tsg TO "uxmW";
