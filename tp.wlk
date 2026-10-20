class Guerrero{
    const property potencialOfensivo
    const energiaInicial
    var experiencia = 0
    var energia = energiaInicial
    var property trajeEquipado
    
    
    method atacarGuerrero(otroGuerrero){
       otroGuerrero.recibirAtaque(potencialOfensivo)
    }

    method comerSemillaErmitanio(){
        energia = energiaInicial
    }

    method recibirAtaque(potencialAtacante){
        energia -= trajeEquipado.disminuirDanio(potencialAtacante *0.1)
        experiencia += trajeEquipado.aumentarExperiencia( 1 )
        trajeEquipado.aumentarDesgaste()
    }

    


      
}

class Traje{
    var desgaste = 0
    const maximoDesgaste = 100
    

    method aumentarDesgaste(){
        desgaste = (desgaste + 5).min(maximoDesgaste)
        
    }

    method estaGastado(){
       return desgaste >= 100
    }

    method cantidadElementos(){
        return 1
    }
}


class TrajeComun inherits Traje{
    const porcentajeProteccion

    method disminuirDanio(danioRecibido){
        if(not self.estaGastado()){
           return danioRecibido - danioRecibido * porcentajeProteccion
        }else{
           return danioRecibido
        }
    }

    method aumentarExperiencia(experiencia){
       return experiencia
    }
}

class TrajeEntrenamiento inherits Traje{
    const multiplicador = 2

    method aumentarExperiencia(experiencia){
       if(not self.estaGastado()){
       return experiencia * multiplicador
       }else{
       return experiencia
       }
    }

    method disminuirDanio(danioRecibido){
       return danioRecibido
    }

    
}

class TrajeModularizado inherits Traje{
    const piezas = []

    override method estaGastado(){
        return piezas.all({pieza => pieza.estaGastado()})
    }

    method disminuirDanio(danioRecibido){
        if(not self.estaGastado()){
        return danioRecibido - piezas.filter({pieza => not pieza.estaGastado()}).sum({pieza => pieza.resistencia()})
        }else{
            return danioRecibido
        }
    }

    method aumentarExperiencia(experiencia){
        return (piezas.count({pieza => not pieza.estaGastado()}) / piezas.size())  * experiencia
    }

    override method cantidadElementos(){
        return piezas.size()
    }

    override method aumentarDesgaste() {
    piezas.forEach({ pieza => pieza.aumentarDesgaste() })
}

}

class Pieza{
    var desgaste = 0
    const property resistencia

    
    method estaGastado(){
        return desgaste >= 20
    }

    method aumentarDesgaste() {
    desgaste += 5
}
    
}

class Torneo{
    const postulantes = []
    var property modalidad

    method postulantesFiltrados(){
        return modalidad.seleccionar(postulantes)
    }
}

object powerIsBest{
    method seleccionar(postulantes){
        const ordenados = postulantes.sortedBy({uno, otro => uno.potencialOfensivo() > otro.potencialOfensivo()})
        return ordenados.take(16)
    }
}

object funny{
    method seleccionar(postulantes){
        const ordenados = postulantes.sortedBy({uno, otro => uno.trajeEquipado().cantidadElementos() > otro.trajeEquipado().cantidadElementos()})
        return ordenados.take(16)
    }
}

object surprise {
    method seleccionar(postulantes) {
        const mezclados = postulantes.sortedBy({ uno, otro => [true, false].anyOne() })
        return mezclados.take(16)
    }
}
