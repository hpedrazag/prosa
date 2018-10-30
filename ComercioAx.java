/*
#java
################################################################################
# Nombre del Programa : ComercioAx.java                                       #
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

package mx.com.prosa.bdu.dmn.mantenimiento.ter;

import mx.com.prosa.bdu.dmn.mantenimiento.catalogo.banco.light.IBancoLight;
import java.util.Date;

/**
 * Created by IntelliJ IDEA.
 * To change this template use File | Settings | File Templates.
 */
public class ComercioAx {
    private Long oid;
    private Long afiliacion;
    private IBancoLight banco;
    private String fiid;
    private String origen;
    private String marca;
    private String producto;
    private String bin;
    private String clavecre;
    private Double valorcre;
    private String clavedeb;
    private String valordeb;
    private String sic;
    private Date fecha;
    private String giro;
    private String grupo;
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
    /* Terminacion: P-20-0115-16 D122 */
    private String urlax;
    private String emailax;

    public Long getOid() {
        return oid;
    }

    public void setOid(Long oid) {
        this.oid = oid;
    }

    public Long getAfiliacion() {
        return afiliacion;
    }

    public void setAfiliacion(Long afiliacion) {
        this.afiliacion = afiliacion;
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

    public Double getValorcre() {
        return valorcre;
    }

    public void setValorcre(Double valorcre) {
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

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
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

    public String getSic() {
        return sic;
    }

    public void setSic(String sic) {
        this.sic = sic;
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

    public IBancoLight getBanco() {
        return banco;
    }

    public void setBanco(IBancoLight banco) {
        this.banco = banco;
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
}
