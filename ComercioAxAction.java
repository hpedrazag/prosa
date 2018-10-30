/*
#java
################################################################################
# Nombre del Programa : ComercioAxAction.java                                 #
# Autor               : HPG                                                    #
# Compania            : Teotl                                                  #
# Proyecto/Procliente : P-20-0115-16                        Fecha: 10/09/2014  #
# Descripcion General : Incorporación de American Express                      #
# Programa Dependiente: Ninguno                                                #
# Programa Subsecuente: Ninguno                                                #
# Cond. de ejecucion  : N/A                                                    #
# Dias de ejecucion   : N/A                                 Horario: N/A       #
#                              MODIFICACIONES                                  #
#------------------------------------------------------------------------------#
# Autor               : HPG                                                    #
# Compania            : Teotl                                                  #
# Proyecto/Procliente : P-20-5175-17                        Fecha: 04/10/2018  #
# Descripcion General : Incorporación de Inbursa a Amex D1                     #
#------------------------------------------------------------------------------#
# Autor               : HPG                                                    #
# Compania            : Teotl                                                  #
# Proyecto/Procliente : P-20-0115-16                        Fecha: 04/10/2018  #
# Descripcion General : Incorporación de Amex D110                             #
#------------------------------------------------------------------------------#
# Autor               : HPG                                                    #
# Compania            : Teotl                                                  #
# Proyecto/Procliente : P-20-0115-16                        Fecha: 11/06/2018  #
# Descripcion General : Incorporacion de American Express D123                 #
#------------------------------------------------------------------------------#
# Numero de Parametros: N/A                                                    #
# Parametros Entrada  : N/A                                 Formato:           #
# Parametros Salida   : N/A                                 Formato:           #
###############################################################################*
*/

package mx.com.prosa.bdu.gui.mantenimiento.ter.action;

import com.zubarev.htmltable.DefaultHTMLTable;
import com.zubarev.htmltable.HTMLTableCache;
import mx.com.prosa.bdu.common.excepcion.BDUException;
import mx.com.prosa.bdu.common.filtro.Filtro;
import mx.com.prosa.bdu.common.filtro.IFiltro;
import mx.com.prosa.bdu.common.util.IConstantes;
import mx.com.prosa.bdu.dmn.mantenimiento.cadena.Cadena;
import mx.com.prosa.bdu.dmn.mantenimiento.catalogo.banco.light.BancoLight;
import mx.com.prosa.bdu.dmn.mantenimiento.catalogo.banco.light.IBancoLight;
import mx.com.prosa.bdu.dmn.mantenimiento.ter.ComercioAx;
import mx.com.prosa.bdu.eai.common.PersistenceConnector;
import mx.com.prosa.bdu.eai.common.PersistenceException;
import mx.com.prosa.bdu.gui.acceso.form.AccesoForm;
import mx.com.prosa.bdu.gui.common.Constantes;
import mx.com.prosa.bdu.gui.common.UtileriaCatalogos;
import mx.com.prosa.bdu.gui.common.UtileriasMantenimientoAction;
import mx.com.prosa.bdu.gui.common.servicio.IServicio;
import mx.com.prosa.bdu.gui.mantenimiento.ter.form.ComercioAxForm;
import mx.com.prosa.bdu.gui.mantenimiento.ter.service.ServicioComercioAx;
import mx.com.prosa.bdu.sna.business.Utilerias;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import org.apache.struts.action.*;
import org.apache.struts.actions.DispatchAction;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
/* Inicio: P-20-5175-17 D1 */
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
/* Terminacion: P-20-5175-17 D1 */
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ComercioAxAction  extends DispatchAction {
    private static UtileriasMantenimientoAction utileriaMantenimiento = null;
    private final static String BEAN = "formComercioAx";
    private final static String LISTADO_REG = "ListadoRegistrosAx";

    public ComercioAxAction(){
        utileriaMantenimiento = UtileriasMantenimientoAction.getInstance();
    }

    public ActionForward form_onLoad(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        ComercioAxForm comercioAxForm = new ComercioAxForm();
        comercioAxForm.setResultados(new ArrayList());

        AccesoForm fbAcceso = (AccesoForm) request.getSession().getAttribute(Constantes.FB_ACCESO);
        ActionMessages errors = new ActionMessages();
        HttpSession session = request.getSession();
        try {
            if (utileriaMantenimiento.esOperador(fbAcceso)) {
                Map mapb= new HashMap();
                mapb.put("agrupacionBanco",((AccesoForm) session.getAttribute(Constantes.FB_ACCESO)).getGrupoBanco());
                comercioAxForm.setCmbBanco(UtileriaCatalogos.buscarBanco(mapb,"LVB"));
            }else{
                comercioAxForm.setCmbBanco(UtileriaCatalogos.catalogo("banco", "", "", errors, "catalogo.sinDatos.banco",fbAcceso.getIdPais()));
            }
            comercioAxForm.setCmbOrigen(UtileriaCatalogos.cargarCatalogoOrigen());
            comercioAxForm.setCmbMarca(UtileriaCatalogos.cargarCatalogoMarca());
            comercioAxForm.setCmbProducto(UtileriaCatalogos.cargarCatalogoProducto());
            /* Inicio: P-20-0115-16 D110*/
            comercioAxForm.setCmbTipo(UtileriaCatalogos.cargarCatalogoAmex());
            comercioAxForm.setCmbPlan(UtileriaCatalogos.catalogoValidaQ6());
            /* Terminacion: P-20-0115-16 D110*/
            comercioAxForm.setCmbGiro(UtileriaCatalogos.catalogo("giro", "", "", errors, "catalogo.sinDatos.giro",fbAcceso.getIdPais()));
            comercioAxForm.setCmbGrupo(UtileriaCatalogos.catalogo("grupo", "", "", errors, "catalogo.sinDatos.grupo",fbAcceso.getIdPais()));

            comercioAxForm.setResultados(new ArrayList());

        } catch (BDUException e) {
            e.printStackTrace();
        }
        session.removeAttribute(LISTADO_REG);
        DefaultHTMLTable dht_registros = new DefaultHTMLTable();
        dht_registros.setMapping(LISTADO_REG);
        dht_registros.setLength(10); //renglones que se verán por pagina
        dht_registros.setSortColumn("afiliacion"); //parámetro de ordenación
        dht_registros.setIsAscending(true); //ordenamiento asc/desc
        dht_registros.addAll(comercioAxForm.getResultados());
        dht_registros.setVolume(200);
        HTMLTableCache cache = new HTMLTableCache(session, "ListadoRegistrosAx");
        cache.updateTable(dht_registros);
        session.setAttribute(LISTADO_REG, dht_registros);
        session.setAttribute(BEAN, comercioAxForm);
        return (mapping.findForward(IConstantes.IR_MAESTRO));    }

    public ActionForward form_onBuscar(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        IFiltro filtro = new Filtro();

        ActionMessages errors = new ActionMessages();
        DefaultHTMLTable dht_registros = new DefaultHTMLTable();
        /* Inicio: P-20-0115-16 D110*/
        AccesoForm fbAcceso = (AccesoForm) request.getSession().getAttribute(Constantes.FB_ACCESO);
        if (utileriaMantenimiento.esOperador(fbAcceso)) {
            if(((ComercioAxForm)form).getBanco()==null || IConstantes.CADENA_VACIA.equals(((ComercioAxForm)form).getBanco().trim())){
                errors.add("0", new ActionMessage("errors.cadenaProsa", "Banco"));
                saveErrors(request, errors);
            }
        }

        if(errors.isEmpty()){

            filtro.setCriterios(getCriterios((ComercioAxForm)form));
            IServicio servicio = ServicioComercioAx.getInstance();
            Collection resultados = servicio.buscar(filtro);
            ((ComercioAxForm)form).setResultados((resultados!=null?resultados:new ArrayList()));

            session.removeAttribute(LISTADO_REG);
//        DefaultHTMLTable dht_registros = new DefaultHTMLTable();
            dht_registros.setMapping(LISTADO_REG);
            dht_registros.setLength(10); //renglones que se ver?n por pagina
            dht_registros.setSortColumn("afiliacion"); //par?metro de ordenaci?n
            dht_registros.setIsAscending(true); //ordenamiento asc/desc
            dht_registros.addAll(((ComercioAxForm)form).getResultados());
            dht_registros.setVolume(((ComercioAxForm)form).getResultados().size());
            HTMLTableCache cache = new HTMLTableCache(session, "ListadoRegistrosAx");
            cache.updateTable(dht_registros);

            if((((ComercioAxForm) form).getResultados().size())==0){
                errors.add("Error", new ActionMessage(Constantes.SIN_RESULTADOS));
                saveErrors(request, errors);
            }
        }
        /* Terminacion: P-20-0115-16 D110*/
        session.setAttribute(LISTADO_REG, dht_registros);
        request.getSession().setAttribute(BEAN, form);
        return (mapping.findForward(IConstantes.IR_MAESTRO));
    }

    private Collection getCriterios(ComercioAxForm comercioAxForm){
        Collection criterios = new ArrayList();

        if(comercioAxForm.getBanco() != null
                && !IConstantes.CADENA_VACIA.equals(comercioAxForm.getBanco().trim())){
            criterios.add(UtileriaCatalogos.crearCriterio(comercioAxForm.getBanco(), "banco", Boolean.FALSE));
        }
        if(comercioAxForm.getAfiliacion() != null
                && !IConstantes.CADENA_VACIA.equals(comercioAxForm.getAfiliacion().trim())){
            criterios.add(UtileriaCatalogos.crearCriterio(comercioAxForm.getAfiliacion(), "afiliacion", Boolean.FALSE));
        }
        if(comercioAxForm.getOrigen() != null
                && !IConstantes.CADENA_VACIA.equals(comercioAxForm.getOrigen().trim())){
            criterios.add(UtileriaCatalogos.crearCriterio(comercioAxForm.getOrigen(), "origen", Boolean.FALSE));
        }

        return criterios;
    }

    public ActionForward form_onNuevo(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        String grupo = null;
        if(grupo==null || "".equals(grupo)){
            grupo = request.getParameter("grupo");
            if(grupo==null || "".equals(grupo)){
                ((ComercioAxForm)form).reset();
                ((ComercioAxForm)form).setAccion(IConstantes.ACCION_CREAR);
                request.getSession().setAttribute(BEAN, form);
                return (mapping.findForward(IConstantes.IR_DETALLE));
            }
        }
        return null;
    }

    public ActionForward form_onCargar(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        String grupo = request.getParameter("afiliacion");
        if(grupo==null || "".equals(grupo)){
            grupo = request.getParameter("grupo");
            if(grupo==null || "".equals(grupo)){
                // ((ComercioAxForm)form).reset();
                // ((ComercioAxForm)form).setAccion(IConstantes.ACCION_CREAR);
                request.getSession().setAttribute(BEAN, form);
                return (mapping.findForward(IConstantes.IR_DETALLE));
            }
        }

        IServicio servicio = ServicioComercioAx.getInstance();
        ComercioAx comercioAx = new ComercioAx();
        comercioAx.setOid(Long.valueOf(grupo));
        servicio.cargar(comercioAx);

        if(comercioAx.getBanco()==null){
            ActionMessages errors = new ActionMessages();
            errors.add("Error", new ActionMessage(Constantes.MSG_FRACASO));
            saveErrors(request, errors);
            return mapping.findForward(IConstantes.IR_MAESTRO);
        }

        ((ComercioAxForm)form).setAccion(IConstantes.ACCION_ACT);
        beanToForm(comercioAx, ((ComercioAxForm)form));
        return (mapping.findForward(IConstantes.IR_DETALLE));
    }

    public ActionForward form_onConfirmar(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws HibernateException, SQLException, PersistenceException {
        String accion = request.getParameter("accion");

        if(IConstantes.ACCION_CANCELAR.equals(accion)){
            return form_onLoad(mapping, form, request, response);
        }else if(IConstantes.ACCION_ELIMINAR.equals(accion)){
            ((ComercioAxForm)form).setAccion(IConstantes.ACCION_ELIMINAR);
        }

        request.getSession().setAttribute(BEAN, form);

        if(!((ComercioAxForm) form).getAccion().equals(IConstantes.ACCION_ELIMINAR)){
            ActionMessages errors = validarFactForm((ComercioAxForm)form);
            if(!errors.isEmpty()){
                saveErrors(request, errors);
                return (mapping.findForward(IConstantes.IR_DETALLE));
            }
        }

        return (mapping.findForward(IConstantes.IR_CONFIRMAR));
    }

    public ActionForward form_onActualizar(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        String accion = ((ComercioAxForm)form).getAccion();

        if(IConstantes.ACCION_CANCELAR.equals(accion)){
            return form_onLoad(mapping, form, request, response);
        }

        accion = ((ComercioAxForm)form).getAccion();

        ComercioAx bean = new ComercioAx();
        formToBean(((ComercioAxForm)form), bean);

        IServicio servicio = ServicioComercioAx.getInstance();
        if(IConstantes.ACCION_ACT.equals(accion)
                || IConstantes.ACCION_CREAR.equals(accion)){
            servicio.guardar(bean, accion);
        }else if(IConstantes.ACCION_ELIMINAR.equals(accion)){
            servicio.eliminar(bean);
        }

        ((ComercioAxForm)form).reset();

        request.getSession().removeAttribute(LISTADO_REG);
        DefaultHTMLTable dht_registros = new DefaultHTMLTable();
        dht_registros.setMapping(LISTADO_REG);
        dht_registros.setLength(10); //renglones que se verán por pagina
        dht_registros.setSortColumn("afiliacion"); //parámetro de ordenación
        dht_registros.setIsAscending(true); //ordenamiento asc/desc
        dht_registros.addAll(((ComercioAxForm)form).getResultados());
        dht_registros.setVolume(((ComercioAxForm)form).getResultados().size());
        HTMLTableCache cache = new HTMLTableCache(request.getSession(), "ListadoRegistrosAx");
        cache.updateTable(dht_registros);

        request.getSession().setAttribute(LISTADO_REG, dht_registros);
        request.getSession().setAttribute(BEAN, form);
        ActionMessages errors = new ActionMessages();
        errors.add("Error", new ActionMessage(Constantes.MSG_EXITO));
        saveErrors(request, errors);
        return (mapping.findForward(IConstantes.IR_MAESTRO));
    }
    /* Inicio: P-20-0115-16 D110*/
    private String verificaRangoFechas(String strFechaInicio) {
        String result = null;
        if(strFechaInicio != null && !"".equals(strFechaInicio.trim())) {
            Date fechaIni = crearFecha(strFechaInicio);
            Date fechaHoy = crearFecha(UtileriasMantenimientoAction.formatearFecha(new Date(), FORMATO_FECHA));
            if(fechaIni.after(fechaHoy)) {
                result = "error.amex.fecha";
            }else if(fechaIni.equals(fechaHoy)) {
                result = "error.amex.fecha";
            }
        }
        return result;
    }

    private static SimpleDateFormat s_simpleDateFormat;
    public static final String FORMATO_FECHA = "yyyyMMdd";
    public static Date crearFecha(String sfecha) {
        Date fecha = null;
        if ( s_simpleDateFormat == null ) {
            s_simpleDateFormat = new SimpleDateFormat(FORMATO_FECHA);
        }
        ParsePosition pos = new ParsePosition(0);
        fecha = s_simpleDateFormat.parse(sfecha, pos);
        return fecha;
    }

    private static String validarFecha(String fecha) {
        String result = null;
        try {
            SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyyMMdd");
            formatoFecha.setLenient(false);
            formatoFecha.parse(fecha);
        } catch (Exception e) {
            result = "error.fecha.invalida";
        }
        return result;
    }
    /* Terminacion: P-20-0115-16 D110*/
    private static boolean isUrl(String s) {
        //String regex = "^(?:http(s)?:\/\/)?(www)?.+\.[a-z]{2,6}(\.[a-z]{2,6})?.+\.[a-z]{2,4}(\/?)([a-z0-9./]{2,20}?)$";
        String regex = " ";
        try {
            Pattern patt = Pattern.compile(regex);
            Matcher matcher = patt.matcher(s);
            return matcher.matches();

        } catch (RuntimeException e) {
            return false;
        }
    }

    private ActionMessages validarFactForm(ComercioAxForm form) throws PersistenceException, HibernateException, SQLException {
        ActionMessages errors = new ActionMessages();
        String sqlPropuestas = "";
        Session session = null;
        Cadena cadena = null;
        String orden;
        orden = null;

        try{
            session = PersistenceConnector.getInstance().getSession();
        } catch (PersistenceException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
        session.clear();

        String accion = form.getAccion();
        Statement stm = null;
        ResultSet rs =  null;
        session = PersistenceConnector.getInstance().getSession();

        /* Inicio: P-20-0115-16 */
        /* se elimina codigo */

        if (!accion.equals("eliminar")){

            form.setFlag1("0");
            form.setFlag2("0");
            form.setFlag4("0");
            form.setFlag5("0");

            StringBuffer sql = new StringBuffer();
            sql.append("SELECT C.CAMPO_1 FROM ACT.TBL_BDU_EXCEPCION_AX C WHERE C.CAMPO_1 = 1 AND C.BANCO = " + form.getBanco());
            Connection con = session.connection();
            stm = con.createStatement();
            rs = stm.executeQuery(sql.toString());
            //System.out.println("fetch : " + String.valueOf(rs.getFetchSize()));
            if(rs.next()){
                form.setFlag1("1");
            }
            stm.close();
            rs.close();

            sql = new StringBuffer();
            sql.append("SELECT C.CAMPO_2 FROM ACT.TBL_BDU_EXCEPCION_AX C WHERE C.CAMPO_2 = 1 AND C.BANCO = " + form.getBanco());
            con = session.connection();
            stm = con.createStatement();
            rs = stm.executeQuery(sql.toString());
            //System.out.println("fetch : " + String.valueOf(rs.getFetchSize()));
            if(rs.next()){
                form.setFlag2("1");
            }
            stm.close();
            rs.close();

            sql = new StringBuffer();
            sql.append("SELECT C.CAMPO_4 FROM ACT.TBL_BDU_EXCEPCION_AX C WHERE C.CAMPO_4 = 1 AND C.BANCO = " + form.getBanco());
            con = session.connection();
            stm = con.createStatement();
            rs = stm.executeQuery(sql.toString());
            //System.out.println("fetch : " + String.valueOf(rs.getFetchSize()));
            if(rs.next()){
                form.setFlag4("1");
            }
            stm.close();
            rs.close();

            sql = new StringBuffer();
            sql.append("SELECT C.CAMPO_5 FROM ACT.TBL_BDU_EXCEPCION_AX C WHERE C.CAMPO_5 = 1 AND C.BANCO = " + form.getBanco());
            con = session.connection();
            stm = con.createStatement();
            rs = stm.executeQuery(sql.toString());
            //System.out.println("fetch : " + String.valueOf(rs.getFetchSize()));
            if(rs.next()){
                form.setFlag5("1");
            }
            stm.close();
            rs.close();

            /* Inicio: P-20-0115-16 D110*/
            System.out.println("excepcion flg : " + form.getFlag1()+ form.getFlag2()+ form.getFlag4()+ form.getFlag5());

            if(form.getBanco()==null || IConstantes.CADENA_VACIA.equals(form.getBanco().trim())){
                errors.add("0", new ActionMessage("errors.cadenaProsa", "Banco"));
            }
            /* Terminacion: P-20-0115-16 D110*/
            if(form.getValordeb()==null || IConstantes.CADENA_VACIA.equals(form.getValordeb().trim())){
                errors.add("0", new ActionMessage("errors.cadenaProsa", "Domicilio RL1"));
            }
            if(form.getAfiliacion()==null || IConstantes.CADENA_VACIA.equals(form.getAfiliacion().trim())){
                errors.add("0", new ActionMessage("errors.cadenaProsa", "Afiliacion"));
            }
            if((form.getFlag2()!= null)&&(form.getFlag2().equals("1"))){
                System.out.println("entra flg 2: " + form.getFlag2());
                if(form.getClavecre()==null || IConstantes.CADENA_VACIA.equals(form.getClavecre().trim())){
                    errors.add("0", new ActionMessage("errors.cadenaProsa", "Apellido Paterno RL1"));
                }
            }
            /*if(form.getClavedeb()==null || IConstantes.CADENA_VACIA.equals(form.getClavedeb().trim())){
                errors.add("0", new ActionMessage("errors.cadenaProsa", "Apellido Materno RL1"));
            }*/
            if((form.getFlag1()!= null)&&(form.getFlag1().equals("1"))){
                if(form.getBin()==null || IConstantes.CADENA_VACIA.equals(form.getBin().trim())){
                    errors.add("0", new ActionMessage("errors.cadenaProsa", "Nombre RL1"));
                }
            }
            if(form.getGiro()==null || IConstantes.CADENA_VACIA.equals(form.getGiro().trim())){
                errors.add("0", new ActionMessage("errors.cadenaProsa", "CP RL1"));
            }
            if((form.getFlag4()!= null)&&(form.getFlag4().equals("1"))){
                if(form.getGrupo()==null || IConstantes.CADENA_VACIA.equals(form.getGrupo().trim())){
                    errors.add("0", new ActionMessage("errors.cadenaProsa", "Ciudad RL1"));
                }
            }
            if((form.getFlag5()!= null)&&(form.getFlag5().equals("1"))){
                if(form.getFecnrl()==null || IConstantes.CADENA_VACIA.equals(form.getFecnrl().trim())){
                    errors.add("0", new ActionMessage("errors.cadenaProsa", "Fecha nacimiento RL1"));
                }
            }
            if(form.getIdu()==null || IConstantes.CADENA_VACIA.equals(form.getIdu().trim())){
                errors.add("0", new ActionMessage("errors.cadenaProsa", "ID RL1"));
            }
            /* Inicio: P-20-5175-17 D1 */
            if(form.getValorcre()==null || IConstantes.CADENA_VACIA.equals(form.getValorcre().trim())){
                errors.add("0", new ActionMessage("errors.cadenaProsa", "Comisión Amex"));
            }
            /* Terminacion: P-20-5175-17 D1 */
            /* se elimina codigo */
            /* Inicio: P-20-0115-16 D110*/
            if(form.getFecnrl()!=""){
                String errorFechaForm = validarFecha(form.getFecnrl());
                if(errorFechaForm!=null){
                    errors.add("0", new ActionMessage("error.amex.fecha.forml"));
                }else{
                    String errorFecha = verificaRangoFechas(form.getFecnrl());
                    if(errorFecha!=null){
                        errors.add("0", new ActionMessage("error.amex.fechal"));
                    }
                }
            }
            if(form.getFecnrll()!=""){
                String errorFechaForm = validarFecha(form.getFecnrll());
                if(errorFechaForm!=null){
                    errors.add("0", new ActionMessage("error.amex.fecha.formll"));
                }else{
                    String errorFecha = verificaRangoFechas(form.getFecnrll());
                    if(errorFecha!=null){
                        errors.add("0", new ActionMessage("error.amex.fechall"));
                    }
                }
            }

            if(accion.equals("crear")){
                if ((form.getAfiliacion()!="")&&(form.getBanco()!="")){
                    sql = new StringBuffer();
                    sql.append("SELECT A.COM_AFILIACION TBL_BDU_COMERCIO_AX A WHERE A.COM_AFILIACION = "+ form.getAfiliacion() + " AND A.COM_BCO = " + form.getBanco());
                    con = session.connection();
                    stm = con.createStatement();
                    rs = stm.executeQuery(sql.toString());
                    if(rs.next()) {
                         errors.add("0", new ActionMessage("error.amex.existe"));
                    }
                    stm.close();
                    rs.close();
                }
            }

            if ((form.getAfiliacion()!="")&&(form.getBanco()!="")){
                sqlPropuestas = "select propuesta.id from propuesta in class mx.com.prosa.bdu.dmn.mantenimiento.comercio.light.ComercioLight where propuesta.afiliacion = " + form.getAfiliacion();
                Query query = null;
                if (!sqlPropuestas.equals("")) {
                    try {
                        query = session.createQuery(sqlPropuestas);
                        if (query.uniqueResult()==null){
                            //errors.add("0", new ActionMessage("error.marcas.afiliacion"));
                            sqlPropuestas = "select propuesta.id from propuesta in class mx.com.prosa.bdu.dmn.mantenimiento.propuesta.PropuestaComercio where propuesta.id = " + form.getAfiliacion();
                            query = null;
                            if (!sqlPropuestas.equals("")) {
                                try {
                                    query = session.createQuery(sqlPropuestas);
                                    if (query.uniqueResult()==null){
                                        errors.add("0", new ActionMessage("error.marcas.afiliacion"));
                                    }

                                } catch (HibernateException e) {
                                    e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                                }
                            }
                        }

                    } catch (HibernateException e) {
                        e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                    }
                }
                /* Inicio: P-20-5175-17 D1 */
                /* se elimina codigo */
                sql = new StringBuffer();
                sql.append("SELECT C.COM_GIRO_ID FROM TBL_BDU_COMERCIOS C, TBL_BDU_GIROS G WHERE C.COM_GIRO_ID = G.OID AND G.GIR_AX IS NULL AND C.COM_AFILIACION = " + form.getAfiliacion());
                con = session.connection();
                stm = con.createStatement();
                rs = stm.executeQuery(sql.toString());
                //System.out.println("fetch : " + String.valueOf(rs.getFetchSize()));
                if(rs.next()){
                    errors.add("0", new ActionMessage("error.amex.giro"));
                }
                stm.close();
                rs.close();
                /* Terminacion: P-20-5175-17 D1 */
                if(form.getBanco()==null || IConstantes.CADENA_VACIA.equals(form.getBanco().trim())){
                    form.setBanco("0");
                }
                sql = new StringBuffer();
                sql.append("SELECT DISTINCT I.IND_FIID FROM TBL_BDU_INDUSTRIA_AX I WHERE I.IND_FIID = " + form.getBanco());
                con = session.connection();
                stm = con.createStatement();
                rs = stm.executeQuery(sql.toString());
                //System.out.println("fetch : " + String.valueOf(rs.getFetchSize()));
                if (rs.next()) {
                    System.out.println("industria true: " + String.valueOf(rs.getFetchSize()));
                } else {
                    errors.add("0", new ActionMessage("error.amex.adquirente"));
                }
                stm.close();
                rs.close();
                /* Inicio: P-20-0115-16 D110*/
                if(!accion.equals("crear")){
                    if((form.getFlgestatus().equals("N"))||(form.getFlgestatus().equals("D"))){
                        sql = new StringBuffer();
                        sql.append("SELECT A.COM_MOV_AX FROM TBL_BDU_COMERCIO_AX A WHERE A.COM_AFILIACION = "+ form.getAfiliacion() + " AND A.COM_MOV_AX IN('R',' ')");
                        con = session.connection();
                        stm = con.createStatement();
                        rs = stm.executeQuery(sql.toString());
                        if(rs.next()) {
                            System.out.println("cancel ok: ");
                        } else {
                            errors.add("0", new ActionMessage("error.amex.activo"));
                        }
                        stm.close();
                        rs.close();
                    }
                    if(form.getFlgestatus().equals("R")){
                        sql = new StringBuffer();
                        sql.append("SELECT A.COM_MOV_AX FROM TBL_BDU_COMERCIO_AX A WHERE A.COM_AFILIACION = "+ form.getAfiliacion() + " AND A.COM_MOV_AX IN('D','N','R')");
                        con = session.connection();
                        stm = con.createStatement();
                        rs = stm.executeQuery(sql.toString());
                        if(rs.next()) {
                            System.out.println("reactivo ok: ");
                        } else {
                            errors.add("0", new ActionMessage("error.amex.inactivo"));
                        }
                        stm.close();
                        rs.close();
                    }
                    if(form.getFlgestatus().equals(" ")){
                        sql = new StringBuffer();
                        sql.append("SELECT A.COM_MOV_AX FROM TBL_BDU_COMERCIO_AX A WHERE A.COM_AFILIACION = "+ form.getAfiliacion() + " AND A.COM_MOV_AX IN(' ')");
                        con = session.connection();
                        stm = con.createStatement();
                        rs = stm.executeQuery(sql.toString());
                        if(rs.next()) {
                            System.out.println("activo ok: ");
                        } else {
                            errors.add("0", new ActionMessage("error.amex.inicial"));
                        }
                        stm.close();
                        rs.close();
                    }
                }
                sql = new StringBuffer();
                sql.append("SELECT DISTINCT I.IND_FIID FROM TBL_BDU_INDUSTRIA_AX I WHERE I.IND_FIID = " + form.getBanco());
                con = session.connection();
                stm = con.createStatement();
                rs = stm.executeQuery(sql.toString());
                //System.out.println("fetch : " + String.valueOf(rs.getFetchSize()));
                if (rs.next()) {
                    System.out.println("industria true: " + String.valueOf(rs.getFetchSize()));
                } else {
                    errors.add("0", new ActionMessage("error.amex.adquirente"));
                }
                stm.close();
                rs.close();
                if(form.getAfiliacion()!=""){
                    sql = new StringBuffer();
                    sql.append("SELECT C.OID FROM TBL_BDU_COMERCIOS C WHERE C.COM_AFILIACION = " + form.getAfiliacion() + " AND C.COM_BCO_ID = " + form.getBanco());
                    con = session.connection();
                    stm = con.createStatement();
                    rs = stm.executeQuery(sql.toString());
                    //System.out.println("fetch : " + String.valueOf(rs.getFetchSize()));
                    if (rs.next()) {
                        System.out.println("banco true: " + String.valueOf(rs.getFetchSize()));
                    } else {
                        errors.add("0", new ActionMessage("error.amex.afiliacion"));
                    }
                    stm.close();
                    rs.close();
                }
                if(form.getGiro()!="") {
                    sql = new StringBuffer();
                    sql.append("SELECT C.OID FROM TBL_BDU_CP C WHERE C.CP_CVE = '"+ form.getGiro() +"' AND ROWNUM<2");
                    con = session.connection();
                    stm = con.createStatement();
                    rs = stm.executeQuery(sql.toString());
                    if (rs.next()) {
                        System.out.println("cp true: " + String.valueOf(rs.getFetchSize()));
                    } else {
                        errors.add("0", new ActionMessage("error.amex.cp"));
                    }
                    stm.close();
                    rs.close();
                }
                if(form.getGirod()!="") {
                    sql = new StringBuffer();
                    sql.append("SELECT C.OID FROM TBL_BDU_CP C WHERE C.CP_CVE = '"+ form.getGirod() +"' AND ROWNUM<2");
                    con = session.connection();
                    stm = con.createStatement();
                    rs = stm.executeQuery(sql.toString());
                    if (rs.next()) {
                        System.out.println("cp2 true: " + String.valueOf(rs.getFetchSize()));
                    } else {
                        errors.add("0", new ActionMessage("error.amex.cpd"));
                    }
                    stm.close();
                    rs.close();
                }
                if(form.getEmailax()!=""){
                    if(!Utilerias.validaEmail(form.getEmailax())){
                        errors.add("0", new ActionMessage("error.amex.email"));
                    }
                }
                //if(form.getUrlax()!=""){
                //    if(!isUrl(form.getUrlax())){
                //        errors.add("0", new ActionMessage("error.amex.url"));
                //    }
                //}
                if(form.getValorcre()!=""){
                    try{
                        Double.parseDouble(form.getValorcre());
                    } catch (NumberFormatException excepcion) {
                        errors.add("0", new ActionMessage("error.amex.valor"));
                    }
                }
                if(form.getPlna()!=""){
                    try{
                        Double.parseDouble(form.getPlna());
                    } catch (NumberFormatException excepcion) {
                        errors.add("0", new ActionMessage("error.amex.valor3"));
                    }
                }
                if(form.getPlnb()!=""){
                    try{
                        Double.parseDouble(form.getPlnb());
                    } catch (NumberFormatException excepcion) {
                        errors.add("0", new ActionMessage("error.amex.valor6"));
                    }
                }
                if(form.getPlnc()!=""){
                    try{
                        Double.parseDouble(form.getPlnc());
                    } catch (NumberFormatException excepcion) {
                        errors.add("0", new ActionMessage("error.amex.valor9"));
                    }
                }
                if(form.getPlnd()!=""){
                    try{
                        Double.parseDouble(form.getPlnd());
                    } catch (NumberFormatException excepcion) {
                        errors.add("0", new ActionMessage("error.amex.valor12"));
                    }
                }
                if(form.getPlne()!=""){
                    try{
                        Double.parseDouble(form.getPlne());
                    } catch (NumberFormatException excepcion) {
                        errors.add("0", new ActionMessage("error.amex.valor15"));
                    }
                }
                if(form.getPlnf()!=""){
                    try{
                        Double.parseDouble(form.getPlnf());
                    } catch (NumberFormatException excepcion) {
                        errors.add("0", new ActionMessage("error.amex.valor18"));
                    }
                }
                if(form.getPlng()!=""){
                    try{
                        Double.parseDouble(form.getPlng());
                    } catch (NumberFormatException excepcion) {
                        errors.add("0", new ActionMessage("error.amex.valor21"));
                    }
                }
                if(form.getPlnh()!=""){
                    try{
                        Double.parseDouble(form.getPlnh());
                    } catch (NumberFormatException excepcion) {
                        errors.add("0", new ActionMessage("error.amex.valor24"));
                    }
                }
            }
        }
        /* Terminacion: P-20-0115-16 D110*/
        return errors;

    }

    private void formToBean(ComercioAxForm form, ComercioAx bean){
        if(form.getBanco()!=null && !"".equals(form.getBanco().trim())){
            IBancoLight banco = new BancoLight();
            banco.setId(UtileriasMantenimientoAction.stringTo_long(form.getBanco()));
            bean.setBanco(banco);
        }
        bean.setAfiliacion(UtileriasMantenimientoAction.stringToLong(form.getAfiliacion()));
        bean.setOrigen((form.getOrigen()));
        bean.setMarca((form.getMarca()));
        bean.setProducto((form.getProducto()));
        bean.setBin(form.getBin());
        bean.setOid(UtileriasMantenimientoAction.stringToLong(form.getOid()));
        bean.setClavecre((form.getClavecre()));
        bean.setClavedeb((form.getClavedeb()));
        bean.setValorcre(Double.valueOf(Double.parseDouble(form.getValorcre())));
        bean.setValordeb((form.getValordeb()));
        bean.setGiro((form.getGiro()));
        bean.setGrupo((form.getGrupo()));
        bean.setIdu(form.getIdu());
        bean.setBind(form.getBind());
        bean.setClavecred((form.getClavecred()));
        bean.setClavedebd((form.getClavedebd()));
        bean.setValordebd((form.getValordebd()));
        bean.setGirod((form.getGirod()));
        bean.setGrupod((form.getGrupod()));
        bean.setIdd(form.getIdd());
        bean.setFecnrl(form.getFecnrl());
        bean.setFecnrll(form.getFecnrll());
        /* Inicio: P-20-0115-16 D110*/
        //bean.setFlgestatus(form.getFlgestatus());
        bean.setFlgestatus(form.getFlgestatus());
        /* Terminacion: P-20-0115-16 D110*/
        /* Inicio: P-20-0115-16 D122 */
        bean.setPlnflag(form.getPlnflag());
        bean.setPlna(form.getPlna());
        bean.setPlnb(form.getPlnb());
        bean.setPlnc(form.getPlnc());
        bean.setPlnd(form.getPlnd());
        bean.setPlne(form.getPlne());
        bean.setPlnf(form.getPlnf());
        bean.setPlng(form.getPlng());
        bean.setPlnh(form.getPlnh());
        /* Terminacion: P-20-0115-16 D122 */
        bean.setUrlax(form.getUrlax());
        bean.setEmailax(form.getEmailax());
        //bean.setFecha(UtileriasMantenimientoAction.formatearFecha(form.getFecha(),Constantes.FORMATO_FECHA_RED));
    }

    private void beanToForm(ComercioAx bean, ComercioAxForm form){
        form.setBanco(Long.toString(bean.getBanco().getId()));
        form.setAfiliacion((bean.getAfiliacion()!=null?bean.getAfiliacion().toString():null));
        form.setOrigen((bean.getOrigen()!=null?bean.getOrigen().toString():null));
        form.setMarca(bean.getMarca()!=null?bean.getMarca().toString():null);
        form.setProducto(bean.getProducto()!=null?bean.getProducto().toString():null);
        form.setBin(bean.getBin());
        form.setOid((bean.getOid()!=null?bean.getOid().toString():null));
        form.setClavecre(bean.getClavecre()!=null?bean.getClavecre().toString():null);
        form.setClavedeb(bean.getClavedeb()!=null?bean.getClavedeb().toString():null);
        form.setValorcre(bean.getValorcre()!=null? Double.toString(bean.getValorcre().doubleValue()):null);
        form.setValordeb(bean.getValordeb()!=null?bean.getValordeb().toString():null);
        //form.setFecha(UtileriasMantenimientoAction.formatearFecha(bean.getFecha(), Constantes.FORMATO_FECHA_RED));
        form.setGiro((bean.getGiro()!=null?bean.getGiro().toString():null));
        form.setGrupo((bean.getGrupo()!=null?bean.getGrupo().toString():null));
        form.setIdu(bean.getIdu());
        form.setBind(bean.getBind());
        form.setClavecred(bean.getClavecred()!=null?bean.getClavecred().toString():null);
        form.setClavedebd(bean.getClavedebd()!=null?bean.getClavedebd().toString():null);
        form.setValordebd(bean.getValordebd()!=null?bean.getValordebd().toString():null);
        form.setGirod((bean.getGirod()!=null?bean.getGirod().toString():null));
        form.setGrupod((bean.getGrupod()!=null?bean.getGrupod().toString():null));
        form.setIdd(bean.getIdd());
        form.setFecnrl(bean.getFecnrl());
        form.setFecnrll(bean.getFecnrll());
        form.setFlga(bean.getFlga());
        form.setFlgb(bean.getFlgb());
        form.setFlgc(bean.getFlgc());
        form.setFlgd(bean.getFlgd());
        form.setFlge(bean.getFlge());
        form.setFlgf(bean.getFlgf());
        form.setFlgg(bean.getFlgg());
        form.setFlgh(bean.getFlgh());
        form.setFlgi(bean.getFlgi());
        form.setFlgj(bean.getFlgj());
        form.setFlgk(bean.getFlgk());
        form.setFlgl(bean.getFlgl());
        form.setFlgm(bean.getFlgm());
        form.setFlgn(bean.getFlgn());
        form.setFlgo(bean.getFlgo());
        form.setFlgestatus(bean.getFlgestatus());
        /* Inicio: P-20-0115-16 D122 */
        form.setPlnflag(bean.getPlnflag());
        form.setPlna(bean.getPlna());
        form.setPlnb(bean.getPlnb());
        form.setPlnc(bean.getPlnc());
        form.setPlnd(bean.getPlnd());
        form.setPlne(bean.getPlne());
        form.setPlnf(bean.getPlnf());
        form.setPlng(bean.getPlng());
        form.setPlnh(bean.getPlnh());
        /* Terminacion: P-20-0115-16 D122 */
        form.setUrlax(bean.getUrlax());
        form.setEmailax(bean.getEmailax());
    }

}
