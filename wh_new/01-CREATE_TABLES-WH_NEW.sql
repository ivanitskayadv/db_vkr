-- USE CREATE TABLESPACE TO CREATE YOUR OWN TABLESPACE;
-- SUFFIX _I IN THE END DEFINES TABLESPACE FOR INDEXES

CREATE TABLE tbl_agent (
  id_ag VARCHAR(10) NOT NULL,
  name_ag VARCHAR(50) NOT NULL,
  town VARCHAR(20) NULL,
  phone VARCHAR(10) NULL
) TABLESPACE TS_WH_NEW;

CREATE UNIQUE INDEX PK_AGENT$ID_AG ON tbl_agent USING btree (id_ag) TABLESPACE TS_WH_NEW_I;

CREATE TABLE tbl_goods (
  id_goods VARCHAR(10) NOT NULL,
  nomenclature VARCHAR(30) NOT NULL,
  measure VARCHAR(10) NULL
) TABLESPACE ts_wh_new;

CREATE UNIQUE INDEX PK_GOODS$ID_GOODS ON tbl_goods USING btree (id_goods) TABLESPACE TS_WH_NEW_I;

CREATE TABLE tbl_goods_wh (
  id SERIAL,
  id_wh VARCHAR(10) NOT NULL,
  id_goods VARCHAR(10) NOT NULL,
  quantity numeric(15, 2) NULL
) TABLESPACE ts_wh_new;

CREATE UNIQUE INDEX PK_GOODS_WH$ID ON tbl_goods_wh USING btree (id) TABLESPACE TS_WH_NEW_I;
CREATE INDEX fk_goods_wh$id_goods ON tbl_goods_wh USING btree (id_goods) TABLESPACE TS_WH_NEW_I;
CREATE INDEX fk_goods_wh$id_wh ON tbl_goods_wh USING btree (id_wh) TABLESPACE TS_WH_NEW_I;

CREATE TABLE tbl_log_file (
  id SERIAL,
  inform varchar(200) NULL,
  user_name VARCHAR(10) NULL,
  ddata date NULL
) TABLESPACE ts_wh_new;

CREATE UNIQUE INDEX pk_log_file$ID ON tbl_log_file USING btree (id) TABLESPACE TS_WH_NEW_I;

CREATE TABLE tbl_operation (
  id SERIAL,
  id_goods VARCHAR(10) NOT NULL,
  id_ag VARCHAR(10) NOT NULL,
  id_wh VARCHAR(10) NOT NULL,
  typeop VARCHAR(1) NOT NULL,
  quantity numeric(15, 2) NOT NULL,
  price numeric(15, 2) NULL,
  op_date date NULL
) TABLESPACE ts_wh_new;

CREATE UNIQUE INDEX PK_OPERATION$ID ON tbl_operation USING btree (id) TABLESPACE TS_WH_NEW_I;

CREATE TABLE tbl_warehouse (
  id_wh VARCHAR(10) NOT NULL,
  name VARCHAR(50) NOT NULL,
  town VARCHAR(20) NULL
) TABLESPACE ts_wh_new;

CREATE INDEX fk_operation$id_agent ON tbl_operation USING btree (id_ag) TABLESPACE TS_WH_NEW_I;
CREATE INDEX fk_operation$id_goods ON tbl_operation USING btree (id_goods) TABLESPACE TS_WH_NEW_I;
CREATE INDEX fk_operation$id_wh ON tbl_operation USING btree (id_wh) TABLESPACE TS_WH_NEW_I;
--

CREATE SEQUENCE seq_id_ag
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 6
  CACHE 1
  NO CYCLE;

CREATE SEQUENCE seq_id_goods
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 9
  CACHE 1
  NO CYCLE;

CREATE SEQUENCE seq_id_warehouse
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 6
  CACHE 1
  NO CYCLE;
  
CREATE OR REPLACE FUNCTION fn_add_id_ag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin 
  IF OLD.id_ag is NULL THEN 
    NEW.id_ag := 'p' || nextval('seq_id_ag') ;
  END IF;
  RETURN NEW;

end;
$function$
;

CREATE OR REPLACE FUNCTION fn_add_id_goods()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin 
  IF OLD.id_goods is NULL THEN 
    NEW.id_goods := 'Т' || nextval('seq_id_goods') ;
  END IF;
  RETURN NEW;

end;
$function$
;

CREATE OR REPLACE FUNCTION fn_add_id_wh()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin 
  IF OLD.id_wh IS NULL THEN 
    NEW.id_wh := 'С' || nextval('seq_id_warehouse') ;
  END IF;
  RETURN NEW;

end;
$function$
;

CREATE TRIGGER TG_ADD_ID_AG 
BEFORE INSERT
ON tbl_agent 
  FOR EACH ROW EXECUTE FUNCTION fn_add_id_ag();
    
CREATE TRIGGER TG_ADD_ID_GOODS 
BEFORE INSERT
ON tbl_goods 
  FOR EACH ROW EXECUTE FUNCTION fn_add_id_goods();
    
CREATE TRIGGER TG_ADD_ID_WH 
BEFORE INSERT
ON tbl_warehouse 
  FOR EACH ROW EXECUTE FUNCTION fn_add_id_wh();