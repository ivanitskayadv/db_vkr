# db_vkr

Для упорядочивания объектов рекомендуется создать 4 табличных пространства: TS_EMPLOYEE, TS_EMPLOYEE_I, TS_WH_NEW, TS_WH_NEW_I для хранения таблиц и индексов соответственно.

При прямом экспорте данных в БД WH_NEW предварительно используйте команду: set session_replication_role to replica;

После завершения экспорта данных необходимо применить команду set session_replication_role to default;
Эта команда вновь активирует все существующие ограничения и триггеры.

Функция fn_gen_date(par_date date DEFAULT NULL::date, 
                    par_pos character DEFAULT NULL::character varying)
генерирует случайную дату при условии, если параметры не поданы. Необходимо подавать оба параметра, либо не подавать вовсе. 
Первый параметр отвечает за дату, до/после которой мы хотим сгенерировать случайную дату. 
Второй параметр отвечает за интервал, в котором будет генерироваться случайная дата. Может принимать лишь два значения 'A" (after) -- будут генерироваться все даты, позднее поданной в качестве параметра включительно.
                                                                                                                       'B" (before) -- будут генерироваться все даты, раннее поданной в качестве параметра включительно.
Интервал генерируемых дат ограничен промежутком 01-01-2006 -- 31.12-2023 (DD-MM-YYYY).


При необходимости генерации новых данных необходимо предварительно вызваать процедуру sp_create_temp_table(). После этого можно запустить скрипт 03_GEN_NEW_OPS-WH_NEW, настроив примерное количество операций в параметре I.

