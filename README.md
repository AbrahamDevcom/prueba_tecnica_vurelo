# 🎬 Flutter Movies App

Aplicación móvil desarrollada en **Flutter** como parte de la prueba técnica.
La app consume la API de [TMDb](https://developers.themoviedb.org) y presenta funcionalidades de exploración y detalle de películas.

---

## 🚀 Tecnologías y librerías principales

* **Flutter** (SDK actual)
* **Riverpod** – gestor de estado principal, con `AsyncValue` para manejar loading, success y error de forma reactiva.
* **Dio** – cliente HTTP con interceptores.
* **Hive** – cache local para contenido offline.
* **Flutter Dotenv** – para manejo de variables de entorno y claves sensibles.
* **Mockito / Mocktail** – mocks para pruebas unitarias.
* **Flutter Test** – framework de testing integrado.

---

## 🏗️ Arquitectura

El proyecto sigue una arquitectura **semi-clean** con enfoque **feature-first**, organizada en **núcleo (`core`)** y **features**:

```
lib/
│
├── core/                       # Núcleo de la aplicación
│   ├── constants/              # Constantes y configuraciones globales
│   ├── di/                     # Providers globales (inyección de dependencias)
│   ├── models/                 # Modelos de dominio y data
│   ├── repositories/           # Contratos e implementaciones de repositorios
│   ├── services/               # Servicios de API, cache, data sources
│   └── usecases/               # Casos de uso (lógica de negocio)
│
├── features/
│   └── movies/                 # Feature principal: películas
│       ├── controllers/        # Controladores (estado con Riverpod)
│       ├── screens/            # Pantallas principales
│       └── widgets/            # Widgets específicos del feature
│
├── main.dart                   # Punto de entrada
└── theme.dart                  # Configuración de tema global
```

### 🔑 Principios aplicados

* **Separación clara de capas**:

  * `core` contiene la lógica central y compartida.
  * `features` encapsula presentación y controladores por módulo.
* **Feature-first**: cada funcionalidad mantiene sus pantallas y lógica de presentación aisladas.
* **Riverpod** como gestor de estado:

  * Providers definidos en `controllers`.
  * Manejo de `AsyncValue` para estados de loading, éxito y error.
* **Modularidad y desacoplamiento**: los `usecases` dependen de repositorios, no de servicios concretos.

---

## ⚡️ Funcionalidades implementadas

* **Categorías en scroll horizontal**:

  * Próximos estrenos
  * Tendencia

* **Recomendados para ti**:

  * Basados en la categoría **Tendencia**.
  * Filtro por **idioma** y **año de lanzamiento**.
  * Grid con un máximo de 6 películas.

* **Detalle de película**:

  * Título, descripción, fecha de estreno, imagen, puntuación y géneros.
  * Botón opcional para ver tráiler.

* **Cache offline**:

  * El contenido previamente cargado se muestra aún sin conexión.

* **Animaciones y transiciones**:

  * Navegación fluida y loaders animados.

---

## 🧪 Testing

El proyecto incluye **tests unitarios** organizados de acuerdo a la misma arquitectura:

```
test/
│
├── core/
│   ├── repositories/           # Tests de repositorios (cache + API)
│   └── usecases/               # Tests de casos de uso
│
└── features/
    └── movies/                 # Tests de providers y widgets de UI
```

Ejemplos incluidos:

* **Use Cases**: `get_trending_movies_test.dart` valida la lógica de negocio.
* **Repositories**: `movie_repository_test.dart` asegura la correcta interacción entre cache y API.
* **Widgets**: tests de UI para validar comportamiento (ej. grid máximo de 6 películas).

Para correr los tests:

```bash
flutter test
```

Con cobertura:

```bash
flutter test --coverage
```

---

## 🔑 Variables de entorno

Se utiliza [`flutter_dotenv`](https://pub.dev/packages/flutter_dotenv) para manejar las claves sensibles.

Ejemplo de archivo `.env`:

```env
TMDB_API_KEY=tu_api_key
BASE_URL=https://api.themoviedb.org/3
```

El archivo `.env` **no se sube al repo** (está en `.gitignore`).

El archivo se adjunto en el correo enviado.

---

## 🧾 Criterios cubiertos

* ✅ Legibilidad y buenas prácticas
* ✅ Arquitectura escalable y modular
* ✅ Uso correcto de Riverpod como gestor de estado
* ✅ Manejo de estado y errores
* ✅ UI limpia y funcional
* ✅ Tests unitarios de casos de uso y repositorios

---
