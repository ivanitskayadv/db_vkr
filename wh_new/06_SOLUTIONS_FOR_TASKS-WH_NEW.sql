--9. НАЙТИ КОЛИЧЕСТВО РАЗНЫХ ТОВАРОВ, С КОТОРЫМИ РАБОТАЛ КАЖДЫЙ ПОСТАВЩИК.
SELECT COUNT(DISTINCT OP.ID_GOODS), AG.NAME_AG
FROM PUBLIC.TBL_OPERATION AS OP
RIGHT JOIN PUBLIC.TBL_AGENT AS AG USING(ID_AG)
GROUP BY NAME_AG;
 
--10. НАЙТИ МИНИМАЛЬНУЮ СТОИМОСТЬ ОПЕРАЦИИ ДЛЯ КАЖДОГО ПОСТАВЩИКА.
SELECT NAME_AG, COALESCE(MIN(OP.QUANTITY * OP.PRICE), 0) AS "TOTAL"
FROM PUBLIC.TBL_OPERATION AS OP
RIGHT JOIN PUBLIC.TBL_AGENT AS AG USING(ID_AG)
GROUP BY ID_AG, NAME_AG;
  
--11. ДЛЯ КАЖДОГО СКЛАДА ОПРЕДЕЛИТЬ СУММАРНОЕ КОЛИЧЕСТВО ХРАНЯЩИХСЯ НА НЕМ ТОВАРОВ.
SELECT WH.NAME, COALESCE(SUM(GW.QUANTITY), 0)
FROM PUBLIC.TBL_WAREHOUSE AS WH
LEFT JOIN PUBLIC.TBL_GOODS_WH AS GW USING(ID_WH)
GROUP BY NAME;

                            --1. НАЙТИ ПОСТАВЩИКОВ, КОТОРЫЕ РАБОТАЛИ С ТОВАРОМ «ПАПКИ».
SELECT ID_AG, NAME_AG, TOWN, PHONE  
  FROM PUBLIC.TBL_AGENT AS TA 
 WHERE TA.ID_AG IN (SELECT ID_AG
                      FROM PUBLIC.TBL_OPERATION AS TO2
                     WHERE ID_GOODS = (SELECT ID_GOODS FROM PUBLIC.TBL_GOODS AS TG WHERE NOMENCLATURE = 'Фломастер (6 шт)'));
                   
SELECT ID_AG, NAME_AG, TOWN, PHONE  
  FROM PUBLIC.TBL_AGENT AS TA 
 WHERE EXISTS(SELECT ID_AG
                FROM PUBLIC.TBL_OPERATION AS TO2
               WHERE ID_GOODS = (SELECT ID_GOODS FROM PUBLIC.TBL_GOODS AS TG WHERE NOMENCLATURE = 'Фломастер (6 шт)')
                 AND TO2.ID_AG = TA.ID_AG);
               
SELECT ID_AG, NAME_AG, TOWN, PHONE  
  FROM PUBLIC.TBL_AGENT AS TA 
 WHERE TA.ID_AG IN (SELECT ID_AG
                      FROM PUBLIC.TBL_OPERATION AS TO2
                      JOIN PUBLIC.TBL_GOODS AS TG 
                        ON TO2.ID_GOODS = TG.ID_GOODS 
                     WHERE TG.NOMENCLATURE = 'Фломастер (6 шт)'
                    );
                  
SELECT ID_AG, NAME_AG, TOWN, PHONE  
  FROM PUBLIC.TBL_AGENT AS TA 
 WHERE EXISTS(SELECT ID_AG
                      FROM PUBLIC.TBL_OPERATION AS TO2
                      JOIN PUBLIC.TBL_GOODS AS TG 
                        ON TO2.ID_GOODS = TG.ID_GOODS 
                     WHERE TG.NOMENCLATURE = 'Фломастер (6 шт)'
                       AND TO2.ID_AG = TA.ID_AG);
                     
SELECT TA.ID_AG, TA.NAME_AG, TA.TOWN, TA.PHONE 
  FROM PUBLIC.TBL_AGENT AS TA 
  JOIN PUBLIC.TBL_OPERATION AS TO2 
    ON TA.ID_AG = TO2.ID_AG 
  JOIN PUBLIC.TBL_GOODS AS TG 
    ON TG.ID_GOODS = TO2.ID_GOODS 
WHERE TG.NOMENCLATURE = 'Фломастер (6 шт)'; 

                                --2. НАЙТИ ТОВАРЫ, С КОТОРЫМИ НЕ БЫЛО НИ ОДНОЙ ОПЕРАЦИИ.
SELECT TG.ID_GOODS, TG.NOMENCLATURE, TG.MEASURE 
  FROM PUBLIC.TBL_GOODS AS TG
 WHERE ID_GOODS NOT IN (SELECT ID_GOODS FROM PUBLIC.TBL_OPERATION AS TO2);
 
SELECT TG.ID_GOODS, TG.NOMENCLATURE, TG.MEASURE 
  FROM PUBLIC.TBL_GOODS AS TG 
 WHERE NOT EXISTS(SELECT ID_GOODS FROM PUBLIC.TBL_OPERATION AS TO2 WHERE TO2.ID_GOODS = TG.ID_GOODS);
 
SELECT TG.ID_GOODS, TG.NOMENCLATURE, TG.MEASURE 
  FROM PUBLIC.TBL_GOODS AS TG 
  LEFT JOIN PUBLIC.TBL_OPERATION AS TO2 
    ON TG.ID_GOODS = TO2.ID_GOODS 
 WHERE OP_DATE IS NULL;
 
SELECT ID_GOODS
  FROM public.tbl_goods  
EXCEPT 
SELECT id_goods 
  FROM public.tbl_operation;
 
                                --3. НАЙТИ ПОСТАВЩИКОВ, КОТОРЫЕ ВЫПОЛНИЛИ ТОЛЬКО ОДНУ ПОСТАВКУ.
SELECT TA.ID_AG, TA.NAME_AG 
  FROM PUBLIC.TBL_OPERATION AS TO2 
  JOIN PUBLIC.TBL_AGENT AS TA 
    ON TO2.ID_AG = TA.ID_AG 
 GROUP BY TA.ID_AG, TA.NAME_AG 
HAVING COUNT(*) = 1;

SELECT TA.ID_AG, TA.NAME_AG, TA.TOWN, TA.PHONE 
  FROM PUBLIC.TBL_AGENT AS TA 
 WHERE ID_AG IN (SELECT ID_AG 
                   FROM PUBLIC.TBL_OPERATION AS TO2
                  GROUP BY ID_AG 
                 HAVING COUNT(*) = 1);
               
SELECT TA.ID_AG, TA.NAME_AG, TA.TOWN, TA.PHONE 
  FROM PUBLIC.TBL_AGENT AS TA 
 WHERE EXISTS (SELECT ID_AG
                 FROM PUBLIC.TBL_OPERATION AS TO2 
                WHERE TO2.ID_AG = TA.ID_AG 
                GROUP BY ID_AG 
               HAVING COUNT(*) = 1);
            
              --4. НАЙТИ ПОСТАВЩИКОВ, КОТОРЫЕ ПОСТАВЛЯЛИ (ОПЕРАЦИИ A ) КАРАНДАШИ -> Копировальная бумага ПО МИНИМАЛЬНОЙ ЦЕНЕ.
                                            --WITH T AS  (
                                            --SELECT TO2.ID_GOODS, TG.NOMENCLATURE, MIN(PRICE) AS MIN
                                            --  FROM public.tbl_operation AS to2 
                                            --  JOIN public.tbl_goods AS tg 
                                            --    ON TO2.id_goods = TG.id_goods 
                                            -- GROUP BY TO2.ID_GOODS, NOMENCLATURE
                                            -- ORDER BY 3)            
                                            --             
                                            --SELECT TO2.ID_GOODS, TG.NOMENCLATURE, COUNT(*)
                                            --  FROM public.tbl_operation AS to2 
                                            --  JOIN public.tbl_goods AS tg 
                                            --    ON TO2.id_goods = TG.id_goods  
                                            -- WHERE PRICE = (SELECT T.MIN FROM T WHERE T.ID_GOODS = TO2.ID_GOODS)
                                            -- GROUP BY TO2.ID_GOODS, TG.NOMENCLATURE
                                            -- ORDER BY 3 DESC;

SELECT DISTINCT TA.id_ag, TA.name_ag, TA.town, TA.phone 
  FROM public.tbl_agent AS ta 
  JOIN public.tbl_operation AS to2 
    ON TA.id_ag = TO2.id_ag 
  JOIN public.tbl_goods AS tg 
    ON TG.id_goods = TO2.id_goods 
 WHERE TG.NOMENCLATURE = 'Копировальная бумага'
   AND TYPEOP = 'A'
   AND TO2.PRICE = (SELECT MIN(PRICE) 
                      FROM public.tbl_operation  
                     WHERE ID_GOODS = (SELECT ID_GOODS 
                                         FROM public.tbl_goods AS tg2 
                                        WHERE NOMENCLATURE = 'Копировальная бумага'));

SELECT DISTINCT TA.id_ag, TA.name_ag, TA.town, TA.phone 
  FROM public.tbl_agent AS ta 
  JOIN public.tbl_operation AS to2 
    ON TA.id_ag = TO2.id_ag 
  JOIN public.tbl_goods AS tg 
    ON TG.id_goods = TO2.id_goods 
 WHERE TG.NOMENCLATURE = 'Копировальная бумага'
   AND TYPEOP = 'A'
   AND TO2.PRICE = (SELECT MIN(PRICE) 
                      FROM public.tbl_operation to3
                      JOIN public.tbl_goods tg2
                        ON to3.id_goods = tg.id_goods 
                     WHERE NOMENCLATURE = 'Копировальная бумага');                                      
                                      
SELECT DISTINCT TA.id_ag, TA.name_ag, TA.town, TA.phone 
  FROM public.tbl_agent AS ta 
 WHERE EXISTS(SELECT id_ag
                FROM public.tbl_operation AS to3
               WHERE TYPEOP = 'A'
                 AND TO3.id_ag = TA.id_ag 
                 AND ID_GOODS = (SELECT ID_GOODS FROM public.tbl_goods AS tg WHERE NOMENCLATURE = 'Копировальная бумага')
                 AND TO3.PRICE = (SELECT MIN(PRICE) 
                                    FROM public.tbl_operation  
                                   WHERE ID_GOODS = (SELECT ID_GOODS 
                                                       FROM public.tbl_goods AS tg2 
                                                      WHERE NOMENCLATURE = 'Копировальная бумага')))
                                                      
SELECT DISTINCT TA.id_ag, TA.name_ag, TA.town, TA.phone 
  FROM public.tbl_agent AS ta 
 WHERE EXISTS(SELECT id_ag
                FROM public.tbl_operation AS to3
                JOIN public.tbl_goods TG
                  ON TG.id_goods = TO3.id_goods 
               WHERE TYPEOP = 'A'
                 AND TO3.id_ag = TA.id_ag 
                 AND NOMENCLATURE = 'Копировальная бумага'
                 AND TO3.PRICE = (SELECT MIN(PRICE) 
                                    FROM public.tbl_operation  
                                   WHERE ID_GOODS = (SELECT ID_GOODS 
                                                       FROM public.tbl_goods AS tg2 
                                                      WHERE NOMENCLATURE = 'Копировальная бумага')));
                                                    
SELECT DISTINCT TA.id_ag, TA.name_ag, TA.town, TA.phone 
  FROM public.tbl_agent AS ta 
 WHERE EXISTS(SELECT id_ag
                FROM public.tbl_operation AS to3
                JOIN public.tbl_goods TG
                  ON TG.id_goods = TO3.id_goods 
               WHERE TYPEOP = 'A'
                 AND TO3.id_ag = TA.id_ag 
                 AND NOMENCLATURE = 'Копировальная бумага'
                 AND TO3.PRICE = (SELECT MIN(PRICE) 
                                    FROM public.tbl_operation to4
                                    JOIN public.tbl_goods tg2
                                      ON TO4.id_goods = TG2.id_goods 
                                   WHERE NOMENCLATURE = 'Копировальная бумага'));                                                    
                                                    

SELECT DISTINCT TA.id_ag, TA.name_ag, TA.town, TA.phone 
  FROM public.tbl_agent AS ta 
 WHERE ID_AG IN (SELECT id_ag
                  FROM public.tbl_operation AS to3
                 WHERE TYPEOP = 'A'
                   AND ID_GOODS = (SELECT ID_GOODS FROM public.tbl_goods AS tg WHERE NOMENCLATURE = 'Копировальная бумага')
                   AND TO3.PRICE = (SELECT MIN(PRICE) 
                                      FROM public.tbl_operation  
                                     WHERE ID_GOODS = (SELECT ID_GOODS 
                                                         FROM public.tbl_goods AS tg2 
                                                        WHERE NOMENCLATURE = 'Копировальная бумага')));
                                                      
SELECT DISTINCT TA.id_ag, TA.name_ag, TA.town, TA.phone 
  FROM public.tbl_agent AS ta 
 WHERE ID_AG IN  (SELECT id_ag
                    FROM public.tbl_operation AS to3
                    JOIN public.tbl_goods TG
                      ON TG.id_goods = TO3.id_goods 
                   WHERE TYPEOP = 'A'
                     AND NOMENCLATURE = 'Копировальная бумага'
                     AND TO3.PRICE = (SELECT MIN(PRICE) 
                                        FROM public.tbl_operation  
                                       WHERE ID_GOODS = (SELECT ID_GOODS 
                                                           FROM public.tbl_goods AS tg2 
                                                          WHERE NOMENCLATURE = 'Копировальная бумага'))); 
                                                        
SELECT DISTINCT TA.id_ag, TA.name_ag, TA.town, TA.phone 
  FROM public.tbl_agent AS ta 
 WHERE ID_AG IN(SELECT id_ag
                  FROM public.tbl_operation AS to3
                  JOIN public.tbl_goods TG
                    ON TG.id_goods = TO3.id_goods 
                 WHERE TYPEOP = 'A'
                   AND NOMENCLATURE = 'Копировальная бумага'
                   AND TO3.PRICE = (SELECT MIN(PRICE) 
                                      FROM public.tbl_operation to4
                                      JOIN public.tbl_goods tg2
                                        ON TO4.id_goods = TG2.id_goods 
                                     WHERE NOMENCLATURE = 'Копировальная бумага'));                                                           
                
SELECT DISTINCT TA.id_ag, TA.name_ag, TA.town, TA.phone 
  FROM public.tbl_agent AS ta 
  JOIN (SELECT id_ag
          FROM public.tbl_operation AS to3
          JOIN public.tbl_goods TG
            ON TG.id_goods = TO3.id_goods 
         WHERE TYPEOP = 'A'
           AND NOMENCLATURE = 'Копировальная бумага'
           AND TO3.PRICE = (SELECT MIN(PRICE) 
                              FROM public.tbl_operation to4
                              JOIN public.tbl_goods tg2
                                ON TO4.id_goods = TG2.id_goods 
                             WHERE NOMENCLATURE = 'Копировальная бумага')) T
    ON T.ID_AG = TA.id_ag; 
 
--5. НАЙТИ СКЛАДЫ, С КОТОРЫМИ НЕ БЫЛО НИ ОДНОЙ ОПЕРАЦИИ.
SELECT TW.id_wh, TW."name", TW.town 
  FROM public.tbl_warehouse AS tw 
 WHERE NOT EXISTS(SELECT id_wh
                    FROM public.tbl_operation AS to2
                   WHERE TO2.id_wh = TW.id_wh);
                 
SELECT TW.id_wh, TW."name", TW.town 
  FROM public.tbl_warehouse AS tw 
 WHERE TW.id_wh NOT IN (SELECT id_wh
                          FROM public.tbl_operation AS to2);
                        
SELECT NAME FROM public.tbl_warehouse AS tw2 
WHERE id_wh IN (SELECT id_wh 
                  FROM public.tbl_warehouse AS tw 
                EXCEPT 
                SELECT id_wh 
                  FROM public.tbl_operation AS to2);
                
SELECT NAME FROM public.tbl_warehouse AS tw2 
WHERE EXISTS (SELECT id_wh 
                FROM public.tbl_warehouse AS tw
               WHERE id_wh = TW2.id_wh 
              EXCEPT 
              SELECT id_wh 
                FROM public.tbl_operation AS to2
               WHERE id_wh = TW2.id_wh);  
             
SELECT TW.*
  FROM public.tbl_warehouse AS tw 
  LEFT JOIN public.tbl_operation AS to2 
    ON TW.id_wh = TO2.id_wh 
 WHERE TO2.OP_DATE IS NULL;
                        
                                   
--6. НАЙТИ ПОСТАВЩИКОВ, КОТОРЫЕ РАБОТАЮТ БОЛЕЕ ЧЕМ С ОДНИМ СКЛАДОМ.
SELECT TA.id_ag, TA.name_ag, TA.town, TA.phone, COUNT(*) OVER (ORDER BY 1)
  FROM public.tbl_agent AS ta
 WHERE EXISTS(SELECT id_ag
                FROM public.tbl_operation AS to3
               WHERE TO3.id_ag = TA.id_ag 
               GROUP BY id_ag
              HAVING COUNT(DISTINCT ID_WH) > 1);
            
SELECT TA.id_ag, TA.name_ag, TA.town, TA.phone, COUNT(*) OVER (ORDER BY 1)
  FROM public.tbl_agent AS ta
 WHERE ID_AG IN (SELECT id_ag
                   FROM public.tbl_operation AS to3 
                  GROUP BY id_ag
                 HAVING COUNT(DISTINCT ID_WH) > 1);
               
SELECT TA.id_ag, TA.name_ag, TA.town, TA.phone, COUNT(*) OVER (ORDER BY 1)
  FROM (SELECT TA2.ID_AG
          FROM public.tbl_agent AS ta2
          JOIN public.tbl_operation AS to2
            ON TA2.ID_AG = TO2.id_ag 
         GROUP BY TA2.ID_AG
        HAVING COUNT(DISTINCT ID_WH) > 1) T
  JOIN public.tbl_agent AS ta 
    ON TA.id_ag = T.ID_AG;
            
WITH T AS (SELECT TA2.ID_AG
          FROM public.tbl_agent AS ta2
          JOIN public.tbl_operation AS to2
            ON TA2.ID_AG = TO2.id_ag 
         GROUP BY TA2.ID_AG
        HAVING COUNT(DISTINCT ID_WH) > 1)

SELECT TA.id_ag, TA.name_ag, TA.town, TA.phone, COUNT(*) OVER (ORDER BY 1)
  FROM public.tbl_agent AS ta 
 WHERE EXISTS(SELECT id_ag FROM T WHERE T.ID_AG = TA.ID_AG);
 
SELECT TA.id_ag, TA.name_ag, TA.town, TA.phone, COUNT(*) OVER (ORDER BY 1)
  FROM public.tbl_agent AS ta 
 WHERE ID_AG IN (SELECT id_ag FROM T); 
 
--7. НАЙТИ ТОВАРЫ, ДЛЯ КОТОРЫХ БЫЛА ВЫПОЛНЕНА ТОЛЬКО ОДНА ПОСТАВКА (A)
 
--INSERT INTO public.tbl_operation(id_goods, id_ag, id_wh, typeop, quantity, price, op_date) 
--VALUES('Т86', 'p218', 'С49', 'A', 320, 100, TO_DATE('27-05-2023', 'DD-MM-YYYY'));
 
SELECT TG.id_goods, TG.nomenclature, TG.measure 
  FROM public.tbl_goods AS tg 
 WHERE EXISTS(SELECT ID_GOODS
                FROM public.tbl_operation AS to2
               WHERE TO2.ID_GOODS = TG.id_goods
                 AND TYPEOP = 'A'
               GROUP BY id_goods
              HAVING COUNT(*) = 1);
            
SELECT TG.id_goods, TG.nomenclature, TG.measure 
  FROM public.tbl_goods AS tg 
 WHERE TG.id_goods  IN (SELECT ID_GOODS
                          FROM public.tbl_operation AS to2
                         WHERE TYPEOP = 'A'
                         GROUP BY id_goods
                        HAVING COUNT(*) = 1); 
                      
SELECT TG.id_goods, TG.nomenclature, TG.measure 
  FROM public.tbl_goods AS tg 
  JOIN (SELECT ID_GOODS
          FROM public.tbl_operation AS to2
         WHERE TYPEOP = 'A'
         GROUP BY id_goods
        HAVING COUNT(*) = 1) T 
    ON T.ID_GOODS = tg.id_goods;     
  
  




