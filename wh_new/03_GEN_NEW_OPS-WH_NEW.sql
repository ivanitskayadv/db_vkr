 --DO
--$$
--DECLARE 
--  CUR_GWH CURSOR FOR 
--    SELECT ID_GOODS,
--           ID_WH,
--           SUM(CASE 
--                 WHEN TYPEOP = 'R' THEN -quantity
--                 WHEN TYPEOP = 'A' THEN quantity
--               END) AS QUANTITY
--      FROM tbl_operation
--  GROUP BY id_goods, ID_WH
--  ORDER BY ID_GOODS, ID_WH;
--  CUR_REC RECORD;
--BEGIN
--  FOR CUR_REC IN CUR_GWH LOOP
--    UPDATE tbl_goods_wh
--       SET quantity = CUR_REC.QUANTITY
--     WHERE id_goods = CUR_REC.ID_GOODS
--       AND ID_WH    = CUR_REC.ID_WH;
--  END LOOP;
--END;
--$$;

--ALTER SEQUENCE seq_id_ag RESTART WITH 1;
--ALTER SEQUENCE seq_id_goods RESTART WITH 1;
--ALTER SEQUENCE seq_id_warehouse RESTART WITH 1;

DO
$$
DECLARE
  TYPEOPS    VARCHAR[] := ARRAY['A', 'R'];
  S_TYPEOP   VARCHAR;
  V_QUANTITY INTEGER;
  V_PRICE    INTEGER;
  V_CHECK    INTEGER;
  D_CH_DATE  DATE;
  S_ID_GOODS VARCHAR;
  S_ID_WH    VARCHAR;
  S_ID_AG    VARCHAR;
  D_OPDATE   DATE;
  I          INTEGER := 1;
BEGIN
  WHILE I < 250 LOOP
    S_TYPEOP   := TYPEOPS[ROUND(RANDOM()*(2-1)+1)];
    V_QUANTITY := ROUND((RANDOM()*(1000-50)+50)::NUMERIC, -1::INTEGER); 
    V_PRICE    := ROUND((RANDOM()*(500-25)+25)::NUMERIC, -1::INTEGER);
    D_OPDATE   := TO_DATE(PKG_FILL_DB.FN_GEN_DATE(), 'DD-MM-YYYY');

    S_ID_GOODS := (SELECT ID_GOODS FROM TMP_ID_GOODS ORDER BY RANDOM() LIMIT 1);
    S_ID_WH    := (SELECT ID_WH    FROM TMP_ID_WH    ORDER BY RANDOM() LIMIT 1);
    S_ID_AG    := (SELECT ID_AG    FROM TMP_ID_AG    ORDER BY RANDOM() LIMIT 1);
    D_CH_DATE  := (SELECT MAX(OP_DATE)
                     FROM TMP_OPERATION 
                    WHERE ID_GOODS = S_ID_GOODS 
                      AND ID_WH = S_ID_WH
                      AND TYPEOP = 'A');
    IF S_TYPEOP = 'R' THEN
      V_CHECK := (SELECT QUANTITY
                    FROM TMP_GOODS_WH
                   WHERE ID_GOODS = S_ID_GOODS
                     AND ID_WH    = S_ID_WH);
      IF (V_CHECK > V_QUANTITY) AND (D_OPDATE > D_CH_DATE) THEN 
        NULL;
      ELSIF (V_CHECK > V_QUANTITY) AND (D_OPDATE < D_CH_DATE) THEN 
        D_OPDATE := TO_DATE(PKG_FILL_DB.FN_GEN_DATE(D_CH_DATE, 'A'), 'DD-MM-YYYY');
      ELSE
        DECLARE 
          NBV_QUANTITY NUMERIC;
          NBV_PRICE    NUMERIC; 
          NBV_ID_AG    VARCHAR;
          NBV_OPDATE   DATE;
        BEGIN
          NBV_QUANTITY := ROUND((RANDOM()*(1200-V_QUANTITY)+V_QUANTITY)::NUMERIC, -1::INTEGER);
          NBV_PRICE    := ROUND((RANDOM()*(500-25)+25)::NUMERIC, -1::INTEGER);
          NBV_ID_AG    := (SELECT ID_AG FROM TMP_ID_AG ORDER BY RANDOM() LIMIT 1);
          NBV_OPDATE   := TO_DATE(PKG_FILL_DB.FN_GEN_DATE(D_OPDATE, 'B'), 'DD-MM-YYYY');
          INSERT INTO TMP_OPERATION (
            ID_GOODS, 
            ID_AG, 
            ID_WH, 
            TYPEOP, 
            QUANTITY, 
            PRICE, 
            OP_DATE) 
          VALUES (
            S_ID_GOODS, 
            NBV_ID_AG, 
            S_ID_WH, 
            'A'::VARCHAR, 
            NBV_QUANTITY, 
            NBV_PRICE, 
            NBV_OPDATE
          );
          UPDATE TMP_GOODS_WH 
             SET QUANTITY = QUANTITY + NBV_QUANTITY 
           WHERE id_wh = S_ID_WH
             AND id_goods = S_ID_GOODS;
          IF NOT FOUND THEN 
            INSERT INTO TMP_GOODS_WH (
              ID_WH, 
              ID_GOODS, 
              QUANTITY)
            VALUES (
              S_ID_WH, 
              S_ID_GOODS, 
              NBV_QUANTITY
            );  
          END IF;
        END;
      END IF;
    END IF;
    INSERT INTO TMP_OPERATION(
        ID_GOODS, 
        ID_AG, 
        ID_WH, 
        TYPEOP, 
        QUANTITY, 
        PRICE, 
        OP_DATE
      ) VALUES (
        S_ID_GOODS, 
        S_ID_AG, 
        S_ID_WH, 
        S_TYPEOP, 
        V_QUANTITY, 
        V_PRICE, 
        D_OPDATE
      );
    UPDATE TMP_GOODS_WH 
       SET QUANTITY = CASE 
                        WHEN S_TYPEOP = 'A' THEN QUANTITY + V_QUANTITY
                        WHEN S_TYPEOP = 'R' THEN QUANTITY - V_QUANTITY
                      END
     WHERE ID_WH = S_ID_WH
       AND ID_GOODS = S_ID_GOODS;
    IF NOT FOUND THEN 
        INSERT INTO TMP_GOODS_WH (
          ID_WH, 
          ID_GOODS, 
          QUANTITY)
        VALUES (
          S_ID_WH, 
          S_ID_GOODS, 
          V_QUANTITY
        );
    END IF;
    COMMIT;
    I := I + 1;
  END LOOP;
END;
$$;


DO
$$
DECLARE 
  REC RECORD;
BEGIN
  FOR REC IN (
    SELECT * 
      FROM TMP_OPERATION 
     ORDER BY OP_DATE
  ) LOOP
      INSERT INTO tbl_operation (
          ID_GOODS, 
          ID_AG, 
          ID_WH, 
          TYPEOP, 
          QUANTITY, 
          PRICE, 
          OP_DATE
      ) VALUES (
          REC.ID_GOODS, 
          REC.ID_AG, 
          REC.ID_WH, 
          REC.TYPEOP, 
          REC.QUANTITY, 
          REC.PRICE, 
          REC.OP_DATE
      );
      COMMIT;
  END LOOP;
END;
$$;
 