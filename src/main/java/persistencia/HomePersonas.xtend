package persistencia

import dominio.Persona
import java.util.List
import org.hibernate.HibernateException
import org.hibernate.Query
import org.hibernate.Session
import org.hibernate.SessionFactory
import org.hibernate.cfg.Configuration
import org.hibernate.criterion.Restrictions

class HomePersonas {

	def init() {

		vaciarTabla

		var maggie = new Persona("Maggie", 23)
		var mariano = new Persona("Mariano", 21)
		var erwin = new Persona("Erwin", 22)
		var dolo = new Persona("Dolores", 14)
				

		this.add(maggie)
		this.add(mariano)
		this.add(erwin)
		this.add(dolo)

	}

	def vaciarTabla() {
		val session = sessionFactory.openSession
		var Query query = session.createQuery("delete from Persona")
		query.executeUpdate
	}

	def void add(Persona unaPersona) {
		this.executeBatch([session|(session as Session).save(unaPersona)])
	}
	
	def void delete(Persona unaPersona) {
		this.executeBatch([session|(session as Session).delete(unaPersona)])
	}

	def getPersonas(int edadMin,int edadMax) {
		
		var List<Persona> resultados = null

		val session = sessionFactory.openSession

		try {
			// Esto es equivalente a hacer SELECT * FROM PERSONA WHERE nombre LIKE %nombreABuscar%
			// Restrictions tiene la lista de las cosas para filtrar	
			var query = session.createCriteria(Persona).add(Restrictions.between("edad",edadMin,edadMax))
			resultados = query.list // La ejecuta
		} catch (HibernateException e) {
			throw new RuntimeException(e)
		} finally {
			session.close
		}

		resultados

	}

	def getPersonasNombreComo(String nombreParecido) {

		var List<Persona> resultados = null

		val session = sessionFactory.openSession

		try {
			// Esto es equivalente a hacer SELECT * FROM PERSONA WHERE nombre LIKE %nombreABuscar%
			// Restrictions tiene la lista de las cosas para filtrar	
			var query = session.createCriteria(Persona).add(Restrictions.like("nombre", "%" + nombreParecido + "%"))
			resultados = query.list // La ejecuta
		} catch (HibernateException e) {
			throw new RuntimeException(e)
		} finally {
			session.close
		}

		resultados
	}

	def getPersonas() {

		var List<Persona> resultados = null

		val session = sessionFactory.openSession

		try {

			var Query query = session.createQuery("from Persona")
			resultados = query.list // La ejecuta
		} catch (HibernateException e) {
			throw new RuntimeException(e)
		} finally {
			session.close
		}

		resultados
	}

	/* 
	 * De acá para abajo está el código necesario para hablarle a hibernate en vez de guardar en memoria
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 
	 */
	 
	 
	 
	 
	private static final SessionFactory sessionFactory = new Configuration().configure().addAnnotatedClass(Persona).
		buildSessionFactory()


	/* Necesitamos siempre hacer lo mismo:
	 * 1) abrir la sesión
	 * 2) ejecutar un query que actualice
	 * 3) commitear los cambios 
	 * 4) y cerrar la sesión
	 * 5) pero además controlar errores
	 * Entonces definimos un método executeBatch que hace eso
	 * y recibimos un closure que es lo que cambia cada vez
	 * (otra opción podría haber sido definir un template method)
	 */
	/**
	 * executeBatch recibe como parametro un closure o expresion lambda:
	 * esa expresion recibe como unico parametro una session y lo aplica a un
	 * bloque que no devuelve nada (void)
	 */
	private def void executeBatch((Session)=>void closure) {
		val session = sessionFactory.openSession
		try {
			session.beginTransaction
			closure.apply(session)
			session.transaction.commit
		} catch (HibernateException e) {
			session.transaction.rollback
			throw new RuntimeException(e)
		} finally {
			session.close
		}
	}

}