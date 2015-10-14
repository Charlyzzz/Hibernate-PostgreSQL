package dominio

import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import org.eclipse.xtend.lib.annotations.Accessors

@Entity
@Accessors
class Persona {

	@Id
	@GeneratedValue
	long id

	String nombre
	int edad

	new(String nomb, int edad) {
		this.nombre = nomb
		this.edad = edad

	}

	// Es necesario tener accessors y un constructor vacio para que funcione hibernate
	// Esto significa que tiene que ser un JAVA Bean
	new() {
	}

	override toString() {
		"Hola!, soy " + this.nombre + " y tengo " + this.edad + " años"
	}

}