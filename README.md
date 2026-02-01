# Posts Challenge

Aplicación Flutter para visualizar posts y comentarios, demostrando buenas prácticas de desarrollo, manejo de estado robusto e integración con código nativo.

## 🏗 Arquitectura

El proyecto sigue los principios de **Clean Architecture** para garantizar la separación de incertidumbres, testabilidad y escalabilidad.

### Capas:
1.  **Domain (Dominio)**:
    *   Núcleo de la aplicación.
    *   Contiene **Entities** (objetos de negocio), **Use Cases** (lógica de negocio) y **Repository Interfaces** (contratos de datos).
    *   Es independiente de cualquier dependencia externa (Flutter, DB, API).

2.  **Data (Datos)**:
    *   Implementación de la capa de dominio.
    *   **Repositories Implementation**: Implementa las interfaces del dominio.
    *   **Data Sources**:
        *   _Remote_: Comunicación con APIs (JSONPlaceholder).
        *   _Local_: Persistencia de datos (SharedPreferences, Bases de datos).
    *   **Models**: DTOs que extienden de las entidades para manejar la serialización/deserialización JSON.

3.  **Presentation (Presentación)**:
    *   Manejo de la UI y el estado.
    *   **BLoC/Cubit**: Patrón de gestión de estado utilizado para separar la lógica de presentación de la UI.
    *   **Pages & Widgets**: Componentes visuales construidos con Flutter.

### Patrones y Herramientas:
*   **MVVM / BLoC**: Gestión reactiva del estado.
*   **Dependency Injection**: Uso de `get_it` e `injectable` para el manejo de dependencias.
*   **Functional Programming**: Uso de `fpdart` (`Either`) para un manejo de errores robusto.

## 🕊 Pigeon Setup

Este proyecto utiliza **Pigeon** para la comunicación segura y tipada entre Flutter y el código nativo (Android/iOS), específicamente para el manejo de Notificaciones Locales y permisos.

El archivo de definición se encuentra en: `pigeons/messages.dart`.

### Generar código nativo y Dart:

Ejecuta el siguiente comando en la raíz del proyecto para regenerar los archivos puente si modificas `messages.dart`:

```bash
dart run pigeon --input pigeons/messages.dart
```

Esto actualizará automáticamente:
*   `lib/core/native/generated/messages.g.dart` (Dart)
*   `android/app/src/main/kotlin/com/example/posts_challenge/Messages.g.kt` (Kotlin)
*   `ios/Runner/Messages.g.swift` (Swift)

## 🚀 Setup General

### Prerrequisitos
*   Flutter SDK (Stable)
*   Cocoapods (para iOS)
*   Android Studio / Xcode

### Instalación

1.  **Clonar el repositorio y obtener dependencias:**
    ```bash
    flutter pub get
    ```

2.  **Generar código (para JsonSerializable, Freezed, Mockito, etc.):**
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

3.  **Ejecutar la aplicación:**
    ```bash
    flutter run
    ```

## 🤖 Uso de IA

Este proyecto ha sido desarrollado asistido por Inteligencia Artificial para:
*   **Refactorización**: Optimización de imports y estructura de carpetas.
*   **Testing**: Generación de tests unitarios y solución de errores en mocks.
*   **Debugging**: Identificación y corrección de errores de compilación nativos (Kotlin/Swift) y lógica de UI (Scroll infinito).
*   **Documentación**: Generación de este README y traducción de comentarios.
