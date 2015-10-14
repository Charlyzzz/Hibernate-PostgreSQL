package runnable

import persistencia.HomePersonas
import dominio.Persona
import java.util.List

class App {

	def static void main(String[] args) {
		// Solo usa tres mensajes: add(persona), delete(persona), personas y personas(nombre)
		var homePersonas = new HomePersonas()

		homePersonas.init()

		imprimir(homePersonas.getPersonas, "Todas las personas")
		imprimir(homePersonas.getPersonasNombreComo("Ma"), "Personas cuyo nombre contiene 'Ma'")
		imprimir(homePersonas.getPersonas(0, 15), "Personas entre 0 y 15 años")

	}

	//Imprimir el resultado
	static def imprimir(List<Persona> resultadoQuery, String textoQuery) {
		println
		println
		println
		print(textoQuery)
		println
		resultadoQuery.forEach[persona|println(persona)]
	}
}