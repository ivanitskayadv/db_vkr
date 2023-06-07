CREATE OR REPLACE FUNCTION sp_create_new_agent()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE array_companies_name VARCHAR[] := ARRAY[
  'Сабона Плюс', 
  'Арт-Комплект', 
  'Металлиндустрия', 
  'Ресурс-Капитал', 
  'Торговый дом Уралкварц', 
  'Оникс', 
  'Ремстройсервис', 
  'МедиаСервис', 
  'Аргумент', 
  'Прайм-Информ', 
  'О Г М', 
  'НПП Модус-М', 
  'Стройтехносфера', 
  'Промснаб', 
  'Элегия', 
  'Интра-Трейд', 
  'УралВагонМеханика', 
  'Шина', 'Строй-Астер', 
  'Автодиск', 
  'Черметопторг',
  'Омега', 
  'ЭКСИМ', 
  'Троица', 
  'МЕТПРОМСЕРВИС', 
  'Уральская Ассоциация Клининга', 
  'Рекламное обеспечение бизнеса', 
  'Вектор', 
  'Ривьера', 
  'Радуга', 
  'Промышленная безопасность', 
  'СтройТрансАвто', 
  'ЕвроТорг', 
  'ТрансСервисВосток', 
  'МонтажСтройИнвест', 
  'Промторгснаб', 
  'Уралсервиcопт', 
  'Бетстрой', 
  'Лига', 
  'АВ-Маркет', 
  'Альянс', 
  'Снабкомплект', 
  'Золотой скорпион', 
  'Приам', 
  'ЭраСтрой', 
  'Урал', 
  'Веста', 
  'ТеплоЭнергоСтрой', 
  'Трубметком', 
  'Профи', 
  'Урал-Альянс', 
  'Универсал-Снаб', 
  'Крокус', 
  'Андромеда', 
  'Салма', 
  'Маяк', 
  'Гамма-Урал', 
  'Вегус', 
  'МИТМ', 
  'ВЭЛТКОМ',
  'Домком',
  'Лига-Кэпитал',
  'Спецпром',
  'ТИСС',
  'Механизированная колонна-12',
  'РЕАЛКОМ',
  'РЕАЛКОМ-ЕК',
  'Уралметторг',
  'Аква-Трейд',
  'Торг Сервис',
  'Орикс',
  'Лэтос',
  'МВК',
  'Строитель',
  'Среднерусский центр спортивного ориентирования', 
  'РУСИЧ', 
  'Монтажник-2', 
  'Платановая аллея', 
  'Усольский Художник', 
  'ПАТРИОТ', 
  'Луч - 7', 
  'Исток', 
  'ДАНИЛЫЧ', 
  'Игл', 
  'Нэвис+', 
  'Стройсервис', 
  'ЭМО',
  'ЛенСтройТоргСервис',
  'КЛИНЛЭНД',
  'МЕЦЕНАТ',
  'АЛЕТЕКС',
  'КВАДРО',
  'Гигабит',
  'Кубань Ксилолит',
  'АВТЕКС-ГРУПП',
  'Рыбокомбинат Волгоградский',
  'Регион Бизнес Альянс',
  'СТРОЙРЕАЛПРЕСТИЖ',
  'АРВЕСТ',
  'ЖБИ Сервис',
  'Реал - НН',
  'Бар-С',
  'Проспект-В',
  'Драйзэн',
  'ВОК - 72',
  'Лагуна',
  'Уралторг',
  'ГрафГаз',
  'Регионсерия',
  'Центр',
  'Срочная Американская Экспресс чистка',
  'АйСиком мастер',
  'МАШТЕХПРОДУКТ',
  'Клин Ленд',
  'Астроник',
  'Уралнефтьсервис',
  'МЕХАНИК',
  'Стелла',
  'Новые Решения',
  'Волжский Капитал',
  'ВИТНА',
  'Ореол С',
  'НВЛ',
  'Орлов и Компания',
  'Министерство',
  'ГрандАвто',
  'ВариантСтрой',
  'Урал-Торг',
  'Металлинвест',
  'АБСТехно',
  'Декарт',
  'Орион',
  'ДОГОДА',
  'Горизонт',
  'Забота',
  'ТРАНСМЕХ',
  'Элана',
  'Водоканал',
  'Барс',
  'Спецторг',
  'Рыбацкая деревня',
  'ЭЛЕКТРОМАШ',
  'Палкинский',
  'Управдом',
  'Тёплый Дом',
  'Чаплыгинский',
  'Опытно-Механический завод',
  'ТЕЗА-ВН',
  'Теза-Н',
  'ЛУЧ-3',
  'Автотехсервис',
  'Дельта-С',
  'Мединфос',
  'Кентавр',
  'Техцентр',
  'Петровские дачи',
  'ЭнергоАктив',
  'Унимерская слобода',
  'Гольдберг-Софт',
  'ВИКТОРИЯ-Л',
  'Энергетик',
  'ВЫМПЕЛ',
  'Призма',
  'А-Я', 
  'Загородный 45', 
  'БСУ', 
  'Академия Бильярда', 
  'Эскорт-медиа', 
  'Паритет', 
  'Продвижение', 
  'Дельта', 
  'Строй-Альянс', 
  'Интерком', 
  'АКСЕЛЬ', 
  'Финпромснаб', 
  'Кит', 
  'ПЕРЕСВЕТ', 
  'Рекаунт', 
  'Адамант', 
  'Лаксар', 
  'Эдельвейс', 
  'Еврокласс-Урал', 
  'Инстрэл', 
  'Лес-Пром', 
  'СтройМатериалы', 
  'Нивад', 
  'Фарфора Сысерти', 
  'Авианта', 
  'Астон Консалтинг',
  'Тритон', 
  'БЕСТ', 
  'Промбетон', 
  'Суводское', 
  'Автосервис №1', 
  'Техноком', 
  'РИР', 
  'Обнорское', 
  'КВТ', 
  'Бриз', 
  'Олимпик-Транс', 
  'Ника LTD', 
  'ТРАНСОЙЛ', 
  'МИГ', 
  'Кубаньтрансстройсервис', 
  'Подъёмэкспертсервис', 
  'Мехпромстрой-ЮГ', 
  'Техинсервис', 
  'Азимут +'  
  ];
DECLARE array_cities VARCHAR[] := ARRAY[
  'Ростов-на-Дону',
  'Казань', 
  'Новосибирск',
  'Краснодар',
  'Санкт-Петербург', 
  'Москва',
  'Екатеринбург',
  'Шахты',
  'Азов',
  'Таганрог',
  'Батайск'
  ];
DECLARE 
  len_cities INT := array_length(array_cities, 1);
  len_companies INT := array_length(array_companies_name, 1);
  I INT;
  temp_phone VARCHAR;
BEGIN 
  FOR I IN 1..len_companies 
  LOOP
    IF (SIGN(RANDOM()-0.8) = -1) THEN 
      INSERT INTO tbl_agent(id_ag, name_ag, town, phone) 
      VALUES 
        (NULL, array_companies_name[i], array_cities[FLOOR(RANDOM()*(len_cities+1-1)+1)], fn_gen_phone());
    ELSE
      INSERT INTO tbl_agent(id_ag, name_ag, town, phone) 
      VALUES 
        (NULL, array_companies_name[i], array_cities[FLOOR(RANDOM()*(len_cities+1-1)+1)], NULL);
    END IF;
  END LOOP; 
END;
$function$
;

CREATE OR REPLACE FUNCTION sp_create_new_goods()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE array_nom VARCHAR[]:= ARRAY [
  'Шариковая ручка (6 шт)',
  'Гелевая ручка (6 шт)', 
  'Маркер',
  'Картон', 
  'Дневник',
  'Калька',
  'Копировальная бумага',
  'Линейка',
  'Транспортир',
  'Циркуль',
  'Ластик',
  'Степлер',
  'Скобы для степлера (100 шт)',
  'Антистеплер',
  'Скрепка (10 шт)',
  'Булавка (8 шт)',
  'Скоросшиватель',
  'Файлы (25 шт)',
  'Конверт',
  'Подставка для книг',
  'Набор закладок (5 шт)',
  'Обложка для книг (3 шт)',
  'Канцелярский нож',
  'Точилка для карандашей',
  'Ножницы',
  'Дырокол',
  'Скотч',
  'Изолента',
  'Клей-карандаш',
  'Клей ПВА',
  'Набор стикеров (50 шт)',
  'Пластилин',
  'Гуашь',
  'Акварель',
  'Кисть',
  'Мел',
  'Пастель',
  'Календарь',
  'Калькулятор',
  'Корректор',
  'Фломастер (6 шт)',
  'Школьный пенал',
  'Ватман',
  'Глобус',
  'Лупа',
  'Кнопка',
  'Трафарет',
  'Грамота', 
  'Механический карандаш',
  'Зажим для бумаги',
  'Бейджик',
  'Настенная карта',
  'Визитница',
  'Портфель',
  'Рюкзак'
];
len_nom INT := ARRAY_LENGTH(array_nom, 1);
I INT;
BEGIN 
  FOR I IN 1..len_nom LOOP
    IF (array_nom[I] LIKE '%' || ' шт)') THEN 
      INSERT INTO tbl_goods 
      VALUES (NULL, array_nom[I], 'уп');
    ELSE 
      INSERT INTO tbl_goods 
      VALUES (NULL, array_nom[I], 'шт');
    END IF;
  END LOOP;
END;
$function$
;

CREATE OR REPLACE FUNCTION sp_create_new_warehouse()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE array_all VARCHAR[] := ARRAY [
'4', 
'ООО Бобер',
'19',
'ООО Поиск',
'20',
'на ул. Мира',
'22',
'7',
'на ул. Сосновая',
'13',
'ИП Иванов',
'14',
'25',
'ООО ВКР',
'на ул. Комарова',
'на ул. Заречная',
'на ул. Колхозная',
'ПАО Магнит', '15',
'ООО ДАШЛЕШ',
'ООО Тракторист',
'11', 'ИП Петров',
'на ул. Горизонтальная',
'на ул. Параллельная',
'5', '10', 'ПАО Сбербанк',
'8', 'ИП Лебовски',
'ПАО МТС',
'на ул. Южная',
'ПАО Ренессанс',
'на ул. Садовая',
'23',
'ПАО Лапки и ушки',
'ООО Гроза',
'ООО Мотылек',
'9',
'6',
'на ул. Майская',
'ИП Троцкий',
'на ул. Озерная',
'на ул. Чапаева',
'21',
'на ул. Трудовая',
'ПАО Газпром',
'24',
'на ул. Подгорная',
'12',
'16',
'на ул. Фрунзе',
'на ул. Горького',
'на ул. Березовая',
'17', 'на ул. Шоссейная',
'18', 'на ул. Полевая',
'ПАО Самокат',
'ООО Кловер',
'ИП Ванин',
'ИП Сальников',
'на ул. Вертикальная',
'на ул. Чехова',
'ИП Дробиков',
'на ул. Восточная'
];
array_cities VARCHAR[] := ARRAY[
  'Ростов-на-Дону',
  'Казань', 
  'Новосибирск',
  'Краснодар',
  'Санкт-Петербург', 
  'Москва',
  'Екатеринбург',
  'Шахты',
  'Азов',
  'Таганрог',
  'Батайск'
];
len_lp INT:= ARRAY_LENGTH(array_all, 1);
len_cities INT := ARRAY_LENGTH(array_cities, 1);
--len_streets INT := array_length(array_streets, 1);
--len_ints INT := array_length(array_ints, 1);
I INT;
BEGIN 
  FOR I IN 1..len_lp LOOP
    INSERT INTO warehouse 
    VALUES (NULL, 'Склад ' || array_all[i], array_cities[FLOOR(RANDOM()*(len_cities+1-1)+1)]);
  END LOOP; 
END;
$function$
;

CREATE OR REPLACE FUNCTION fn_gen_date(par_date date DEFAULT NULL::date)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
  DECLARE 
  PAR_MONTH INT;
  PAR_YEAR INT;
  YEAR_ INT;
  MONTH_ INT;
  MONTH_2 VARCHAR;
  DAY_ VARCHAR;
  BEGIN 
    PAR_YEAR  := (SELECT COALESCE(EXTRACT (YEAR  FROM PAR_DATE), 2023));
    PAR_MONTH := (SELECT COALESCE(EXTRACT (MONTH FROM PAR_DATE), 12));
    YEAR_     := ROUND(RANDOM()*(PAR_YEAR-2006)+2006);
    MONTH_    := ROUND(RANDOM()*(PAR_MONTH-1)+1);
    
    IF (MOD(YEAR_, 4) = 0 AND MONTH_ = 2) THEN
      DAY_ := ROUND(RANDOM()*(SELECT 
                              CASE 
                                WHEN PAR_YEAR = YEAR_ AND PAR_MONTH = MONTH_ THEN 
                                  EXTRACT (DAY  FROM PAR_DATE) - 1
                                ELSE 
                                  29-1
                              END) + 1);  
    ELSIF (MONTH_ IN (1, 3, 5, 7, 8, 10, 12)) THEN
      DAY_ := ROUND(RANDOM()*(SELECT 
                              CASE 
                                WHEN PAR_YEAR = YEAR_ AND PAR_MONTH = MONTH_ THEN 
                                  EXTRACT (DAY  FROM PAR_DATE) - 1
                                ELSE 
                                  31-1
                              END) + 1);
    ELSIF (MONTH_ IN (4, 6, 9, 11)) THEN
      DAY_ := ROUND(RANDOM()*(SELECT 
                              CASE 
                                WHEN PAR_YEAR = YEAR_ AND PAR_MONTH = MONTH_ THEN 
                                  EXTRACT (DAY  FROM PAR_DATE) - 1
                                ELSE 
                                  30-1
                              END) + 1);
    ELSE 
      DAY_ := ROUND(RANDOM()*(SELECT 
                              CASE 
                                WHEN PAR_YEAR = YEAR_ AND PAR_MONTH = MONTH_ THEN 
                                  EXTRACT (DAY  FROM PAR_DATE) - 1
                                ELSE 
                                  28-1
                              END) + 1);
    END IF;
    DAY_ := '0' || DAY_;
    MONTH_2 := '0' || MONTH_;

    IF LENGTH(DAY_) = 3 THEN DAY_ := LTRIM(DAY_, '0'); END IF;
    IF LENGTH(MONTH_2) = 3 THEN MONTH_2 := LTRIM(MONTH_2, '0'); END IF;
  
    RETURN DAY_ || '-' || MONTH_2 || '-' || YEAR_ ;
   
  END;
$function$
;

CREATE OR REPLACE FUNCTION fn_gen_phone()
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
BEGIN 
  RETURN CAST(FLOOR(RANDOM()*(999-100)+100) AS VARCHAR) || '-' || CAST(FLOOR(RANDOM() * (99-10) + 10) AS VARCHAR) || '-' || CAST(FLOOR(RANDOM() * (99-10) + 10) AS VARCHAR);
END;
$function$
;

CREATE OR REPLACE PROCEDURE sp_create_temp_table()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
  CREATE GLOBAL TEMPORARY TABLE TMP_ID_GOODS 
  (
    ID_GOODS VARCHAR
  ) ON COMMIT PRESERVE ROWS;
  
  INSERT INTO TMP_ID_GOODS
    SELECT ID_GOODS 
      FROM tbl_goods
     ORDER BY RANDOM()
     LIMIT 45;
  
  CREATE GLOBAL TEMPORARY TABLE TMP_ID_AG
  (
    ID_AG VARCHAR
  ) ON COMMIT PRESERVE ROWS;
  
  INSERT INTO TMP_ID_AG
    SELECT ID_AG
      FROM tbl_agent
     ORDER BY RANDOM()
     LIMIT 200;
  
  CREATE GLOBAL TEMPORARY TABLE TMP_ID_WH
  (
    ID_WH VARCHAR
  ) ON COMMIT PRESERVE ROWS;
  
  INSERT INTO TMP_ID_WH
    SELECT ID_WH
      FROM tbl_warehouse
     ORDER BY RANDOM()
     LIMIT 60;
   
  CREATE GLOBAL TEMPORARY TABLE TMP_OPERATION
  (
    ID SERIAL,
    ID_GOODS VARCHAR(10) NOT NULL,
    ID_AG VARCHAR(10) NOT NULL,
    ID_WH VARCHAR(10) NOT NULL,
    TYPEOP VARCHAR(1) NOT NULL,
    QUANTITY NUMERIC(15, 2) NOT NULL,
    PRICE NUMERIC(15, 2) NULL,
    OP_DATE DATE NULL 
  ) ON COMMIT PRESERVE ROWS;

  CREATE GLOBAL TEMPORARY TABLE TMP_GOODS_WH
  (
    ID SERIAL,
    ID_WH VARCHAR(10) NOT NULL,
    ID_GOODS VARCHAR(10) NOT NULL,
    QUANTITY NUMERIC(15, 2) NULL
  ) ON COMMIT PRESERVE ROWS;

END;
$procedure$
; 

CREATE OR REPLACE FUNCTION fn_tg_fill_goods_wh()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE 
  S_GOODS_NAME VARCHAR;
  S_WH_NAME    VARCHAR;
  V_QUANTITY   INTEGER;
BEGIN
  S_GOODS_NAME := (SELECT NOMENCLATURE FROM tbl_goods WHERE id_goods = NEW.ID_GOODS);
  S_WH_NAME    := (SELECT         NAME FROM tbl_warehouse WHERE ID_WH = NEW.ID_WH);
  V_QUANTITY := (SELECT QUANTITY FROM tbl_goods_wh WHERE id_goods = NEW.ID_GOODS AND id_wh = NEW.ID_WH);
  IF NEW.TYPEOP = 'A' THEN
    UPDATE tbl_goods_wh
       SET quantity = quantity + NEW.QUANTITY
     WHERE id_goods = NEW.ID_GOODS
       AND id_wh    = NEW.ID_WH;
    IF NOT FOUND THEN
      INSERT INTO tbl_goods_wh(ID_WH, id_goods, QUANTITY)
      VALUES (NEW.ID_WH, NEW.ID_GOODS, NEW.QUANTITY);
    END IF;
  ELSIF (NEW.TYPEOP = 'R') AND (V_QUANTITY >= NEW.QUANTITY) THEN
    UPDATE tbl_goods_wh
       SET quantity = quantity - NEW.QUANTITY
     WHERE id_goods = NEW.ID_GOODS
       AND id_wh    = NEW.ID_WH;
  ELSE
    RAISE EXCEPTION 'Ошибка. Недостаточное количество (%) товара % % на складе % %, попытка увезти %', V_QUANTITY, S_GOODS_NAME, NEW.ID_GOODS, S_WH_NAME, NEW.ID_WH, NEW.QUANTITY; 
  END IF;
  RETURN NULL;
END;
$function$
;

CREATE TRIGGER TG_FILL_GOODS_WH
AFTER INSERT
ON PUBLIC.TBL_OPERATION
FOR EACH ROW
  EXECUTE FUNCTION PKG_FILL_DB.FN_TG_FILL_GOODS_WH()
 
CREATE OR REPLACE FUNCTION fn_tg_delete_zero_goods_wh()
  RETURNS TRIGGER
  LANGUAGE plpgsql
AS $FUNCTION$
DECLARE 
BEGIN 
  IF NEW.QUANTITY = 0 THEN 
    DELETE FROM TBL_GOODS_WH
     WHERE ID = OLD.ID;
  END IF;
  RETURN NULL;
END;
$FUNCTION$;
  
CREATE TRIGGER TG_DELETE_ZERO_GOODS_WH
AFTER UPDATE 
ON TBL_GOODS_WH 
FOR EACH STATEMENT 
EXECUTE FUNCTION fn_tg_delete_zero_goods_wh(); 