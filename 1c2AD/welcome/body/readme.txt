﻿Тексты писем для уведомлений новым сотрудникам
==============================================

В этой папке хранятся письма, которые будут рассылаться новым сотрудникам.

Первое письмо будет отослано примерно через 10 минут после того,
как будет создан почтовый ящик сотрудника. Последующие письма – каждое на следующий день,
в рабочее время. Суббота и воскресенье пропускаются.

Само количество рассылаемых писем определяется просто количеством файлов в папке,
можно добавлять или убирать.

Формат писем
------------
Письма можно размещать здесь в одном из двух форматов:

1) Простое текстовое письмо в файле N.txt (где N - номер письма, например 3.txt)

Первая строка - тема письма, она в тело письма не попадёт.
Если она нужна и в теле письма - просто продублируйте её в файле.

2) Письмо с форматированием

Лежит в подпапке, имеющей имя с номеро письма (например, 2).
В папке отдельно лежат тема письма, тело письма в формате HTML
и вложения.

Сформировать такую папку можно любым способом,
но проще всего:
1) подготовить письмо прямо в Outlook,
2) сохранить (Файл / Сохранить как) в эту папку в формате N.msg
3) Запустить скрипт msg2html.ps1
4) Указать ему сохранённый .msg-файл
5) Папка будет создана в нужном формате

После запуска скрипта msg2html.ps1 рекомендуется
закрыть и снова запустить Outlook.

