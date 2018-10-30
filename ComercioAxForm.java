/*
#java
################################################################################
# Nombre del Programa : ComercioAxForm.java                                   #
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

package mx.com.prosa.bdu.gui.mantenimiento.ter.form;

import mx.com.prosa.bdu.common.util.IConstantes;
import org.apache.struts.validator.ValidatorForm;

import java.util.ArrayList;
import java.util.Collection;

public class ComercioAxForm extends ValidatorForm {

    private String oid;
    private String afiliacion;
    private Collection cmbBanco;
    private Collection cmbOrigen;
    private Collection cmbMarca;
    private Collection cmbProducto;
    private Collection cmbTipo;
    private Collection cmbGiro;
    private Collection cmbGrupo;
    private Collection cmbPlan;
    private String banco;
    private String fiid;
    private String giro;
    private String grupo;
    private String origen;
    private String marca;
    private String producto;
    private String bin;
    private String clavecre;
    private String valorcre;
    private String clavedeb;
    private String valordeb;
    private String fecha;
    private String sic;
    private String idu;
    private String bind;
    private String clavecred;
    private String clavedebd;
    private String valordebd;
    private String girod;
    private String grupod;
    private String idd;
    private String fecnrl;
    private String fecnrll;
    private Boolean flga;
    private Boolean flgb;
    private Boolean flgc;
    private Boolean flgd;
    private Boolean flge;
    private Boolean flgf;
    private Boolean flgg;
    private Boolean flgh;
    private Boolean flgi;
    private Boolean flgj;
    private Boolean flgk;
    private Boolean flgl;
    private Boolean flgm;
    private Boolean flgn;
    private Boolean flgo;
    /* Inicio: P-20-0115-16 D110*/
    private String flgestatus;
    /* Terminacion: P-20-0115-16 D110*/
    /* Inicio: P-20-0115-16 D122 */
    private String plnflag;
    private String plna;
    private String plnb;
    private String plnc;
    private String plnd;
    private String plne;
    private String plnf;
    private String plng;
    private String plnh;
    private String isFlag1;
    private String isFlag2;
    private String isFlag3;
    private String isFlag4;
    private String isFlag5;
    /* Terminacion: P-20-0115-16 D122 */
    private String urlax;
    private String emailax;

    private String accion;
    private Collection resultados;
    private String recargar;
    private String ocultar;

    public Collection getCmbTipo() {
        return cmbTipo;
    }

    public void setCmbTipo(Collection cmbTipo) {
        this.cmbTipo = cmbTipo;
    }

    public Collection getCmbOrigen() {
        return cmbOrigen;
    }

    public void setCmbOrigen(Collection cmbOrigen) {
        this.cmbOrigen = cmbOrigen;
    }

    public Collection getCmbMarca() {
        return cmbMarca;
    }

    public void setCmbMarca(Collection cmbMarca) {
        this.cmbMarca = cmbMarca;
    }

    public Collection getCmbProducto() {
        return cmbProducto;
    }

    public void setCmbProducto(Collection cmbProducto) {
        this.cmbProducto = cmbProducto;
    }

    public Collection getCmbPlan() {
        return cmbPlan;
    }

    public void setCmbPlan(Collection cmbPlan) {
        this.cmbPlan = cmbPlan;
    }

    public String getFiid() {
        return fiid;
    }

    public void setFiid(String fiid) {
        this.fiid = fiid;
    }

    public String getOrigen() {
        return origen;
    }

    public void setOrigen(String origen) {
        this.origen = origen;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getProducto() {
        return producto;
    }

    public void setProducto(String producto) {
        this.producto = producto;
    }

    public String getBin() {
        return bin;
    }

    public void setBin(String bin) {
        this.bin = bin;
    }

    public String getClavecre() {
        return clavecre;
    }

    public void setClavecre(String clavecre) {
        this.clavecre = clavecre;
    }

    public String getValorcre() {
        return valorcre;
    }

    public void setValorcre(String valorcre) {
        this.valorcre = valorcre;
    }

    public String getClavedeb() {
        return clavedeb;
    }

    public void setClavedeb(String clavedeb) {
        this.clavedeb = clavedeb;
    }

    public String getValordeb() {
        return valordeb;
    }

    public void setValordeb(String valordeb) {
        this.valordeb = valordeb;
    }

    public Collection getCmbBanco() {
        return cmbBanco;
    }

    public void setCmbBanco(Collection cmbBanco) {
        this.cmbBanco = cmbBanco;
    }

    public String getAccion() {
        return accion;
    }

    public void setAccion(String accion) {
        this.accion = accion;
    }

    public String getOid() {
        return oid;
    }

    public void setOid(String oid) {
        this.oid = oid;
    }

    public String getAfiliacion() {
        return afiliacion;
    }

    public void setAfiliacion(String afiliacion) {
        this.afiliacion = afiliacion;
    }

    public String getBanco() {
        return banco;
    }

    public void setBanco(String banco) {
        this.banco = banco;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public Collection getResultados() {
        return resultados;
    }

    public void setResultados(Collection resultados) {
        this.resultados = resultados;
    }

    public String getRecargar() {
        return recargar;
    }

    public void setRecargar(String recargar) {
        this.recargar = recargar;
    }

    public String getOcultar() {
        return ocultar;
    }

    public void setOcultar(String ocultar) {
        this.ocultar = ocultar;
    }

    public Collection getCmbGiro() {
        return cmbGiro;
    }

    public void setCmbGiro(Collection cmbGiro) {
        this.cmbGiro = cmbGiro;
    }

    public String getGiro() {
        return giro;
    }

    public void setGiro(String giro) {
        this.giro = giro;
    }

    public String getGrupo() {
        return grupo;
    }

    public void setGrupo(String grupo) {
        this.grupo = grupo;
    }

    public Collection getCmbGrupo() {
        return cmbGrupo;
    }

    public void setCmbGrupo(Collection cmbGrupo) {
        this.cmbGrupo = cmbGrupo;
    }

    public String getIdu() {
        return idu;
    }

    public void setIdu(String idu) {
        this.idu = idu;
    }

    public String getBind() {
        return bind;
    }

    public void setBind(String bind) {
        this.bind = bind;
    }

    public String getClavecred() {
        return clavecred;
    }

    public void setClavecred(String clavecred) {
        this.clavecred = clavecred;
    }

    public String getClavedebd() {
        return clavedebd;
    }

    public void setClavedebd(String clavedebd) {
        this.clavedebd = clavedebd;
    }

    public String getValordebd() {
        return valordebd;
    }

    public void setValordebd(String valordebd) {
        this.valordebd = valordebd;
    }

    public String getGirod() {
        return girod;
    }

    public void setGirod(String girod) {
        this.girod = girod;
    }

    public String getGrupod() {
        return grupod;
    }

    public void setGrupod(String grupod) {
        this.grupod = grupod;
    }

    public String getIdd() {
        return idd;
    }

    public void setIdd(String idd) {
        this.idd = idd;
    }

    public String getFecnrl() {
        return fecnrl;
    }

    public void setFecnrl(String fecnrl) {
        this.fecnrl = fecnrl;
    }

    public String getFecnrll() {
        return fecnrll;
    }

    public void setFecnrll(String fecnrll) {
        this.fecnrll = fecnrll;
    }

    public String getSic() {
        return sic;
    }

    public void setSic(String sic) {
        this.sic = sic;
    }

    public Boolean getFlga() {
        return flga;
    }

    public void setFlga(Boolean flga) {
        this.flga = flga;
    }

    public Boolean getFlgb() {
        return flgb;
    }

    public void setFlgb(Boolean flgb) {
        this.flgb = flgb;
    }

    public Boolean getFlgc() {
        return flgc;
    }

    public void setFlgc(Boolean flgc) {
        this.flgc = flgc;
    }

    public Boolean getFlgd() {
        return flgd;
    }

    public void setFlgd(Boolean flgd) {
        this.flgd = flgd;
    }

    public Boolean getFlge() {
        return flge;
    }

    public void setFlge(Boolean flge) {
        this.flge = flge;
    }

    public Boolean getFlgf() {
        return flgf;
    }

    public void setFlgf(Boolean flgf) {
        this.flgf = flgf;
    }

    public Boolean getFlgg() {
        return flgg;
    }

    public void setFlgg(Boolean flgg) {
        this.flgg = flgg;
    }

    public Boolean getFlgh() {
        return flgh;
    }

    public void setFlgh(Boolean flgh) {
        this.flgh = flgh;
    }

    public Boolean getFlgi() {
        return flgi;
    }

    public void setFlgi(Boolean flgi) {
        this.flgi = flgi;
    }

    public Boolean getFlgj() {
        return flgj;
    }

    public void setFlgj(Boolean flgj) {
        this.flgj = flgj;
    }

    public Boolean getFlgk() {
        return flgk;
    }

    public void setFlgk(Boolean flgk) {
        this.flgk = flgk;
    }

    public Boolean getFlgl() {
        return flgl;
    }

    public void setFlgl(Boolean flgl) {
        this.flgl = flgl;
    }

    public Boolean getFlgm() {
        return flgm;
    }

    public void setFlgm(Boolean flgm) {
        this.flgm = flgm;
    }

    public Boolean getFlgn() {
        return flgn;
    }

    public void setFlgn(Boolean flgn) {
        this.flgn = flgn;
    }

    public Boolean getFlgo() {
        return flgo;
    }

    public void setFlgo(Boolean flgo) {
        this.flgo = flgo;
    }

    public String getFlgestatus() {
        return flgestatus;
    }

    public void setFlgestatus(String flgestatus) {
        this.flgestatus = flgestatus;
    }

    public String getPlnflag() {
        return plnflag;
    }

    public void setPlnflag(String plnflag) {
        this.plnflag = plnflag;
    }

    public String getPlna() {
        return plna;
    }

    public void setPlna(String plna) {
        this.plna = plna;
    }

    public String getPlnb() {
        return plnb;
    }

    public void setPlnb(String plnb) {
        this.plnb = plnb;
    }

    public String getPlnc() {
        return plnc;
    }

    public void setPlnc(String plnc) {
        this.plnc = plnc;
    }

    public String getPlnd() {
        return plnd;
    }

    public void setPlnd(String plnd) {
        this.plnd = plnd;
    }

    public String getPlne() {
        return plne;
    }

    public void setPlne(String plne) {
        this.plne = plne;
    }

    public String getPlnf() {
        return plnf;
    }

    public void setPlnf(String plnf) {
        this.plnf = plnf;
    }

    public String getPlng() {
        return plng;
    }

    public void setPlng(String plng) {
        this.plng = plng;
    }

    public String getPlnh() {
        return plnh;
    }

    public void setPlnh(String plnh) {
        this.plnh = plnh;
    }

    public String getFlag1() {
        return isFlag1;
    }

    public void setFlag1(String flag1) {
        isFlag1 = flag1;
    }

    public String getFlag2() {
        return isFlag2;
    }

    public void setFlag2(String flag2) {
        isFlag2 = flag2;
    }

    public String getFlag3() {
        return isFlag3;
    }

    public void setFlag3(String flag3) {
        isFlag3 = flag3;
    }

    public String getFlag4() {
        return isFlag4;
    }

    public void setFlag4(String flag4) {
        isFlag4 = flag4;
    }

    public String getFlag5() {
        return isFlag5;
    }

    public void setFlag5(String flag5) {
        isFlag5 = flag5;
    }

    public String getUrlax() {
        return urlax;
    }

    public void setUrlax(String urlax) {
        this.urlax = urlax;
    }

    public String getEmailax() {
        return emailax;
    }

    public void setEmailax(String emailax) {
        this.emailax = emailax;
    }

    public void reset(){
        afiliacion = IConstantes.CADENA_VACIA;
        banco = IConstantes.CADENA_VACIA;
        origen = IConstantes.CADENA_VACIA;
        marca = IConstantes.CADENA_VACIA;
        producto = IConstantes.CADENA_VACIA;
        bin = IConstantes.CADENA_VACIA;
        clavecre = IConstantes.CADENA_VACIA;
        giro = IConstantes.CADENA_VACIA;
        grupo = IConstantes.CADENA_VACIA;
        valorcre = IConstantes.CADENA_VACIA;
        clavedeb = IConstantes.CADENA_VACIA;
        valordeb = IConstantes.CADENA_VACIA;
        fecha = IConstantes.CADENA_VACIA;
        idu = IConstantes.CADENA_VACIA;
        bind = IConstantes.CADENA_VACIA;
        clavecred = IConstantes.CADENA_VACIA;
        clavedebd = IConstantes.CADENA_VACIA;
        valordebd = IConstantes.CADENA_VACIA;
        girod = IConstantes.CADENA_VACIA;
        grupod = IConstantes.CADENA_VACIA;
        idd = IConstantes.CADENA_VACIA;
        sic = IConstantes.CADENA_VACIA;
        fecnrl = IConstantes.CADENA_VACIA;
        fecnrll = IConstantes.CADENA_VACIA;
        plnflag = IConstantes.CADENA_VACIA;
        plna = IConstantes.CADENA_VACIA;
        plnb = IConstantes.CADENA_VACIA;
        plnc = IConstantes.CADENA_VACIA;
        plnd = IConstantes.CADENA_VACIA;
        plne = IConstantes.CADENA_VACIA;
        plnf = IConstantes.CADENA_VACIA;
        plng = IConstantes.CADENA_VACIA;
        plnh = IConstantes.CADENA_VACIA;
        isFlag1 = IConstantes.CADENA_VACIA;
        isFlag2 = IConstantes.CADENA_VACIA;
        isFlag3 = IConstantes.CADENA_VACIA;
        isFlag4 = IConstantes.CADENA_VACIA;
        isFlag5 = IConstantes.CADENA_VACIA;
        urlax = IConstantes.CADENA_VACIA;
        emailax = IConstantes.CADENA_VACIA;

        accion = IConstantes.CADENA_VACIA;
        if(resultados == null){
            resultados = new ArrayList();
        }else{
            resultados.clear();
        }
    }
}
