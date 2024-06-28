CREATE TABLE papercut (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	"Time" timestamp NOT NULL, -- Дата
	"User" varchar NOT NULL, -- Пользователь
	"Pages" int4 NOT NULL, -- Страниц
	"Copies" int4 NOT NULL, -- Копий
	"Printer" varchar NOT NULL, -- Принтер
	"Document Name" varchar NOT NULL, -- Документ
	"Client" varchar NOT NULL, -- Компьютер
	"PaperSize" varchar NOT NULL, -- Формат листа
	"Language" varchar NOT NULL, -- Драйвер
	"Height" varchar NOT NULL, -- Высота
	"Width" varchar NOT NULL, -- Ширина
	"Duplex" varchar NOT NULL, -- Двусторонняя печать
	"Grayscale" varchar NOT NULL, -- Черно-белый
	"Size" varchar NOT NULL, -- Размер файла
	CONSTRAINT papercut_pkey PRIMARY KEY (id)
);
CREATE INDEX "papercut_Client_Time" ON public.papercut USING btree ("Client", "Time");
CREATE INDEX "papercut_Time" ON public.papercut USING btree ("Time");
CREATE INDEX "papercut_User_Time" ON public.papercut USING btree ("User", "Time");
COMMENT ON TABLE public.papercut IS 'PaperCut Log';

COMMENT ON COLUMN public.papercut."Time" IS 'Дата';
COMMENT ON COLUMN public.papercut."User" IS 'Пользователь';
COMMENT ON COLUMN public.papercut."Pages" IS 'Страниц';
COMMENT ON COLUMN public.papercut."Copies" IS 'Копий';
COMMENT ON COLUMN public.papercut."Printer" IS 'Принтер';
COMMENT ON COLUMN public.papercut."Document Name" IS 'Документ';
COMMENT ON COLUMN public.papercut."Client" IS 'Компьютер';
COMMENT ON COLUMN public.papercut."PaperSize" IS 'Формат листа';
COMMENT ON COLUMN public.papercut."Language" IS 'Драйвер';
COMMENT ON COLUMN public.papercut."Height" IS 'Высота';
COMMENT ON COLUMN public.papercut."Width" IS 'Ширина';
COMMENT ON COLUMN public.papercut."Duplex" IS 'Двусторонняя печать';
COMMENT ON COLUMN public.papercut."Grayscale" IS 'Черно-белый';
COMMENT ON COLUMN public.papercut."Size" IS 'Размер файла';
