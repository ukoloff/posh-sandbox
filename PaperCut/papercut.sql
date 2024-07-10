CREATE TABLE papercut (
	id int generated always as identity NOT NULL,
	"time" timestamp NOT NULL, -- Дата
	"user" varchar NOT NULL, -- Пользователь
	"pages" int4 NOT NULL, -- Страниц
	"copies" int4 NOT NULL, -- Копий
	"printer" varchar NOT NULL, -- Принтер
	"document" varchar NOT NULL, -- Документ
	"client" varchar NOT NULL, -- Компьютер
	"paper" varchar NOT NULL, -- Формат листа
	"language" varchar NOT NULL, -- Драйвер
	"height" varchar NOT NULL, -- Высота
	"width" varchar NOT NULL, -- Ширина
	"duplex" varchar NOT NULL, -- Двусторонняя печать
	"grayscale" varchar NOT NULL, -- Черно-белый
	"size" varchar NOT NULL, -- Размер файла
	CONSTRAINT papercut_pkey PRIMARY KEY (id)
);
CREATE INDEX "papercut_Client_Time" ON papercut USING btree ("client", "time");
CREATE INDEX "papercut_Time" ON papercut USING btree ("time");
CREATE INDEX "papercut_User_Time" ON papercut USING btree ("user", "time");
cluster papercut using papercut_pkey;

COMMENT ON TABLE  papercut IS 'PaperCut Log';
COMMENT ON COLUMN papercut."time" IS 'Дата';
COMMENT ON COLUMN papercut."user" IS 'Пользователь';
COMMENT ON COLUMN papercut."pages" IS 'Страниц';
COMMENT ON COLUMN papercut."copies" IS 'Копий';
COMMENT ON COLUMN papercut."printer" IS 'Принтер';
COMMENT ON COLUMN papercut."document" IS 'Документ';
COMMENT ON COLUMN papercut."client" IS 'Компьютер';
COMMENT ON COLUMN papercut."paper" IS 'Формат листа';
COMMENT ON COLUMN papercut."language" IS 'Драйвер';
COMMENT ON COLUMN papercut."height" IS 'Высота';
COMMENT ON COLUMN papercut."width" IS 'Ширина';
COMMENT ON COLUMN papercut."duplex" IS 'Двусторонняя печать';
COMMENT ON COLUMN papercut."grayscale" IS 'Черно-белый';
COMMENT ON COLUMN papercut."size" IS 'Размер файла';

GRANT SELECT ON TABLE papercut TO "uxmR";
GRANT DELETE, INSERT, UPDATE ON TABLE papercut TO "uxmW";

CREATE TABLE papercut_log (
	id int generated always as identity NOT NULL,
	ctime timestamptz DEFAULT clock_timestamp() NOT NULL, -- Дата создания
	session_id int4 NULL, -- В рамках соединения
	"day" date NULL, -- Добавляемый день
	duration float8 NULL, -- Продолжительность, сек
	total int4 NULL, -- Записей в дне всего
	added int4 NULL, -- Добавлено записей
	CONSTRAINT papercut_log_pkey PRIMARY KEY (id),
	CONSTRAINT papercut_log_papercut_log_fk FOREIGN KEY (session_id) REFERENCES papercut_log(id)
);
CREATE INDEX papercut_log_day_idx ON papercut_log USING btree (day, ctime);
cluster papercut_log using papercut_log_pkey;

-- Column comments

COMMENT ON TABLE  papercut_log IS 'PaperCut - журнал импорта';
COMMENT ON COLUMN papercut_log.ctime IS 'Дата создания';
COMMENT ON COLUMN papercut_log.session_id IS 'В рамках соединения';
COMMENT ON COLUMN papercut_log."day" IS 'Добавляемый день';
COMMENT ON COLUMN papercut_log.duration IS 'Продолжительность, сек';
COMMENT ON COLUMN papercut_log.total IS 'Записей в дне всего';
COMMENT ON COLUMN papercut_log.added IS 'Добавлено записей';

-- Permissions

GRANT SELECT ON TABLE papercut_log TO "uxmR";
GRANT INSERT, UPDATE ON TABLE papercut_log TO "uxmW";
