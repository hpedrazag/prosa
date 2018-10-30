CREATE OR REPLACE PACKAGE "ACT"."PKG_BDU_CYT_BATCH" IS
--/*###################################################################################
--# Nombre Del Programa : PKG_BDU_CYT_BATCH                                           #
--# Autor               : HPG                                                         #
--# Compania            : CSA                                                         #
--# Proyecto/procliente : P-02-0274-11                         Fecha: 02/05/2011      #
--# Descripcion General : Alta masiva de comercios Elavon                             #
--# Programa Dependiente: N/a                                                         #
--# Programa Subsecuente: N/a                                                         #
--# Cond. De Ejecucion  : N/a                                                         #
--# Dias De Ejecucion   : N/a                                 Horario: N/a            #
--#                              MODIFICACIONES                                       #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/procliente : P-20-5116-17                            Fecha: 09/08/2017   #
--# Descripcion General : Segmentacion de comercios adquirente Santander              #
--#-----------------------------------------------------------------------------------#
--# Numero De Parametros: N/a                                                         #
--# Parametros Entrada  : N/a                                     Formato: N/a        #
--# Parametros Salida   : N/a                                     Formato: N/a        #
--###################################################################################*/

  -- Com
  PROCEDURE procesa_comercios (plinea IN VARCHAR2, parch IN VARCHAR2, pout OUT VARCHAR2);
  -- Terminales
  PROCEDURE procesa_terminales(plinea IN VARCHAR2, parch IN VARCHAR2, pout OUT VARCHAR2);
  -- Verificacion
  FUNCTION abrevia(plinea IN VARCHAR2, ptipo IN NUMBER) RETURN VARCHAR2;
  --
  PROCEDURE verifica_rfc(prfc IN VARCHAR2, pout OUT VARCHAR2);
  --
  PROCEDURE servicomercio(pafil IN NUMBER, pafils IN NUMBER, pid IN VARCHAR2,
                          pmov IN NUMBER,  puser  IN VARCHAR2, pout OUT VARCHAR2);
  --
  -- Inicio: P-20-5116-17
  PROCEDURE Send_Mail (pfecha IN VARCHAR2, ptipo IN NUMBER, pout OUT VARCHAR2);
  -- Terminacion: P-20-5116-17
  --
END Pkg_Bdu_Cyt_Batch;
/
 
CREATE OR REPLACE PACKAGE BODY "ACT"."PKG_BDU_CYT_BATCH" IS
--/*###################################################################################
--# Nombre Del Programa : PKG_BDU_CYT_BATCH                                           #
--# Autor               : HPG                                                         #
--# Compania            : CSA                                                         #
--# Proyecto/procliente : Archivo de altas masivas para Elavon Fecha: 02/05/2011      #
--# Descripcion General : PROCESAMIENTO COMERCIOS BATCH                               #
--# Programa Dependiente: N/a                                                         #
--# Programa Subsecuente: N/a                                                         #
--# Cond. De Ejecucion  : N/a                                                         #
--# Dias De Ejecucion   : N/a                                 Horario: N/a            #
--#                              MODIFICACIONES                                       #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : CSA                                                         #
--# Proyecto/procliente : C-08-3094-12                            Fecha: 09/10/2012   #
--# Descripcion General : Mejoras proceso de Elavon                                   #
--#-----------------------------------------------------------------------------------#
--# Autor               : CML                                                         #
--# Compania            : PROSA                                                       #
--# Proyecto/procliente : F-08-2006-13                            Fecha: 05/01/2013   #
--# Descripcion General : Proceso Elavon - Refresh B24                                #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/procliente : P-02-0091-13                            Fecha: 16/11/2013   #
--# Descripcion General : Homologacion del ID Elavon                                  #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/procliente : C-54-2679-14                            Fecha: 10/10/2014   #
--# Descripcion General : Actualizacion ID Elavon                                     #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/procliente : C-54-2621-15                            Fecha: 06/09/2015   #
--# Descripcion General : Modificacion batch Elavon                                   #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/procliente : F-54-2175-16                            Fecha: 31/05/2016   #
--# Descripcion General : Correccion al domicilio fiscal Elavon                       #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/procliente : F-54-2195-16                            Fecha: 11/06/2016   #
--# Descripcion General : Reactivaciones clave 60                                     #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/procliente : P-20-5082-17                            Fecha: 23/06/2017   #
--# Descripcion General : Modificacion Amex Elavon                                    #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/Procliente : P-20-0115-16                        Fecha: 10/09/2017       #
--# Descripcion General : Incorporación de American Express                           #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/procliente : P-20-5116-17                            Fecha: 09/08/2017   #
--# Descripcion General : Segmentacion de comercios adquirente Santander              #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/procliente : P-20-5116-17 D2                         Fecha: 11/05/2018   #
--# Descripcion General : Segmentacion de comercios adquirente Santander              #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/Procliente : P-20-0115-16 D110                   Fecha: 11/07/2017       #
--# Descripcion General : Incorporación de American Express                           #
--#-----------------------------------------------------------------------------------#
--# Numero De Parametros: N/a                                                         #
--# Parametros Entrada  : N/a                                     Formato: N/a        #
--# Parametros Salida   : N/a                                     Formato: N/a        #
--###################################################################################*/

  errbuf VARCHAR2(500);

-- ------------------------------------------------------------------------
PROCEDURE procesa_comercios (plinea IN VARCHAR2, parch IN VARCHAR2, pout OUT VARCHAR2) IS
-- ------------------------------------------------------------------------

  -- Inicio: P-20-5082-17
  v_linea   VARCHAR2(4000);
  v_amex    VARCHAR2(1200);
  -- Terminacion: P-20-5082-17
  v_dummy   VARCHAR2(80);
  v_dummy_2 VARCHAR2(80);
  v_error   VARCHAR2(150);
  v_moneda  NUMBER(2);
  v_mov    VARCHAR2(2);
  v_mov_id   NUMBER(15);
  v_banco   VARCHAR2(3);
  v_banco_id  NUMBER(15);
  v_banco_id_s  NUMBER(15);
  v_afiliacion  VARCHAR2(9);
  v_afiliante  VARCHAR2(9);
  v_nombre   VARCHAR2(22);
  v_domicilio  VARCHAR2(32);
  v_domicilio_f  VARCHAR2(32);
  v_cp    VARCHAR2(5);
  v_cp_f   VARCHAR2(5);
  v_colonia   VARCHAR2(65);
  v_colonia_f  VARCHAR2(65);
  v_pob    VARCHAR2(5);
  v_pob_f   VARCHAR2(5);
  v_pob_id    NUMBER(15);
  v_estado   VARCHAR2(2);
  v_edo_id   NUMBER(15);
  v_estado_f  VARCHAR2(2);
  v_propietario  VARCHAR2(30);
  v_razon   VARCHAR2(30);
  v_responsable VARCHAR2(24);
  v_rfc      VARCHAR2(13);
  v_cod_cas    VARCHAR2(2);
  v_cod_cas_s  VARCHAR2(2);
  v_cadena    VARCHAR2(4);
  v_cadena_id   NUMBER(15);
  v_grupo    VARCHAR2(6);
  v_cat_cred   VARCHAR2(2);
  v_cat_deb    VARCHAR2(2);
  v_cve_cred   VARCHAR2(1);
  v_cve_deb    VARCHAR2(1);
  v_iva      VARCHAR2(1);
  v_iva_id   NUMBER(15);
  v_lada     VARCHAR2(3);
  v_lada_2    VARCHAR2(3);
  v_lada_f    VARCHAR2(3);
  v_tel      VARCHAR2(8);
  v_tel_2    VARCHAR2(8);
  v_tel_f    VARCHAR2(8);
  v_valor_cred  VARCHAR2(7);
  v_valor_deb   VARCHAR2(7);
  v_valor_tarc  VARCHAR2(5);
  v_chequera   VARCHAR2(20);
  v_cuenta    VARCHAR2(10);
  v_cecoban_pob VARCHAR2(5);
  v_cecoban_bco VARCHAR2(5);
  v_suc_cheques VARCHAR2(4);
  v_criter_cad  VARCHAR2(4);
  v_giro     VARCHAR2(4);
  v_giro_id    NUMBER(15);
  v_cve_recont  VARCHAR2(2);
  v_sucursal   VARCHAR2(4);
  v_asoc     VARCHAR2(5);
  v_usuario    VARCHAR2(8);
  v_placas    VARCHAR2(2);
  v_prov_plac   VARCHAR2(2);
  v_servicom   VARCHAR2(1);
  v_arbitro    VARCHAR2(1);
  v_email    VARCHAR2(50);
  v_registro    VARCHAR2(3);
  v_obs      VARCHAR2(155);
  v_oid      NUMBER(15);
  v_bitacora    NUMBER(15);
  v_cp_id   NUMBER(15);
  v_cpf_id   NUMBER(15);
  v_ter_id    VARCHAR2(10);
  v_estat    VARCHAR2(1);
  v_rfc_ok    NUMBER(1);
  v_estado_pro  NUMBER(1);
  v_estado_arb NUMBER(1);
  v_criter_id  NUMBER(15);
  v_recont_id  NUMBER(15);
  v_vip     NUMBER(1);
  v_inst    NUMBER(1);

  v_servicom_a  VARCHAR2(9);
  v_sca         VARCHAR2(1);
  v_procom      VARCHAR2(1);
  v_pro_tipo    VARCHAR2(1);
  v_pro_fecha   VARCHAR2(8);
  v_pro_emi     VARCHAR2(3);
  v_pro_fei     VARCHAR2(8);
  v_pro_fef     VARCHAR2(8);
  v_pro_q6      VARCHAR2(6);
  v_pro_mtomin  VARCHAR2(15);
  v_pro_mtomax  VARCHAR2(15);
  v_pro_tasa    VARCHAR2(4);
  v_pro_per     VARCHAR2(1);
  v_pro_id      VARCHAR2(24);
  v_pro_desc    VARCHAR2(25);
  v_pro_pref    VARCHAR2(3);
  v_pro_emiinv  VARCHAR2(2);
  v_bloqueoq6   VARCHAR2(2);
  v_swa         VARCHAR2(1);
  v_multicaja   VARCHAR2(1);
  v_tcc         VARCHAR2(1);
  v_tcc_afil    VARCHAR2(9);
  v_tcc_mto     VARCHAR2(4);
  v_id_elavon   VARCHAR2(10);
  v_nuevo       NUMBER(1):=0;
  v_out         VARCHAR2(50);
  v_existe      NUMBER(1):=1;
  v_prop_id     NUMBER(10);
  v_cm          NUMBER(2):=0;
  -- Inicio: C-54-2621-15
  v_himms VARCHAR2(16);
  -- Terminacion: C-54-2621-15
 -- Inicio: P-20-0115-16
  v_amex    VARCHAR2(1400);
  v_amexmv  VARCHAR2(2);
  v_amexmk  VARCHAR2(1);
  v_amexcanc VARCHAR2(1);
  v_amexnm  VARCHAR2(70);
  v_amexdm  VARCHAR2(70);
  v_amexcp  VARCHAR2(70);
  v_amexcd  VARCHAR2(70);
  v_amexap  VARCHAR2(70);
  v_amexfn  VARCHAR2(70);
  v_amexid  VARCHAR2(70);
  v_amexnmd  VARCHAR2(70);
  v_amexdmd  VARCHAR2(70);
  v_amexcpd  VARCHAR2(70);
  v_amexcdd  VARCHAR2(70);
  v_amexapd  VARCHAR2(70);
  v_amexfnd  VARCHAR2(70);
  v_amexidd  VARCHAR2(70);
  v_amextn   VARCHAR2(1);
  v_mov_ax   VARCHAR2(1);
  v_cadenaoka  NUMBER(1);
  v_cadenaokb  NUMBER(1);
  v_cadenaokc  NUMBER(1);
  v_cadenaokd  NUMBER(1);
  v_cadenaoke  NUMBER(1);
  v_cadenaokf  NUMBER(1);
  v_cadenaokg  NUMBER(1);
  -- Terminacion: P-20-0115-16
BEGIN

  v_linea := plinea;
  -- Inicio: P-20-5082-17
  IF LENGTH(v_linea) < 2961 THEN
    v_error := 'LONG';
 GOTO FIN;
  END IF;
  -- Terminacion: P-20-5082-17
  SELECT BDUSEQ047.NEXTVAL INTO v_oid FROM DUAL;
  SELECT BDUSEQ525.NEXTVAL INTO v_bitacora FROM DUAL;

  v_mov        := SUBSTR(v_linea, 1, 2);
  v_banco       := SUBSTR(v_linea, 3, 3);
  v_afiliacion  := SUBSTR(v_linea, 6, 9);
  v_afiliante   := SUBSTR(v_linea, 15, 9);
  v_nombre      := SUBSTR(v_linea, 24, 22);
  v_domicilio   := SUBSTR(v_linea, 46, 32);
  v_domicilio_f := SUBSTR(v_linea, 78, 32);
  v_cp         := SUBSTR(v_linea, 110, 5);
  v_cp_f        := SUBSTR(v_linea, 115, 5);
  v_colonia     := SUBSTR(v_linea, 120, 65);
  v_colonia_f   := SUBSTR(v_linea, 185, 65);
  v_pob        := SUBSTR(v_linea, 250, 5);
  v_pob_f       := SUBSTR(v_linea, 255, 5);
  v_estado      := SUBSTR(v_linea, 260, 2);
  v_estado_f    := SUBSTR(v_linea, 262, 2);
  v_propietario := SUBSTR(v_linea, 264, 30);
  v_razon       := SUBSTR(v_linea, 294, 30);
  v_responsable := SUBSTR(v_linea, 324, 24);
  v_rfc        := SUBSTR(v_linea, 348, 13);
  v_cod_cas     := SUBSTR(v_linea, 361, 2);
  v_cadena      := SUBSTR(v_linea, 363, 4);
  v_grupo       := SUBSTR(v_linea, 367, 6);
  v_cat_cred    := SUBSTR(v_linea, 373, 2);
  v_cat_deb     := SUBSTR(v_linea, 375, 2);
  v_cve_cred    := SUBSTR(v_linea, 377, 1);
  v_cve_deb     := SUBSTR(v_linea, 378, 1);
  v_iva        := SUBSTR(v_linea, 379, 1);
  v_lada        := SUBSTR(v_linea, 380, 3);
  v_lada_2      := SUBSTR(v_linea, 383, 3);
  v_lada_f      := SUBSTR(v_linea, 386, 3);
  v_tel        := SUBSTR(v_linea, 389, 8);
  v_tel_2       := SUBSTR(v_linea, 397, 8);
  v_tel_f       := SUBSTR(v_linea, 405, 8);
  v_valor_cred  := SUBSTR(v_linea, 413, 7);
  v_valor_deb   := SUBSTR(v_linea, 420, 7);
  v_chequera    := SUBSTR(v_linea, 427, 20);
  v_cuenta      := SUBSTR(v_linea, 447, 10);
  v_cecoban_pob := SUBSTR(v_linea, 457, 5);
  v_cecoban_bco := SUBSTR(v_linea, 462, 5);
  v_suc_cheques := SUBSTR(v_linea, 467, 4);
  v_criter_cad  := SUBSTR(v_linea, 471, 4);
  v_giro        := SUBSTR(v_linea, 475, 4);
  v_cve_recont  := SUBSTR(v_linea, 479, 2);
  v_sucursal    := SUBSTR(v_linea, 481, 4);
  v_asoc        := SUBSTR(v_linea, 485, 5);
  v_usuario     := SUBSTR(v_linea, 490, 8);
  v_placas      := SUBSTR(v_linea, 498, 2);
  v_prov_plac   := SUBSTR(v_linea, 500, 2);
  v_servicom    := SUBSTR(v_linea, 502, 1);
  v_servicom_a  := SUBSTR(v_linea, 503, 9);
  v_arbitro     := SUBSTR(v_linea, 512, 1);
  v_registro    := SUBSTR(v_linea, 513, 3);
  v_email       := SUBSTR(v_linea, 516, 50);
  v_obs        := UPPER(SUBSTR(v_linea, 566, 155));
  v_obs  := REPLACE(v_obs, CHR(10), ' ');

  v_sca         := SUBSTR(v_linea, 721, 1);
  v_procom      := SUBSTR(v_linea, 722, 1);
  v_pro_tipo    := SUBSTR(v_linea, 723, 1);
  v_pro_fecha   := SUBSTR(v_linea, 724, 8);
  v_pro_emi     := SUBSTR(v_linea, 732, 3);
  v_pro_fei     := SUBSTR(v_linea, 735, 8);
  v_pro_fef     := SUBSTR(v_linea, 743, 8);
  v_pro_q6      := SUBSTR(v_linea, 751, 6);
  v_pro_mtomin  := SUBSTR(v_linea, 757, 15);
  v_pro_mtomax  := SUBSTR(v_linea, 772, 15);
  v_pro_tasa    := SUBSTR(v_linea, 787, 4);
  v_pro_per     := SUBSTR(v_linea, 791, 1);
  v_pro_id      := SUBSTR(v_linea, 792, 24);
  v_pro_desc    := SUBSTR(v_linea, 816, 25);
  v_pro_pref    := SUBSTR(v_linea, 841, 3);
  v_pro_emiinv  := SUBSTR(v_linea, 844, 2);
  v_bloqueoq6   := SUBSTR(v_linea, 846, 2);
  v_swa         := SUBSTR(v_linea, 848, 1);
  v_multicaja   := SUBSTR(v_linea, 849, 1);
  v_tcc         := SUBSTR(v_linea, 850, 1);
  v_tcc_afil    := SUBSTR(v_linea, 851, 9);
  v_tcc_mto     := SUBSTR(v_linea, 860, 4);
  v_id_elavon   := SUBSTR(v_linea, 864, 10);
  -- Inicio: C-54-2621-15
  v_himms       := SUBSTR(v_linea, 874, 16);
  -- Terminacion: C-54-2621-15
  --
  --
  IF v_mov NOT IN('AL','MO','CA','RA','RE','BA') THEN
    v_error := 'MOVBAD';
 GOTO FIN;
  END IF;
  --
  INSERT INTO TBL_BDU_COM_ELAV(
    v_mov, v_banco, v_afiliacion,
    v_afiliante, v_nombre, v_domicilio,
    v_domicilio_f, v_cp, v_cp_f,
    v_colonia, v_colonia_f, v_pob,
    v_pob_f, v_estado, v_estado_f,
    v_propietario, v_razon, v_responsable,
    v_rfc, v_cod_cas, v_cadena,
    v_grupo, v_cat_cred, v_cat_deb,
    v_cve_cred, v_cve_deb, v_iva,
    v_lada, v_lada_2, v_lada_f,
    v_tel, v_tel_2, v_tel_f,
    v_valor_cred, v_valor_deb, v_valor_tarc,
    v_chequera, v_cuenta, v_cecoban_pob,
    v_cecoban_bco, v_suc_cheques, v_criter_cad,
    v_giro, v_cve_recont, v_sucursal,
    v_asoc, v_usuario, v_placas,
    v_prov_plac, v_servicom, v_arbitro,
    v_registro, v_email, v_obs,
    v_fecha, v_archivo, v_p_oid,
    v_id_elavon,
    v_prom_tipo, v_prom_fecc, v_prom_emi, v_prom_feci, v_prom_fecf,
    v_prom_cve, v_prom_min, v_prom_max, v_prom_tasa, v_prom_per, v_prom_id,
    v_prom_desc, v_prom_pref, v_prom_inv,
    v_sca, v_procom, v_bloq6, v_swa, v_multicaja,
    v_tcc, v_tcc_afil, v_tcc_monto,
    -- Inicio: C-54-2621-15
    idhimms
    -- Terminacion: C-54-2621-15
    )
 VALUES(
    v_mov     ,    v_banco    ,
    v_afiliacion  , v_afiliante   ,
    v_nombre    , v_domicilio   ,
    v_domicilio_f , v_cp     ,
    v_cp_f     , v_colonia    ,
    v_colonia_f   , v_pob     ,
    v_pob_f    , v_estado    ,
    v_estado_f    , v_propietario ,
    v_razon    , v_responsable ,
    v_rfc     , v_cod_cas    ,
    v_cadena    , v_grupo    ,
    v_cat_cred    , v_cat_deb    ,
    v_cve_cred    , v_cve_deb    ,
    v_iva     , v_lada     ,
    v_lada_2    , v_lada_f    ,
    v_tel     , v_tel_2    ,
    v_tel_f    , v_valor_cred  ,
    v_valor_deb   , v_valor_tarc  ,
    v_chequera    , v_cuenta    ,
    v_cecoban_pob , v_cecoban_bco ,
    v_suc_cheques , v_criter_cad  ,
    v_giro     , v_cve_recont  ,
    v_sucursal    , v_asoc     ,
    v_usuario    , v_placas    ,
  v_prov_plac   ,
    v_servicom    , v_arbitro     ,
    v_registro    , v_email    ,
    v_obs     , SYSDATE,
    parch     , v_oid,
    v_id_elavon,
    v_pro_tipo, v_pro_fecha, v_pro_emi,  v_pro_fei,  v_pro_fef,
    v_pro_q6,   v_pro_mtomin, v_pro_mtomax,  v_pro_tasa, v_pro_per, v_pro_id,
    v_pro_desc, v_pro_pref, v_pro_emiinv,
    v_sca, v_procom, v_bloqueoq6, v_swa, v_multicaja,
    v_tcc, v_tcc_afil, v_tcc_mto,
    -- Inicio: C-54-2621-15
    v_himms
    -- Terminacion: C-54-2621-15
    );

  -- Estado pro
  IF v_arbitro = '1' THEN
    v_estado_pro := 3; v_estado_arb := 0;
  ELSE
    v_estado_pro := 1; v_estado_arb := 1;
  END IF;
  --
  -- Mov
  BEGIN
    SELECT/*+ FIRST_ROWS */ oid INTO v_mov_id
    FROM TBL_BDU_MOVIMIENTOS_COM
    WHERE com_mov_clave = v_mov
     AND com_pais_id = 1;
  EXCEPTION
    WHEN OTHERS THEN
      v_error:= v_error||'MOV |';
      GOTO FIN;
  END;
  --
  IF v_mov = 'BA' AND v_servicom = 0 THEN
    v_error:= v_error||'NO SE PERMITE BAJA EN COMERCIOS';
    GOTO FIN;
  END IF;
  --
  --IF v_mov NOT IN('MO','BA') AND v_servicom = 1 THEN
  --  v_error:= v_error||'SERVICOMERCIOS SOLO PERMITE MO - BA';
  --  GOTO FIN;
  --END IF;
  --
  v_nombre      := LTRIM(v_nombre);
  v_domicilio   := RTRIM(v_domicilio);
  v_domicilio_f := RTRIM(v_domicilio_f);
  v_cp       := LTRIM(v_cp);
  v_cp_f      := LTRIM(v_cp_f);
  v_colonia     := RTRIM(v_colonia);
  v_colonia_f   := RTRIM(v_colonia_f);
  v_pob      := LTRIM(v_pob);
  v_pob_f       := LTRIM(v_pob_f);
  v_estado      := LTRIM(v_estado);
  v_estado_f    := LTRIM(v_estado_f);
  v_propietario := RTRIM(v_propietario);
  v_razon       := RTRIM(v_razon);
  v_responsable := RTRIM(v_responsable);
  v_rfc      := RTRIM(v_rfc);
  v_cod_cas     := LTRIM(v_cod_cas);
  v_cadena      := LTRIM(v_cadena);
  v_grupo       := LTRIM(v_grupo);
  v_cat_cred    := LTRIM(v_cat_cred);
  v_cat_deb     := LTRIM(v_cat_deb);
  v_cve_cred    := LTRIM(v_cve_cred);
  v_cve_deb     := LTRIM(v_cve_deb);
  v_iva      := LTRIM(v_iva);
  v_lada      := LTRIM(v_lada);
  v_lada_2      := LTRIM(v_lada_2);
  v_lada_f      := LTRIM(v_lada_f);
  v_tel      := LTRIM(v_tel);
  v_tel_2       := LTRIM(v_tel_2);
  v_tel_f       := LTRIM(v_tel_f);
  v_valor_cred  := LTRIM(v_valor_cred);
  v_valor_deb   := LTRIM(v_valor_deb);
  v_valor_tarc  := LTRIM(v_valor_tarc);
  v_chequera    := LTRIM(SUBSTR(v_chequera,-19,19));
  v_cuenta      := LTRIM(v_cuenta);
  v_cecoban_pob := LTRIM(v_cecoban_pob);
  v_cecoban_bco := LTRIM(v_cecoban_bco);
  v_suc_cheques := LTRIM(v_suc_cheques);
  v_criter_cad  := LTRIM(v_criter_cad);
  v_giro      := LTRIM(v_giro);
  v_cve_recont  := LTRIM(v_cve_recont);
  v_sucursal    := LTRIM(v_sucursal);
  v_asoc      := LTRIM(v_asoc);
  v_placas      := LTRIM(v_placas);
  v_prov_plac   := LTRIM(v_prov_plac);
  v_servicom    := LTRIM(v_servicom);
  v_arbitro     := '1';
  v_email     := RTRIM(v_email);
  v_obs      := RTRIM(v_obs);
  v_banco_id    := TO_NUMBER(v_banco);

  --
  v_nombre      := REPLACE(v_nombre,'  ',' ');
  v_domicilio   := REPLACE(v_domicilio,'  ',' ');
  v_domicilio_f := REPLACE(v_domicilio_f,'  ',' ');
  v_propietario := REPLACE(v_propietario,'  ',' ');
  v_razon       := REPLACE(v_razon,'  ',' ');
  v_responsable := REPLACE(v_responsable,'  ',' ');
  --
  -- Inicio: P-20-0115-16
  IF(SUBSTR(v_linea,891,1)='1') THEN
  -- Inicio: P-20-0115-16
  v_amexmv  := '1';
  v_amexcanc:= LTRIM(RTRIM(SUBSTR(v_linea, 1494, 1)));
  v_amexnm  := LTRIM(RTRIM(SUBSTR(v_linea, 982, 20)));
  v_amexdm  := LTRIM(RTRIM(SUBSTR(v_linea, 1060, 40)));
  v_amexcp  := LTRIM(RTRIM(SUBSTR(v_linea, 1140, 5)));
  v_amexcd  := LTRIM(RTRIM(SUBSTR(v_linea, 1100, 40)));
  v_amexap  := LTRIM(RTRIM(SUBSTR(v_linea, 1002, 20)));
  v_amexfn  := LTRIM(RTRIM(SUBSTR(v_linea, 1052, 8)));
  v_amexid  := LTRIM(RTRIM(SUBSTR(v_linea, 1022, 30)));
  v_amexnmd := LTRIM(RTRIM(SUBSTR(v_linea, 1145, 20)));
  v_amexdmd := LTRIM(RTRIM(SUBSTR(v_linea, 1223, 40)));
  v_amexcpd := LTRIM(RTRIM(SUBSTR(v_linea, 1303, 5)));
  v_amexcdd := LTRIM(RTRIM(SUBSTR(v_linea, 1263, 40)));
  v_amexapd := LTRIM(RTRIM(SUBSTR(v_linea, 1165, 20)));
  v_amexfnd := LTRIM(RTRIM(SUBSTR(v_linea, 1215, 8)));
  v_amexidd := LTRIM(RTRIM(SUBSTR(v_linea, 1185, 30)));
  v_amexmk  := LTRIM(RTRIM(SUBSTR(v_linea, 1491, 1)));
  v_amextn  := LTRIM(RTRIM(SUBSTR(v_linea, 1492, 1)));  
  END IF;
  -- Terminacion: P-20-0115-16
  -- Inicio: P-20-5082-17
      IF INSTR(v_obs,CHR(10))>0 THEN
      v_obs := REPLACE(v_obs,CHR(10),' ');
    END IF;
  -- Terminacion: P-20-5082-17
  -- usuario
  IF UPPER(SUBSTR(v_usuario,1,4)) != SUBSTR(parch,7,4) THEN
    v_error:= v_error||'USUARIO NO CORRESPONDE AL BANCO ';
    GOTO FIN;
  END IF;
  --
  IF (TO_NUMBER(v_valor_cred)/100)>100 OR (TO_NUMBER(v_valor_deb)/100)>100 THEN
    v_error:= v_error||'VALOR DESCUENTO CRED/DEB EXCEDE 100% ';
    GOTO FIN;
  END IF;
  --
  IF (v_mov NOT IN('CA','RE') AND TO_NUMBER(v_cod_cas)> 0) THEN
    v_error:= v_error||'CVE CANCELACION ';
    GOTO FIN;
  END IF;
  -- indicadores
  IF TO_NUMBER(NVL(v_sca,'0'))>1 THEN
    v_error:= v_error||'SCA ';
    GOTO FIN;
  -- Modificacion: Inicio C-08-3094-12
  ELSIF TO_NUMBER(NVL(v_procom,'0'))>3 THEN
 -- Modificacion: Terminacion C-08-3094-12
    v_error:= v_error||'PROCOM ';
    GOTO FIN;
  ELSIF TO_NUMBER(NVL(v_bloqueoq6,'0'))>1 THEN
    v_error:= v_error||'BLOQUEO Q6 ';
    GOTO FIN;
  ELSIF TO_NUMBER(NVL(v_swa,'0'))>1 THEN
    v_error:= v_error||'SWA ';
    GOTO FIN;
  END IF;
  --
   -- Inicio: P-20-5116-17
   -- Inicio: P-20-5116-17 D2
  IF v_mov = 'MO' THEN
    BEGIN
      SELECT/*+ FIRST_ROWS */ com_bco_id, com_bloqueo_id
      INTO v_banco_id, v_cod_cas
      FROM TBL_BDU_COMERCIOS
      WHERE com_afiliacion = v_afiliacion;
      --
      IF((v_banco IN(3,33)) AND (v_banco_id IN(14,140))) THEN
   -- Terminacion: P-20-5116-17 D2
        v_error:= v_error||'MOVIMIENTO RESTRINGIDO';
        BEGIN
          Pkg_bdu_cyt_batch.Send_Mail(TO_CHAR(SYSDATE,'DDMMYYYY'), v_afiliacion, v_out);
        END;
        GOTO FIN;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        v_error:= v_error||'AFILIACION NO EXISTE ';
        GOTO FIN;
    END;
  END IF;
  -- Terminacion: P-20-5116-17
  IF v_mov IN('RA','MO') THEN
    BEGIN
      SELECT/*+ FIRST_ROWS */ oid, com_bloqueo_id
   INTO v_dummy, v_dummy_2
      FROM TBL_BDU_COMERCIOS
      WHERE com_afiliacion = v_afiliacion;
   --
   IF v_mov = 'MO' AND TO_NUMBER(v_dummy_2) > 0 THEN
     v_error:= v_error||'LA AFILIACION ESTA CANCELADA ';
        GOTO FIN;
   END IF;
   --
   IF v_mov = 'RA' AND TO_NUMBER(v_dummy_2) = 0 THEN
     v_error:= v_error||'LA AFILIACION NO ESTA CANCELADA ';
        GOTO FIN;
   END IF;
   --
   IF v_mov = 'RA' AND TO_NUMBER(NVL(v_cod_cas,'0')) > 0 THEN
     v_error:= v_error||'REACTIVACION DEBE TENER CVE CANCEL CERO ';
        GOTO FIN;
   END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_error:= v_error||'AFILIACION NO EXISTE ';
        GOTO FIN;
    END;
  END IF;
  --
  IF (v_domicilio IS NULL) OR
    ((INSTR(v_domicilio,' NO ') = 0) AND (INSTR(v_domicilio,'SN') = 0) AND
     (INSTR(v_domicilio,' KM ') = 0) AND (INSTR(v_domicilio,'SKM') = 0)) THEN
    v_error:= 'DOMICILIO ';
    GOTO FIN;
  END IF;
  -- Inicio: F-54-2175-16
  -- se elimina codigo
  -- Terminacion: F-54-2175-16
  --
  IF v_propietario IS NULL THEN
    v_error:= 'PROPIETARIO ';
    GOTO FIN;
  END IF;
  --
  BEGIN
    SELECT/*+ FIRST_ROWS */ com_bco_id, oid, com_movimiento_id
    INTO v_banco_id, v_prop_id, v_cm
    FROM TBL_BDU_PROPUESTAS_COM
    WHERE com_afiliacion = v_afiliacion
     AND com_movimiento_id != 7;
    --
    v_existe := 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_existe := 0;
  END;
  --
  BEGIN
    SELECT/*+ FIRST_ROWS */ com_bco_id, oid, com_movimiento_id
    INTO v_banco_id, v_prop_id, v_cm
    FROM TBL_BDU_PROPUESTAS_COM
    WHERE com_afiliacion = v_afiliacion
     AND com_movimiento_id = 7;
    --
    v_cm := 7;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_cm := 0;
  END;
  -- Validar mov
  -- Afiliacion
  IF v_mov NOT IN('AL','RE') THEN
    BEGIN
      SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
      FROM TBL_BDU_COMERCIOS
      WHERE com_afiliacion = v_afiliacion;
    EXCEPTION
      WHEN OTHERS THEN
        v_error:= v_error||'AFILIACION NO EXISTE ';
        GOTO FIN;
    END;
  END IF;
  --
  -- bloqueo
  IF v_mov IN('CA','RE') THEN
    BEGIN
      SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
      FROM TBL_BDU_CODIGOS_BLOQUEO
      WHERE oid = TO_NUMBER(v_cod_cas);
    EXCEPTION
      WHEN OTHERS THEN
        v_error:= v_error||'CVE BLOQUEO ';
        GOTO FIN;
    END;
    --
    -- Verifica com
    IF (TO_NUMBER(NVL(v_cod_cas,'0')) = 0 AND v_mov = 'CA') THEN
      v_error:= v_error||'CVE BLOQUEO ';
      GOTO FIN;
    END IF;
    --
    BEGIN
      SELECT/*+ FIRST_ROWS */ com_bco_id, com_bloqueo_id
      INTO v_banco_id, v_cod_cas
      FROM TBL_BDU_COMERCIOS
      WHERE com_afiliacion = DECODE(v_mov,'RE',v_afiliante,v_afiliacion);
      --
      IF v_banco_id NOT IN(3,33,14,140,897) THEN
        IF v_mov IN ('CA','BA') THEN
          v_error:= v_error||'AFILIACION CON OTRO BANCO ';
          GOTO FIN;
        END IF;
      END IF;
      --
      IF (TO_NUMBER(NVL(v_cod_cas,'0'))= 0 AND v_mov = 'RA') THEN
        v_error:= v_error||'AFILIACION NO ESTA CANCELADA ';
        GOTO FIN;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        v_error:= v_error||'AFILIACION NO EXISTE ';
        GOTO FIN;
    END;
    --
    v_cod_cas     := SUBSTR(v_linea, 361, 2);
  END IF;
  --
  -- Banco
  BEGIN
   SELECT/*+ FIRST_ROWS */ oid, bco_moneda_id
   INTO v_banco_id, v_moneda
   FROM   TBL_BDU_BANCOS
   WHERE  oid = v_banco;
  EXCEPTION
    WHEN OTHERS THEN
      v_error := v_error||'BANCO ';
      GOTO FIN;
  END;
  --
  IF v_mov NOT IN('CA','BA') THEN
    --
    -- Afilianter
    IF v_mov = 'RE' THEN
      IF v_afiliante IS NULL OR v_afiliante = '000000000' THEN
        v_error:= v_error||'AFILIANTER ';
        GOTO FIN;
      ELSE
        BEGIN
          SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
          FROM TBL_BDU_COMERCIOS
          WHERE com_afiliacion = v_afiliante;
        EXCEPTION
          WHEN OTHERS THEN
            v_error:= v_error||'AFILIANTER ';
            GOTO FIN;
        END;
      END IF;
      --
      BEGIN
        SELECT/*+ FIRST_ROWS */ oid INTO v_recont_id
        FROM TBL_BDU_CLAVES_RECONTRATACION
        WHERE oid = v_cve_recont;
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'CVE RECONTRATACION ';
          GOTO FIN;
      END;
    END IF;
    --
    -- Cadena
    IF ((TO_NUMBER(v_grupo)=0 AND TO_NUMBER(v_cadena)=0))
      AND TO_NUMBER(v_criter_cad)>0 THEN
        v_error:= v_error||'CRIT ENCAD ';
        GOTO FIN;
    END IF;
    --
    IF (TO_NUMBER(v_grupo)>0 OR TO_NUMBER(v_cadena)>0) THEN
      IF ((TO_NUMBER(v_grupo)>0 AND TO_NUMBER(v_cadena)=0)
       OR (TO_NUMBER(v_grupo)=0 AND TO_NUMBER(v_cadena)>0)) THEN
          v_error:= v_error||'CADENA ';
          GOTO FIN;
      END IF;
      --
      IF TO_NUMBER(v_criter_cad) = 0 THEN
        v_error:= v_error||'CRIT ENCAD ';
        GOTO FIN;
      END IF;
      --
      BEGIN
        SELECT/*+ FIRST_ROWS */ oid INTO v_cadena_id
        FROM TBL_BDU_CADENAS
        WHERE cad_cve = TO_NUMBER(v_cadena)
         AND  cad_grupo_id = TO_NUMBER(v_grupo);
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'CADENA ';
          GOTO FIN;
      END;
      --
      IF v_cadena_id > 0 THEN
        BEGIN
          SELECT/*+ FIRST_ROWS */ DECODE(oid,0,NULL,oid) INTO v_criter_id
          FROM TBL_BDU_CRITERIOS_ENCAD
          WHERE oid = TO_NUMBER(v_criter_cad);
        EXCEPTION
          WHEN OTHERS THEN
            v_error:= v_error||'CRIT ENCAD ';
            GOTO FIN;
        END;
      END IF;
    END IF;
    --
    -- Cred
    BEGIN
      SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
      FROM TBL_BDU_CATEGORIAS_CREDITO
      WHERE oid = v_cat_cred;
    EXCEPTION
      WHEN OTHERS THEN
        v_error:= v_error||'CATEG CRED ';
        GOTO FIN;
    END;
    --
    BEGIN
      SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
      FROM TBL_BDU_TIPOS_PAGO_CREDITO
      WHERE oid = v_cve_cred;
    EXCEPTION
      WHEN OTHERS THEN
        v_error:= v_error||'CVE CRED ';
        GOTO FIN;
    END;
    --
    -- Deb
    BEGIN
      SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
      FROM TBL_BDU_CATEGORIAS_DEBITO
      WHERE oid = v_cat_deb;
    EXCEPTION
      WHEN OTHERS THEN
        v_error:= v_error||'CATEG DEB ';
        GOTO FIN;
    END;
    --
    BEGIN
      SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
      FROM TBL_BDU_TIPOS_PAGO_DEBITO
      WHERE oid = v_cve_deb;
    EXCEPTION
      WHEN OTHERS THEN
        v_error:= v_error||'CVE DEB ';
        GOTO FIN;
    END;
    --
    -- Iva
    BEGIN
      SELECT/*+ FIRST_ROWS */ oid INTO v_iva_id
      FROM TBL_BDU_IMPUESTOS_PAIS
      WHERE oid = v_iva
       AND  imp_pais_id = 1;
    EXCEPTION
      WHEN OTHERS THEN
        v_error:= v_error||'IVA ';
    END;
    -- Giro
        BEGIN
          SELECT/*+ FIRST_ROWS */ oid INTO v_giro_id
          FROM TBL_BDU_GIROS
          WHERE gir_cve = v_giro
           AND  gir_pais_id = 1;
        EXCEPTION
          WHEN OTHERS THEN
            v_error:= v_error||'GIRO ';
            GOTO FIN;
        END;
     --
     -- CP
     BEGIN
       SELECT/*+ FIRST_ROWS */ oid INTO v_cp_id
       FROM TBL_BDU_CP
       WHERE cp_cve = v_cp
        AND cp_colonia = LTRIM(RTRIM(v_colonia));
     EXCEPTION
    WHEN OTHERS THEN
         v_error:= v_error||'CP | COLONIA';
         v_estado_pro := 6;
         GOTO FIN;
      END;
     -- CP fisc
      BEGIN
        SELECT/*+ FIRST_ROWS */ oid INTO v_cpf_id
        FROM TBL_BDU_CP
        WHERE cp_cve = v_cp_f
         AND cp_colonia = LTRIM(RTRIM(v_colonia_f));
      EXCEPTION
     WHEN OTHERS THEN
       v_error:= v_error||'CP FISCAL | COLONIA FISCAL';
          v_estado_pro := 6;
          GOTO FIN;
      END;
     --
  -- Pob
     BEGIN
        SELECT/*+ FIRST_ROWS */ oid INTO v_pob_id
        FROM TBL_BDU_POBLACIONES
        WHERE oid = v_pob;
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'POBLACION ';
     v_estado_pro := 6;
     GOTO FIN;
      END;
   IF v_pob_f != '     ' AND v_pob_f != '00000' THEN
        BEGIN
          SELECT/*+ FIRST_ROWS */ oid INTO v_pob_id
          FROM TBL_BDU_POBLACIONES
          WHERE oid = v_pob_f;
        EXCEPTION
          WHEN OTHERS THEN
            v_error:= v_error||'POB FISCAL ';
         v_estado_pro := 6;
         GOTO FIN;
        END;
   END IF;
  -- Edo
     BEGIN
        SELECT/*+ FIRST_ROWS */ oid INTO v_edo_id
        FROM TBL_BDU_ESTADOS
        WHERE oid = v_estado
         AND  edo_pais_id = 1;
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'ESTADO ';
     v_estado_pro := 6;
     GOTO FIN;
      END;
   IF v_estado_f != '  ' AND v_estado_f != '00' THEN
        BEGIN
          SELECT/*+ FIRST_ROWS */ oid INTO v_edo_id
          FROM TBL_BDU_ESTADOS
          WHERE oid = v_estado_f
           AND  edo_pais_id = 1;
        EXCEPTION
          WHEN OTHERS THEN
            v_error:= v_error||'ESTADO FISCAL ';
       v_estado_pro := 6;
       GOTO FIN;
        END;
   END IF;
     -- Tel
     IF LENGTH(TO_NUMBER(v_lada))+LENGTH(TO_NUMBER(v_tel)) != 10 THEN
       v_error:= v_error||'LADA |TEL ';
       v_estado_pro := 6;
       GOTO FIN;
     END IF;
     --
     IF v_lada_2 != '000' AND v_tel_2 != '00000000' THEN
       IF LENGTH(TO_NUMBER(v_lada_2))+LENGTH(TO_NUMBER(v_tel_2)) != 10 THEN
         v_error:= v_error||'LADA2 |TEL2 ';
         v_estado_pro := 6;
         GOTO FIN;
       END IF;
     END IF;
     --
     IF v_lada_f != '000' AND v_tel_f != '00000000' THEN
       IF LENGTH(TO_NUMBER(v_lada_f))+LENGTH(TO_NUMBER(v_tel_f)) != 10 THEN
         v_error:= v_error||'LADA |TEL FISCAL ';
         v_estado_pro := 6;
         GOTO FIN;
       END IF;
     END IF;
  END IF;
  --
  IF v_servicom = 1 AND (v_mov IN('MO','BA'))THEN
    IF TO_NUMBER(v_servicom_a)=0 THEN
      v_error:= v_error||'AFIL SERVICOMERCIO INVALIDA ';
      GOTO FIN;
    END IF;
    --
      BEGIN
        SELECT/*+ FIRST_ROWS */ com_bco_id, com_bloqueo_id
        INTO v_banco_id_s, v_cod_cas_s
        FROM TBL_BDU_COMERCIOS
        WHERE com_afiliacion = v_servicom_a;
        --
        IF v_banco_id NOT IN(3,33,14,140) THEN
          v_error:= v_error||'AFIL SERVICOMERCIO BANCO ';
          GOTO FIN;
        END IF;
        --
        IF TO_NUMBER(NVL(v_cod_cas,0)) BETWEEN 1 AND 57 THEN
          v_error:= v_error||'AFIL SERVICOMERCIO CANCELADA ';
          GOTO FIN;
        END IF;
        --
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'AFIL SERVICOMERCIO NO EXISTE ';
          GOTO FIN;
      END;
  END IF;
  --
  IF v_mov NOT IN('CA','BA') THEN
       verifica_rfc(LPAD(NVL(v_rfc,'0'),13,'0'), v_rfc_ok);
    IF v_rfc_ok = 0 THEN
      v_error:= v_error||'RFC ';
      GOTO FIN;
    END IF;
  END IF;
  --
  IF TO_NUMBER(v_banco) IN(3,14) THEN
     v_moneda := 1;
  ELSE
     v_moneda := 2;
  END IF;
 --
 IF v_error IS NULL THEN
   --
   IF v_mov = 'MO' AND v_cm = 7 THEN
     DELETE TBL_BDU_PROPUESTAS_COM
     WHERE com_afiliacion = v_afiliacion
      AND com_movimiento_id = 7;
   END IF;
   --
   IF v_mov != 'BA' THEN
     IF (v_mov IN('AL', 'RE') AND TO_NUMBER(NVL(v_afiliacion,'0')) = 0) THEN
       Pkg_Bdu_Utilerias_Com.nueva_afiliacion(v_afiliacion);
     ELSIF ((v_mov IN('CA', 'BA')) AND v_existe = 1) THEN
       UPDATE TBL_BDU_PROPUESTAS_COM
       SET  com_bloqueo_id     = v_cod_cas,
            com_estatus_pro_id = v_estado_pro,
            com_fecha_propuesta = SYSDATE
       WHERE com_afiliacion = TO_NUMBER(v_afiliacion)
        AND com_estatus_pro_id = 2;
     ELSIF ((TO_NUMBER(NVL(v_afiliacion,'0')) > 0) AND v_existe = 1) THEN
       UPDATE TBL_BDU_PROPUESTAS_COM
       SET  com_nombre                  = v_nombre,
            com_propietario             = v_propietario,
            com_razon                   = v_razon,
            com_responsable             = v_responsable,
            com_rfc                     = v_rfc,
            com_valor_credito           = v_valor_cred,
            com_valor_debito            = v_valor_deb,
            com_num_placa               = v_placas,
            com_suc_numero              = v_sucursal,
            com_giro_id                 = v_giro_id,
            com_cadena_id               = v_cadena_id,
            com_crit_encadena_id        = v_criter_id,
            com_obs_banco               = v_obs,
            bdu_usuario                 = v_usuario,
            com_estatus_pro_id          = v_estado_pro,
            com_fecha_propuesta = SYSDATE
       WHERE com_afiliacion = TO_NUMBER(v_afiliacion)
        AND com_estatus_pro_id = 2;
       --
       UPDATE TBL_BDU_PROPUESTAS_COM_ADDN
       SET com_domicilio = v_domicilio,
         com_telefono    = v_tel,
         com_cp_id       = v_cp_id,
         com_lada_1      = v_lada
       WHERE com_pro_id = v_prop_id
        AND com_tipo_dato_id = 1;
       --
       UPDATE TBL_BDU_PROPUESTAS_COM_ADDN
       SET com_domicilio = v_domicilio_f,
         com_telefono    = v_tel_f,
         com_cp_id       = v_cpf_id,
         com_lada_1      = v_lada_f
       WHERE com_pro_id = v_prop_id
        AND com_tipo_dato_id = 2;
       --
     END IF;
   END IF;
   --
   IF v_mov != 'CA'  THEN
     --
     IF v_giro IN(6010,6011) THEN
       v_estado_arb := 1;
     ELSE
       v_estado_arb := 0;
     END IF;
     IF v_nombre IS NOT NULL THEN
    v_nombre     := abrevia(v_nombre, 1);
  END IF;
  IF v_domicilio IS NOT NULL THEN
       v_domicilio  := abrevia(v_domicilio,2);
  END IF;
  -- Inicio: F-54-2175-16
  -- se elimina codigo
  -- Terminacion: F-54-2175-16
     --
   END IF;

    IF ((v_mov = 'MO' AND v_servicom = 0) OR v_mov = 'RA')
     AND v_existe != 1 THEN
      BEGIN
      FOR X IN(
      SELECT com_afiliacion, id_bitacora
      FROM TBL_BDU_COMERCIOS
      WHERE com_afiliacion = v_afiliacion
      )
      LOOP
      BEGIN
        INSERT INTO TBL_BDU_PROPUESTAS_COM (
          com_afil_amex, com_afil_diners, com_chq_chequera,
          com_chq_cuenta, com_chq_plaza, com_chq_plaza_bco,
          com_chq_sucursal, com_afiliacion, com_afilianter,
          com_enviar_arbitro, com_impr_placa, com_nombre,
          com_propietario, com_razon, com_responsable,
          com_rfc, com_tipo_bloqueo, com_valor_credito,
          com_valor_debito, com_num_placa, com_numero_prosa,
          com_suc_numero, mon_proc_aten, mon_tran_perm,
          mon_tran_perm_cambio, pose_mm_auto_batch_release,
          pose_mm_auto_release_time_1,
          pose_mm_auto_release_time_2, oid, com_bco_id,
          com_bloqueo_id, com_cat_cred_id, com_cat_deb_id,
          com_moneda_id, com_recontratacion_id,
          com_giro_id, com_impuesto_id, com_cadena_id,
          com_crit_encadena_id, com_fecha_propuesta,
          com_estatus_id, com_movimiento_id, com_cve_cred_id,
          com_cve_deb_id, com_cve_tarc_id, com_fec_cve_cred,
          com_fec_cve_deb, com_fec_cve_tarc, com_valor_tarc,
          com_asociacion_id, com_asig_cred_id, com_asig_deb_id,
          com_obs_banco, com_obs_despacho, com_corte_inicio,
          com_corte_fin, com_estatus_pro_id, com_multi_hora_id,
          com_cecoban_id, com_prov_placas_id,
          com_servicomercio, com_tipo_debito_id, com_interred,
          bdu_usuario, com_pro_cad_id, com_obs_adquiriente,
          id_bitacora, com_sponsor, com_desc_sponsor,
          com_benef_tasa1, com_benef_tasa2, com_benef_amt_1,
          com_benef_amt_2, com_clave_neg,
          com_cuota_anual, com_cuota_mensual, com_registro_fiscal
          )
        SELECT
        -- Inicio: F-54-2195-16
          com_afil_amex, com_afil_diners, v_chequera,
          NVL(v_cuenta,'0000000000'), com_chq_plaza, com_chq_plaza_bco,
          com_chq_sucursal, com_afiliacion, com_afilianter,
          v_estado_arb, com_impr_placa, NVL(v_nombre,com_nombre),
          NVL(v_propietario,com_propietario), NVL(v_razon,com_razon),
          NVL(v_responsable,com_responsable),
          NVL(v_rfc,com_rfc), NULL, v_valor_cred,
          v_valor_deb,
          v_placas,
          com_numero_prosa,
          com_suc_numero, mon_proc_aten, mon_tran_perm,
          mon_tran_perm_cambio, pose_mm_auto_batch_release,
          pose_mm_auto_release_time_1,
          pose_mm_auto_release_time_2, com_afiliacion, v_banco,
          0, com_cat_cred_id, com_cat_deb_id,
          com_moneda_id, com_recontratacion_id,
          NVL(v_giro,com_giro_id), com_impuesto_id, NVL(v_cadena_id,com_cadena_id),
          NVL(v_criter_id,com_crit_encadena_id), SYSDATE,
          1, DECODE(v_mov,'MO',2,'RA',4), com_cve_cred_id,
          com_cve_deb_id, com_cve_tarc_id, com_fec_cve_cred,
          com_fec_cve_deb, com_fec_cve_tarc, com_valor_tarc,
          com_asociacion_id, com_asig_cred_id, com_asig_deb_id,
          NVL(v_obs,com_obs_banco), com_obs_despacho, com_corte_inicio,
          com_corte_fin, DECODE(v_estado_pro,6,6,3), com_multi_hora_id,
          com_cecoban_id, DECODE(v_prov_plac,'00',NULL,'0',NULL,v_prov_plac),
          com_servicomercio, com_tipo_debito_id, com_interred,
          v_usuario, com_pro_cad_id, com_obs_adquiriente,
          id_bitacora, com_sponsor, com_desc_sponsor,
          com_benef_tasa1, com_benef_tasa2, com_benef_amt_1,
          com_benef_amt_2, com_clave_neg,
          com_cuota_anual, com_cuota_mensual, com_registro_fiscal
        -- Terminacion: F-54-2195-16
        FROM TBL_BDU_COMERCIOS
        WHERE com_afiliacion = x.com_afiliacion
         AND  com_pais = 1;
        --
     -- Gen
     INSERT INTO TBL_BDU_PROPUESTAS_COM_ADDN(
       com_domicilio,
       com_telefono,
       com_telefono_2,
       com_fax, com_email, com_pro_id,
       com_cp_id,
       com_tipo_dato_id, oid,
       com_lada_1,
       com_lada_2,
       bdu_usuario, id_bitacora, com_banco_id
       )
     SELECT
       v_domicilio,
       DECODE(TO_NUMBER(v_tel),0,com_telefono,TO_NUMBER(v_tel)),
       DECODE(TO_NUMBER(v_tel_2),0,com_telefono_2,TO_NUMBER(v_tel_2)),
       com_fax, NVL(v_email, com_email), com_id,
       DECODE(v_cp_id, NULL, com_cp_id, v_cp_id),
       com_tipo_dato_id, BDUSEQ020.NEXTVAL,
       DECODE(TO_NUMBER(v_lada),0,com_lada_1,TO_NUMBER(v_lada)),
       DECODE(TO_NUMBER(v_lada_2),0,com_lada_2,TO_NUMBER(com_lada_2)),
       bdu_usuario,
       id_bitacora, v_banco
     FROM TBL_BDU_COMERCIOS_ADDRESS_N
     WHERE com_id = x.com_afiliacion
      AND com_tipo_dato_id = 1;
  -- Leg
    INSERT INTO TBL_BDU_PROPUESTAS_COM_ADDN(
      com_domicilio,
      com_telefono,
      com_fax, com_email, com_pro_id,
      com_cp_id, com_tipo_dato_id, oid,
      com_lada_1,
      bdu_usuario, id_bitacora, com_banco_id
      )
    SELECT
      v_domicilio_f,
      DECODE(TO_NUMBER(v_tel_f),0,com_telefono,TO_NUMBER(v_tel_f)),
      com_fax, NVL(v_email, com_email), com_id,
      DECODE(v_cpf_id, NULL, com_cp_id, v_cpf_id),
      com_tipo_dato_id, BDUSEQ020.NEXTVAL,
      DECODE(TO_NUMBER(v_lada_f),0,com_lada_1,TO_NUMBER(v_lada_f)),
      bdu_usuario,
      id_bitacora, v_banco
    FROM TBL_BDU_COMERCIOS_ADDRESS_N
    WHERE com_id = x.com_afiliacion
     AND com_tipo_dato_id = 2;
   -- Inicio: F-08-2006-13 CML
   --IF v_mov = 'RA' THEN
    FOR Y IN(
     SELECT car_card_type_id
     FROM TBL_BDU_CARD_TYPES_BCO
     WHERE car_bco_id = v_banco
     )
     LOOP
      BEGIN
       INSERT INTO TBL_BDU_CARD_TYPES_PRO_COM(
         car_card_type_id, car_propuesta_id,
         oid, bdu_usuario, id_bitacora
       )
       VALUES(
         y.car_card_type_id, x.com_afiliacion,
         BDUSEQ022.NEXTVAL, v_usuario, NVL(x.id_bitacora, x.com_afiliacion)
       );
      --EXCEPTION
      --  WHEN OTHERS THEN NULL;
      END;
     END LOOP;
   --END IF;
   -- Terminacion: F-08-2006-13 CML
  --
  --    EXCEPTION
  --      WHEN OTHERS THEN
  --  v_error:= v_error||'MODIFICACION NO CREADA|';
      END;
      END LOOP;
      END;
   END IF;
   --
   IF (v_mov NOT IN('CA','MO','RA'))
    AND(v_mov IN('AL','RE') AND v_existe = 0 )
   THEN
    -- Inicio C-54-2679-14
    --BEGIN
    --  pkg_bdu_utilerias_com.nueva_afiliacion(v_afiliacion);
    --END;
     BEGIN
      INSERT INTO TBL_BDU_PROPUESTAS_COM(
        com_chq_chequera,  com_chq_cuenta,
        com_chq_plaza,     com_chq_plaza_bco,
        com_chq_sucursal,  com_afiliacion,
        com_afilianter,    com_enviar_arbitro,
        com_impr_placa,    com_nombre,
        com_propietario,   com_razon,
        com_responsable,   com_rfc,
        com_valor_credito, com_valor_debito,
        com_num_placa,     com_suc_numero,
        pose_mm_auto_batch_release,
        pose_mm_auto_release_time_1,
        pose_mm_auto_release_time_2,
     com_corte_inicio,
     com_corte_fin,
        oid,            com_bco_id,
        com_bloqueo_id,    com_cat_cred_id,
        com_cat_deb_id,    com_moneda_id,
        com_recontratacion_id,
        com_giro_id,       com_impuesto_id,
        com_cadena_id,     com_crit_encadena_id,
        com_fecha_propuesta,com_estatus_id,
        com_movimiento_id, com_cve_cred_id,
        com_cve_deb_id,    com_cve_tarc_id,
        com_fec_cve_cred,  com_fec_cve_deb,
        com_fec_cve_tarc,  com_valor_tarc,
        com_asociacion_id, com_asig_cred_id,
        com_asig_deb_id,   com_obs_banco,
        com_estatus_pro_id,
        com_multi_hora_id, com_cecoban_id,
        com_prov_placas_id,com_servicomercio,
        com_tipo_debito_id,com_interred,
        bdu_usuario,
        id_bitacora,
        com_flag_1,        com_flag_2
        )
      VALUES(
        SUBSTR(RTRIM(LTRIM(v_chequera)), 6, 15),   v_cuenta,
        NULL,     v_cecoban_bco,
        v_sucursal,   TO_NUMBER(v_afiliacion),
        DECODE(TO_NUMBER(v_afiliante), 0, NULL, TO_NUMBER(v_afiliante)), v_estado_arb,
        'P',     RTRIM(LTRIM(v_nombre)),
        RTRIM(LTRIM(v_propietario)),   RTRIM(LTRIM(v_razon)),
        RTRIM(LTRIM(v_responsable)),  v_rfc,
        TO_NUMBER(v_valor_cred)/100,
     TO_NUMBER(v_valor_deb)/100,
        TO_NUMBER(v_placas),   v_sucursal,
        'Y',
        TO_DATE(TO_CHAR(SYSDATE,'DD/MM/YYYY')||' 22:29','DD/MM/YYYY HH24:MI'),
        TO_DATE(TO_CHAR(SYSDATE,'DD/MM/YYYY')||' 22:30','DD/MM/YYYY HH24:MI'),
        TO_DATE(TO_CHAR(SYSDATE,'DD/MM/YYYY')||' 22:29','DD/MM/YYYY HH24:MI'),
        TO_DATE(TO_CHAR(SYSDATE,'DD/MM/YYYY')||' 22:30','DD/MM/YYYY HH24:MI'),
        v_oid,     v_banco_id,
        0,    TO_NUMBER(v_cat_cred),
        TO_NUMBER(v_cat_deb), 1,
        v_recont_id,
        v_giro,    v_iva,
        v_cadena_id,  v_criter_id,
        SYSDATE,         1,
        v_mov_id,    TO_NUMBER(v_cve_cred),
        TO_NUMBER(v_cve_deb),    NULL,
        SYSDATE,   SYSDATE,
        NULL,     NULL,
        DECODE(TO_NUMBER(v_asoc),0,NULL,TO_NUMBER(v_asoc)),    1,
        1,     v_afiliacion||' '||v_obs,
    -- Terminacion C-54-2679-14
        v_estado_pro,
        NULL,    DECODE(v_cecoban_pob,0,1000,v_cecoban_pob),
        DECODE(v_prov_plac,0,NULL,v_prov_plac), v_servicom,
        3,      1,
        v_usuario,
        v_bitacora,
        NVL(v_vip,0),        NVL(v_inst,0)
        );

      -- Generales
      INSERT INTO TBL_BDU_PROPUESTAS_COM_ADDN(
        com_domicilio,  com_telefono,
        com_telefono_2, com_fax,
        com_email,     com_pro_id,
        com_cp_id,     com_tipo_dato_id,
        oid,      com_lada_1,
        com_lada_2,    bdu_usuario,
        id_bitacora,    com_banco_id
        )
      VALUES(
        v_domicilio,    TO_NUMBER(v_tel),
        DECODE(v_tel_2,'00000000', NULL, v_tel_2),  NULL,
        v_email,     v_oid,
        v_cp_id,     1,
        BDUSEQ003.NEXTVAL, TO_NUMBER(v_lada),
        DECODE(v_lada_2,'000', NULL, v_lada_2), v_usuario,
        v_bitacora,    v_banco
        );

     -- Legales
      INSERT INTO TBL_BDU_PROPUESTAS_COM_ADDN(
        com_domicilio,  com_telefono,
        com_telefono_2, com_fax,
        com_email,     com_pro_id,
        com_cp_id,     com_tipo_dato_id,
        oid,      com_lada_1,
        com_lada_2,    bdu_usuario,
        id_bitacora,    com_banco_id
        )
      VALUES(
        v_domicilio_f,  TO_NUMBER(v_tel_f),
        DECODE(v_tel_2,'00000000', NULL, v_tel_2),  NULL,
        v_email,     v_oid,
        v_cpf_id,     2,
        BDUSEQ003.NEXTVAL, TO_NUMBER(v_lada_f),
        DECODE(v_lada_2,'000', NULL, v_lada_2), v_usuario,
        v_bitacora,    v_banco
        );

       -- Types
       FOR Y IN(
         SELECT car_card_type_id
         FROM TBL_BDU_CARD_TYPES_BCO
         WHERE car_bco_id = v_banco
         )
         LOOP
           INSERT INTO TBL_BDU_CARD_TYPES_PRO_COM(
             car_card_type_id, car_propuesta_id,
           oid,              bdu_usuario,
           id_bitacora
           )
          VALUES(
            Y.CAR_CARD_TYPE_ID, V_OID,
           BDUSEQ022.NEXTVAL,  v_usuario,
           v_bitacora
           );
     END LOOP;
   --
   -- aplicacion
     IF v_servicom = 1 THEN
       INSERT INTO TBL_BDU_ASIGNACION_APP_PRO_COM(
         aac_propuesta_id, aac_aplicacion_id, oid,
         bdu_usuario, id_bitacora
         )
       VALUES(
         v_oid, 12, BDUSEQ014.NEXTVAL,
         v_usuario, v_bitacora
         );
      END IF;
     IF v_placas = 1 THEN
       INSERT INTO TBL_BDU_ASIGNACION_APP_PRO_COM(
         aac_propuesta_id, aac_aplicacion_id, oid,
         bdu_usuario, id_bitacora
         )
       VALUES(
         v_oid, 14, BDUSEQ014.NEXTVAL,
         v_usuario, v_bitacora
         );
      END IF;
      -- Modificacion: Inicio C-08-3094-12
      IF v_procom > 0 THEN
      -- Modificacion: Terminacion C-08-3094-12
       INSERT INTO TBL_BDU_ASIGNACION_APP_PRO_COM(
         aac_propuesta_id, aac_aplicacion_id, oid,
         bdu_usuario, id_bitacora
         )
       VALUES(
         v_oid, 7, BDUSEQ014.NEXTVAL,
         v_usuario, v_bitacora
         );
      END IF;
       INSERT INTO TBL_BDU_ASIGNACION_APP_PRO_COM(
         aac_propuesta_id, aac_aplicacion_id, oid,
         bdu_usuario, id_bitacora
         )
       VALUES(
         v_oid, 13, BDUSEQ014.NEXTVAL,
         v_usuario, v_bitacora
         );

   END;

  ELSIF (v_mov = 'CA' AND v_existe != 1) THEN -- Cancel
     BEGIN
      INSERT INTO TBL_BDU_PROPUESTAS_COM(
        com_chq_chequera, com_chq_cuenta,
        com_chq_plaza,    com_chq_plaza_bco,
        com_chq_sucursal, com_afiliacion,
        com_afilianter,   com_enviar_arbitro,
        com_impr_placa,   com_nombre,
        com_propietario,  com_razon,
        com_responsable,  com_rfc,
        com_valor_credito,com_valor_debito,
        com_num_placa,    com_suc_numero,
        pose_mm_auto_batch_release,
        pose_mm_auto_release_time_1,
        pose_mm_auto_release_time_2,
        com_corte_inicio,
        com_corte_fin,
        oid,     com_bco_id,
        com_bloqueo_id,  com_cat_cred_id,
        com_cat_deb_id,  com_moneda_id,
        com_recontratacion_id,
        com_giro_id,     com_impuesto_id,
        com_cadena_id,   com_crit_encadena_id,
        com_fecha_propuesta,com_estatus_id,
        com_movimiento_id,  com_cve_cred_id,
        com_cve_deb_id,  com_cve_tarc_id,
        com_fec_cve_cred,com_fec_cve_deb,
        com_fec_cve_tarc,com_valor_tarc,
        com_asociacion_id,  com_asig_cred_id,
       com_asig_deb_id, com_obs_banco,
        com_estatus_pro_id,
        com_multi_hora_id, com_cecoban_id,
        com_prov_placas_id, com_servicomercio,
        com_tipo_debito_id, com_interred,
        bdu_usuario,
        id_bitacora
  )
   SELECT
        com_chq_chequera, com_chq_cuenta,
        com_chq_plaza,   com_chq_plaza_bco,
        com_chq_sucursal,  com_afiliacion,
        com_afilianter,     v_estado_arb,
        com_impr_placa,  com_nombre,
        com_propietario,  com_razon,
        com_responsable, com_rfc,
        com_valor_credito,  com_valor_debito,
        com_num_placa,  com_suc_numero,
        pose_mm_auto_batch_release,
        pose_mm_auto_release_time_1,
        pose_mm_auto_release_time_2,
        com_corte_inicio,
        com_corte_fin,
        v_oid,     com_bco_id,
        v_cod_cas,  com_cat_cred_id,
        com_cat_deb_id,  com_moneda_id,
        com_recontratacion_id,
        com_giro_id,   com_impuesto_id,
        com_cadena_id,  com_crit_encadena_id,
        SYSDATE,  2,
        3,                com_cve_cred_id,
        com_cve_deb_id,  com_cve_tarc_id,
        com_fec_cve_cred, com_fec_cve_deb,
        com_fec_cve_tarc,  com_valor_tarc,
        com_asociacion_id,  com_asig_cred_id,
        com_asig_deb_id, v_obs,
        v_estado_pro,
        com_multi_hora_id, com_cecoban_id,
        com_prov_placas_id, com_servicomercio,
        com_tipo_debito_id, com_interred,
        v_usuario,
        v_bitacora
      FROM TBL_BDU_COMERCIOS
   WHERE com_afiliacion = v_afiliacion;

      -- Generales
      INSERT INTO TBL_BDU_PROPUESTAS_COM_ADDN(
        com_domicilio,  com_telefono,
        com_telefono_2, com_fax,
        com_email,     com_pro_id,
        com_cp_id,     com_tipo_dato_id,
        oid,      com_lada_1,
        com_lada_2,    bdu_usuario,
        id_bitacora,    com_banco_id
        )
      SELECT/*+ FIRST_ROWS */
        com_domicilio,   com_telefono,
        com_telefono_2,  com_fax,
        com_email,      v_oid,
        com_cp_id,      1,
        BDUSEQ003.NEXTVAL, com_lada_1,
        com_lada_2,     bdu_usuario,
        v_bitacora,     com_bco_id
      FROM TBL_BDU_COMERCIOS_ADDRESS_N
   WHERE com_id = v_afiliacion
    AND com_tipo_dato_id = 1;

     -- Legales
      INSERT INTO TBL_BDU_PROPUESTAS_COM_ADDN(
        com_domicilio,   com_telefono,
        com_telefono_2,  com_fax,
        com_email,      com_pro_id,
        com_cp_id,      com_tipo_dato_id,
        oid,       com_lada_1,
        com_lada_2,     bdu_usuario,
        id_bitacora,     com_banco_id
        )
      SELECT/*+ FIRST_ROWS */
        com_domicilio,   com_telefono,
        com_telefono_2,  com_fax,
        com_email,      v_oid,
        com_cp_id,      2,
        BDUSEQ003.NEXTVAL, com_lada_1,
        com_lada_2,     bdu_usuario,
        v_bitacora,     com_bco_id
      FROM TBL_BDU_COMERCIOS_ADDRESS_N
   WHERE com_id = v_afiliacion
    AND com_tipo_dato_id = 2;

   --EXCEPTION
   --  WHEN OTHERS THEN NULL;
   END;

   END IF; -- Canc
  -- svc
  IF v_multicaja = 1 AND v_servicom = 0 THEN
    v_error:= 'INDICADOR SERVICOMERCIO ';
    GOTO FIN;
  END IF;
  --
  IF v_servicom = 1 THEN
    IF v_mov = 'MO' THEN
      -- 1
      servicomercio(v_servicom_a, v_afiliacion, v_multicaja, 1, v_usuario, v_out);
      IF v_out != '1' THEN
        v_error := v_out;
      ELSE
        BEGIN
          INSERT INTO TBL_BDU_ASIGNACION_APP_COM(
            aac_comercio_id,
            aac_aplicacion_id,
            oid,
            bdu_usuario
            )
          VALUES(
            v_afiliacion,
            12,
            BDUSEQ007.NEXTVAL,
            v_usuario
            );
        EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN NULL;
        END;
      END IF;
    ELSIF v_mov = 'BA' THEN
      servicomercio(v_servicom_a, v_afiliacion, v_multicaja, 3, v_usuario, v_out);
    END IF;
  END IF; -- svc

  END IF; -- v_error NULL
  -- Inicio: P-20-0115-16
  IF(v_amexmv='1' AND v_error IS NULL AND v_banco_id!=33)THEN
    IF(v_amexnm=NULL OR v_amexdm=NULL OR v_amexcp=NULL OR v_amexap=NULL OR v_amexfn=NULL
     OR v_amexcd=NULL OR v_amexid=NULL)THEN
       v_error:= v_error||'DATOS AMEX REQUERIDOS ';
       GOTO FIN;
    ELSE
      v_cadenaoka:=PKG_BDU_OFFLINE.valida(v_amexnm,1);
      v_cadenaokb:=PKG_BDU_OFFLINE.valida(v_amexdm,1);
      v_cadenaokc:=PKG_BDU_OFFLINE.valida(v_amexcp,0);
      v_cadenaokd:=PKG_BDU_OFFLINE.valida(v_amexcd,1);
      v_cadenaoke:=PKG_BDU_OFFLINE.valida(v_amexap,1);
      v_cadenaokf:=PKG_BDU_OFFLINE.valida(v_amexfn,0);
      v_cadenaokg:=PKG_BDU_OFFLINE.valida(v_amexid,1);
    END IF;
    --
    IF(v_cadenaoka=0 OR v_cadenaokb=0 OR v_cadenaokc=0 OR v_cadenaokd=0 OR v_cadenaoke=0
     OR v_cadenaokf=0 OR v_cadenaokg=0)THEN
       v_error:= v_error||'DATOS AMEX CARACTERES INVALIDOS ';
       GOTO FIN;
    END IF;
    DBMS_OUTPUT.PUT_LINE('POUT = ' || v_error);
    --
    IF v_giro IS NOT NULL THEN
      BEGIN
        SELECT oid INTO v_giro_id
        FROM TBL_BDU_GIROS
        WHERE gir_cve = v_giro
         AND  gir_ax > 0;
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'GIRO NO PERMITIDO EN LA OPERATIVA AMEX |';
          GOTO FIN;
       END;
    END IF;
    --
     BEGIN
      INSERT INTO TBL_BDU_COMERCIO_AX(
        com_afiliacion, com_seller_id, oid,
        com_nm_rl1,  com_ap_pat_rl1,
        com_id_rl1,  com_fec_nac_rl1,
        com_dom_rl1, com_cd_rl1,
        com_cp_rl1,
        com_nm_rl2,  com_ap_pat_rl2,
        com_id_rl2,  com_fec_nac_rl2,
        com_dom_rl2, com_cd_rl2,
        com_cp_rl2,
        com_mkt,     com_tn
        )
      VALUES(
        v_afiliacion, RPAD(v_afiliacion,20,' '), v_afiliacion,
        v_amexnm, v_amexap,
        v_amexid, v_amexfn,
        v_amexdm, v_amexcd,
        v_amexcp,
        v_amexnmd, v_amexapd,
        v_amexidd, v_amexfnd,
        v_amexdmd, v_amexcdd,
        v_amexcpd,
        v_amexmk, v_amextn
        );
     EXCEPTION
       WHEN dup_val_on_index THEN
         UPDATE TBL_BDU_COMERCIO_AX
         SET com_nm_rl1 = v_amexnm,  
           com_ap_pat_rl1 = v_amexap,
           com_id_rl1 = v_amexid,  
           com_fec_nac_rl1 = v_amexfn,
           com_dom_rl1 = v_amexdm, 
           com_cd_rl1 = v_amexcd,
           com_cp_rl1 = v_amexcp,
           com_nm_rl2 = v_amexnmd,  
           com_ap_pat_rl2 = v_amexapd,
           com_id_rl2 = v_amexidd,  
           com_fec_nac_rl2 = v_amexfnd,
           com_dom_rl2 = v_amexdmd, 
           com_cd_rl2 = v_amexcdd,
           com_cp_rl2 = v_amexcpd,
           com_mkt = v_amexmk,
           com_tn  = v_amextn
         WHERE com_afiliacion = v_afiliacion;
      WHEN others THEN
        v_estat := 'R';
        v_error := v_mov||LPAD(v_afiliacion,9,'0')||LPAD(v_banco,3,'0')||
        '000'||v_estat||RPAD('ERROR EN DATOS AMEX',50,' ')||RPAD(v_id_elavon,10,'0')||v_himms;
    END;
    --
    BEGIN
      SELECT com_mov_ax INTO v_mov_ax
      FROM TBL_BDU_COMERCIO_AX
      WHERE com_afiliacion = v_afiliacion;
    EXCEPTION
      WHEN no_data_found THEN NULL;
    END;
    --
    IF(v_amexcanc IS NOT NULL) THEN
     IF((v_amexcanc ='R') AND (NVL(v_mov_ax,'X') NOT IN('D','R')))THEN
        v_estat := 'R';
        v_error := v_mov||LPAD(v_afiliacion,9,'0')||LPAD(v_banco,3,'0')||
        '000'||v_estat||RPAD('REACTIVACION AMEX INVALIDA',50,' ')||RPAD(v_id_elavon,10,'0')||v_himms;
        GOTO FIN;
     END IF;   
     IF((v_amexcanc IN('D','N')) AND (v_mov_ax IN('D','N')))THEN
        v_estat := 'R';
        v_error := v_mov||LPAD(v_afiliacion,9,'0')||LPAD(v_banco,3,'0')||
        '000'||v_estat||RPAD('CANCELACION AMEX INVALIDA',50,' ')||RPAD(v_id_elavon,10,'0')||v_himms;
        GOTO FIN;
     END IF;   
    END IF;
    --
    IF(v_amexmv='1' AND NVL(v_amexcanc,'X') NOT IN('D','R'))THEN
     UPDATE TBL_BDU_COMERCIO_AX
     SET com_estatus = 1,
       com_mov_ax='N'
     WHERE com_afiliacion = v_afiliacion;
    END IF;
    IF(v_amexmv='1' AND NVL(v_amexcanc,'X')='R') THEN
     UPDATE TBL_BDU_COMERCIO_AX
     SET com_estatus = 0,
       com_mov_ax='R'
     WHERE com_afiliacion = v_afiliacion;
    END IF;
    IF(v_amexmv='1' AND NVL(v_amexcanc,'X')='D') THEN
     UPDATE TBL_BDU_COMERCIO_AX
     SET com_estatus = 1,
       com_mov_ax='D'
     WHERE com_afiliacion = v_afiliacion;
    END IF;
   END IF;  
  -- Terminacion: P-20-0115-16
<<FIN>>
  -- Inicio: P-20-5082-17
    IF v_error = 'LONG' THEN
      v_estat := 'R';
      v_error := SUBSTR(v_linea,1,2)||'000000000003000R'||
              RPAD('REGISTRO INVALIDO: '||SUBSTR(v_linea,1,25),50,' ')||
        '00000000000000000000';
   GOTO FIN2;
   END IF;
    -- Inicio: C-54-2621-15
    IF v_error = 'MOVBAD' THEN
      v_estat := 'R';
      v_error := SUBSTR(v_linea,1,2)||'000000000003000R'||
              RPAD('MOVIMIENTO INVALIDO: '||SUBSTR(v_linea,1,25),50,' ')||
        RPAD(v_id_elavon,10,'0')||v_himms;
   GOTO FIN2;
 END IF;
  -- Terminacion: P-20-5082-17
    -- Errores
    IF v_error IS NOT NULL  THEN
    v_estat := 'R';
      v_error := v_mov||LPAD(v_afiliacion,9,'0')||LPAD(v_banco,3,'0')||
   '000'||v_estat||RPAD(v_error,50,' ')||RPAD(v_id_elavon,10,'0')||v_himms;
   ELSIF v_error IS NULL AND v_moneda > 1 THEN
    -- OK
     v_estat := 'A';
     v_error := v_mov||LPAD(v_afiliacion,9,'0')||LPAD(v_banco,3,'0')||
  '000'||v_estat||RPAD('MOV GENERADO DOLARES',50,' ')||RPAD(v_id_elavon,10,'0')||v_himms;
    -- Modificacion: Inicio C-08-3094-12
    ELSIF (v_error IS NULL AND v_servicom = 1)
      OR(v_error IS NULL AND v_giro IN(6010,6011))  THEN
    -- Modificacion: Terminacion C-08-3094-12
    -- OK
     v_estat := 'S';
     v_error := v_mov||LPAD(v_afiliacion,9,'0')||LPAD(v_banco,3,'0')||
  '000'||'A'||RPAD('AUTORIZADA',50,' ')||RPAD(v_id_elavon,10,'0')||v_himms;
    ELSIF v_error IS NULL AND v_arbitro = 1 THEN
    -- OK
     v_estat := 'A';
     v_error := v_mov||LPAD(v_afiliacion,9,'0')||LPAD(v_banco,3,'0')||
  '000'||v_estat||RPAD('AUTORIZADA PROSA',50,' ')||RPAD(v_id_elavon,10,'0')||v_himms;
    -- Inicio: P-20-5082-17
    -- se elimina codigo
    -- Terminacion: P-20-5082-17
   ELSIF v_error IS NULL AND v_arbitro = 0 THEN
    -- OK
   v_estat := 'A';
     v_error := v_mov||LPAD(v_afiliacion,9,'0')||LPAD(v_banco,3,'0')||
  '000'||v_estat||RPAD('MOV GENERADO S/ENVIO ARBITRO',50,' ')||RPAD(v_id_elavon,10,'0')||v_himms;
   END IF;
    --

<<FIN2>>

   IF (v_moneda = 1 AND v_giro NOT IN(6010,6011)) THEN
    IF v_estat = 'A' AND v_servicom = 1 THEN
      v_estat := 'S';
    END IF;
    --
    INSERT INTO TBL_BDU_REP_ELAV(
      mov_cve, com_afiliacion, bco_cve,
      ter_id, estatus, motivo, motivo_compe,
      fecha, misc, v_id_elavon,
      v_tipo_reg, v_archivo, v_folio_tel,
      idhimms
      )
    VALUES(
      v_mov,   v_afiliacion, v_banco,
      v_ter_id,DECODE(v_estat,'S','A',v_estat), v_error,
      DECODE(v_estat,'A',v_error,'S',v_error, NULL),
      SYSDATE, DECODE(v_estat,'A','0','S','2','3'), v_id_elavon,
      'C', parch, NULL, v_himms
      );
   ELSE
    INSERT INTO TBL_BDU_REP_ELAV(
      mov_cve, com_afiliacion, bco_cve,
      ter_id, estatus, motivo, motivo_compe,
      fecha, misc, v_id_elavon,
      v_tipo_reg, v_archivo, v_folio_tel, idhimms
      )
    VALUES(
      v_mov,   v_afiliacion, v_banco,
      v_ter_id,v_estat, v_error,
      DECODE(v_estat,'A',v_error,'S',v_error,NULL),
      SYSDATE, DECODE(v_estat,'A','2','S','2','3'), v_id_elavon,
      'C', parch, NULL, v_himms
      );
    -- Terminacion: C-54-2621-15
 END IF;

  pout := v_error;

  --COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    v_linea := SUBSTR(SQLERRM,1,90);
  INSERT INTO TBL_BDU_BIT_SISTEMA(
    bit_fecha,
    bit_usuario,
    bit_movimiento,
    bit_banco
   )
  VALUES(
    SYSDATE,
    v_mov,
    v_linea,
    3
    );
   --
   --pout := 'REGISTRO INVALIDO';
END;

-- ------------------------------------------------------------------------
PROCEDURE procesa_terminales(plinea IN VARCHAR2, parch IN VARCHAR2, pout OUT VARCHAR2) IS
-- ------------------------------------------------------------------------

  CURSOR c_pro_oid(parch VARCHAR2, preg VARCHAR2) IS
    SELECT/*+ FIRST_ROWS*/ v_p_oid
    FROM TBL_BDU_OFF_COM
  WHERE v_archivo = parch
    AND  v_registro = preg
  AND v_p_oid IN(SELECT/*+ FIRST_ROWS */ oid FROM TBL_BDU_PROPUESTAS_COM);

  v_linea      VARCHAR2(300);
  v_dummy      VARCHAR2(80);
  -- Inicio: C-54-2621-15
  v_error      VARCHAR2(150):=NULL;
  -- Terminacion: C-54-2621-15
  v_mov        VARCHAR2(2);
  v_afiliacion VARCHAR2(9);
  v_banco      VARCHAR2(3);
  v_banco_id   NUMBER(15);
  v_ter_id     VARCHAR2(3);
  v_lim_cash   VARCHAR2(7);
  v_lim_dev    VARCHAR2(7);
  v_lim_vta    VARCHAR2(9);
  v_ubica      VARCHAR2(25);
  v_modelo     VARCHAR2(2);
  v_apl        VARCHAR2(2);
  v_plan       VARCHAR2(1);
  v_vta_forz   VARCHAR2(1);
  v_oper       VARCHAR2(1);
  v_prep       VARCHAR2(1);
  v_post       VARCHAR2(1);
  v_dev        VARCHAR2(1);
  v_inst       VARCHAR2(2);
  v_carrier    VARCHAR2(2);
  v_protocol   VARCHAR2(2);
  v_min        VARCHAR2(16);
  v_usuario    VARCHAR2(8);
  v_registro   VARCHAR2(3);
  v_com        VARCHAR2(3);
  v_obs        VARCHAR2(70);
  v_oid        NUMBER(15);
  v_bitacora   NUMBER(15);
  v_pro_id     NUMBER(15);
  v_estat      VARCHAR2(1);
  v_telecarga  NUMBER(15);
  v_arch_com   VARCHAR2(35);
  v_p_id       NUMBER(15);
  v_tcp_u    VARCHAR2(30);
  v_tcp_p    VARCHAR2(16);
  v_oid_ter    NUMBER(15);
  v_ok     NUMBER(15);
  v_servi      NUMBER(1);
  v_folio      NUMBER(10);
  v_bco_id     NUMBER(3);
  v_term_id    VARCHAR2(8);
  v_fol_tel    VARCHAR2(12);
  v_id_elavon   VARCHAR2(10);
  -- Inicio: C-54-2621-15
  v_himms VARCHAR2(16);
  -- Terminacion: C-54-2621-15

BEGIN

 v_linea := plinea;

      v_mov        := SUBSTR(v_linea, 1, 2);
      v_afiliacion := SUBSTR(v_linea, 3, 9);
      v_banco      := SUBSTR(v_linea, 12, 3);
      v_ter_id     := SUBSTR(v_linea, 15, 3);
      v_lim_cash   := SUBSTR(v_linea, 18, 7);
      v_lim_dev    := SUBSTR(v_linea, 25, 7);
      v_lim_vta    := SUBSTR(v_linea, 32, 9);
      v_ubica      := SUBSTR(v_linea, 41, 25);
      v_modelo     := SUBSTR(v_linea, 66, 2);
      v_apl        := SUBSTR(v_linea, 68, 2);
      v_plan       := SUBSTR(v_linea, 70, 1);
      v_vta_forz   := SUBSTR(v_linea, 71, 1);
      v_oper       := SUBSTR(v_linea, 72, 1);
      v_prep       := SUBSTR(v_linea, 73, 1);
      v_post       := SUBSTR(v_linea, 74, 1);
      v_dev        := SUBSTR(v_linea, 75, 1);
      v_inst       := SUBSTR(v_linea, 76, 2);
      v_carrier    := SUBSTR(v_linea, 78, 2);
      v_protocol   := SUBSTR(v_linea, 80, 2);
      v_min        := SUBSTR(v_linea, 82, 16);
      v_usuario    := SUBSTR(v_linea, 98, 8);
      v_registro   := SUBSTR(v_linea, 106, 3);
      v_com        := SUBSTR(v_linea, 109, 3);
      v_obs        := SUBSTR(v_linea, 112, 70);
      v_obs  := REPLACE(v_obs, CHR(10), ' ');

   v_id_elavon   := SUBSTR(v_linea, 174, 10);
  -- Inicio: C-54-2621-15
  v_himms       := SUBSTR(v_linea, 184, 16);
  -- Terminacion: C-54-2621-15

   -- archivo com
   v_arch_com := SUBSTR(parch, 1, 19)||'0'||SUBSTR(parch, 21, 14);
   --
   OPEN  c_pro_oid(v_arch_com, v_com);
   FETCH c_pro_oid INTO v_p_id;
   CLOSE c_pro_oid;
   --
   IF v_mov = 'AL' AND TO_NUMBER(RTRIM(v_afiliacion)) = 0 THEN
     IF v_p_id IS NULL THEN
       v_error:= v_error||'SIN PROPUESTA COM. VERIFICAR CARGA DE ARCHIVO DE COMERCIOS ';
     -- Inicio: P-02-0091-13
     ELSIF TO_NUMBER(RTRIM(v_afiliacion)) = 0 THEN
       v_error:= v_error||'AFILIACION INVALIDA ';
     END IF;
     GOTO FIN;
     -- Terminacion: P-02-0091-13
   END IF;
  v_ubica := RTRIM(v_ubica);
  IF v_ubica IS NULL THEN
    v_ubica := 'EN LA CAJA';
  END IF;

    INSERT INTO TBL_BDU_TER_ELAV(
      v_mov, v_afiliacion, v_banco,
      v_ter_id, v_lim_cash, v_lim_dev,
      v_lim_vta, v_ubica, v_modelo,
      v_apl, v_plan, v_vta_forz,
      v_oper, v_prep, v_post,
      v_dev, v_inst, v_carrier,
      v_protocol, v_min, v_usuario,
      v_registro, v_com, v_obs,
      v_fecha, v_archivo, v_p_oid,
      v_id_elavon,
    -- Inicio: C-54-2621-15
      idhimms
    -- Terminacion: C-54-2621-15
      )
    VALUES(
      v_mov      , v_afiliacion,
      v_banco    , v_ter_id  ,
      v_lim_cash , v_lim_dev  ,
      v_lim_vta  , v_ubica  ,
      v_modelo   , v_apl   ,
      v_plan     , v_vta_forz  ,
      v_oper     , v_prep      ,
      v_post     , v_dev   ,
      v_inst     , v_carrier   ,
      v_protocol , v_min   ,
      v_usuario  , v_registro  ,
      v_com      , v_obs   ,
      SYSDATE    , parch   ,
      v_p_id, v_id_elavon,
    -- Inicio: C-54-2621-15
      v_himms
    -- Terminacion: C-54-2621-15
      );

   -- Validar mov
   IF v_mov NOT IN ('AL','MO','BA','CA') THEN
     v_error:= v_error||'MOVIMIENTO ';
     GOTO FIN;
   END IF;
   --
   --IF v_mov = 'AL' AND TO_NUMBER(v_ter_id) > 0 THEN
   --  v_error:= 'ID CAJA DEBE SER CERO ';
   --END IF;
   -- Banco
   BEGIN
     SELECT/*+ FIRST_ROWS */ oid INTO v_banco_id
     FROM   TBL_BDU_BANCOS
     WHERE  oid = v_banco;
   EXCEPTION
     WHEN OTHERS THEN
       v_error := v_error||'BANCO ';
    GOTO FIN;
   END;
  --
  -- Afiliacion
  IF (v_mov != 'AL') OR (v_mov = 'AL' AND TO_NUMBER(v_afiliacion) > 0) THEN
      BEGIN
        SELECT/*+ FIRST_ROWS */ oid, com_servicomercio, com_bco_id
        INTO v_dummy, v_servi, v_bco_id
        FROM TBL_BDU_COMERCIOS
        WHERE com_afiliacion = v_afiliacion;
        --
        --IF v_servi > 0 THEN
        --  v_error:= v_error||'ALTA DE POS CON AFILIACION DE SERVICOMERCIO|';
        --  GOTO FIN;
        --END IF;
        --
        IF v_bco_id != TO_NUMBER(v_banco) THEN
          v_error:= v_error||'AFILIACION CON OTRO BANCO ';
          GOTO FIN;
        END IF;
        --
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'NO EXISTE AFILIACION ';
          GOTO FIN;
      END;
      --
  END IF;
  --
  IF (v_mov != 'AL') THEN
      BEGIN
        SELECT/*+ FIRST_ROWS */ oid INTO v_oid_ter
        FROM TBL_BDU_TERMINALES
        WHERE ter_comercio_id = v_afiliacion
         AND  ter_id = v_ter_id
         AND  ter_bco_id = v_banco_id;
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'NO EXISTE POS ';
    GOTO FIN;
      END;
      --
   END IF;

   IF v_mov != 'BA' THEN
     -- Modelo
     BEGIN
        SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
        FROM TBL_BDU_MODELOS
        WHERE oid = v_modelo;
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'MODELO ';
    GOTO FIN;
      END;
      --
  -- Inicio: P-02-0091-13
  IF (v_mov = 'AL') THEN
      BEGIN
        SELECT/*+ FIRST_ROWS */ oid INTO v_oid_ter
        FROM TBL_BDU_TERMINALES
        WHERE ter_comercio_id = v_afiliacion
         AND  ter_id = v_ter_id
         AND  ter_bco_id = v_banco_id;
        --
        v_error:= v_error||'YA EXISTE POS CON EL MISMO ID';
        GOTO FIN;
      EXCEPTION
        WHEN no_data_found THEN
          NULL;
      END;
      --
   END IF;
   -- Terminacion: P-02-0091-13
      -- Aplic
      BEGIN
        SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
        FROM TBL_BDU_APLICACIONES_TER
        WHERE oid = v_apl;
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'APLICACION ';
    GOTO FIN;
      END;
      --
      -- Plan
      BEGIN
        SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
        FROM TBL_BDU_PLANES_ACEPTACION
        WHERE oid = v_plan;
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'PLAN ';
    GOTO FIN;
      END;
      --
      IF (NVL(v_carrier,'00') = '00' AND NVL(v_protocol,'00') > '00')
       OR(NVL(v_carrier,'00') > '00' AND NVL(v_protocol,'00') = '00') THEN
       --
       v_error:= v_error||'CARRIER PROTOCOLO ';
      GOTO FIN;
       --
      END IF;
      --
      IF (v_carrier > 0 OR v_protocol > 0) THEN
        --
        -- Carrier
        BEGIN
          SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
          FROM TBL_BDU_CARRIERS_PROTOCOLOS
          WHERE oid = TO_NUMBER(v_carrier)||TO_NUMBER(v_protocol);
          --
    SELECT/*+ FIRST_ROWS */ usuario, PASSWORD
    INTO v_tcp_u, v_tcp_p
          FROM TBL_BDU_USUARIOS_TCP
          WHERE carrier_id = TO_NUMBER(v_carrier);
        EXCEPTION
          WHEN OTHERS THEN
            v_error:= v_error||'CARRIER PROT ';
      GOTO FIN;
        END;
      END IF;
      --
      IF v_carrier = '00' THEN v_carrier := NULL; END IF;
      IF v_protocol = '00' THEN v_protocol:= NULL; END IF;
      --
      SELECT BDUSEQ047.NEXTVAL INTO v_oid FROM DUAL;
      SELECT BDUSEQ525.NEXTVAL INTO v_bitacora FROM DUAL;

      IF v_vta_forz NOT IN (0,1, NULL) THEN
        v_error:= v_error||'VTA FORZADA '; GOTO FIN;
      END IF;
      --
      IF v_oper NOT IN ('Y', 'M', NULL) THEN
        v_error:= v_error||'OPERATIVA '; GOTO FIN;
      END IF;
      --
      IF v_post NOT IN (0,1,NULL) THEN
        v_error:= v_error||'POSTPROPINA '; GOTO FIN;
      END IF;
      --
      IF v_prep NOT IN (0,1,NULL) THEN
        v_error:= v_error||'PREPROPINA '; GOTO FIN;
      END IF;

 END IF;


 IF v_error IS NULL THEN

    IF v_mov = 'MO' THEN
   BEGIN
        UPDATE TBL_BDU_TERMINALES
       SET ter_modelo_id   = NVL(RTRIM(v_modelo),ter_modelo_id),
         ter_aplicacion_id = NVL(RTRIM(v_apl),ter_aplicacion_id),
      ter_limite_venta = NVL(v_lim_vta/100,ter_limite_venta),
      ter_limite_devolucion = NVL(v_lim_dev/100,ter_limite_devolucion),
      ter_limite_cashback = NVL(v_lim_cash/100,ter_limite_cashback),
         ter_instalador_id = NVL(RTRIM(v_inst),ter_instalador_id),
      ter_plan_id = NVL(RTRIM(v_plan),ter_plan_id)
       WHERE ter_comercio_id = v_afiliacion
        AND ter_bco_id = v_banco_id
        AND ter_id = v_ter_id;
   EXCEPTION
        WHEN OTHERS THEN
          v_error := 'PARAMETROS PARA MODIFICACION INCORRECTOS ';
   END;
 END IF;

  -- Alta
  IF v_mov = 'AL' THEN
  -- Inicio: P-02-0091-13
    IF ((v_ter_id IS NULL) OR (TO_NUMBER(v_ter_id) = 0))THEN
      BEGIN
        SELECT/*+ FIRST_ROWS */ LPAD((NVL(MAX(ter_id), 0) + 1), 3, '0')
        INTO   v_ter_id
        FROM   TBL_BDU_TERMINALES
        WHERE  ter_comercio_id = v_afiliacion;
      EXCEPTION
        WHEN OTHERS THEN NULL;
      END;
    END IF;
  -- Terminacion: P-02-0091-13

      IF TO_NUMBER(v_afiliacion) = 0 THEN

        BEGIN
          INSERT INTO TBL_BDU_PROPUESTAS_TER (
            pro_ter_fecha_recarga,  pro_ter_fecha_telecarga,
            pro_ter_noreplica,      pro_ter_num_telecarga_dias, pro_ter_pos_tel_rec,
            pro_ter_baja_logica,    pro_ter_fecha_instalacion,
            pro_ter_host_flag,      pro_ter_id,           pro_ter_limite_cashback,
            pro_ter_limite_devolucion, pro_ter_limite_venta,    pro_ter_serie,
            pro_ter_srv_telecarga_flag, pro_ter_tipo,        pro_ter_ubicacion,
            pro_ter_version_b24,    pro_ter_term_grp,        tran_refresh_online,
            pro_ter_devolucion_id,  oid,
            pro_ter_aplicacion_id,  pro_ter_instalador_id,      pro_ter_plan_id,
            pro_ter_propuesta_id,   pro_ter_modelo_id,       pro_ter_cargo_th_id,
            pro_ter_fecha_alta,     pro_ter_fecha_mod,        pro_ter_ult_mov,
            pro_ter_folio_odt,      pro_ter_bco_id,
            pro_ter_horario_ini,    pro_ter_horario_fin,        ter_tcp_usuario,
            ter_tcp_pass,        ter_tcp_min,          ter_tcp_carrier_pro_id,
            bdu_usuario,         id_bitacora
            )
          VALUES(
            SYSDATE+30,   SYSDATE,
            0,      30,           '52581266',
            0,      SYSDATE,
            0,      v_ter_id,     v_lim_cash/100,
            v_lim_dev/100,v_lim_vta/100,    NULL,
            0,      'C',          v_ubica,
            1,      NULL,         0,
            v_dev,        v_oid,
            v_apl,     v_inst,       v_plan,
            v_p_id,    v_modelo,     NULL,
            SYSDATE,     SYSDATE,      1,
            NULL,        v_banco_id,
            NULL,        NULL,        v_tcp_u,
            v_tcp_p,     NULL,        TO_NUMBER(v_carrier)||TO_NUMBER(v_protocol),
            v_usuario,    NULL
            );
          --
          UPDATE TBL_BDU_PROPUESTAS_COM
          SET com_obs_adquiriente = SUBSTR((com_obs_adquiriente||v_obs),1,250)
          WHERE oid = v_p_id;
      -- app
          IF v_vta_forz = 1 THEN
           BEGIN
             INSERT INTO TBL_BDU_ASIGNACION_SER_PRO_TER(
               pro_terminal_id, pro_servicio_id, oid, bdu_usuario, id_bitacora)
             VALUES(v_oid, 1, BDUSEQ033.NEXTVAL, 'ACT',v_bitacora);
           EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN NULL;
           END;
          END IF;
         --
         IF v_oper = 'M' THEN
           BEGIN
             INSERT INTO TBL_BDU_ASIGNACION_SER_PRO_TER(
               pro_terminal_id, pro_servicio_id, oid, bdu_usuario, id_bitacora)
             VALUES(v_oid, 2, BDUSEQ033.NEXTVAL, 'ACT',v_bitacora);
           EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN NULL;
           END;
         END IF;
         --
         IF v_post = 1 THEN
           BEGIN
             INSERT INTO TBL_BDU_ASIGNACION_SER_PRO_TER(
               pro_terminal_id, pro_servicio_id, oid, bdu_usuario, id_bitacora)
             VALUES(v_oid, 3, BDUSEQ033.NEXTVAL, 'ACT',v_bitacora);
           EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN NULL;
           END;
         END IF;
         --
         IF v_prep = 1 THEN
           BEGIN
             INSERT INTO TBL_BDU_ASIGNACION_SER_PRO_TER(
               pro_terminal_id, pro_servicio_id, oid, bdu_usuario, id_bitacora)
             VALUES(v_oid, 4, BDUSEQ033.NEXTVAL, 'ACT',v_bitacora);
           EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN NULL;
           END;
         END IF;
   --
         FOR Y IN(
           SELECT car_card_type_id
           FROM TBL_BDU_CARD_TYPES_BCO
           WHERE car_bco_id = v_banco_id
           )
           LOOP
         INSERT INTO TBL_BDU_CARD_TYPES_PRO_TER (
           pro_card_type_id, pro_propuesta_ter_id, oid,
          bdu_usuario, id_bitacora
          )
         VALUES(
           y.car_card_type_id, v_oid, BDUSEQ526.NEXTVAL,
           v_usuario, v_bitacora
          );
       END LOOP;
       --
        EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN
            v_error := 'TERMINAL YA EXISTE ';
          WHEN OTHERS THEN
            v_error := 'ERROR '||v_error;
         errbuf:= SUBSTRB(SQLERRM, 1, 250);
         INSERT INTO TBL_BDU_ERR_INT_TER(
              fecha, afiliacion, error
     )
            VALUES(SYSDATE , v_p_id, errbuf);
        END;

      ELSE
        BEGIN
  -- Inicio: P-02-0091-13
         -- IF ((v_ter_id IS NOT NULL) OR (TO_NUMBER(v_ter_id) > 0))THEN
         --   BEGIN
         --     SELECT /*+ FIRST_ROWS */ LPAD((NVL(MAX(ter_id), 0) + 1), 3, '0')
         --     INTO   v_ter_id
         --     FROM   TBL_BDU_TERMINALES
         --     WHERE  ter_comercio_id = v_afiliacion;
         --   EXCEPTION
         --     WHEN OTHERS THEN NULL;
         --   END;
         -- END IF;
  -- Terminacion P-02-0091-13
         -- Modificacion: Inicio C-08-3094-12
         -- Se elimina codigo
         -- Modificacion: Terminacion C-08-3094-12
          INSERT INTO TBL_BDU_TERMINALES (
           ter_comercio_id,
            ter_fecha_recarga,  ter_fecha_telecarga,
            ter_noreplica,      ter_num_telecarga_dias, ter_pos_tel_rec,
            ter_baja_logica,    ter_fecha_instalacion,
            ter_host_flag,      ter_id,           ter_limite_cashback,
            ter_limite_devolucion, ter_limite_venta,    ter_serie,
            ter_srv_telecarga_flag, ter_tipo,        ter_ubicacion,
            ter_version_b24,    ter_term_grp,        tran_refresh_online,
            ter_devolucion_id,  oid,
            ter_aplicacion_id,  ter_instalador_id,      ter_plan_id,
            ter_modelo_id,      ter_cargo_th_id,
            ter_fecha_alta,     ter_fecha_mod,        ter_ult_mov,
            ter_folio_odt,      ter_bco_id,
            ter_horario_ini,    ter_horario_fin,        ter_tcp_usuario,
            ter_tcp_pass,       ter_tcp_min,            ter_tcp_carrier_pro_id,
            bdu_usuario,        id_bitacora,
            ter_folio_telecarga
            )
          VALUES(
           v_afiliacion,
            SYSDATE+30,   SYSDATE,
            0,      30,           '52581266',
            0,      SYSDATE,
            0,      v_ter_id,     v_lim_cash/100,
            v_lim_dev/100,v_lim_vta/100,NULL,
            0,      'C',         v_ubica,
            1,      NULL,         0,
            v_dev,        BDUSEQ003.NEXTVAL,
            v_apl,     v_inst,       v_plan,
            v_modelo,     NULL,
            SYSDATE,     SYSDATE,      1,
            NULL,       v_banco_id,
            NULL,        NULL,        v_tcp_u,
            v_tcp_p,     NULL,        TO_NUMBER(v_carrier)||TO_NUMBER(v_protocol),
            v_usuario,    v_bitacora, v_telecarga
            );
         --
            FOR Y IN (
            SELECT car_card_type_id
            FROM TBL_BDU_CARD_TYPES_BCO
            WHERE car_bco_id = v_banco_id
            )
            LOOP
              INSERT INTO TBL_BDU_CARD_TYPES_TER(
                car_card_type_id,
                car_ter_id,
                oid,
                id_bitacora
                )
              VALUES(
                y.car_card_type_id,
                BDUSEQ003.CURRVAL,
                BDUSEQ010.NEXTVAL,
                v_bitacora
                );
            END LOOP;
    --
    -- app
          IF v_vta_forz = 1 THEN
           BEGIN
             INSERT INTO TBL_BDU_ASIGNACION_SER_TER(
               ser_terminal_id, ser_servicio_id, oid, bdu_usuario, id_bitacora)
             VALUES(BDUSEQ003.CURRVAL, 1, BDUSEQ009.NEXTVAL, 'ACT',v_bitacora);
           EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN NULL;
           END;
          END IF;
         --
         IF v_oper = 'M' THEN
           BEGIN
             INSERT INTO TBL_BDU_ASIGNACION_SER_TER(
               ser_terminal_id, ser_servicio_id, oid, bdu_usuario, id_bitacora)
             VALUES(BDUSEQ003.CURRVAL, 2, bduseq009.NEXTVAL, 'ACT',v_bitacora);
           EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN NULL;
           END;
         END IF;
         --
         IF v_post = 1 THEN
           BEGIN
             INSERT INTO TBL_BDU_ASIGNACION_SER_TER(
               ser_terminal_id, ser_servicio_id, oid, bdu_usuario, id_bitacora)
             VALUES(BDUSEQ003.CURRVAL, 3, bduseq009.NEXTVAL, 'ACT',v_bitacora);
           EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN NULL;
           END;
         END IF;
         --
         IF v_prep = 1 THEN
           BEGIN
             INSERT INTO TBL_BDU_ASIGNACION_SER_TER(
               ser_terminal_id, ser_servicio_id, oid, bdu_usuario, id_bitacora)
             VALUES(BDUSEQ003.CURRVAL, 4, bduseq009.NEXTVAL, 'ACT',v_bitacora);
           EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN NULL;
           END;
         END IF;
         --

        EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN
            v_error := 'TERMINAL YA EXISTE ';
          WHEN OTHERS THEN
            v_error := 'ERROR '||v_error;
          errbuf:= SUBSTRB(SQLERRM, 1, 250);
          INSERT INTO TBL_BDU_ERR_INT_TER(
           fecha, afiliacion, error
           )
          VALUES(
           SYSDATE , v_afiliacion, errbuf
         );
        END;

      END IF;
   END IF;
    COMMIT;

    IF v_error IS NULL THEN
      BEGIN
        SELECT /*+ FIRST_ROWS */ ter_folio_telecarga
        INTO v_folio
        FROM TBL_BDU_TERMINALES
        WHERE ter_comercio_id = v_afiliacion
         AND ter_id = v_ter_id
         AND ter_bco_id = v_banco_id;
      EXCEPTION
        WHEN OTHERS THEN NULL;
      END;
    END IF;
 --
 -- svc
 -- Modificacion: Inicio C-08-3094-12
BEGIN
   SELECT v_folio_tel INTO v_telecarga
   FROM TBL_BDU_REP_ELAV
   WHERE v_archivo = parch
    AND estatus = 'A'
    AND v_tipo_reg = 'T'
    AND v_folio_tel IN(SELECT com_folio_telecarga
                        FROM TBL_BDU_SERVICOMERCIOS
                        WHERE com_comercio_id = v_afiliacion
                         AND com_caja_id = v_ter_id)
    AND NVL(v_folio_tel,0) > 0
    AND ROWNUM < 2;
 -- Modificacion: Terminacion C-08-3094-12
   v_folio := v_telecarga;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     BEGIN
       FOR x IN(
         SELECT com_folio_telecarga
         FROM TBL_BDU_SERVICOMERCIOS
         WHERE com_comercio_id = v_afiliacion
          AND com_caja_id = v_ter_id
          AND ROWNUM < 2
         )
       LOOP
         BEGIN
           UPDATE TBL_BDU_SERVICOMERCIOS
           SET com_folio_telecarga = v_folio
           WHERE com_folio_telecarga = x.com_folio_telecarga;
         EXCEPTION
           WHEN OTHERS THEN NULL;
         END;
       END LOOP;
     END;
 END;
 --

   -- Baja ----------------------------------------------
  IF v_mov = 'BA' THEN
      IF TO_NUMBER(v_afiliacion) > 0 THEN
        BEGIN
    DELETE TBL_BDU_TERMINALES
    WHERE oid = v_oid_ter;
  EXCEPTION
   WHEN OTHERS THEN
     v_error:= v_error||'ERROR EN LA BAJA DE TERMINAL. CONTACTE AL ADMIN';
  END;
   END IF;
  END IF;

   END IF;

   <<FIN>>
    -- Inicio: C-54-2621-15
    IF v_error IS NOT NULL  THEN
      v_error := v_mov||LPAD(v_afiliacion,9,'0')||LPAD(NVL(v_banco,'0'),3,'0')||
   LPAD(v_ter_id,3,'0')||'R'||RPAD(v_error,50,' ')||LPAD(NVL(v_ter_id,'0'),8,'0')||
   LPAD(NVL(v_folio,'0'),12,'0')||LPAD(v_id_elavon,10,'0')||v_himms;
    ELSIF v_error IS NULL AND v_mov = 'BA' THEN
    -- OK
      v_error := v_mov||LPAD(v_afiliacion,9,'0')||LPAD(NVL(v_banco,'0'),3,'0')||
   LPAD(v_ter_id,3,'0')||'A'||RPAD('TERMINAL ELIMINADA',50,' ')||
   LPAD(NVL(v_ter_id,'0'),8,'0')||LPAD(NVL(v_folio,'0'),12,'0')||
   LPAD(v_id_elavon,10,'0')||v_himms;
    ELSIF v_error IS NULL AND v_mov = 'MO' THEN
    -- OK
      v_error := v_mov||LPAD(v_afiliacion,9,'0')||LPAD(NVL(v_banco,'0'),3,'0')||
   LPAD(v_ter_id,3,'0')||'A'||RPAD('TERMINAL MODIFICADA',50,' ')||
   LPAD(NVL(v_ter_id,'0'),8,'0')||LPAD(NVL(v_folio,'0'),12,'0')||
   LPAD(v_id_elavon,10,'0')||v_himms;
    ELSIF v_error IS NULL THEN
    -- OK
      v_error := v_mov||LPAD(v_afiliacion,9,'0')||LPAD(NVL(v_banco,'0'),3,'0')||
   LPAD(v_ter_id,3,'0')||'A'||RPAD('TERMINAL GENERADA',50,' ')||
   LPAD(NVL(v_ter_id,'0'),8,'0')||LPAD(NVL(v_folio,'0'),12,'0')||
   LPAD(v_id_elavon,10,'0')||v_himms;
    ELSIF v_error IS NULL AND v_pro_id = 0 THEN
      -- OK
      v_error := v_mov||LPAD(v_afiliacion,9,'0')||LPAD(NVL(v_banco,'0'),3,'0')||
   LPAD(v_ter_id,3,'0')||'A'||RPAD('TERMINAL GENERADA',50,' ')||
   LPAD(NVL(v_ter_id,'0'),8,'0')||LPAD(NVL(v_folio,'0'),12,'0')||
   LPAD(v_id_elavon,10,'0')||v_himms;
    END IF;
    --
  v_estat := 'A';
  pout := v_error;

    INSERT INTO TBL_BDU_REP_ELAV(
      mov_cve, com_afiliacion, bco_cve,
      ter_id, estatus, motivo, motivo_compe,
      fecha, misc, v_id_elavon,
      v_tipo_reg, v_archivo, v_folio_tel, idhimms
   )
    VALUES(
   v_mov,   v_afiliacion, v_banco,
      v_ter_id,v_estat, v_error, NULL,
      SYSDATE, DECODE(v_estat,'A','0','3'), v_id_elavon,
      'T', parch, v_folio, v_himms
      );
    -- Terminacion: C-54-2621-15
   COMMIT;

END;

-- ------------------------------------------------------------------------
FUNCTION abrevia(plinea IN VARCHAR2, ptipo IN NUMBER) RETURN VARCHAR2 IS
-- ------------------------------------------------------------------------
  nombre VARCHAR2(40);

BEGIN

  nombre := plinea;

  FOR x IN(
    SELECT/*+ FIRST_ROWS */ abr_cve, abr_descripcion
    FROM TBL_BDU_ABREVIATURAS
    WHERE abr_campo_aplica = ptipo
 )
  LOOP
    --
    IF INSTR(nombre, x.abr_descripcion) > 0 THEN
      nombre := REPLACE(nombre, x.abr_descripcion, x.abr_cve);
    END IF;
  END LOOP;

  RETURN(nombre);

END;

-- --------------------------------------------------------------------------
PROCEDURE verifica_rfc(prfc IN VARCHAR2, pout OUT VARCHAR2) IS
-- --------------------------------------------------------------------------

  Boton           NUMBER;
  V_FechaRFC      VARCHAR2(6);
  V_Valida_Fecha  DATE;
  primero         VARCHAR2(1);
  segundo         VARCHAR2(1);
  Cuarto          VARCHAR2(1);
  tercero         VARCHAR2(1);
  Razon           VARCHAR2(40);
  Longitud        NUMBER;
  Fisica          EXCEPTION;
  Moral           EXCEPTION;
  Mayor_hoy       EXCEPTION;
  Menor_edad      EXCEPTION;
  No_Contenido    EXCEPTION;
  Con_eqe         EXCEPTION;
  Clave_error     NUMBER(9) := 0;
  --
  NoProcede    NUMBER;
  Source       VARCHAR2 ( 255 );
  Siglo        NUMBER;
  v_ok         NUMBER(1);

BEGIN

  IF SUBSTR (prfc, 5, 2 ) <= 17 THEN
     SIGLO := 20;
  ELSE
     SIGLO := 19;
  END IF;

  v_fecharfc := SUBSTR(prfc,5,6);
  v_valida_fecha := TO_DATE(siglo||v_fecharfc, 'YYYYMMDD');

   primero := LTRIM ( SUBSTR (prfc, 1, 1 ) );
   segundo := LTRIM ( SUBSTR (prfc, 2, 1 ) );
   tercero := LTRIM ( SUBSTR (prfc, 3, 1 ) );
   Cuarto  := LTRIM ( SUBSTR (prfc, 4, 1 ) );

   IF   ( primero NOT BETWEEN 'A' AND 'Z' ) AND ( primero != '&')
   THEN
     v_ok := 1;
   ELSIF ( segundo NOT BETWEEN 'A' AND 'Z' ) AND ( segundo != '&')
   THEN
     v_ok := 1;
   ELSIF  ( tercero NOT BETWEEN 'A' AND 'Z' ) AND ( tercero != '&')
   THEN
     v_ok := 1;
   END IF;

   IF ( Cuarto IS NOT NULL ) AND ( Cuarto NOT BETWEEN 'A' AND 'Z')
   AND( Cuarto != '&' )  THEN
     v_ok := 1;

   ELSIF Cuarto IS NULL THEN
      IF INSTR (prfc, 'Ñ') != 0 THEN
        v_ok := 1;
      END IF;

  ELSE

     -- A LA FECHA DEL RFC SE SUMAN 216 MESES QUE CORRESPODEN A 18 ANOS
      V_Valida_Fecha := ADD_MONTHS (V_Valida_Fecha,216);

      -- SI LA FECHA DEL RFC +  18 ANOS ES MAYOR A HOY ES MENOR DE EDAD
      -- Se elimina validacion menor edad

      IF INSTR (prfc,'Ñ') > 0 THEN
        v_ok := 1;
      END IF;

   END IF;

  IF v_ok = 1 THEN
    pout := '0';
  ELSE
    pout := '1';
  END IF;

EXCEPTION
  WHEN OTHERS THEN
     pout := '0';

END;

-- --------------------------------------------------------------------------
PROCEDURE servicomercio(pafil IN NUMBER, pafils IN NUMBER, pid IN VARCHAR2,
                        pmov IN NUMBER, puser IN VARCHAR2, pout OUT VARCHAR2) IS
-- --------------------------------------------------------------------------

  v_folio  NUMBER(10);
  v_ter_id VARCHAR2(10);

BEGIN

  IF pmov = 1 THEN
    IF pafil != pafils THEN
      IF pid = '1' THEN
        BEGIN
          SELECT/*+ FIRST_ROWS */LPAD((NVL(MAX(com_caja_id),0)+1),3,'0')
          INTO v_ter_id
          FROM TBL_BDU_SERVICOMERCIOS
          WHERE com_comercio_id = pafil;
        EXCEPTION
          WHEN OTHERS THEN NULL;
        END;
      END IF;
      --
      BEGIN
        SELECT com_folio_telecarga INTO v_folio
        FROM TBL_BDU_SERVICOMERCIOS
        WHERE com_comercio_id = pafil;
        --
       INSERT INTO TBL_BDU_SERVICOMERCIOS(
         com_comercio_id, com_folio_telecarga, com_caja_id,
         bdu_usuario, com_pais_id
         )
       VALUES(
         pafils, v_folio, v_ter_id,
         puser, 1
         );
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
         pout := 'AFILIACION PRIMARIA NO ESTA ASOCIADA';
      END;
    ELSE
       SELECT BDUSEQ050.NEXTVAL INTO v_folio FROM DUAL;
       --
      IF pid = '1' THEN
        BEGIN
          SELECT/*+ FIRST_ROWS */LPAD((NVL(MAX(com_caja_id),0)+1),3,'0')
          INTO v_ter_id
          FROM TBL_BDU_SERVICOMERCIOS
          WHERE com_comercio_id = pafil;
        EXCEPTION
          WHEN OTHERS THEN NULL;
        END;
      END IF;
      --
       INSERT INTO TBL_BDU_SERVICOMERCIOS(
         com_comercio_id, com_folio_telecarga, com_caja_id,
         bdu_usuario, com_pais_id
         )
       VALUES(
         pafils, v_folio, v_ter_id,
         puser, 1
         );
    END IF;
    --
  ELSIF pmov = 2 THEN
     NULL;
  ELSIF pmov = 3 THEN
      BEGIN
        SELECT/*+ FIRST_ROWS */LPAD((NVL(MAX(com_caja_id),0)+1),3,'0')
        INTO v_ter_id
        FROM TBL_BDU_SERVICOMERCIOS
        WHERE com_comercio_id = pafil;
        EXCEPTION
          WHEN OTHERS THEN NULL;
        END;
    --
    DELETE TBL_BDU_SERVICOMERCIOS
    WHERE com_comercio_id = pafil
     AND com_caja_id = v_ter_id;
  END IF;
  --

EXCEPTION
  WHEN OTHERS THEN
    pout := '1';

END;
-- Inicio: P-20-5116-17
PROCEDURE Send_Mail (pfecha IN VARCHAR2, ptipo IN NUMBER, pout OUT VARCHAR2) IS
  v_num NUMBER(2):=0;
  v_cta NUMBER(2):=0;
  v_ref  VARCHAR2(20);
  v_head VARCHAR2(2000);
  v_mensaje1  VARCHAR2(200):='CMD';

  c UTL_SMTP.CONNECTION;
  PROCEDURE send_header(name IN VARCHAR2, header IN VARCHAR2) AS
  BEGIN
    UTL_SMTP.WRITE_DATA(c, name || ': ' || header ||CHR(13) || CHR(10));
  END;

BEGIN
  -- tipo
  v_head := '------ INTENTO DE MODIFICACION DE COMERCIO -----';

  pout := v_mensaje1;

  FOR x IN(
    SELECT *
    FROM TBL_SNA_CORREO_BANCOS
    WHERE sna_causas LIKE 'ELV'
    )
  LOOP
    c := UTL_SMTP.OPEN_CONNECTION('proofpoint.prosa.com.mx');
    UTL_SMTP.HELO(c, 'prosa.com.mx');
    UTL_SMTP.MAIL(c, 'comercios@prosa.com.mx');
    UTL_SMTP.RCPT(c, x.sna_email);
    UTL_SMTP.OPEN_DATA(c);
    send_header('From',    '"comercios" <comercios@prosa.com.mx>');
    send_header('To',      x.sna_email);
    send_header('Subject', 'Modificacion de comercio');
    UTL_SMTP.WRITE_DATA(c, v_head||CHR(13)||CHR(10)||'La afiliacion: '||TO_CHAR(ptipo)||CHR(13)||CHR(10)||
    'Intento ser modificada por Santander.');
    UTL_SMTP.CLOSE_DATA(c);
    UTL_SMTP.QUIT(c);
  END LOOP;

END;
-- Terminacion: P-20-5116-17

END Pkg_Bdu_Cyt_Batch;