[TOC]

## 隐式类型转换和显式类型转换。

- 隐式类型转换（标准转换）

  - 算数转换——在混合类型的算术表达式中, 最宽的数据类型成为目标转换类型

    ```C++
    int a = 1;
    double d = 10.0;
    auto result = 10 + a; //a被提升为double类型，因为double是最宽的
    ```

    转换原则：

    - 对于同类算术类型，如short 与 int，float 与 double，占用较小内存的类型将转换成另一类型。如 short+ int将被转换为 int + int。此种类型转换称为类型提升

    - 整形将转为浮点型。如 int+ double 将被转换为 double + double

    - 仅当无符号类型占用的内存小于有符号类型时，无符号类型才发生类型提升从而转为有符号类型，否则，有符号类型将转为无符号类型。

      例子：

      ```c++
      unsigned short a = 1;
      unsigned b = 1;
      cout << (a > -1) << " " << (b > -1) << endl; // 输出 1 0!
      ```

      

  - 赋值转换——目标类型是被赋值对象的类型

    ```C++
    int a = 1;
    double d = a; //a被转换为目标的类型double
    ```

    

  - 函数调用转换——目标转换类型为形参的类型

    ```c++
    #include <iostream>
    
    int func(double a) { return a + 10.0; }
    
    int main(int argc, char **argv) {
      int a = 10;
      int i = func(a); //a被转换为double类型
      std::cout << i << std::endl;
      return 0;
    }
    ```

    调用函数func的时候，实参a本来是int类型的，但是形参是double类型，因此a被转换成了double类型。

  - 函数返回转换——目标转换类型为函数的返回类型

    ```c++
    #include <iostream>
    
    int func(double a) { return a + 10.0; }
    
    int main(int argc, char **argv) {
      int a = 10;
      int i = func(a); //函数func的返回值类型是int，但是a+10.0的类型本来是double的，需要转换为int类型
      std::cout << i << std::endl;
      return 0;
    }
    ```

    

- 显式转换（强制转换cast）

  - C风格转换

    ```C++
    int a = 1;
    double b = (double)a;
    ```

  - C++风格转换——推荐使用这种风格的转换

    格式如下：**XXX_cast** < type-id > ( expression )

    - static_cast

      使用格式 :`static_cast<type-id>(expression)`

      static_cast是没有运行时类型检查确保转换的安全性的，需要开发人员确保转换的安全。

      - 能够隐式转换的地方，均可使用static_cast 进行转换
      - 如果类型不兼容，使用static_cast，编译器会报错

      例子：

      ```C++
      #include <iostream>
      
      class B {
        int m;
      
       public:
        B() : m(10) {}
        void hello() const { std::cout << "Hello world, this is B!\n"; }
      };
      
      class D : public B {
        int m;
      
       public:
        D() : m(11) {}
        void hello() const { std::cout << "Hello world, this is D!\n"; }
      };
      
      int main(int argc, char** argv) {
        int a = 10;
        double d1 = static_cast<double>(a);
        int a1 = static_cast<int>(d1);
        std::cout << d1 << std::endl;
      
        // char *pstr = "Hello World";
        // int *pi_error = static_cast<int*>(pstr);
      
        // downcast 演示
        D d;
        B& br = d;
        br.hello();
        D& dr = static_cast<D&>(br);
        dr.hello();
        // upcast 演示
        B b = static_cast<B>(d);
        b.hello();
        return 0;
      }
      ```

      输出：

      ```
      10
      Hello world, this is B!
      Hello world, this is D!
      Hello world, this is B!
      ```

      ​	禁止隐式转换的话，可以使用static_cast进行强制的转换：

      ```C++
      #include <iostream>
      
      class A {
       public:
        explicit A(int) {}
      };
      
      int main(int argc, char **argv) {
        // A a1 = 10; //explicit禁止了隐式类型转换
        A a2(10);
        A a1 = static_cast<A>(10);  // 强制转换允许
        return 0;
      }
      ```

      

    - reinterpret_cast

      使用格式：**reinterpret_cast <**` *new_type* `**> (**` *expression* `**)**

      reinterpret_cast相当于一个不受限版本的static_cast, reinterpret_cast通常用于指针和整型的转换或者一些内存级别的操作时候。因此，这个转换是存在风险的。

      > reinterpret_cast expression does not compile to any CPU instructions (except when converting between integers and pointers or on obscure architectures where pointer representation depends on its type). It is purely a compile-time directive which instructs the compiler to treat *expression* as if it had the type *new_type*.

    - dynamic_cast

      用于父类指针和子类指针之前的转换。如果是子类转换成父类，效果与static_cast是一样的，换言之，子类指针是可以转换成父类的。当父类指针转换为子类的指针的时候，就会做运行时的检查

      ```C++
      #include <iostream>
      
      class A {
        virtual void dummy() {} //要有一个虚函数，触发多态的机制
      };
      
      class B : public A {};
      
      int main(int argc, char** argv) {
        A* pa1 = new B();
        A* pa2 = new A();
      
        // 都不能通过编译
        // B* pb1 = pa1;
        // B* pb2 = pa2;
      
        // 我们可以看到static_cast可以进行强制类型转换的。只要B的公开继承与A，换言之B的对象可以访问到A的
        B* pb1 = static_cast<B*>(pa1);
        B* pb2 = static_cast<B*>(
            pa2);  //虽然可以转换，但是这个转换是危险的。没有运行时的检查
      
        B* pb11 = dynamic_cast<B*>(pa1);
        if (pb11) {
          std::cout << "pb11 got" << std::endl; // 这一行会被输出的
        }
      
        B* pb22 = dynamic_cast<B*>(pa2);
        if (pb22) {
          std::cout << "pb22 got" << std::endl; // 这一行是不会被输出的，因为pa2指向的对象是A
        }
        return 0;
      }
      ```

      

    - const_cast

      使用格式：**const_cast**<type-id> (expression)

      用于修改类型的const或者volatile的属性。除了const或volatile的修饰符外，type-id和expression的类型是必须一样的。

      ```C++
      #include <iostream>
      using namespace std;
      int main() {
        const int a = 20;
        const int* b = &a;
        cout << "old value is " << *b << endl; //输出20
        int* c = const_cast<int*>(b);
        *c = 40;
        cout << "new value is " << *b << endl; //输出40
        cout << "a is " << a << endl; //输出20
        return 0;
      }
      ```

      const_cast后生成的对象与原来的是不一样的。因此最后a的值是没有变化的。

      

## 编译器默认类型检查

编译器默认会对类型转换进行检查，包括隐式转换和static_cast的转换。不能通过编译检查的情况有：

- 父类的对象的指针绑定到子类上
- 基本数据类型的指针之前的转换

```C++
#include <iostream>

class A {};

class B : A {};

int main(int argc, char** argv) {
  A* pa = new A();

  // B* pb = pa; 这个会编译出错的，子类的指针不能指向父类

  // B* pb = static_cast<B*>(pa);
  // 这个也会编译出错。这里static_cast不能强制转换的原因是：B的实例不能访问到A的实例的成员。因为B不是public继承于A的。这跟C++的对象内存模型是有关系的，具体不展开讲

  // reinterpret_cast是不会做类型检查的，需要开发人员自己保证
  B* pb = reinterpret_cast<B*>(pa);
  delete pa;

  char *ptr = "Hello";
  //int *pint = ptr; 类型不同，编译出错
  //int *pint = static_cast<int*>(ptr);
  return 0;
}
```



```C++
#include <iostream>

class A {};

class B : public A {};

int main(int argc, char** argv) {
  A* pa1 = new B();
  A* pa2 = new A();

  // 都不能通过编译
  // B* pb1 = pa1;
  // B* pb2 = pa2;

  // 我们可以看到static_cast可以进行强制类型转换的。只要B的公开继承与A，换言之B的对象可以访问到A的
  B* pb1 = static_cast<B*>(pa1);
  B* pb2 = static_cast<B*>(pa2); //虽然可以转换，但是这个转换是危险的。没有运行时的检查

  /* 下面这种情况是不能用dynamic_cast的，因为dynamic_cast是用于多态父类指针转换为子类指针的。因为A没有虚函数，所以不存在多态的可能性。
         B* pb11 = dynamic_cast<B*>(pa1);
         if (pb11) {
                 std::cout << "pb11 got" << std::endl;

         }

         B* pb22 = dynamic_cast<B*>(pa2);
         if (pb11) {
                 std::cout << "pb22 got" << std::endl;
 */

  return 0;
}
```



