#include <iostream>

// Clase de ejemplo
class Foo {
public:
    void bar() {
        std::cout << "Acceso a Foo" << std::endl;
    }
};

template <typename Foo>
class Puntero {
private:
    Foo* f; // Puntero crudo al objeto
    int accessCount; // Contador de acceso al objeto

public:
    Puntero(Foo* foo) : f(foo), accessCount(0) {}

    // Operador de indirección ->
    Foo* operator->() {
        accessCount++;
        return f;
    }

    // Función para obtener el número de accesos
    int getAccessCount() const {
        return accessCount;
    }

    // Destructor
    ~Puntero() {
        delete f;
    }
};

int main() {
    Puntero<Foo> p(new Foo());

    p->bar();
    p->bar();

    std::cout << "Número de accesos al objeto: " << p.getAccessCount() << std::endl;

    return 0;
}