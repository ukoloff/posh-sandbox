CREATE TABLE papercut (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
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
CREATE INDEX "papercut_Client_Time" ON public.papercut USING btree ("client", "time");
CREATE INDEX "papercut_Time" ON public.papercut USING btree ("time");
CREATE INDEX "papercut_User_Time" ON public.papercut USING btree ("user", "time");

COMMENT ON TABLE public.papercut IS 'PaperCut Log';
COMMENT ON COLUMN public.papercut."time" IS 'Дата';
COMMENT ON COLUMN public.papercut."user" IS 'Пользователь';
COMMENT ON COLUMN public.papercut."pages" IS 'Страниц';
COMMENT ON COLUMN public.papercut."copies" IS 'Копий';
COMMENT ON COLUMN public.papercut."printer" IS 'Принтер';
COMMENT ON COLUMN public.papercut."document" IS 'Документ';
COMMENT ON COLUMN public.papercut."client" IS 'Компьютер';
COMMENT ON COLUMN public.papercut."paper" IS 'Формат листа';
COMMENT ON COLUMN public.papercut."language" IS 'Драйвер';
COMMENT ON COLUMN public.papercut."height" IS 'Высота';
COMMENT ON COLUMN public.papercut."width" IS 'Ширина';
COMMENT ON COLUMN public.papercut."duplex" IS 'Двусторонняя печать';
COMMENT ON COLUMN public.papercut."grayscale" IS 'Черно-белый';
COMMENT ON COLUMN public.papercut."size" IS 'Размер файла';

GRANT SELECT ON TABLE public.papercut TO "uxmR";
GRANT DELETE, INSERT, UPDATE ON TABLE public.papercut TO "uxmW";

CREATE TABLE papercut_log (
	id serial4 NOT NULL,
	ctime timestamptz DEFAULT clock_timestamp() NOT NULL, -- Дата создания
	session_id int4 NULL, -- В рамках соединения
	"day" date NULL, -- Добавляемый день
	duration float8 NULL, -- Продолжительность, сек
	total int4 NULL, -- Записей в дне всего
	added int4 NULL, -- Добавлено записей
	CONSTRAINT papercut_log_pk PRIMARY KEY (id),
	CONSTRAINT papercut_log_papercut_log_fk FOREIGN KEY (session_id) REFERENCES papercut_log(id)
);
CREATE INDEX papercut_log_day_idx ON papercut_log USING btree (day, ctime);

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
GRANT UPDATE ON SEQUENCE papercut_log_id_seq TO "uxmW";
