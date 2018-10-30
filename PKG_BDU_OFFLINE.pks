create or replace PACKAGE     Pkg_Bdu_offline IS
--/*###################################################################################
--# Nombre Del Programa : Pkg_Bdu_offline                                             #
--# Autor               : Hpg                                                         #
--# Compania            : DesisXXI                                                    #
--# Proyecto/procliente : P-08-524-03 Reingenieria Bdu        Fecha: 26/12/2006       #
--# Descripcion General : Procesamiento BDU batch.                                    #
--# Programa Dependiente: N/a                                                         #
--# Programa Subsecuente: N/a                                                         #
--# Cond. De Ejecucion  : N/a                                                         #
--# Dias De Ejecucion   : N/a                                 Horario: N/a            #
--#                              MODIFICACIONES                                       #
--#-----------------------------------------------------------------------------------#
--# Autor               : Joaquin Angel Mojica                                        #
--# Compania            : Wellcom SA de CV                                            #
--# Proyecto/procliente : N-08-2142-12                        Fecha: 10.07.20012      #
--# Descripcion General : Se agrega la columna COM_RSIM                               #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/Procliente : C-54-2253-14                        Fecha: 24/05/2014       #
--# Descripcion General : Mejoras masivos de comercios                                #
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

  -- Com
  PROCEDURE procesa_comercios (plinea IN VARCHAR2, parch IN VARCHAR2, pout OUT VARCHAR2);
  -- Terminales
  PROCEDURE procesa_terminales(plinea IN VARCHAR2, parch IN VARCHAR2, pout OUT VARCHAR2);
  -- Cadenas
  PROCEDURE procesa_cadenas   (plinea IN VARCHAR2, parch IN VARCHAR2, pout OUT VARCHAR2);

  FUNCTION abrevia(plinea IN VARCHAR2, ptipo IN NUMBER) RETURN VARCHAR2;
  -- Modificacion: Inicio C-54-2253-14
  PROCEDURE eliminar(pfecha IN VARCHAR2);
  -- Modificacion: Terminacion C-54-2253-14
  -- Inicio: P-20-0115-16 D110
  FUNCTION valida(plinea IN VARCHAR2, ptipo IN NUMBER) RETURN NUMBER;
  PROCEDURE valida_conv(plinea IN VARCHAR2, parch IN VARCHAR2, pout OUT VARCHAR2);
  -- Terminacion: P-20-0115-16 D110
END Pkg_Bdu_offline;
/

create or replace PACKAGE BODY     Pkg_Bdu_Offline AS
--/*###################################################################################
--# Nombre Del Programa : Pkg_Bdu_offline                                             #
--# Autor               : Hpg                                                         #
--# Compania            : DesisXXI                                                    #
--# Proyecto/procliente : Reingenieria Bdu                    Fecha: 26/12/2006       #
--# Descripcion General : Procesamiento BDU bach.                                     #
--# Programa Dependiente: N/a                                                         #
--# Programa Subsecuente: N/a                                                         #
--# Cond. De Ejecucion  : N/a                                                         #
--# Dias De Ejecucion   : N/a                                 Horario: N/a            #
--#                              MODIFICACIONES                                       #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : DesisXXI                                                    #
--# Proyecto/procliente : I-08-0696-08                        Fecha: 16/06/2008       #
--# Descripcion General : mejoras al aplicativo ACT                                   #
--#-----------------------------------------------------------------------------------#
--# Autor               : EPF                                                         #
--# Compania            : CSA                                                         #
--# Proyecto/procliente : R-02-0592-08                        Fecha: 25/07/2008       #
--# Descripcion General : cambios a los reportes de HSBC                              #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : DesisXXI                                                    #
--# Proyecto/Procliente : I-04-0315-09                        Fecha: 11/05/2008       #
--# Descripcion General : cambio a promociones para mejoras en procesos en ACT de Q6  #
--#-----------------------------------------------------------------------------------#
--# Autor               : ROM                                                         #
--# Compania            : CSA                                                         #
--# Proyecto/Procliente : I-04-0889-09                        Fecha: 12/08/2009       #
--# Descripcion General : Mejoras en procesos de ACT                                  #
--#-----------------------------------------------------------------------------------#
--# Autor               : ROM                                                         #
--# Compania            : CSA                                                         #
--# Proyecto/procliente : F-08-2028-10                        Fecha: 25/01/2010       #
--# Descripcion General : Aplicacion de mejoras en ACT                                #
--#-----------------------------------------------------------------------------------#
--# Autor               : ROM                                                         #
--# Compania            : CSA                                                         #
--# Proyecto/procliente : C-08-2087-10                        Fecha: 09/02/2010       #
--# Descripcion General : Modificaciones al alta masiva de comercio                   #
--#-----------------------------------------------------------------------------------#
--# autor               : HPG                                                         #
--# compania            : CSA                                                         #
--# proyecto/procliente : C-04-2439-10                         fecha: 14/07/2010      #
--# descripcion general : Se incorporan las interredes                                #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : CSA                                                         #
--# Proyecto/Procliente : C-04-2792-10                        Fecha: 14/01/2011       #
--# Descripcion General : Paquete de cambios ACT                                      #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : CSA                                                         #
--# Proyecto/Procliente : F-04-3017-11                        Fecha: 06/11/2011       #
--# Descripcion General : Se soluciona falla en transaccionalidad de comercios        #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/Procliente : P-02-0234-13                        Fecha: 05/08/2013       #
--# Descripcion General : Baja masiva de terminales Inbursa                           #
--#-----------------------------------------------------------------------------------#
--# Autor               : Joaquin Angel Mojica                                        #
--# Compania            : Wellcom SA de CV                                            #
--# Proyecto/procliente : N-08-2142-12                        Fecha: 10.07.20012      #
--# Descripcion General : Se agrega la columna COM_RSIM                               #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/Procliente : C-54-2253-14                        Fecha: 24/05/2014       #
--# Descripcion General : Mejoras masivos de comercios                                #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/Procliente : F-04-2280-13                        Fecha: 12/01/2014       #
--# Descripcion General : Modificacion a masivos                                      #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/Procliente : F-54-2267-14                         Fecha: 11/04/2014      #
--# Descripcion General : Correccion de fallas en ACT                                 #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/procliente : P-54-2008-15                        Fecha: 26/03/2015       #
--# Descripcion General : Limite servicomercios                                       #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/Procliente : N-51-2254-14                        Fecha: 21/04/2015       #
--# Descripcion General : Reglas devolucion TPV                                       #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/Procliente : P-20-0115-16                        Fecha: 10/09/2017       #
--# Descripcion General : Incorporación de American Express                           #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/Procliente : P-20-0115-16 D110                   Fecha: 11/07/2017       #
--# Descripcion General : Incorporación de American Express                           #
--#-----------------------------------------------------------------------------------#
--# Autor               : HPG                                                         #
--# Compania            : Teotl                                                       #
--# Proyecto/Procliente : P-20-0115-16 D122                   Fecha: 16/07/2017       #
--# Descripcion General : Incorporación de American Express                           #
--#-----------------------------------------------------------------------------------#
--# Numero De Parametros: N/a                                                         #
--# Parametros Entrada  : N/a                                     Formato: N/a        #
--# Parametros Salida   : N/a                                     Formato: N/a        #
--###################################################################################*/

  errbuf VARCHAR2(250);

-- ------------------------------------------------------------------------
PROCEDURE procesa_comercios (plinea IN VARCHAR2, parch IN VARCHAR2, pout OUT VARCHAR2) IS
-- ------------------------------------------------------------------------
-- Nombre:      Comercios
-- Descripcion: Comercios Offline
-- Autor:       Hpg
-- Compania:    Desisxxi
-- Fecha:       21.12.2006
-- Entrada:     Linea
-- Salida:      Estatus
-- -----------------------------------------------------------------------
  -- Inicio: P-20-0115-16
  v_linea   VARCHAR2(4000);
  -- Terminacion: P-20-0115-16  
  v_dummy   VARCHAR2(80);
  v_error   VARCHAR2(100);
  v_mov    VARCHAR2(2);
  v_mov_id   NUMBER(15);
  v_banco   VARCHAR2(3);
  v_banco_id  NUMBER(15);
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
  v_estado   VARCHAR2(2);
  v_estado_f  VARCHAR2(2);
  v_propietario  VARCHAR2(30);
  v_razon   VARCHAR2(30);
  v_responsable VARCHAR2(24);
  v_rfc      VARCHAR2(13);
  v_cod_cas    VARCHAR2(2);
  v_cadena    VARCHAR2(4);
  v_cadena_id   NUMBER(15);
  v_grupo    VARCHAR2(6);
  v_cat_cred   VARCHAR2(2);
  v_cat_deb    VARCHAR2(2);
  v_cve_cred   VARCHAR2(1);
  v_cve_deb    VARCHAR2(1);
  v_iva      VARCHAR2(1);
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
  -- Inicio: I-08-0696-08 DesisXXI-HPG
  v_criter_id  NUMBER(15);
  v_recont_id  NUMBER(15);
  -- Terminacion: I-08-0696-08 DesisXXI-HPG
  -- Inicio: R-02-0592-08 CSA-EPF
  v_vip        NUMBER(1);
  v_inst    NUMBER(1);
  -- Terminacion: R-02-0592-08 CSA-EPF
  -- Modificacion: Inicio       WELL-JMQ N-08-2142-12      
  v_com_rsim varchar2(30);
  -- Modificacion: Terminacion  WELL-JMQ N-08-2142-12  
  -- Inicio: F-04-2280-13
  v_gen NUMBER(1):=0;
  -- Terminacion: F-04-2280-13
  -- Inicio: P-20-0115-16
  v_amex    VARCHAR2(1400);
  v_amexmv  VARCHAR2(2);
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
  v_cadenaoka  NUMBER(1);
  v_cadenaokb  NUMBER(1);
  v_cadenaokc  NUMBER(1);
  v_cadenaokd  NUMBER(1);
  v_cadenaoke  NUMBER(1);
  v_cadenaokf  NUMBER(1);
  v_cadenaokg  NUMBER(1);
  v_cadenaokh  NUMBER(1);
  -- Terminacion: P-20-0115-16
  -- Inicio: P-20-0115-16 D122
  v_amexpn VARCHAR2(1);
  v_amex3  VARCHAR2(5);
  v_amex6  VARCHAR2(5);
  v_amex9  VARCHAR2(5);
  v_amex12  VARCHAR2(5);
  v_amex15  VARCHAR2(5);
  v_amex18  VARCHAR2(5);
  v_amex21  VARCHAR2(5);
  v_amex24  VARCHAR2(5);
  v_esax    NUMBER(1):=0;
  v_amextasa VARCHAR2(5);
  v_url     VARCHAR2(80);
  v_test NUMBER(2);
  -- Terminacion: P-20-0115-16 D122
BEGIN

 v_linea := plinea;

 --IF LENGTH(v_linea) < 509 THEN
 --  v_error := 'ERROR |REGISTRO NO CUMPLE CON LA LONGITUD';
 --END IF;

 SELECT BDUSEQ047.NEXTVAL INTO v_oid FROM DUAL;
 SELECT BDUSEQ525.NEXTVAL INTO v_bitacora FROM DUAL;

    v_mov           := SUBSTR(v_linea, 1, 2);
    v_banco       := SUBSTR(v_linea, 3, 3);
    v_afiliacion  := SUBSTR(v_linea, 6, 9);
    v_afiliante   := SUBSTR(v_linea, 15, 9);
    v_nombre      := SUBSTR(v_linea, 24, 22);
    v_domicilio   := SUBSTR(v_linea, 46, 32);
    v_domicilio_f := SUBSTR(v_linea, 78, 32);
    v_cp            := SUBSTR(v_linea, 110, 5);
    -- Inicio: I-08-0696-08 DesisXXI-HPG
    v_cp_f           := SUBSTR(v_linea, 115, 5);
    -- Terminacion: I-08-0696-08 DesisXXI-HPG
    v_colonia     := SUBSTR(v_linea, 120, 65);
    v_colonia_f   := SUBSTR(v_linea, 185, 65);
    v_pob           := SUBSTR(v_linea, 250, 5);
    v_pob_f       := SUBSTR(v_linea, 255, 5);
    v_estado      := SUBSTR(v_linea, 260, 2);
    v_estado_f    := SUBSTR(v_linea, 262, 2);
    v_propietario := SUBSTR(v_linea, 264, 30);
    v_razon       := SUBSTR(v_linea, 294, 30);
    v_responsable := SUBSTR(v_linea, 324, 24);
    v_rfc           := SUBSTR(v_linea, 348, 13);
    v_cod_cas     := SUBSTR(v_linea, 361, 2);
    v_cadena      := SUBSTR(v_linea, 363, 4);
    v_grupo       := SUBSTR(v_linea, 367, 6);
    v_cat_cred    := SUBSTR(v_linea, 373, 2);
    v_cat_deb     := SUBSTR(v_linea, 375, 2);
    v_cve_cred    := SUBSTR(v_linea, 377, 1);
    v_cve_deb     := SUBSTR(v_linea, 378, 1);
    v_iva           := SUBSTR(v_linea, 379, 1);
    v_lada           := SUBSTR(v_linea, 380, 3);
    v_lada_2      := SUBSTR(v_linea, 383, 3);
    v_lada_f      := SUBSTR(v_linea, 386, 3);
    v_tel           := SUBSTR(v_linea, 389, 8);
    v_tel_2       := SUBSTR(v_linea, 397, 8);
    v_tel_f       := SUBSTR(v_linea, 405, 8);
    v_valor_cred  := SUBSTR(v_linea, 413, 7);
    v_valor_deb   := SUBSTR(v_linea, 420, 7);
    v_valor_tarc  := SUBSTR(v_linea, 427, 5);
    v_chequera    := SUBSTR(v_linea, 432, 20);
    v_cuenta      := SUBSTR(v_linea, 452, 10);
    v_cecoban_pob := SUBSTR(v_linea, 462, 5);
    v_cecoban_bco := SUBSTR(v_linea, 467, 5);
    v_suc_cheques := SUBSTR(v_linea, 472, 4);
    v_criter_cad  := SUBSTR(v_linea, 476, 4);
    v_giro           := SUBSTR(v_linea, 480, 4);
    v_cve_recont  := SUBSTR(v_linea, 484, 2);
    v_sucursal    := SUBSTR(v_linea, 486, 4);
    v_asoc           := SUBSTR(v_linea, 490, 5);
    v_usuario     := SUBSTR(v_linea, 495, 8);
    v_placas      := SUBSTR(v_linea, 503, 2);
      v_prov_plac   := SUBSTR(v_linea, 505, 2);
    v_servicom    := SUBSTR(v_linea, 507, 1);
    v_arbitro     := SUBSTR(v_linea, 508, 1);
    v_registro    := SUBSTR(v_linea, 509, 3);
    v_email          := SUBSTR(v_linea, 512, 50);
    v_obs           := SUBSTR(v_linea, 562, 155);
  -- Inicio: I-08-0696-08 DesisXXI-HPG
    v_obs  := REPLACE(v_obs, CHR(10), ' ');
  -- Terminacion: I-08-0696-08 DesisXXI-HPG
  -- Inicio: R-02-0592-08 CSA-EPF
  IF TO_NUMBER(v_banco) = 21 THEN
    v_vip        := SUBSTR(v_linea, 717, 1);
    v_inst         := SUBSTR(v_linea, 718, 1);
  END IF;
  -- Terminacion: R-02-0592-08 CSA-EPF
  -- Modificacion: Inicio       WELL-JMQ N-08-2142-12      
    v_com_rsim := SUBSTR(v_linea, 719, 30);
  -- Inicio: F-54-2267-14
    v_chequera := SUBSTR(v_chequera,2,19);
    v_com_rsim := LTRIM(RTRIM(v_com_rsim));
  -- Terminacion: F-54-2267-14    
  -- Modificacion: Terminacion  WELL-JMQ N-08-2142-12  
  -- Inicio: P-20-0115-16
  v_amexmv  := LTRIM(RTRIM(SUBSTR(v_linea, 1371, 2)));
  v_amexnm  := LTRIM(RTRIM(SUBSTR(v_linea, 1045, 20)));
  v_amexdm  := LTRIM(RTRIM(SUBSTR(v_linea, 1123, 40)));
  v_amexcp  := LTRIM(RTRIM(SUBSTR(v_linea, 1203, 5)));
  v_amexcd  := LTRIM(RTRIM(SUBSTR(v_linea, 1163, 40)));
  v_amexap  := LTRIM(RTRIM(SUBSTR(v_linea, 1065, 20)));
  v_amexfn  := LTRIM(RTRIM(SUBSTR(v_linea, 1115, 8)));
  v_amexid  := LTRIM(RTRIM(SUBSTR(v_linea, 1085, 30)));
  v_amexnmd  := LTRIM(RTRIM(SUBSTR(v_linea, 1208, 20)));
  v_amexdmd  := LTRIM(RTRIM(SUBSTR(v_linea, 1286, 40)));
  v_amexcpd  := LTRIM(RTRIM(SUBSTR(v_linea, 1366, 5)));
  v_amexcdd  := LTRIM(RTRIM(SUBSTR(v_linea, 1326, 40)));
  v_amexapd  := LTRIM(RTRIM(SUBSTR(v_linea, 1228, 20)));
  v_amexfnd  := LTRIM(RTRIM(SUBSTR(v_linea, 1278, 8)));
  v_amexidd  := LTRIM(RTRIM(SUBSTR(v_linea, 1248, 30)));
  v_amextasa := LTRIM(RTRIM(SUBSTR(v_linea, 797, 5)));
  v_url      := LTRIM(RTRIM(SUBSTR(v_linea, 802, 80)));
  v_email    := LTRIM(RTRIM(v_email));
  -- Inicio: P-20-0115-16 D122
  --IF LENGTH(LTRIM(RTRIM(v_linea)))> 1374 THEN
  v_amexpn  := LTRIM(RTRIM(SUBSTR(v_linea, 1373, 1)));
  v_amex3   := LTRIM(RTRIM(SUBSTR(v_linea, 1374, 5)));
  v_amex6   := LTRIM(RTRIM(SUBSTR(v_linea, 1379, 5)));
  v_amex9   := LTRIM(RTRIM(SUBSTR(v_linea, 1384, 5)));
  v_amex12  := LTRIM(RTRIM(SUBSTR(v_linea, 1389, 5)));
  v_amex15  := LTRIM(RTRIM(SUBSTR(v_linea, 1394, 5)));
  v_amex18  := LTRIM(RTRIM(SUBSTR(v_linea, 1399, 5)));
  v_amex21  := LTRIM(RTRIM(SUBSTR(v_linea, 1404, 5)));
  v_amex24  := LTRIM(RTRIM(SUBSTR(v_linea, 1409, 5)));
  --END IF;
  --
  IF((v_amexmv IN('01','02','03','04','05')) OR (v_amexpn IN('0','1'))) THEN
    v_esax := 1;
  END IF;
  -- Terminacion: P-20-0115-16 D122
  IF(v_amexmv IN('01','05'))THEN
    BEGIN
       FOR x IN(
        SELECT *
        FROM TBL_BDU_EXCEPCION_AX
        WHERE banco = TO_NUMBER(v_banco)
        )
        LOOP
         IF(x.campo_1=1) THEN
          IF v_amexnm IS NULL THEN v_error:= v_error||'NOMBRE |'; END IF;
         END IF; 
         IF v_amexdm IS NULL THEN v_error:= v_error||'DOMICILIO |'; END IF;
         IF v_amexcp IS NULL THEN v_error:= v_error||'CP |'; END IF;
         IF(x.campo_2=1) THEN
         IF v_amexap IS NULL THEN v_error:= v_error||'APELLIDO |'; END IF; 
         END IF; 
         IF(x.campo_4=1) THEN
         IF v_amexfn IS NULL THEN v_error:= v_error||'FEC NAC |'; END IF; 
         END IF; 
         IF(x.campo_5=1) THEN
         IF v_amexcd IS NULL THEN v_error:= v_error||'CIUDAD |'; END IF; 
         END IF; 
         IF v_amexid IS NULL THEN v_error:= v_error||'IDENTIFICACION |'; END IF;
        END LOOP;  
         --
         IF(v_error IS NOT NULL) THEN
           v_error:= v_error||' AMEX REQUERIDO';
           GOTO FIN;   
         END IF;
    END;
    --
      v_cadenaoka:=PKG_BDU_OFFLINE.valida(NVL(v_amexnm,'A'),1);
      v_cadenaokb:=PKG_BDU_OFFLINE.valida(v_amexdm,1);
      v_cadenaokc:=PKG_BDU_OFFLINE.valida(v_amexcp,0);
      v_cadenaokd:=PKG_BDU_OFFLINE.valida(NVL(v_amexcd,'A'),1);
      v_cadenaoke:=PKG_BDU_OFFLINE.valida(NVL(v_amexap,'A'),1);
      v_cadenaokf:=PKG_BDU_OFFLINE.valida(NVL(v_amexfn,'1'),0);
      v_cadenaokg:=PKG_BDU_OFFLINE.valida(v_amexid,1);
      v_cadenaokh:=PKG_BDU_OFFLINE.valida(v_amextasa,0);
    --
    IF(v_cadenaoka=0 OR v_cadenaokb=0 OR v_cadenaokc=0 OR v_cadenaokd=0 OR v_cadenaoke=0
     OR v_cadenaokf=0 OR v_cadenaokg=0 OR v_cadenaokh=0)THEN
       v_error:= v_error||'DATOS AMEX CARACTERES INVALIDOS |';
       GOTO FIN;
    END IF;
    --
    IF(v_amexcp IS NOT NULL) THEN
      BEGIN
        SELECT 1 INTO v_test
        FROM TBL_BDU_CP
        WHERE cp_cve = v_amexcp
         AND ROWNUM<2;
      EXCEPTION
        WHEN no_data_found THEN
          v_error:= v_error||'CP RL1 AMEX INVALIDO |';
          GOTO FIN;
      END;    
    END IF;
    IF(v_amexcpd IS NOT NULL) THEN
      BEGIN
        SELECT 1 INTO v_test
        FROM TBL_BDU_CP
        WHERE cp_cve = v_amexcpd
         AND ROWNUM<2;
      EXCEPTION
        WHEN no_data_found THEN
          v_error:= v_error||'CP RL2 AMEX INVALIDO |';
          GOTO FIN;
      END;    
    END IF;
    -- 
    IF(v_email IS NOT NULL) THEN
      BEGIN
        SELECT 1 INTO v_test
        FROM dual
        WHERE regexp_like (v_email,'^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,3}$','i');
      EXCEPTION
        WHEN no_data_found THEN
          v_error:= v_error||'EMAIL INVALIDO |';
          GOTO FIN;
      END;    
    END IF;
    --IF(v_url IS NOT NULL) THEN
    --  BEGIN
    --    SELECT 1 INTO v_test
    --    FROM dual
    --    WHERE regexp_like (v_url,'^(?:http(s)?:\/\/)?(www)?.+\.[a-z]{2,6}(\.[a-z]{2,6})?.+\.[a-z]{2,4}(\/?)([a-z0-9./]{2,20}?)$');
        -- WHERE regexp_like (v_url,'^(www)?.+\.[a-z]{2,6}(\.[a-z]{2,6})?.+\.[a-z]{2,4}$');
    --  EXCEPTION
    --  WHEN no_data_found THEN
    --      v_error:= v_error||'URL INVALIDA |';
    --      GOTO FIN;
    --  END;    
    --END IF;       
  END IF;
  --
  -- Inicio: P-20-0115-16 
  IF( (v_mov ='MO') AND (v_amexmv != NULL) AND (v_amexmv NOT IN('01','02','03','04','05')) )
  -- Terminacion: P-20-0115-16  
   OR ( (v_mov IN('AL','CA','RA')) AND (v_amexmv != NULL) AND (v_amexmv !='01') )  THEN
    v_error:= v_error||'MOVIMIENTO AMEX INVALIDO |';
    GOTO FIN;  
  END IF;
  IF(v_amexmv ='01') THEN
    BEGIN
      SELECT com_afiliacion INTO v_dummy
      FROM TBL_BDU_COMERCIO_AX
      WHERE com_afiliacion = TO_NUMBER(v_afiliacion);
      --
      v_error:= v_error||'AFILIACION YA REGISTRADA EN AMEX |';
      GOTO FIN;      
    EXCEPTION
      WHEN no_data_found THEN NULL;
    END;  
    --
     BEGIN
      SELECT DISTINCT ind_fiid
      INTO v_dummy
      FROM TBL_BDU_INDUSTRIA_AX
      WHERE ind_fiid = TO_NUMBER(v_banco);
    EXCEPTION
      WHEN no_data_found THEN NULL;
        v_error:= v_error||'BANCO SIN OPERATIVA AMEX |';
        GOTO FIN;
    END;     
  END IF;
 -- Terminacion: P-20-0115-16
 -- Estado pro
    IF v_arbitro = '1' THEN
      v_estado_pro := 3; v_estado_arb := 0;
    ELSE v_estado_pro := 1; v_estado_arb := 1;
    END IF;
 --
 -- Mov
    BEGIN
      SELECT/*+ FIRST_ROWS */ oid INTO v_mov_id
      FROM TBL_BDU_MOVIMIENTOS_COM
      WHERE com_mov_clave = v_mov
       AND  com_pais_id = 1;
    EXCEPTION
      WHEN OTHERS THEN
        v_error:= v_error||'MOV |';
         v_estado_pro := 6;
    -- Modificacion: Inicio P-08-524-03 DesisXXI-HPG
        GOTO FIN;
    END;
      --
  -- Inicio: I-04-0315-09 DesisXXI
  -- Modificacion: Inicio CSA I-04-0889-09
 -- Inicio:      F-04-2280-13
       v_banco_id := TO_NUMBER(v_banco);
  -- Terminacion: F-04-2280-13
  IF v_mov = 'MO' THEN
    v_nombre      := LTRIM(v_nombre);
    v_domicilio   := RTRIM(v_domicilio);
    v_domicilio_f := RTRIM(v_domicilio_f);
    v_cp            := LTRIM(v_cp);
    v_cp_f           := LTRIM(v_cp_f);
    v_colonia     := RTRIM(v_colonia);
    v_colonia_f   := RTRIM(v_colonia_f);
    v_pob           := LTRIM(v_pob);
    v_pob_f       := LTRIM(v_pob_f);
    v_estado      := LTRIM(v_estado);
    v_estado_f    := LTRIM(v_estado_f);
    v_propietario := RTRIM(v_propietario);
    v_razon       := RTRIM(v_razon);
    v_responsable := RTRIM(v_responsable);
    v_rfc           := RTRIM(v_rfc);
    v_cod_cas     := LTRIM(v_cod_cas);
    v_cadena      := LTRIM(v_cadena);
    v_grupo       := LTRIM(v_grupo);
    v_cat_cred    := LTRIM(v_cat_cred);
    v_cat_deb     := LTRIM(v_cat_deb);
    v_cve_cred    := LTRIM(v_cve_cred);
    v_cve_deb     := LTRIM(v_cve_deb);
    v_iva           := LTRIM(v_iva);
    v_lada           := LTRIM(v_lada);
    v_lada_2      := LTRIM(v_lada_2);
    v_lada_f      := LTRIM(v_lada_f);
    v_tel           := LTRIM(v_tel);
    v_tel_2       := LTRIM(v_tel_2);
    v_tel_f       := LTRIM(v_tel_f);
    v_valor_cred  := LTRIM(v_valor_cred);
    v_valor_deb   := LTRIM(v_valor_deb);
    v_valor_tarc  := LTRIM(v_valor_tarc);
    v_chequera    := LTRIM(v_chequera);
    v_cuenta      := LTRIM(v_cuenta);
    v_cecoban_pob := LTRIM(v_cecoban_pob);
    v_cecoban_bco := LTRIM(v_cecoban_bco);
    v_suc_cheques := LTRIM(v_suc_cheques);
    v_criter_cad  := LTRIM(v_criter_cad);
    v_giro           := LTRIM(v_giro);
    v_cve_recont  := LTRIM(v_cve_recont);
    v_sucursal    := LTRIM(v_sucursal);
    v_asoc           := LTRIM(v_asoc);
    v_placas      := LTRIM(v_placas);
      v_prov_plac   := LTRIM(v_prov_plac);
    v_servicom    := LTRIM(v_servicom);
  -- Inicio:      F-04-2280-13
    v_arbitro     := LTRIM(v_arbitro);
  -- Terminacion: F-04-2280-13
    v_email          := RTRIM(v_email);
    v_obs           := RTRIM(v_obs);
    v_banco_id    := TO_NUMBER(v_banco);
   -- Inicio: F-04-2280-13
   IF((v_nombre IS NOT NULL) OR
     (v_domicilio IS NOT NULL) OR 
     (v_cp IS NOT NULL) OR
     (v_colonia IS NOT NULL) OR
     (v_rfc IS NOT NULL) OR
     (v_razon IS NOT NULL) OR
     (v_propietario IS NOT NULL) OR
     (v_tel IS NOT NULL) OR
     (v_lada IS NOT NULL) OR
     (v_cadena IS NOT NULL) OR
     (v_grupo IS NOT NULL)) THEN
    v_estado_pro := 1;
    v_arbitro := 1;
   ELSE
    v_estado_pro := 2;
    v_arbitro := 0;
    --
    BEGIN
      SELECT/*+ FIRST_ROWS */ bco_moneda_id INTO v_gen
      FROM TBL_BDU_BANCOS
      WHERE oid = TO_NUMBER(v_banco);
      --
      IF v_gen = 2 THEN
        v_estado_pro := 2;
        v_arbitro := 0;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        v_error := v_error||'BANCO |';
        v_estado_pro := 6;
    END;
   END IF;
   -- Terminacion: F-04-2280-13
  END IF;
  -- Modificacion: Terminacion CSA I-04-0889-09
  -- Fin: I-04-0315-09 DesisXXI
  -- Modificacion: Inicio C-04-2792-10 CSA
  -- usuario
  IF UPPER(SUBSTR(v_usuario,1,4)) != SUBSTR(parch,7,4) THEN
    v_error:= v_error||'USUARIO NO CORRESPONDE AL BANCO |';
    GOTO FIN;
  END IF;
  --
  IF (TO_NUMBER(v_valor_cred)/100)>100 OR (TO_NUMBER(v_valor_deb)/100)>100 THEN
    v_error:= v_error||'VALOR DESCUENTO CRE/DEB EXCEDE 100% |';
    GOTO FIN;
  END IF;
  -- Modificacion: Terminacion C-04-2792-10 CSA

      BEGIN
        SELECT/*+ FIRST_ROWS */ com_bco_id
        INTO v_banco_id
        FROM TBL_BDU_PROPUESTAS_COM
        WHERE com_afiliacion = v_afiliacion;
        --
        v_error:= v_error||'YA EXISTE PROPUESTA PARA LA AFILIACION |';
         v_estado_pro := 6;
        GOTO FIN;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
    -- Modificacion: Fin P-08-524-03 DesisXXI-HPG
 --
 -- Validar mov
 --
 -- Afiliacion
 IF v_mov NOT IN('AL','RE') THEN
      BEGIN
        SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
        FROM TBL_BDU_COMERCIOS
        WHERE com_afiliacion = v_afiliacion;
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'AFILIACION NO EXISTE|';
          v_estado_pro := 6;
    -- Modificacion: Inicio P-08-524-03 DesisXXI-HPG
          GOTO FIN;
    -- Modificacion: Terminacion P-08-524-03 DesisXXI-HPG
      END;
 END IF;
 --
 -- Inicio: N-51-2254-14 
 -- MO
  IF v_mov = 'MO' THEN
      BEGIN
        SELECT/*+ FIRST_ROWS */ com_bco_id, com_bloqueo_id
        INTO v_banco_id, v_cod_cas
        FROM TBL_BDU_COMERCIOS
        WHERE com_afiliacion = v_afiliacion;
        --
        IF v_banco_id != TO_NUMBER(v_banco) THEN
          v_error:= v_error||'AFILIACION CON OTRO BANCO |';
          GOTO FIN;
        END IF;
        --
        IF TO_NUMBER(NVL(v_cod_cas,0)) > 0 THEN
          v_error:= v_error||'AFILIACION CANCELADA |';
          GOTO FIN;
        END IF;
        --
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'AFILIACION NO EXISTE |';
          v_estado_pro := 6;
          GOTO FIN;
      END;
  END IF;
 -- Terminacion: N-51-2254-14 
 -- bloqueo
 IF v_mov = 'CA' THEN
 BEGIN
 SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
 FROM TBL_BDU_CODIGOS_BLOQUEO
 WHERE cas_cve = v_cod_cas;
 EXCEPTION
 WHEN OTHERS THEN
 v_error:= v_error||'CVE BLOQUEO |';
 v_estado_pro := 6;
 GOTO FIN;
 END;
 -- Modificacion: Inicio CSA I-04-0889-09
 IF v_cod_cas BETWEEN 1 AND 49 THEN
 v_error:= v_error||'CVE CANC ES DE FRAUDES|';
 GOTO FIN;
 END IF;
 -- Modificacion: Terminacion CSA I-04-0889-09
 --
 -- Verifica com
 -- Modificacion: Inicio P-08-524-03 DesisXXI-HPG
 --
 IF TO_NUMBER(NVL(v_cod_cas,'0')) = 0 THEN
 v_error:= v_error||'CVE BLOQUEO |';
 GOTO FIN;
 END IF;
 --
 BEGIN
 SELECT/*+ FIRST_ROWS */ com_bco_id, com_bloqueo_id
 INTO v_banco_id, v_cod_cas
 FROM TBL_BDU_COMERCIOS
 WHERE com_afiliacion = v_afiliacion;
 --
 IF v_banco_id != TO_NUMBER(v_banco) THEN
 v_error:= v_error||'AFILIACION CON OTRO BANCO |';
 GOTO FIN;
 END IF;
 --
 IF TO_NUMBER(NVL(v_cod_cas,0)) BETWEEN 1 AND 49 THEN
 v_error:= v_error||'AFILIACION CANC X FRAUDES |';
 GOTO FIN;
 END IF;
 --
 EXCEPTION
 WHEN OTHERS THEN
 v_error:= v_error||'AFILIACION NO EXISTE |';
 v_estado_pro := 6;
 GOTO FIN;
 END;
 --
 v_cod_cas := SUBSTR(v_linea, 361, 2);
 -- Modificacion: Fin P-08-524-03 DesisXXI-HPG
 END IF;
 --
 --
 -- Modificacion: Inicio CSA I-04-0889-09
 IF v_mov != 'CA' AND v_mov != 'MO' THEN
 -- Modificacion: Terminacion CSA I-04-0889-09
 --
 -- Banco
 BEGIN
 SELECT/*+ FIRST_ROWS */ oid INTO v_banco_id
 FROM TBL_BDU_BANCOS
 WHERE oid = v_banco;
 EXCEPTION
 WHEN OTHERS THEN
 v_error := v_error||'BANCO |';
 v_estado_pro := 6;
 END;
 --
 -- Afilianter
 IF v_mov = 'RE' THEN
 -- Inicio: I-08-0696-08 DesisXXI-HPG
 IF v_afiliante IS NULL OR v_afiliante = '000000000' THEN
 v_error:= v_error||'AFILIANTER |';
 v_estado_pro := 6;
 GOTO FIN;
 ELSE
 BEGIN
 SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
 FROM TBL_BDU_COMERCIOS
 WHERE com_afiliacion = v_afiliante;
 EXCEPTION
 WHEN OTHERS THEN
 v_error:= v_error||'AFILIANTER |';
 v_estado_pro := 6;
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
 v_error:= v_error||'CVE RECONTRATACION |';
 v_estado_pro := 6;
 GOTO FIN;
 END;
 -- Terminacion: I-08-0696-08 DesisXXI-HPG
 END IF;
 --
 -- Cadena
 -- Inicio: F-04-2280-13
 -- se elimina codigo
 -- Terminacion: F-04-2280-13 
     --
     -- Cred
     BEGIN
          SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
          FROM TBL_BDU_CATEGORIAS_CREDITO
          WHERE oid = v_cat_cred;
        EXCEPTION
          WHEN OTHERS THEN
            v_error:= v_error||'CATEG CRED |';
               v_estado_pro := 6;
        END;
     --
     BEGIN
          SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
          FROM TBL_BDU_TIPOS_PAGO_CREDITO
          WHERE oid = v_cve_cred;
        EXCEPTION
          WHEN OTHERS THEN
            v_error:= v_error||'CVE CRED |';
               v_estado_pro := 6;
        END;
     --
     -- Deb
     BEGIN
          SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
          FROM TBL_BDU_CATEGORIAS_DEBITO
          WHERE oid = v_cat_deb;
        EXCEPTION
          WHEN OTHERS THEN
            v_error:= v_error||'CATEG DEB |';
               v_estado_pro := 6;
        END;
     --
     BEGIN
          SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
          FROM TBL_BDU_TIPOS_PAGO_DEBITO
          WHERE oid = v_cve_deb;
        EXCEPTION
          WHEN OTHERS THEN
            v_error:= v_error||'CVE DEB |';
               v_estado_pro := 6;
        END;
     --
     -- Giro
 -- Inicio: F-04-2280-13
     -- Giro 
     --
     -- CP
     --
 -- se elimina codigo
 -- Terminacion: F-04-2280-13
     -- Tel
     -- Inicio: I-08-0696-08 DesisXXI-HPG
     IF LENGTH(TO_NUMBER(v_lada))+LENGTH(TO_NUMBER(v_tel)) != 10 THEN
       v_error:= v_error||'LADA |TEL |';
       v_estado_pro := 6;
     END IF;
     --
     IF v_lada_2 != '000' AND v_tel_2 != '00000000' THEN
       IF LENGTH(TO_NUMBER(v_lada_2))+LENGTH(TO_NUMBER(v_tel_2)) != 10 THEN
         v_error:= v_error||'LADA2 |TEL2 |';
         v_estado_pro := 6;
       END IF;
     END IF;
     --
     IF v_lada_f != '000' AND v_tel_f != '00000000' THEN
       IF LENGTH(TO_NUMBER(v_lada_f))+LENGTH(TO_NUMBER(v_tel_f)) != 10 THEN
         v_error:= v_error||'LADA |TEL FISCAL |';
         v_estado_pro := 6;
       END IF;
     END IF;
  END IF;
     -- Terminacion: I-08-0696-08 DesisXXI-HPG
     --
     -- CP
  -- Inicio: F-04-2280-13
  IF v_mov != 'CA' THEN
   IF v_cp IS NOT NULL THEN 
     BEGIN
          SELECT/*+ FIRST_ROWS */ oid INTO v_cp_id
          FROM TBL_BDU_CP
          WHERE cp_cve = v_cp
         AND cp_colonia = LTRIM(RTRIM(v_colonia));
        EXCEPTION WHEN OTHERS THEN
          BEGIN
            SELECT/*+ FIRST_ROWS */ oid INTO v_cp_id
            FROM TBL_BDU_CP
            WHERE cp_cve = v_cp
              AND ROWNUM = 1;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              SELECT/*+ FIRST_ROWS */ oid INTO v_cp_id
              FROM TBL_BDU_CP
              WHERE cp_cve = '00000';
          END;
     END;
    END IF;
     -- CP fisc
    IF v_cp_f IS NOT NULL THEN 
      BEGIN
          SELECT/*+ FIRST_ROWS */ oid INTO v_cpf_id
          FROM TBL_BDU_CP
          WHERE cp_cve = v_cp_f
         AND cp_colonia = LTRIM(RTRIM(v_colonia_f));
        EXCEPTION WHEN OTHERS THEN
          BEGIN
            SELECT/*+ FIRST_ROWS */ oid INTO v_cpf_id
            FROM TBL_BDU_CP
            WHERE cp_cve = v_cp_f
              AND ROWNUM = 1;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              SELECT/*+ FIRST_ROWS */ oid INTO v_cpf_id
              FROM TBL_BDU_CP
              WHERE cp_cve = '00000';
          END;
     END;
    END IF;
    -- Giro
    IF v_giro IS NOT NULL THEN
       BEGIN
          SELECT/*+ FIRST_ROWS */ oid INTO v_giro_id
          FROM TBL_BDU_GIROS
          WHERE gir_cve = v_giro
           AND  gir_pais_id = 1;
        EXCEPTION
          WHEN OTHERS THEN
            v_error:= v_error||'GIRO |';
               v_estado_pro := 6;
               GOTO FIN;
        END;
    END IF;
    -- Cad
    IF (TO_NUMBER(v_grupo)>0 OR TO_NUMBER(v_cadena)>0) THEN
         BEGIN
            SELECT/*+ FIRST_ROWS */ oid INTO v_cadena_id
            FROM TBL_BDU_CADENAS
            WHERE cad_cve = TO_NUMBER(v_cadena)
             AND  cad_grupo_id = TO_NUMBER(v_grupo);
          EXCEPTION
            WHEN OTHERS THEN
              v_error:= v_error||'CADENA |';
               v_estado_pro := 6;
          END;
          --
          IF v_cadena_id > 0 THEN
            BEGIN
              SELECT/*+ FIRST_ROWS */ oid INTO v_criter_id
              FROM TBL_BDU_CRITERIOS_ENCAD
              WHERE oid = TO_NUMBER(v_criter_cad);
            EXCEPTION
              WHEN OTHERS THEN
                v_error:= v_error||'CRIT ENCAD |';
                 v_estado_pro := 6;
            END;
          END IF;
    END IF;
   END IF;
     --
     -- Tel
     -- Inicio: I-08-0696-08 DesisXXI-HPG
    IF (v_tel IS NOT NULL OR v_lada IS NOT NULL) AND v_mov != 'CA' THEN
     IF LENGTH(TO_NUMBER(v_lada))+LENGTH(TO_NUMBER(v_tel)) != 10 THEN
       v_error:= v_error||'LADA |TEL |';
       v_estado_pro := 6;
     END IF;
    END IF;
     --
    IF (v_tel_2 IS NOT NULL OR v_lada_2 IS NOT NULL) AND v_mov != 'CA' THEN
     IF v_lada_2 != '000' AND v_tel_2 != '00000000' THEN
       IF LENGTH(TO_NUMBER(v_lada_2))+LENGTH(TO_NUMBER(v_tel_2)) != 10 THEN
         v_error:= v_error||'LADA2 |TEL2 |';
         v_estado_pro := 6;
       END IF;
     END IF;
    END IF;
     --
    IF (v_tel_f IS NOT NULL OR v_lada_f IS NOT NULL) AND v_mov != 'CA' THEN
     IF v_lada_f != '000' AND v_tel_f != '00000000' THEN
       IF LENGTH(TO_NUMBER(v_lada_f))+LENGTH(TO_NUMBER(v_tel_f)) != 10 THEN
         v_error:= v_error||'LADA |TEL FISCAL |';
         v_estado_pro := 6;
       END IF;
     END IF;
   END IF;
  -- Terminacion: F-04-2280-13
     -- Terminacion: I-08-0696-08 DesisXXI-HPG
    -- al Arbitro
    --v_arbitro = 0 AND
 IF v_error IS NULL THEN
 --
 -- Inicio: N-51-2254-14 
 -- se elimina codigo
 -- Terminacion: N-51-2254-14 
 --
 IF v_mov = 'AL' OR v_mov = 'MO' OR v_mov = 'RE' OR v_mov = 'RA' THEN
 --
 -- Modificacion: Inicio C-04-2792-10 CSA
 IF v_giro IN(6010,6011) THEN
 v_estado_arb := 1;
 ELSE
 v_estado_arb := 0;
 END IF;
 -- Modificacion: Terminacion C-04-2792-10 CSA
 -- Modificacion: Inicio CSA I-04-0889-09
 IF v_nombre IS NOT NULL THEN
 v_nombre := ACT.Pkg_Bdu_Offline.abrevia(v_nombre, 1);
 END IF;
 IF v_domicilio IS NOT NULL THEN
 v_domicilio := Pkg_Bdu_Offline.abrevia(v_domicilio,2);
 END IF;
 IF v_domicilio_f IS NOT NULL THEN
 v_domicilio_f:= Pkg_Bdu_Offline.abrevia(v_domicilio_f,2);
 END IF;
 -- Modificacion: Inicio F-04-3017-11 CSA
 IF v_razon IS NOT NULL THEN
 v_razon := Pkg_Bdu_Offline.abrevia(v_razon,3);
 END IF;
 --
 IF INSTR(v_razon,'.') > 0 OR INSTR(v_razon,',')> 0 OR
 INSTR(v_nombre,'.') > 0 OR INSTR(v_nombre,',')> 0 OR
 INSTR(v_domicilio,'.') > 0 OR INSTR(v_domicilio,',')> 0 OR
 INSTR(v_domicilio_f,'.') > 0 OR INSTR(v_domicilio_f,',')> 0
 THEN
 v_error:= v_error||'CARACTERES INVALIDOS |';
 GOTO FIN;
 END IF;
 --
 -- Inicio: F-04-2280-13
 IF v_mov IN('AL','RA','RE') THEN 
 IF (v_domicilio IS NULL) OR
 ((INSTR(v_domicilio,' NO ') = 0) AND (INSTR(v_domicilio,'SN') = 0) AND
 (INSTR(v_domicilio,' KM ') = 0) AND (INSTR(v_domicilio,'SKM') = 0)) THEN
 v_error:= 'DOMICILIO ';
 GOTO FIN;
 END IF;
 IF (v_domicilio_f IS NULL) OR
 ((INSTR(v_domicilio_f,' NO ') = 0) AND (INSTR(v_domicilio_f,'SN') = 0) AND
 (INSTR(v_domicilio_f,' KM ') = 0) AND (INSTR(v_domicilio_f,'SKM') = 0)) THEN
 v_error:= 'DOMICILIO FISCAL ';
 GOTO FIN;
 END IF;
 IF v_propietario IS NULL THEN
 v_error:= 'PROPIETARIO ';
 GOTO FIN;
 END IF;
 END IF;
 -- Terminacion: F-04-2280-13
 -- Modificacion: Terminacion F-04-3017-11 CSA
 IF v_rfc IS NOT NULL THEN
 Pkg_Bdu_Utilerias_Com.verifica_rfc (v_rfc, v_rfc_ok);
 END IF;
 -- Modificacion: Terminacion CSA I-04-0889-09
 --
 -- Modificacion: Inicio F-04-3017-11 CSA
 -- Inicio: F-04-2280-13
 IF v_rfc_ok = 0 THEN
 IF INSTR(v_rfc,'Ñ') > 0 THEN
 v_error:= v_error||'RFC |';
 v_estado_pro := 6;
 GOTO FIN;
 END IF;
 END IF;
 --
 -- Terminacion: F-04-2280-13
 -- Modificacion: Terminacion F-04-3017-11 CSA
 --
 END IF;
 --
 -- Inicio: P-20-0115-16 D110
  IF(v_amexmv='01')THEN
    -- Giro
    IF v_giro IS NOT NULL THEN
      BEGIN
        SELECT oid INTO v_giro_id
        FROM TBL_BDU_GIROS
        WHERE gir_cve = v_giro
         AND  gir_ax > 0;
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'GIRO NO PERMITIDO EN LA OPERATIVA AMEX |';
          v_estado_pro := 6;
          GOTO FIN;
       END;
    END IF;
    --
    IF v_mov = 'MO' THEN
      BEGIN
        SELECT g.oid INTO v_giro_id
        FROM TBL_BDU_COMERCIOS c, TBL_BDU_GIROS g
        WHERE c.com_afiliacion = TO_NUMBER(v_afiliacion) 
         AND g.gir_cve = c.com_giro_id
         AND  g.gir_ax > 0;
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'GIRO NO PERMITIDO EN LA OPERATIVA AMEX |';
          v_estado_pro := 6;
          GOTO FIN;
       END;
    END IF;
  END IF;
  --
  IF(v_amexpn='1')THEN
    IF v_giro IS NOT NULL THEN
      IF v_giro IN(5172, 5532, 5541, 5542, 5983) THEN
          v_error:= v_error||'GIRO NO PERMITIDO EN PLAN-N AMEX |';
          v_estado_pro := 6;
          GOTO FIN;
      END IF;
    END IF;
  END IF;
 -- Terminacion: P-20-0115-16 D110
 -- Inicio: N-51-2254-14 
 IF v_mov = 'AL' OR v_mov = 'RE' THEN
 Pkg_Bdu_Utilerias_Com.nueva_afiliacion(v_afiliacion);
 END IF;
 -- Terminacion: N-51-2254-14 
 --
 INSERT INTO TBL_BDU_OFF_COM
 VALUES(
 v_mov , v_banco ,
 v_afiliacion , v_afiliante ,
 v_nombre , v_domicilio ,
 v_domicilio_f , v_cp ,
 v_cp_f , v_colonia ,
 v_colonia_f , v_pob ,
 v_pob_f , v_estado ,
 v_estado_f , v_propietario ,
 v_razon , v_responsable ,
 v_rfc , v_cod_cas ,
 v_cadena , v_grupo ,
 v_cat_cred , v_cat_deb ,
 v_cve_cred , v_cve_deb ,
 v_iva , v_lada ,
 v_lada_2 , v_lada_f ,
 v_tel , v_tel_2 ,
 v_tel_f , v_valor_cred ,
 v_valor_deb , v_valor_tarc ,
 v_chequera , v_cuenta ,
 v_cecoban_pob , v_cecoban_bco ,
 v_suc_cheques , v_criter_cad ,
 v_giro , v_cve_recont ,
 v_sucursal , v_asoc ,
 v_usuario , v_placas ,
 v_prov_plac ,
 v_servicom , v_arbitro ,
 v_registro , v_email ,
 v_obs , SYSDATE,
 parch , v_oid
 -- Modificacion: Inicio WELL-JMQ N-08-2142-12 
 ,v_com_rsim
 -- Modificacion: Terminacion WELL-JMQ N-08-2142-12 
 );
commit;
    -- Modificacion: Inicio CSA I-04-0889-09
   -- Terminacion: F-04-2280-13
    IF((v_mov = 'MO') AND (v_esax = 0))THEN
      BEGIN
      FOR X IN(
      SELECT com_afiliacion
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
      -- Inicio: F-54-2267-14          
          com_obs_banco, com_obs_despacho, com_corte_inicio,
      -- Terminacion: F-54-2267-14          
          com_corte_fin, com_estatus_pro_id, com_multi_hora_id,
          com_cecoban_id, com_prov_placas_id,
          com_servicomercio, com_tipo_debito_id, com_interred,
          bdu_usuario, com_pro_cad_id, com_obs_adquiriente,
          id_bitacora, com_sponsor, com_desc_sponsor,
          com_benef_tasa1, com_benef_tasa2, com_benef_amt_1,
          com_benef_amt_2, com_clave_neg,
          com_cuota_anual, com_cuota_mensual, com_registro_fiscal
      -- Modificacion: Inicio       WELL-JMQ N-08-2142-12      
         ,com_rsim
          -- Modificacion: Terminacion  WELL-JMQ N-08-2142-12  
          )
        -- Inicio: F-08-2028-10 CSA -------------------------
  -- Inicio: F-04-2280-13
        SELECT
          com_afil_amex, com_afil_diners, NVL(v_chequera,com_chq_chequera),
          NVL(v_cuenta,com_chq_cuenta), com_chq_plaza, com_chq_plaza_bco,
          com_chq_sucursal, com_afiliacion, com_afilianter,
          com_enviar_arbitro, com_impr_placa, NVL(v_nombre,com_nombre),
          NVL(v_propietario,com_propietario), NVL(v_razon,com_razon), 
          NVL(v_responsable,com_responsable),
          NVL(v_rfc,com_rfc), com_tipo_bloqueo, NVL(v_valor_cred/100,com_valor_credito),
          NVL(v_valor_deb/100,com_valor_debito), com_num_placa, com_numero_prosa,
          com_suc_numero, mon_proc_aten, mon_tran_perm,
          mon_tran_perm_cambio, pose_mm_auto_batch_release,
          pose_mm_auto_release_time_1,
          pose_mm_auto_release_time_2, com_afiliacion, v_banco,
          0, com_cat_cred_id, com_cat_deb_id,
          com_moneda_id, com_recontratacion_id,
          NVL(v_giro,com_giro_id), com_impuesto_id, NVL(v_cadena_id,com_cadena_id),
          NVL(v_criter_id,com_crit_encadena_id), SYSDATE,
          1, 2, NVL(v_cve_cred,com_cve_cred_id),
          NVL(v_cve_deb,com_cve_deb_id), com_cve_tarc_id, com_fec_cve_cred,
          com_fec_cve_deb, com_fec_cve_tarc, com_valor_tarc,
          com_asociacion_id, com_asig_cred_id, com_asig_deb_id,
          SUBSTR(v_obs,1,200), com_obs_despacho, com_corte_inicio,
          com_corte_fin, DECODE(v_estado_pro,6,6,1,3,2,1,1), com_multi_hora_id,
          com_cecoban_id, com_prov_placas_id,
          com_servicomercio, com_tipo_debito_id, com_interred,
          v_usuario, com_pro_cad_id, com_obs_adquiriente,
          id_bitacora, com_sponsor, com_desc_sponsor,
          com_benef_tasa1, com_benef_tasa2, com_benef_amt_1,
          com_benef_amt_2, com_clave_neg,
          com_cuota_anual, com_cuota_mensual, com_registro_fiscal
      -- Modificacion: Inicio       WELL-JMQ N-08-2142-12      
         ,v_com_rsim
          -- Modificacion: Terminacion  WELL-JMQ N-08-2142-12  
        FROM TBL_BDU_COMERCIOS
        WHERE com_afiliacion = x.com_afiliacion
         AND  com_pais = 1;
        -- Terminacion: F-08-2028-10 CSA -------------------------
        --
        INSERT INTO TBL_BDU_PROPUESTAS_COM_ADDN (
          com_domicilio, com_telefono, com_telefono_2,
          com_fax, com_email, com_pro_id,
          com_cp_id, com_tipo_dato_id, oid,
          com_lada_1, com_lada_2, bdu_usuario,
          id_bitacora, com_banco_id)
        SELECT
          NVL(v_domicilio,com_domicilio), NVL(v_tel,com_telefono), com_telefono_2,
          com_fax, NVL(v_email, com_email), com_id,
          NVL(v_cp_id,com_cp_id), com_tipo_dato_id, BDUSEQ020.NEXTVAL,
          NVL(v_lada,com_lada_1), com_lada_2, bdu_usuario,
          id_bitacora, v_banco
        FROM TBL_BDU_COMERCIOS_ADDRESS_N
        WHERE com_id = x.com_afiliacion
         AND com_tipo_dato_id = 1;
        --
       INSERT INTO TBL_BDU_PROPUESTAS_COM_ADDN (
          com_domicilio, com_telefono, com_telefono_2,
          com_fax, com_email, com_pro_id,
          com_cp_id, com_tipo_dato_id, oid,
          com_lada_1, com_lada_2, bdu_usuario,
          id_bitacora, com_banco_id)
        SELECT
          NVL(v_domicilio_f,com_domicilio), NVL(v_tel_f,com_telefono), com_telefono_2,
          com_fax, NVL(v_email, com_email), com_id,
          NVL(v_cpf_id,com_cp_id), com_tipo_dato_id, BDUSEQ020.NEXTVAL,
          NVL(v_lada_f,com_lada_1), com_lada_2, bdu_usuario,
          id_bitacora, v_banco
        FROM TBL_BDU_COMERCIOS_ADDRESS_N
        WHERE com_id = x.com_afiliacion
         AND com_tipo_dato_id = 2;
  -- Terminacion: F-04-2280-13
        --
    --  EXCEPTION
    --     WHEN OTHERS THEN
    --       v_error:= v_error||'MODIFICACION NO CREADA|';
      END;
      END LOOP;
      END;
   END IF;
   --
   -- Inicio: F-04-2280-13
   IF v_mov = 'MO' THEN
    IF LENGTH(v_chequera)= 20 THEN
     v_chequera := SUBSTR(v_chequera,2,19);
    END IF;
    --
    IF v_prov_plac IS NOT NULL THEN
      BEGIN
        SELECT/*+ FIRST_ROWS */ oid INTO v_prov_plac
        FROM TBL_BDU_PROVEEDORES_PLACAS
        WHERE oid = v_prov_plac;
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'PROV PLACAS |';
          v_estado_pro := 6;
          GOTO FIN;
      END;
    END IF;
   END IF;    
   --
   -- Terminacion: F-04-2280-13
   --
   IF (v_mov != 'CA' AND v_mov != 'MO') AND (NVL(v_amexmv,'00') NOT IN('02','03','04','05')) THEN
   -- Modificacion: Terminacion CSA I-04-0889-09
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
  -- Modificacion: Inicio CSA I-04-0889-09
           com_asig_deb_id,   com_obs_banco,
  -- Modificacion: Terminacion CSA I-04-0889-09
           com_estatus_pro_id,
           com_multi_hora_id, com_cecoban_id,
           com_prov_placas_id,com_servicomercio,
           com_tipo_debito_id,com_interred,
        bdu_usuario,
        id_bitacora,
  -- Inicio: R-02-0592-08 DesisXXI-HPG
        com_flag_1,        com_flag_2
  -- Terminacion: R-02-0592-08 DesisXXI-HPG
    -- Modificacion: Inicio       WELL-JMQ N-08-2142-12      
      ,com_rsim
  -- Modificacion: Terminacion  WELL-JMQ N-08-2142-12  
        )
      VALUES(
        SUBSTR(RTRIM(LTRIM(v_chequera)), 6, 15),   v_cuenta,
           NULL,     v_cecoban_bco,
        v_sucursal,   TO_NUMBER(v_afiliacion),
           DECODE(TO_NUMBER(v_afiliante), 0, NULL, TO_NUMBER(v_afiliante)), DECODE(v_arbitro,0,1,1,0,1),
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
        -- Inicio: I-08-0696-08 DesisXXI-HPG
           v_cadena_id,  v_criter_id,
        -- Terminacion: I-08-0696-08 DesisXXI-HPG
           SYSDATE,         1,
           v_mov_id,    TO_NUMBER(v_cve_cred),
        TO_NUMBER(v_cve_deb),    NULL,
           SYSDATE,   SYSDATE,
           NULL,     NULL,
        DECODE(TO_NUMBER(v_asoc),0,NULL,TO_NUMBER(v_asoc)),    1,
           1,     SUBSTR(v_obs,1,200),
   -- Inicio: P-20-0115-16 D110
           DECODE(v_arbitro,6,6,0,1,1,3,1),
   -- Terminacion: P-20-0115-16 D110
           NULL,    DECODE(v_cecoban_pob,0,1000,v_cecoban_pob),
           DECODE(v_prov_plac,0,NULL,v_prov_plac), v_servicom,
           3,      1,
        v_usuario,
        v_bitacora,
  -- Inicio: R-02-0592-08 CSA-EPF
        NVL(v_vip,0),        NVL(v_inst,0)
  -- Terminacion: R-02-0592-08 CSA-EPF
        -- Modificacion: Inicio       WELL-JMQ N-08-2142-12      
       ,v_com_rsim
        -- Modificacion: Terminacion  WELL-JMQ N-08-2142-12  

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
        -- Inicio: I-08-0696-08 DesisXXI-HPG
        v_domicilio,    TO_NUMBER(v_tel),
           DECODE(v_tel_2,'00000000', NULL, v_tel_2),  NULL,
           v_email,     v_oid,
        v_cp_id,     1,
           BDUSEQ020.NEXTVAL, TO_NUMBER(v_lada),
           DECODE(v_lada_2,'000', NULL, v_lada_2), v_usuario,
        v_bitacora,    v_banco
        -- Terminacion: I-08-0696-08 DesisXXI-HPG
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
        -- Inicio: I-08-0696-08 DesisXXI-HPG
        v_domicilio_f,  TO_NUMBER(v_tel_f),
           DECODE(v_tel_2,'00000000', NULL, v_tel_2),  NULL,
           v_email,     v_oid,
        v_cpf_id,     2,
           BDUSEQ020.NEXTVAL, TO_NUMBER(v_lada_f),
           DECODE(v_lada_2,'000', NULL, v_lada_2), v_usuario,
        v_bitacora,    v_banco
        -- Terminacion: I-08-0696-08 DesisXXI-HPG
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
            y.car_card_type_id, v_oid,
           BDUSEQ526.NEXTVAL,  v_usuario,
           v_bitacora
           );
     END LOOP;
   --
   -- Inicio: I-08-0696-08 DesisXXI-HPG
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
  -- Terminacion: I-08-0696-08 DesisXXI-HPG
  -- Modificacion: Inicio      C-04-2439-10 CSA
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
  -- Modificacion: Terminacion C-04-2439-10 CSA
  -- Modificacion: Inicio CSA I-04-0889-09
       INSERT INTO TBL_BDU_ASIGNACION_APP_PRO_COM(
         aac_propuesta_id, aac_aplicacion_id, oid,
         bdu_usuario, id_bitacora
         )
       VALUES(
         v_oid, 13, BDUSEQ014.NEXTVAL,
         v_usuario, v_bitacora
         );
   --EXCEPTION
   --  WHEN OTHERS THEN NULL;
   END;
  ELSIF v_mov = 'CA' THEN -- Cancel
  -- Modificacion: Terminacion CSA I-04-0889-09
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
  -- Modificacion: Inicio CSA I-04-0889-09
          com_asig_deb_id, com_obs_banco,
  -- Modificacion: Terminacion CSA I-04-0889-09
           com_estatus_pro_id,
           com_multi_hora_id, com_cecoban_id,
           com_prov_placas_id, com_servicomercio,
           com_tipo_debito_id, com_interred,
        bdu_usuario,
        id_bitacora
    -- Modificacion: Inicio       WELL-JMQ N-08-2142-12      
      ,com_rsim
       -- Modificacion: Terminacion  WELL-JMQ N-08-2142-12  
        )
      SELECT
        com_chq_chequera, com_chq_cuenta,
           com_chq_plaza,   com_chq_plaza_bco,
        com_chq_sucursal,  com_afiliacion,
      -- Modificacion: Inicio P-08-524-03 DesisXXI-HPG
           com_afilianter,     v_estado_arb,
      -- Modificacion: Fin    P-08-524-03 DesisXXI-HPG
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
          com_asig_deb_id, SUBSTR(v_obs,1,200),
           v_estado_pro,
           com_multi_hora_id, com_cecoban_id,
           com_prov_placas_id, com_servicomercio,
           com_tipo_debito_id, com_interred,
        v_usuario,
        v_bitacora
     -- Modificacion: Inicio       WELL-JMQ N-08-2142-12      
       ,com_rsim
        -- Modificacion: Terminacion  WELL-JMQ N-08-2142-12  
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
           BDUSEQ020.NEXTVAL, com_lada_1,
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
           BDUSEQ020.NEXTVAL, com_lada_1,
           com_lada_2,     bdu_usuario,
        v_bitacora,     com_bco_id
      FROM TBL_BDU_COMERCIOS_ADDRESS_N
   WHERE com_id = v_afiliacion
    AND com_tipo_dato_id = 2;

   EXCEPTION
     WHEN OTHERS THEN NULL;
   END;

   END IF; -- Canc

  END IF; -- v_error NULL

  -- END IF;

 -- Result
<<FIN>>
    -- Inicio: P-20-0115-16
    IF LTRIM(RTRIM(v_error)) IS NOT NULL THEN
      GOTO FIN2;
    ELSE
  IF(v_amexmv IN('02','03','04','05')) THEN
    BEGIN
      SELECT com_afiliacion INTO v_dummy
      FROM TBL_BDU_COMERCIO_AX
      WHERE com_afiliacion = TO_NUMBER(v_afiliacion);
    EXCEPTION
      WHEN no_data_found THEN
        v_error:= v_error||'AFILIACION NO REGISTRADA EN AMEX ';
        GOTO FIN2;
    END;  
  END IF;
  --
  IF((NVL(v_amexmv,'00')='00') AND (v_amexpn IN('0','1'))) THEN
    BEGIN
      SELECT com_afiliacion INTO v_dummy
      FROM TBL_BDU_COMERCIO_AX
      WHERE com_afiliacion = TO_NUMBER(v_afiliacion);
    EXCEPTION
      WHEN no_data_found THEN
        v_error:= v_error||'AFILIACION NO REGISTRADA EN AMEX ';
        GOTO FIN2;
    END;  
  END IF;
  --  
    IF(v_amexmv='01')THEN
     BEGIN
      INSERT INTO TBL_BDU_COMERCIO_AX(
        com_afiliacion, com_seller_id, oid,
        com_nm_rl1,  com_ap_pat_rl1,
        com_id_rl1,  com_fec_nac_rl1,
        com_dom_rl1, com_cd_rl1,
        com_cp_rl1, com_tasa_ax,
        com_nm_rl2,  com_ap_pat_rl2,
        com_id_rl2,  com_fec_nac_rl2,
        com_dom_rl2, com_cd_rl2,
        com_cp_rl2,  com_fec_alta,
        com_bco,     com_fiid,
        com_pln,     tasa_3,
        tasa_6,      tasa_9,
        tasa_12,     tasa_15,
        tasa_18,     tasa_21,
        tasa_24,     com_email,
        com_url
        )
      VALUES(
        v_afiliacion, LPAD(v_banco_id,3,'0')||TO_NUMBER(v_afiliacion)||'0000000001', v_afiliacion,
        v_amexnm, v_amexap,
        v_amexid, v_amexfn,
        v_amexdm, v_amexcd,
        LPAD(v_amexcp,5,'0'), 2.75,
        v_amexnmd, v_amexapd,
        v_amexidd, v_amexfnd,
        v_amexdmd, v_amexcdd,
        v_amexcpd, SYSDATE,
        v_banco_id, (SELECT bco_fiid FROM TBL_BDU_BANCOS WHERE oid=v_banco_id),
        NVL(v_amexpn,0), DECODE(v_amexpn,'1',NVL(v_amex3/100,NULL),NULL),
        DECODE(v_amexpn,'1',NVL(v_amex6/100,NULL),NULL),  DECODE(v_amexpn,'1',NVL(v_amex9/100,NULL),NULL),
        DECODE(v_amexpn,'1',NVL(v_amex12/100,NULL),NULL), DECODE(v_amexpn,'1',NVL(v_amex15/100,NULL),NULL),
        DECODE(v_amexpn,'1',NVL(v_amex18/100,NULL),NULL), DECODE(v_amexpn,'1',NVL(v_amex21/100,NULL),NULL),
        DECODE(v_amexpn,'1',NVL(v_amex24/100,NULL),NULL), v_email,
        v_url
        );
     --EXCEPTION
     --  WHEN OTHERS THEN NULL;
     END;
    END IF;
    --
    IF(v_amexmv='02')THEN
     UPDATE TBL_BDU_COMERCIO_AX
     SET com_estatus = 1,
       com_mov_ax='N'
     WHERE com_afiliacion = v_afiliacion;
    END IF;
    IF(v_amexmv='03')THEN
     UPDATE TBL_BDU_COMERCIO_AX
     SET com_estatus = 0,
       com_mov_ax='R'
     WHERE com_afiliacion = v_afiliacion;
    END IF; 
    IF(v_amexmv='04')THEN
     UPDATE TBL_BDU_COMERCIO_AX
     SET com_estatus = 1,
       com_mov_ax='D'
     WHERE com_afiliacion = v_afiliacion;
    END IF;
    IF(v_amexmv='05')THEN
     BEGIN
      SELECT com_afiliacion INTO v_dummy
      FROM TBL_BDU_COMERCIO_AX
      WHERE com_afiliacion = TO_NUMBER(v_afiliacion)
       AND com_mov_ax NOT IN('D','N');
      --
     UPDATE TBL_BDU_COMERCIO_AX
     SET com_nm_rl1    = NVL(v_amexnm,com_nm_rl1),  
        com_ap_pat_rl1 = NVL(v_amexap,com_ap_pat_rl1),
        com_id_rl1 = NVL(v_amexid,com_id_rl1),  
        com_fec_nac_rl1 = NVL(v_amexfn,com_fec_nac_rl1),
        com_dom_rl1 = NVL(v_amexdm,com_nm_rl1), 
        com_cd_rl1  = NVL(v_amexcd,com_dom_rl1),
        com_cp_rl1  = NVL(v_amexcp,com_cp_rl1), 
        com_tasa_ax = DECODE(v_amextasa,NULL,com_tasa_ax,(v_amextasa/100)),
        com_nm_rl2  = NVL(v_amexnmd,com_nm_rl2),  
        com_ap_pat_rl2 = NVL(v_amexapd,com_ap_pat_rl2),
        com_id_rl2  = NVL(v_amexidd,com_id_rl2),  
        com_fec_nac_rl2 = NVL(v_amexfnd,com_fec_nac_rl2),
        com_dom_rl2 = NVL(v_amexdmd,com_dom_rl2), 
        com_cd_rl2  = NVL(v_amexcdd,com_cd_rl2),
        com_cp_rl2  = NVL(v_amexcpd,com_cp_rl2),
        com_email   = NVL(v_email,com_email),
        com_url     = NVL(v_url,com_url)
     WHERE com_afiliacion = v_afiliacion;
     EXCEPTION
      WHEN no_data_found THEN
        v_error:= v_error||'MODIFICACION NO PERMITIDA ';
        GOTO FIN2;
     END;  
    END IF;    
   END IF;
    -- Terminacion: P-20-0115-16 D110
  -- Inicio: P-20-0115-16 D122
  --
  IF(v_amexpn='1') AND (NVL(v_amexmv,'00') NOT IN('00','02','03','04'))THEN
    FOR X IN(
      SELECT tasa_3,tasa_6,tasa_9,tasa_12,tasa_15,tasa_18,tasa_21,tasa_24
      FROM TBL_BDU_TASA_AMEX
      WHERE bco = v_banco_id
      )
    LOOP
     BEGIN
      UPDATE TBL_BDU_COMERCIO_AX
      SET TASA_3 = NVL(v_amex3/100,NVL(TASA_3,x.tasa_3)), 
       TASA_6  = NVL(v_amex6/100,NVL(TASA_6,x.tasa_6)), 
       TASA_9  = NVL(v_amex9/100,NVL(TASA_9,x.tasa_9)), 
       TASA_12 = NVL(v_amex12/100,NVL(TASA_12,x.tasa_12)), 
       TASA_15 = NVL(v_amex15/100,NVL(TASA_15,x.tasa_15)), 
       TASA_18 = NVL(v_amex18/100,NVL(TASA_18,x.tasa_18)), 
       TASA_21 = NVL(v_amex21/100,NVL(TASA_21,x.tasa_21)), 
       TASA_24 = NVL(v_amex24/100,NVL(TASA_24,x.tasa_24)),
       COM_PLN = 1
      WHERE com_afiliacion = v_afiliacion;
     EXCEPTION
       WHEN others THEN
          v_error:= v_error||'VALOR INVALIDO PLAN-N AMEX |';
          v_estado_pro := 6;
     END;
   END LOOP;   
  END IF;
  IF(v_amexpn='0') AND (NVL(v_amexmv,'00') NOT IN('00','02','03','04')) THEN
     UPDATE TBL_BDU_COMERCIO_AX
     SET TASA_3 = NULL, 
      TASA_6  = NULL, 
      TASA_9  = NULL, 
      TASA_12 = NULL, 
      TASA_15 = NULL, 
      TASA_18 = NULL, 
      TASA_21 = NULL, 
      TASA_24 = NULL,
      COM_PLN = 0
     WHERE com_afiliacion = v_afiliacion;
  END IF;
  -- Terminacion: P-20-0115-16 D122
  <<FIN2>>
    -- Errores
    IF v_error IS NOT NULL  THEN
   v_estat := 'R';
      v_error := LPAD(v_registro, 3, '0')||'|'||v_mov||'|'||
   TO_NUMBER(v_afiliacion)||'|'||LPAD(v_banco_id,3,'0')||'|R|'||v_error;
    -- Inicio: P-20-0115-16 D110
    ELSIF v_error IS NULL AND (v_arbitro = 1)THEN
    -- Terminacion: P-20-0115-16 D110
    -- OK
   v_estat := 'A';
      v_error := LPAD(v_registro, 3, '0')||'|'||v_mov||'|'||
   TO_NUMBER(v_afiliacion)||'|'||LPAD(v_banco_id,3,'0')||'|A|'||
   'MOV GENERADO C/ENVIO ARBITRO';
    -- Inicio: P-20-0115-16 D110
  -- Inicio: P-20-0115-16 D122
    ELSIF (v_arbitro IN(0,1) AND v_esax = 1) THEN
    -- OK
   v_estat := 'A';
      v_error := LPAD(v_registro, 3, '0')||'|'||v_mov||'|'||
   TO_NUMBER(v_afiliacion)||'|'||LPAD(v_banco_id,3,'0')||'|A|'||
   'MOV GENERADO AMEX';
  -- Terminacion: P-20-0115-16 D122   
    ELSIF (v_error IS NULL AND v_arbitro = 0 AND v_esax = 0) THEN
    -- OK
   v_estat := 'A';
      v_error := LPAD(v_registro, 3, '0')||'|'||v_mov||'|'||
   TO_NUMBER(v_afiliacion)||'|'||LPAD(v_banco_id,3,'0')||'|A|'||
   'MOV GENERADO S/ENVIO ARBITRO';
    END IF;
    -- 
    -- Inicio: P-20-0115-16
    -- Inicio: P-20-0115-16 D110
    dbms_output.put_line('error: '||v_error||' len: '||LENGTH(v_error));
    dbms_output.put_line(v_arbitro);
    dbms_output.put_line(v_amexmv);
    -- Terminacion: P-20-0115-16
 pout := v_error;

    INSERT INTO TBL_BDU_OFF_REP(
      mov_cve, com_afiliacion,
      bco_cve, ter_id,
      estatus, motivo,
      fecha,   misc
      )
    VALUES(
      v_mov,   v_afiliacion,
      v_banco, v_ter_id,
      v_estat, v_error,
      SYSDATE, v_registro
      );


  COMMIT;

END;

-- ------------------------------------------------------------------------
PROCEDURE procesa_terminales(plinea IN VARCHAR2, parch IN VARCHAR2, pout OUT VARCHAR2) IS
-- ------------------------------------------------------------------------
-- Nombre:      Terminales
-- Descripcion: Terminales Offline
-- Autor:       Hpg
-- Compania:    Desisxxi
-- Fecha:       21.12.2006
-- Entrada:     Linea
-- Salida:      Estatus
-- ------------------------------------------------------------------------

  CURSOR c_pro_oid(parch VARCHAR2, preg VARCHAR2) IS
    SELECT/*+ FIRST_ROWS*/ v_p_oid
    FROM TBL_BDU_OFF_COM
  WHERE v_archivo = parch
    AND  v_registro = preg
  AND v_p_oid IN(SELECT/*+ FIRST_ROWS */ oid FROM TBL_BDU_PROPUESTAS_COM);

  v_linea      VARCHAR2(800);
  v_dummy      VARCHAR2(80);
  v_error      VARCHAR2(100):=NULL;
  v_mov        VARCHAR2(2);

  v_afiliacion VARCHAR2(9);
  v_banco      VARCHAR2(3);
  v_banco_id   NUMBER(15);
  v_ter_id     VARCHAR2(3);
  v_lim_cash   VARCHAR2(7);
  v_lim_dev    VARCHAR2(7);
  -- Inicio: F-04-2280-13
  v_lim_vta    VARCHAR2(14);
  -- Terminacion: F-04-2280-13
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
  v_tcp_u       VARCHAR2(30);
  v_tcp_p       VARCHAR2(16);
  v_oid_ter    NUMBER(15);
  v_ok           NUMBER(15);
  -- Inicio: I-08-0696-08 DesisXXI-HPG
  v_servi      NUMBER(1);
  v_folio      NUMBER(10);
  v_bco_id     NUMBER(3);
  -- Terminacion: I-08-0696-08 DesisXXI-HPG
  -- Modificacion: Inicio P-02-0234-13 
  v_foliot   VARCHAR2(10);
  -- Modificacion: Terminacion P-02-0234-13 
  -- Inicio: F-04-2280-13
  v_movdes   VARCHAR2(30);
  -- Terminacion: F-04-2280-13
  -- Inicio: P-54-2008-15
  v_mon NUMBER(2);
  -- Fin: P-54-2008-15

BEGIN

 v_linea := plinea;

 --IF LENGTH(v_linea) < 509 THEN
 --  v_error := 'ERROR |REGISTRO NO CUMPLE CON LA LONGITUD';
 --END IF;
  -- Inicio: F-04-2280-13
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
    -- Modificacion: Inicio P-02-0234-13 
    IF v_banco = '036' THEN
      v_foliot      := SUBSTR(v_linea, 162, 7);
    END IF;
    -- Modificacion: Terminacion P-02-0234-13 
    IF v_mov='AL' THEN v_movdes := 'TERMINAL GENERADA|';
    ELSIF v_mov='MO' THEN v_movdes := 'TERMINAL MODIFICADA|';
    ELSIF v_mov='BA' THEN v_movdes := 'TERMINAL ELIMINADA|'; 
    END IF;
  -- Terminacion: F-04-2280-13
  -- Inicio: I-08-0696-08 DesisXXI-HPG
      v_obs  := REPLACE(v_obs, CHR(10), ' ');
  -- Terminacion: I-08-0696-08 DesisXXI-HPG

   -- archivo com
   v_arch_com := SUBSTR(parch, 1, 19)||'0'||SUBSTR(parch, 21, 14);
   --
   OPEN  c_pro_oid(v_arch_com, v_com);
   FETCH c_pro_oid INTO v_p_id;
   CLOSE c_pro_oid;
   --
  -- Inicio: N-51-2254-14
 IF v_mov IN('MO','BA') THEN
      v_ter_id     := LTRIM(v_ter_id);
      v_lim_cash   := LTRIM(v_lim_cash);
      v_lim_dev    := LTRIM(v_lim_dev);
      v_lim_vta    := LTRIM(v_lim_vta);
      v_ubica      := LTRIM(v_ubica);
      v_modelo     := LTRIM(v_modelo);
      v_apl        := LTRIM(v_apl);
      v_plan       := LTRIM(v_plan);
      v_vta_forz   := LTRIM(v_vta_forz);
      v_oper       := LTRIM(v_oper);
      v_prep       := LTRIM(v_prep);
      v_post       := LTRIM(v_post);
      v_dev        := LTRIM(v_dev);
      v_inst       := LTRIM(v_inst);
      v_carrier    := LTRIM(v_carrier);
      v_protocol   := LTRIM(v_protocol);
      v_min        := LTRIM(v_min);
      v_usuario    := LTRIM(v_usuario);
      v_registro   := LTRIM(v_registro);
      v_com        := LTRIM(v_com);
      v_obs        := LTRIM(v_obs);
  END IF;
  -- Terminacion: N-51-2254-14
   -- Inicio: I-08-0696-08 DesisXXI-HPG
   IF v_mov = 'AL' AND TO_NUMBER(RTRIM(v_afiliacion)) = 0 THEN
     IF v_p_id IS NULL THEN
       v_error:= v_error||'SIN PROPUESTA COM. VERIFICAR CARGA DE ARCHIVO DE COMERCIOS |';
       GOTO FIN;
     END IF;
   END IF;
   -- Terminacion: I-08-0696-08 DesisXXI-HPG
  -- Modificacion: Inicio CSA I-04-0889-09
  v_ubica := RTRIM(v_ubica);
  IF v_ubica IS NULL THEN
    v_ubica := 'EN LA CAJA';
  END IF;
  -- Modificacion: Terminacion CSA I-04-0889-09
   INSERT INTO TBL_BDU_OFF_TER
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
     v_p_id
     );

   -- Validar mov
   IF v_mov NOT IN ('AL','MO','BA') THEN
     v_error:= v_error||'MOVIMIENTO |';
     GOTO FIN;
   END IF;
   --
   -- Banco
   BEGIN
     -- Inicio: P-54-2008-15
     SELECT/*+ FIRST_ROWS */ oid, bco_moneda_id
     INTO v_banco_id, v_mon
     FROM   TBL_BDU_BANCOS
     WHERE  oid = v_banco;
    -- Fin: P-54-2008-15
   EXCEPTION
     WHEN OTHERS THEN
       v_error := v_error||'BANCO |';
       GOTO FIN;
   END;
  --
  -- Afiliacion
  IF (v_mov != 'AL') OR (v_mov = 'AL' AND TO_NUMBER(v_afiliacion) > 0) THEN
    -- Inicio: I-08-0696-08 DesisXXI-HPG
      BEGIN
        SELECT/*+ FIRST_ROWS */ oid, com_servicomercio, com_bco_id
        INTO v_dummy, v_servi, v_bco_id
        FROM TBL_BDU_COMERCIOS
        WHERE com_afiliacion = v_afiliacion;
        --
        IF v_servi > 0 THEN
          v_error:= v_error||'ALTA DE POS CON AFILIACION DE SERVICOMERCIO|';
          GOTO FIN;
        END IF;
        --
        IF v_bco_id != TO_NUMBER(v_banco) THEN
          v_error:= v_error||'AFILIACION CON OTRO BANCO |';
          GOTO FIN;
        END IF;
        --
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'NO EXISTE AFILIACION |';
          GOTO FIN;
      END;
      -- Terminacion: I-08-0696-08 DesisXXI-HPG
      --
  END IF;
  --
  IF (v_mov != 'AL') THEN
    -- Modificacion: Inicio P-02-0234-13
    IF ((v_mov = 'BA') AND (v_banco_id = 36)) THEN
      BEGIN
        SELECT/*+ FIRST_ROWS */ oid INTO v_oid_ter
        FROM TBL_BDU_TERMINALES
        WHERE ter_comercio_id = v_afiliacion
         AND ter_bco_id = v_banco_id
         AND ter_folio_telecarga = TO_NUMBER(v_foliot);
      EXCEPTION
        WHEN no_data_found THEN
          v_error:= v_error||'NO EXISTE FOLIO |';
          GOTO FIN;
      END;
    ELSE
    -- Modificacion: Inicio C-54-2253-14 
      BEGIN
        SELECT/*+ FIRST_ROWS */ oid, ter_folio_telecarga
        INTO v_oid_ter, v_foliot
        FROM TBL_BDU_TERMINALES
        WHERE ter_comercio_id = v_afiliacion
         AND  ter_id = v_ter_id
         AND  ter_bco_id = v_banco_id;
    -- Modificacion: Terminacion C-54-2253-14 
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'NO EXISTE POS |';
          GOTO FIN;
      END;
    END IF;
    -- Modificacion: Terminacion P-02-0234-13
      --
   END IF;

   IF v_mov != 'BA' THEN
  -- Inicio: N-51-2254-14
    IF(v_modelo IS NOT NULL) THEN
     -- Modelo
     BEGIN
        SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
        FROM TBL_BDU_MODELOS
        WHERE oid = v_modelo;
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'MODELO |';
          GOTO FIN;
      END;
    END IF;
      --
      -- Aplic
    IF(v_apl IS NOT NULL) THEN
      BEGIN
        SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
        FROM TBL_BDU_APLICACIONES_TER
        WHERE oid = v_apl;
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'APLICACION |';
          GOTO FIN;
      END;
    END IF;
      --
      -- Plan
    IF(v_plan IS NOT NULL) THEN
      BEGIN
        SELECT/*+ FIRST_ROWS */ oid INTO v_dummy
        FROM TBL_BDU_PLANES_ACEPTACION
        WHERE oid = v_plan;
      EXCEPTION
        WHEN OTHERS THEN
          v_error:= v_error||'PLAN |';
          GOTO FIN;
      END;
    END IF;
      --
      IF v_carrier = '00' THEN v_carrier := NULL; END IF;
      IF v_protocol = '00' THEN v_protocol:= NULL; END IF;
      -- Modificacion: Inicio P-08-524-03 DesisXXI-HPG
      IF (NVL(v_carrier,'00') = '00' AND NVL(v_protocol,'00') > '00')
       OR(NVL(v_carrier,'00') > '00' AND NVL(v_protocol,'00') = '00') THEN
       --
       v_error:= v_error||'CARRIER PROTOCOLO |';
         GOTO FIN;
       --
      END IF;
      -- Modificacion: Fin P-08-524-03 DesisXXI-HPG
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
            v_error:= v_error||'CARRIER PROT |';
            GOTO FIN;
        END;
      END IF;
      --
      -- Inicio: I-08-0696-08 DesisXXI-HPG
      -- se elimina codigo
      -- Terminacion: I-08-0696-08 DesisXXI-HPG
  -- Terminacion: N-51-2254-14
      --
      SELECT BDUSEQ047.NEXTVAL INTO v_oid FROM DUAL;
      SELECT BDUSEQ525.NEXTVAL INTO v_bitacora FROM DUAL;

      IF v_vta_forz NOT IN (0,1, NULL) THEN
        v_error:= v_error||'VTA FORZADA |'; GOTO FIN;
      END IF;
      --
      IF v_oper NOT IN ('Y', 'M', NULL) THEN
        v_error:= v_error||'OPERATIVA |'; GOTO FIN;
      END IF;
      --
      IF v_post NOT IN (0,1,NULL) THEN
        v_error:= v_error||'POSTPROPINA |'; GOTO FIN;
      END IF;
      --
      IF v_prep NOT IN (0,1,NULL) THEN
        v_error:= v_error||'PREPROPINA |'; GOTO FIN;
      END IF;

    END IF;


    IF v_error IS NULL THEN

    -- Inicio: C-08-2087-10 CSA -------------------------
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
          v_error := 'PARAMETROS PARA MODIFICACION INCORRECTOS |';
      END;
    END IF;
    -- Terminacion: C-08-2087-10 CSA -------------------------

     -- Alta
     IF v_mov = 'AL' THEN
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
          -- Inicio: I-08-0696-08 DesisXXI-HPG
          UPDATE TBL_BDU_PROPUESTAS_COM
          SET com_obs_adquiriente = SUBSTR((com_obs_adquiriente||v_obs),1,250)
          WHERE oid = v_p_id;
          -- Terminacion: I-08-0696-08 DesisXXI-HPG
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
            v_error := 'TERMINAL YA EXISTE |';
          WHEN OTHERS THEN
            v_error := 'ERROR |'||v_error;
            errbuf:= SUBSTRB(SQLERRM, 1, 250);
            INSERT INTO TBL_BDU_ERR_INT_TER(
              fecha, afiliacion, error
              )
            VALUES(SYSDATE , v_p_id, errbuf);
        END;

      ELSE
        BEGIN
         -- Inicio: I-08-0696-08 DesisXXI-HPG
          IF ((v_ter_id IS NULL) OR (TO_NUMBER(v_ter_id) = 0))THEN
            BEGIN
              SELECT /*+ FIRST_ROWS */ LPAD((NVL(MAX(ter_id), 0) + 1), 3, '0')
              INTO   v_ter_id
              FROM   TBL_BDU_TERMINALES
              WHERE  ter_comercio_id = v_afiliacion;
            EXCEPTION
              WHEN OTHERS THEN NULL;
            END;
          END IF;
         -- Terminacion: I-08-0696-08 DesisXXI-HPG

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
            bdu_usuario,        id_bitacora
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
            v_usuario,    v_bitacora
            );
            --
          -- Inicio: I-08-0696-08 DesisXXI-HPG
          BEGIN
            UPDATE TBL_BDU_COMERCIOS
            SET com_obs_adquiriente = SUBSTR((com_obs_adquiriente||v_obs),1,250)
            WHERE com_afiliacion = v_afiliacion;
          EXCEPTION
            WHEN OTHERS THEN NULL;
          END;
          -- Terminacion: I-08-0696-08 DesisXXI-HPG

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
         -- Inicio: I-08-0696-08 DesisXXI-HPG
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
         -- Terminacion: I-08-0696-08 DesisXXI-HPG

        EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN
            v_error := 'TERMINAL YA EXISTE |';
          WHEN OTHERS THEN
            v_error := 'ERROR |'||v_error;
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

     -- Baja ----------------------------------------------
    -- Modificacion: Inicio P-02-0234-13 
    -- Modificacion: Inicio C-54-2253-14 
     IF v_mov = 'BA' AND TO_NUMBER(v_banco) != '36'
      OR v_mov = 'BA' AND TO_NUMBER(v_banco) = '36' THEN
     -- Modificacion: Inicio P-08-524-03 DesisXXI-HPG
      IF TO_NUMBER(v_afiliacion) > 0 THEN
        BEGIN
            INSERT INTO TBL_BDU_TER_BAJA_MASIVO(
               oid, terminal_id_baja, folio_tel_baja, 
               cve_bco_masivo, fech_archivo, fech_aplica_baja
               ) 
            VALUES(
               BDUSEQ051.NEXTVAL, v_oid_ter, v_foliot,
               TO_NUMBER(v_banco), SYSDATE, SYSDATE
               );
          --
          BEGIN
            UPDATE TBL_BDU_TERMINALES
            SET ter_bco_id = 37
            WHERE oid = v_oid_ter;
          EXCEPTION
            WHEN others THEN NULL;
          END;
   -- se elimina codigo
      -- Modificacion: Fin  P-08-524-03 DesisXXI-HPG
        EXCEPTION
         WHEN OTHERS THEN
           v_error:= v_error||'ERROR EN EL BORRADO |';
        END;
      END IF;
   -- se elimina codigo      
     END IF;
   END IF;
   -- Modificacion: Terminacion C-54-2253-14    
    -- Modificacion: Terminacion P-02-0234-13 

   <<FIN>>

    IF v_error IS NOT NULL  THEN
      v_error := LPAD(v_registro, 3, '0')||'|'||v_mov||'|'||
      TO_NUMBER(v_afiliacion)||'|'||LPAD(v_banco_id,3,'0')||
      '|'||v_ter_id||'|R|'||v_error;
    -- Inicio: I-08-0696-08 DesisXXI-HPG
    ELSIF v_error IS NULL AND v_mov = 'BA' THEN
    -- OK
    -- Modificacion: Inicio P-02-0234-13
     IF TO_NUMBER(v_banco) = '36' THEN
      v_error := LPAD(v_registro, 3, '0')||'|'||v_mov||'|'||
         TO_NUMBER(v_afiliacion)||'|'||LPAD(v_banco_id,3,'0')||
         '|'||v_ter_id||'|A|'||
         'TERMINAL ELIMINADA|'||TO_NUMBER(v_foliot);
     ELSE
      v_error := LPAD(v_registro, 3, '0')||'|'||v_mov||'|'||
         TO_NUMBER(v_afiliacion)||'|'||LPAD(v_banco_id,3,'0')||
         '|'||v_ter_id||'|A|'||
         'TERMINAL ELIMINADA';
     END IF;
    -- Modificacion: Terminacion P-02-0234-13 
    -- Terminacion: I-08-0696-08 DesisXXI-HPG
    ELSIF v_error IS NULL THEN
    -- OK
  -- Inicio: F-04-2280-13
      v_error := LPAD(v_registro, 3, '0')||'|'||v_mov||'|'||
         TO_NUMBER(v_afiliacion)||'|'||LPAD(v_banco_id,3,'0')||
         '|'||v_ter_id||'|A|'||
         v_movdes||v_folio;
    ELSIF v_error IS NULL AND v_pro_id = 0 THEN
      -- OK
      v_error := LPAD(v_registro, 3, '0')||'|'||v_mov||'|'||
         TO_NUMBER(v_afiliacion)||'|'||LPAD(v_banco_id,3,'0')||
         '|'||v_ter_id||'|A|'||
         v_movdes||v_folio;
    END IF;
  -- Terminacion: F-04-2280-13
    --
     v_estat := 'A';
     pout := v_error;

    INSERT INTO TBL_BDU_OFF_REP(
      mov_cve, com_afiliacion,
      bco_cve, ter_id,
      estatus, motivo,
      fecha,   misc
      )
    VALUES(
      v_mov,   v_afiliacion,
      v_banco, v_ter_id,
      v_estat, v_error,
      SYSDATE, v_registro
      );

   COMMIT;

END;

-- ------------------------------------------------------------------------
PROCEDURE procesa_cadenas(plinea IN VARCHAR2, parch IN VARCHAR2, pout OUT VARCHAR2) IS
-- ------------------------------------------------------------------------
-- Nombre:      Cadenas
-- Descripcion: Cadenas Offline
-- Autor:       Hpg
-- Compania:    Desisxxi
-- Fecha:       21.12.2006
-- Entrada:     Linea
-- Salida:      Estatus
-- ------------------------------------------------------------------------

  CURSOR c_pro_ter(pptoid NUMBER) IS
    SELECT oid
    FROM   TBL_BDU_PROPUESTAS_TER
    WHERE  pro_ter_propuesta_id = pptoid;

  v_pro_id NUMBER(15);

BEGIN

  NULL;

END;
--

-- ------------------------------------------------------------------------
FUNCTION abrevia(plinea IN VARCHAR2, ptipo IN NUMBER) RETURN VARCHAR2 IS
-- ------------------------------------------------------------------------
-- Nombre:      Cadenas
-- Descripcion: Cadenas Offline
-- Autor:       Hpg
-- Compania:    Desisxxi
-- Fecha:       21.12.2006
-- Entrada:     Linea
-- Salida:      Estatus
-- ------------------------------------------------------------------------

  nombre VARCHAR2(32);

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
-- Modificacion: Inicio C-54-2253-14 --------------------------
PROCEDURE eliminar (pfecha IN VARCHAR2) IS
---------------------------------------------------------------
  errbuf  VARCHAR2(200);
  retcode NUMBER;
  v_cta NUMBER(10);

BEGIN
      FOR X IN(
        SELECT OID, terminal_id_baja, folio_tel_baja, cve_bco_masivo
        FROM TBL_BDU_TER_BAJA_MASIVO
        WHERE TO_CHAR(fech_aplica_baja,'YYYYMMDD')
         BETWEEN TO_CHAR((TO_DATE(pfecha,'YYYYMMDD')-1),'YYYYMMDD') AND pfecha
        )
        LOOP
          BEGIN
            DELETE TBL_BDU_TERMINALES
            WHERE OID = x.terminal_id_baja;
          EXCEPTION
            WHEN OTHERS THEN
              errbuf :=SUBSTRB(SQLERRM,1,95);
              retcode:=SQLCODE;
              INSERT INTO TBL_BDU_BIT_SISTEMA(
                bit_fecha,bit_usuario,bit_movimiento,bit_banco
                )
              VALUES(
               SYSDATE, 'OFFLINE', x.terminal_id_baja||'-'||errbuf,
                x.cve_bco_masivo
                );
          END;
          v_cta := v_cta+1;
          IF v_cta = 10 THEN
            COMMIT;
            v_cta := 0;
          END IF;
        END LOOP;
  COMMIT;
END;
-- Modificacion: Terminacion C-54-2253-14
-- Inicio: P-20-0115-16 D110
FUNCTION valida(plinea IN VARCHAR2, ptipo IN NUMBER) RETURN NUMBER IS
  v_cadok NUMBER(1);
BEGIN
  IF(ptipo=1) THEN
    SELECT 1 INTO v_cadok FROM dual
    WHERE REGEXP_LIKE(plinea,'^[0-9ABCDEFGHIJKLMNOPQRSTUVWXYZ ]+$','c');
  ELSE
    SELECT 1 INTO v_cadok FROM dual
    WHERE REGEXP_LIKE(plinea,'^[0-9]+$','c');
  END IF;

  RETURN(v_cadok);
EXCEPTION
  WHEN no_data_found THEN
   RETURN 0;
END;

PROCEDURE valida_conv(plinea IN VARCHAR2, parch IN VARCHAR2, pout OUT VARCHAR2) IS

v_afil VARCHAR2(8);
v_afila NUMBER(8);
v_nm   VARCHAR2(25);
v_bcoa VARCHAR2(3);
v_bco  NUMBER(3);
v_fiid VARCHAR2(4);
v_error VARCHAR2(80);
v_tipo VARCHAR2(2);

BEGIN

  SELECT oid
  INTO v_bco
  FROM TBL_BDU_BANCOS
  WHERE bco_fiid =  SUBSTR(parch,7,4);

  SELECT SUBSTR(plinea,1,8), SUBSTR(plinea,9,25)
  INTO v_afil, v_nm
  FROM DUAL;

  SELECT SUBSTR(plinea,34,2)
  INTO v_tipo
  FROM DUAL;

  IF v_tipo NOT IN('00','01') THEN
    v_error := v_afil||v_nm||' | REGISTRO INVALIDO';
    GOTO FIN;
  END IF;

dbms_output.put_line('afil: '||v_afil||' nom: '||v_nm||' bco: '||v_bco);
  BEGIN 
    SELECT TO_NUMBER(v_afil)
    INTO v_afila
    FROM TBL_BDU_COMERCIOS C
    WHERE c.com_bco_id = v_bco
     AND C.COM_AFILIACION = TO_NUMBER(v_afil);
  EXCEPTION
    WHEN others THEN
      v_error := v_afil||v_nm||' | AFILIACION INVALIDA';
      GOTO FIN;
  END;

  BEGIN 
    SELECT TO_NUMBER(c.com_afiliacion)
    INTO v_afila
    FROM TBL_BDU_COMERCIOS C, TBL_BDU_GIROS G
    WHERE C.COM_GIRO_ID = G.OID
     AND c.com_bco_id = v_bco
     AND C.COM_AFILIACION = v_afil
     AND g.gir_ax > 0;
  EXCEPTION
    WHEN no_data_found THEN
      v_error := v_afil||v_nm||' | GIRO NO PERMITIDO AMEX';
      GOTO FIN;
  END;

  BEGIN
    SELECT com_afiliacion
    INTO v_afila
    FROM TBL_BDU_COMERCIO_AX_CNV
    WHERE com_afiliacion = v_afil;
    --
    UPDATE ACT.TBL_BDU_COMERCIO_AX_CNV
    SET COM_ESTATUS = 0,
      COM_MOV_AX = NULL,
      com_archivo = parch,
      com_fec_mod = SYSDATE 
    WHERE COM_AFILIACION = v_afil;
    --
  EXCEPTION
    WHEN no_data_found THEN
           INSERT INTO ACT.TBL_BDU_COMERCIO_AX_CNV (
             OID, COM_AFILIACION, 
             COM_BCO, 
             COM_FIID, COM_NOMBRE, 
             COM_FEC_ALTA, COM_FEC_MOD,
             COM_ESTATUS, COM_ARCHIVO
             ) 
           VALUES(
             v_afil, v_afil,
             v_bco,
             SUBSTR(parch,7,4), v_nm,
             SYSDATE, SYSDATE,
             0, parch
             );
  END;

  v_error := v_afil||v_nm||' | REGISTRO CARGADO';

<<FIN>>

 pout := v_error;
END;
 -- Terminacion: P-20-0115-16 D110 
END Pkg_Bdu_Offline;
