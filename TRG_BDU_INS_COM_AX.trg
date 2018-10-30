CREATE OR REPLACE TRIGGER TRG_BDU_INS_COM_AX
BEFORE INSERT OR UPDATE ON TBL_BDU_COMERCIO_AX FOR EACH ROW
DECLARE
-- -----------------------------------------------------------------------------
-- Nombre del Programa : TRG_BDU_INS_COM_AX
-- Autor               : HPG
-- Compania            : Teotl
-- Proyecto/Procliente : P-20-0115-16                        Fecha: 14/08/2016
-- Descripcion General : Comercios amex
-- Programa Dependiente: N/A
-- Programa Subsecuente: N/A
-- Cond. de ejecucion  : N/A
-- Dias de ejecucion   : N/A                                 Horario: N/A
--                              MODIFICACIONES
--------------------------------------------------------------------------------
-- Autor               : HPG
-- Compania            : Teotl
-- Proyecto/procliente : P-20-5013-17                        Fecha: 02/06/2017
-- Descripcion General : Amex Opt Blue Carretera para Elavon
--------------------------------------------------------------------------------
-- Autor               : HPG
-- Compania            : Teotl
-- Proyecto/Procliente : P-20-5082-17                      Fecha: 26/09/2017
-- Descripcion General : Incorporacion de Elavon al programa Optblue Amex
--------------------------------------------------------------------------------
-- Autor               : HPG
-- Compania            : Teotl
-- Proyecto/Procliente : P-20-0115-16                        Fecha: 12/02/2018
-- Descripcion General : Comercios amex D26
-- -----------------------------------------------------------------------------
-- Autor               : HPG
-- Compania            : Teotl
-- Proyecto/Procliente : P-20-0115-16                        Fecha: 12/02/2018
-- Descripcion General : Comercios amex D32
-- -----------------------------------------------------------------------------
-- Autor               : HPG
-- Compania            : Teotl
-- Proyecto/Procliente : P-20-0115-16                        Fecha: 11/03/2018
-- Descripcion General : Comercios amex D37
-- -----------------------------------------------------------------------------
-- Autor               : HPG
-- Compania            : Teotl
-- Proyecto/Procliente : P-20-5082-17 D4                     Fecha: 08/04/2018
-- Descripcion General : Incorporacion de Elavon al programa Optblue Amex
--------------------------------------------------------------------------------
-- Autor               : HPG
-- Compania            : Teotl
-- Proyecto/Procliente : P-20-0115-16 D58                     Fecha: 28/04/2018
-- Descripcion General : Incorporacion de Elavon al programa Optblue Amex
--------------------------------------------------------------------------------
-- Autor               : HPG
-- Compania            : Teotl
-- Proyecto/Procliente : P-20-5175-17                         Fecha: 02/05/2018
-- Descripcion General : Incorporación de Inbursa a Amex D1
--------------------------------------------------------------------------------
-- Autor               : HPG
-- Compania            : Teotl
-- Proyecto/Procliente : P-20-0115-16 D79                     Fecha: 28/05/2018
-- Descripcion General : Incorporacion de Elavon al programa Optblue Amex
--------------------------------------------------------------------------------
-- Autor               : HPG
-- Compania            : Teotl
-- Proyecto/Procliente : P-20-0115-16 D107                     Fecha: 29/06/2018
-- Descripcion General : Incorporacion de Elavon al programa Optblue Amex
--------------------------------------------------------------------------------
-- Autor               : HPG
-- Compania            : Teotl
-- Proyecto/Procliente : P-20-0115-16 D110                     Fecha: 22/06/2018
-- Descripcion General : Incorporacion de Elavon al programa Optblue Amex
--------------------------------------------------------------------------------
-- Autor               : HPG
-- Compania            : Teotl
-- Proyecto/Procliente : P-20-0115-16 D123                     Fecha: 18/07/2018
-- Descripcion General : Incorporacion de Elavon al programa Optblue Amex
--------------------------------------------------------------------------------
-- Numero de Parametros: N/A
-- Parametros Entrada  : N/A                                     Formato: N/A
-- Parametros Salida   : N/A                                     Formato: N/A
-- -----------------------------------------------------------------------------
BEGIN

  IF INSERTING THEN
    :NEW.com_fec_alta:= SYSDATE;
  -- Inicio: P-20-0115-16 D110
    :NEW.com_fec_mod:= SYSDATE;
    :NEW.com_estatus:=0;
    :NEW.com_mov_ax:=' ';
  -- Terminacion: P-20-0115-16 D110
    --
      BEGIN
       SELECT c.com_bco_id, c.com_giro_id, b.bco_fiid, i.ind_cve
       INTO :NEW.com_bco, :NEW.com_giro, :NEW.com_fiid, :NEW.com_ind_cve
       FROM TBL_BDU_COMERCIOS C, TBL_BDU_BANCOS B, TBL_BDU_GIROS G,
        TBL_BDU_INDUSTRIA_AX I
       WHERE c.com_afiliacion = :NEW.com_afiliacion
        AND c.com_bco_id = b.oid
        AND c.com_giro_id = g.oid
        AND g.gir_ax = i.ind_tipo
  -- Inicio: P-20-5013-17
        AND c.com_bco_id = i.ind_fiid;
  -- Terminacion: P-20-5013-17
  -- Inicio: P-20-0115-16 D110
      EXCEPTION
        WHEN no_data_found THEN
         BEGIN
           SELECT c.com_bco_id, c.com_giro_id, b.bco_fiid, i.ind_cve
           INTO :NEW.com_bco, :NEW.com_giro, :NEW.com_fiid, :NEW.com_ind_cve
           FROM TBL_BDU_PROPUESTAS_COM C, TBL_BDU_BANCOS B, TBL_BDU_GIROS G,
            TBL_BDU_INDUSTRIA_AX I
           WHERE c.com_afiliacion = :NEW.com_afiliacion
            AND c.com_bco_id = b.oid
            AND c.com_giro_id = g.oid
            AND g.gir_ax = i.ind_tipo
           AND c.com_bco_id = i.ind_fiid;
         EXCEPTION
          WHEN OTHERS THEN
          :NEW.com_bco :=37;
          :NEW.com_fiid:='B999';
         END;
      END;
  --
    :NEW.COM_ID_RL2 := RTRIM(:NEW.COM_ID_RL2);
    :NEW.COM_NM_RL2 := RTRIM(:NEW.COM_NM_RL2);
    :NEW.COM_AP_PAT_RL2 := RTRIM(:NEW.COM_AP_PAT_RL2);
    :NEW.COM_AP_MAT_RL2 := RTRIM(:NEW.COM_AP_MAT_RL2);
    :NEW.COM_DOM_RL2 := RTRIM(:NEW.COM_DOM_RL2);
    :NEW.COM_CD_RL2 := RTRIM(:NEW.COM_CD_RL2);
    :NEW.COM_CP_RL2 := RTRIM(:NEW.COM_CP_RL2);
  -- Terminacion: P-20-0115-16 D110
    --
    -- Inicio: P-20-5082-17
    IF(:NEW.com_bco IN(3,14)) THEN
      :NEW.com_seller_id := RPAD(:NEW.com_afiliacion,20,' ');
    ELSE
      :NEW.com_seller_id := LPAD(:NEW.com_bco,3,'0')||LPAD(:NEW.com_afiliacion,7,'0')||
      '0000000001';
    END IF;
    --
    -- Inicio: P-20-5175-17 D1
    IF(:NEW.com_bco=37)THEN
      :NEW.com_cmp_flg:= 1;
    ELSE
      :NEW.com_cmp_flg:= NULL;
    END IF;
    -- Terminacion: P-20-5175-17 D1
    -- Terminacion: P-20-5082-17
  -- Inicio: P-20-0115-16 D123
  IF(:NEW.com_tasa_ax IS NULL)THEN
    :NEW.com_tasa_ax :=2.75;
  END IF;
  --
  IF(:NEW.com_pln=0)THEN
      :NEW.tasa_3 := NULL; 
      :NEW.tasa_6  := NULL; 
      :NEW.tasa_9  := NULL; 
      :NEW.tasa_12 := NULL; 
      :NEW.tasa_15 := NULL; 
      :NEW.tasa_18 := NULL; 
      :NEW.tasa_21 := NULL; 
      :NEW.tasa_24 := NULL;
  END IF;
  --
  IF((:NEW.com_bco=3) OR (:NEW.com_pln=1))THEN
    FOR X IN(
      SELECT tasa_3,tasa_6,tasa_9,tasa_12,tasa_15,tasa_18,tasa_21,tasa_24
      FROM TBL_BDU_TASA_AMEX
      WHERE bco = :NEW.com_bco
      )
    LOOP
         :NEW.TASA_3 := NVL(:NEW.tasa_3,NVL(:NEW.TASA_3,x.tasa_3)); 
         :NEW.TASA_6 := NVL(:NEW.tasa_6,NVL(:NEW.TASA_6,x.tasa_6)); 
         :NEW.TASA_9 := NVL(:NEW.tasa_9,NVL(:NEW.TASA_9,x.tasa_9)); 
         :NEW.TASA_12 := NVL(:NEW.tasa_12,NVL(:NEW.TASA_12,x.tasa_12)); 
         :NEW.TASA_15 := NVL(:NEW.tasa_15,NVL(:NEW.TASA_15,x.tasa_15)); 
         :NEW.TASA_18 := NVL(:NEW.tasa_18,NVL(:NEW.TASA_18,x.tasa_18)); 
         :NEW.TASA_21 := NVL(:NEW.tasa_21,NVL(:NEW.TASA_21,x.tasa_21)); 
         :NEW.TASA_24 := NVL(:NEW.tasa_24,NVL(:NEW.TASA_24,x.tasa_24));
         :NEW.COM_PLN := 1;
    END LOOP; 
  END IF;    
  -- Terminacion: P-20-0115-16 D123
    --
    :NEW.COM_NM_RL1 := UPPER(:NEW.COM_NM_RL1);
    :NEW.COM_AP_PAT_RL1 := UPPER(:NEW.COM_AP_PAT_RL1);
    :NEW.COM_AP_MAT_RL1 := UPPER(:NEW.COM_AP_MAT_RL1);
    :NEW.COM_DOM_RL1 := UPPER(:NEW.COM_DOM_RL1);
    :NEW.COM_CD_RL1 := UPPER(:NEW.COM_CD_RL1);
    :NEW.COM_ID_RL1 := UPPER(:NEW.COM_ID_RL1);
    :NEW.COM_ID_RL2 := UPPER(:NEW.COM_ID_RL2);
    :NEW.COM_NM_RL2 := UPPER(:NEW.COM_NM_RL2);
    :NEW.COM_AP_PAT_RL2 := UPPER(:NEW.COM_AP_PAT_RL2);
    :NEW.COM_AP_MAT_RL2 := UPPER(:NEW.COM_AP_MAT_RL2);
    :NEW.COM_DOM_RL2 := UPPER(:NEW.COM_DOM_RL2);
    :NEW.COM_CD_RL2 := UPPER(:NEW.COM_CD_RL2);
    :NEW.COM_URL := UPPER(:NEW.COM_URL);
    --
    -- Inicio: P-20-0115-16 D26
    UPDATE TBL_BDU_PTDF
    SET ter_fec_ult_mod = SYSDATE
    WHERE com_afiliacion = :NEW.com_afiliacion;
    -- Terminacion: P-20-0115-16 D26
    -- Inicio: P-20-0115-16 D58
    UPDATE TBL_BDU_PRDF
    SET com_fec_ult_mod = SYSDATE
    WHERE com_afiliacion = :NEW.com_afiliacion;
  --
  BEGIN
    Pkg_Bdu_Datos_Com.actualiza_typ_prdf(:NEW.com_afiliacion,
                                         :NEW.com_bco,
                                         17, 'AMEX', 'ACT');
  -- Inicio: P-20-0115-16 D32
  -- Inicio: P-20-0115-16 D37
  UPDATE TBL_BDU_PTDF
  SET ter_fec_ult_mod = SYSDATE
  WHERE com_afiliacion = :NEW.com_afiliacion;
  --
   BEGIN
    FOR X IN(
    SELECT OID, TER_ID, TER_LIMITE_VENTA
    FROM TBL_BDU_TERMINALES
    WHERE TER_COMERCIO_ID = :NEW.com_afiliacion
    )
    LOOP
     INSERT INTO TBL_BDU_CARD_TYPES_TER(
      car_card_type_id, com_afiliacion,
      bco_cve,          car_ter_id,
      oid,              id_bitacora,
      typ_tran_lmt,     ter_id,
      term_owner_fiid
      )
     VALUES(
      17,                 :NEW.com_afiliacion,
      :NEW.com_bco,       x.oid,
      BDUSEQ010.NEXTVAL,  BDUSEQ010.CURRVAL,
      x.ter_limite_venta, x.ter_id,
      :NEW.com_fiid
      );
    -- se elimina codigo
    END LOOP;
   END;
  -- Terminacion: P-20-0115-16 D58
  -- Terminacion: P-20-0115-16 D37
  -- Terminacion: P-20-0115-16 D32
  -- Inicio: P-20-5013-17
  EXCEPTION
    WHEN others THEN NULL;
  -- Terminacion: P-20-5013-17
  END;
  END IF;
  --
  IF UPDATING THEN
  -- Inicio: P-20-0115-16 D110
  -- se elimina codigo
  -- Inicio: P-20-5013-17
  -- Terminacion: P-20-5013-17
  -- Terminacion: P-20-0115-16 D110
    -- Inicio: P-20-5082-17
    -- Inicio: P-20-5082-17 D4
    IF((NVL(:NEW.COM_NM_RL1,' ')!= NVL(:OLD.COM_NM_RL1,' '))OR
      (NVL(:NEW.COM_AP_PAT_RL1,' ')!= NVL(:OLD.COM_AP_PAT_RL1,' '))OR
      (NVL(:NEW.COM_CD_RL1,' ')!= NVL(:OLD.COM_CD_RL1,' '))OR
      (NVL(:NEW.COM_CP_RL1,' ')!= NVL(:OLD.COM_CP_RL1,' '))OR
      (NVL(:NEW.COM_FEC_NAC_RL1,' ')!= NVL(:OLD.COM_FEC_NAC_RL1,' '))OR
      (NVL(:NEW.COM_ID_RL1,' ')!= NVL(:OLD.COM_ID_RL1,' '))OR
      (NVL(:NEW.COM_DOM_RL1,' ')!= NVL(:OLD.COM_DOM_RL1,' '))) THEN
    -- Inicio: P-20-5175-17 D1
      IF(:NEW.com_bco=37)THEN
        :NEW.com_cmp_flg:= 1;
      ELSE
        :NEW.com_cmp_flg:= NULL;
      END IF;
    -- Terminacion: P-20-5175-17 D1
    END IF;
    -- Inicio: P-20-0115-16 D79
  -- Inicio: P-20-0115-16 D110
    :NEW.com_giro:=NVL(:NEW.com_giro,:OLD.com_giro);
    --
  -- Inicio: P-20-0115-16 D110
    IF(:NEW.com_giro!=:OLD.com_giro) THEN
     BEGIN
       SELECT i.ind_cve
       INTO :NEW.com_ind_cve
       FROM  TBL_BDU_GIROS G,
        TBL_BDU_INDUSTRIA_AX I
       WHERE g.oid = :NEW.com_giro
        AND g.gir_ax = i.ind_tipo
        AND i.ind_fiid = :NEW.com_bco;
     EXCEPTION
       WHEN others THEN
        :NEW.com_mov_ax:='N';
        :NEW.com_cmp_flg:=1;
        :NEW.com_estatus:=1;
     END;
    END IF;
  -- Terminacion: P-20-0115-16 D110
  --
    :NEW.com_fiid:=:OLD.com_fiid;
  -- se elimina codigo
    IF(((:OLD.com_mov_ax=' ')OR(:OLD.com_mov_ax='R'))
     AND(:NEW.com_mov_ax IN('N','D')))THEN
      :NEW.com_cmp_flg:=NULL;
      :NEW.com_estatus:=1;
      --
      DELETE TBL_BDU_CARD_TYPES_TER
      WHERE COM_AFILIACION = :NEW.com_afiliacion
       AND TYP = 'AX';
      --
      DELETE TBL_BDU_CARD_TYPES_COM
      WHERE COM_AFILIACION = :NEW.com_afiliacion
       AND TYP = 'AX';
      --
      UPDATE TBL_BDU_PTDF
      SET ter_fec_ult_mod = SYSDATE
      WHERE com_afiliacion = :NEW.com_afiliacion;
      --
      UPDATE TBL_BDU_PRDF
      SET com_fec_ult_mod = SYSDATE
      WHERE com_afiliacion = :NEW.com_afiliacion;
    END IF;
    --
    IF((:OLD.com_mov_ax IN('N','D')) AND (:NEW.com_mov_ax IN('R')))THEN
      :NEW.com_cmp_flg:=NULL;
      :NEW.com_estatus:=0;
      --
        UPDATE TBL_BDU_PRDF
        SET com_fec_ult_mod = SYSDATE
        WHERE com_afiliacion = :NEW.com_afiliacion;
        --
        UPDATE TBL_BDU_PTDF
        SET ter_fec_ult_mod = SYSDATE
        WHERE com_afiliacion = :NEW.com_afiliacion;
        --
        BEGIN
          Pkg_Bdu_Datos_Com.actualiza_typ_prdf(:NEW.com_afiliacion,
                                             :NEW.com_bco,
                                             17, 'AMEX', 'ACT');
        END;
        --
         BEGIN
          FOR X IN(
          SELECT OID, TER_ID, TER_LIMITE_VENTA
          FROM TBL_BDU_TERMINALES
          WHERE TER_COMERCIO_ID = :NEW.com_afiliacion
          )
          LOOP
           INSERT INTO TBL_BDU_CARD_TYPES_TER(
            car_card_type_id, com_afiliacion,
            bco_cve,          car_ter_id,
            oid,              id_bitacora,
            typ_tran_lmt,     ter_id,
            term_owner_fiid
            )
           VALUES(
            17,                 :NEW.com_afiliacion,
            :NEW.com_bco,       x.oid,
            BDUSEQ010.NEXTVAL,  BDUSEQ010.CURRVAL,
            x.ter_limite_venta, x.ter_id,
            :NEW.com_fiid
            );
          -- se elimina codigo
          END LOOP;
         END;
    END IF;
    --
    IF(:NEW.com_cmp_flg=1 AND (NVL(:OLD.com_cmp_flg,0)=0)) THEN
      IF((:NEW.com_estatus=1) AND (:OLD.com_estatus=1))THEN
       IF((:NEW.com_env=1) AND (NVL(:OLD.com_env,0)=0))THEN
         :NEW.com_bco:=37;
       END IF;
      END IF;
    END IF;
    --
    IF(NVL(:NEW.com_cmp_flg,0)=0 AND :OLD.com_cmp_flg=1) THEN
      IF((NVL(:NEW.com_estatus,0)=0) AND (:OLD.com_estatus=1)) THEN
        IF(:OLD.com_bco=37)THEN
          :NEW.com_bco:=SUBSTR(:NEW.com_seller_id,1,3);
        END IF;
      END IF;
    END IF;
  -- Terminacion: P-20-0115-16 D110
    -- Terminacion: P-20-0115-16 D79
    -- Terminacion: P-20-5082-17 D4
    -- Terminacion: P-20-5082-17
    -- Inicio: P-20-0115-16 D58
    :NEW.com_fec_mod:= SYSDATE;
    -- Inicio: P-20-0115-16 D107
    :NEW.com_fec_alta:= :OLD.com_fec_alta;
    -- Terminacion: P-20-0115-16 D107
    --
  -- Inicio: P-20-0115-16 D123
    IF(:NEW.com_pln=0)THEN
      :NEW.tasa_3 := NULL; 
      :NEW.tasa_6  := NULL; 
      :NEW.tasa_9  := NULL; 
      :NEW.tasa_12 := NULL; 
      :NEW.tasa_15 := NULL; 
      :NEW.tasa_18 := NULL; 
      :NEW.tasa_21 := NULL; 
      :NEW.tasa_24 := NULL;
    END IF;
  IF(:NEW.com_pln=1)THEN
    FOR X IN(
      SELECT tasa_3,tasa_6,tasa_9,tasa_12,tasa_15,tasa_18,tasa_21,tasa_24
      FROM TBL_BDU_TASA_AMEX
      WHERE bco = :NEW.com_bco
      )
    LOOP
         :NEW.TASA_3 := NVL(:NEW.tasa_3,NVL(:NEW.TASA_3,x.tasa_3)); 
         :NEW.TASA_6 := NVL(:NEW.tasa_6,NVL(:NEW.TASA_6,x.tasa_6)); 
         :NEW.TASA_9 := NVL(:NEW.tasa_9,NVL(:NEW.TASA_9,x.tasa_9)); 
         :NEW.TASA_12 := NVL(:NEW.tasa_12,NVL(:NEW.TASA_12,x.tasa_12)); 
         :NEW.TASA_15 := NVL(:NEW.tasa_15,NVL(:NEW.TASA_15,x.tasa_15)); 
         :NEW.TASA_18 := NVL(:NEW.tasa_18,NVL(:NEW.TASA_18,x.tasa_18)); 
         :NEW.TASA_21 := NVL(:NEW.tasa_21,NVL(:NEW.TASA_21,x.tasa_21)); 
         :NEW.TASA_24 := NVL(:NEW.tasa_24,NVL(:NEW.TASA_24,x.tasa_24));
    END LOOP; 
  END IF;    
  -- Terminacion: P-20-0115-16 D123
    :NEW.COM_NM_RL1 := UPPER(:NEW.COM_NM_RL1);
    :NEW.COM_AP_PAT_RL1 := UPPER(:NEW.COM_AP_PAT_RL1);
    :NEW.COM_AP_MAT_RL1 := UPPER(:NEW.COM_AP_MAT_RL1);
    :NEW.COM_DOM_RL1 := UPPER(:NEW.COM_DOM_RL1);
    :NEW.COM_CD_RL1 := UPPER(:NEW.COM_CD_RL1);
    :NEW.COM_ID_RL1 := UPPER(:NEW.COM_ID_RL1);
    :NEW.COM_ID_RL2 := UPPER(:NEW.COM_ID_RL2);
    :NEW.COM_NM_RL2 := UPPER(:NEW.COM_NM_RL2);
    :NEW.COM_AP_PAT_RL2 := UPPER(:NEW.COM_AP_PAT_RL2);
    :NEW.COM_AP_MAT_RL2 := UPPER(:NEW.COM_AP_MAT_RL2);
    :NEW.COM_DOM_RL2 := UPPER(:NEW.COM_DOM_RL2);
    :NEW.COM_CD_RL2 := UPPER(:NEW.COM_CD_RL2);
    :NEW.COM_URL := UPPER(:NEW.COM_URL);
    --
  END IF;
    -- se elimina codigo
  IF DELETING THEN
  -- Inicio: P-20-0115-16 D110
      DELETE TBL_BDU_CARD_TYPES_TER
      WHERE COM_AFILIACION = :OLD.com_afiliacion
       AND TYP = 'AX';
      --
      DELETE TBL_BDU_CARD_TYPES_COM
      WHERE COM_AFILIACION = :OLD.com_afiliacion
       AND TYP = 'AX';
      --
      UPDATE TBL_BDU_PTDF
      SET ter_fec_ult_mod = SYSDATE
      WHERE com_afiliacion = :OLD.com_afiliacion;
      --
      UPDATE TBL_BDU_PRDF
      SET com_fec_ult_mod = SYSDATE
      WHERE com_afiliacion = :OLD.com_afiliacion;
 -- Terminacion: P-20-0115-16 D110
  END IF;
  -- Terminacion: P-20-0115-16 D37
  -- Terminacion: P-20-0115-16 D32
  -- Inicio: P-20-5013-17
  -- Terminacion: P-20-5013-17
  -- Terminacion: P-20-0115-16 D58
END;
/
