#include <iostream>

class Puntero {
    private:
        Foo* f;
    public:
        Puntero(Foo* foo) : f(foo) {}
        Foo* operator->() const { return f; }
};

class Foo {
public:
    void bar() {
        std::cout << "Acceso a Foo" << std::endl;
    }
};

int main() {
    Puntero p(new Foo);
    p->bar();

    return 0;
}