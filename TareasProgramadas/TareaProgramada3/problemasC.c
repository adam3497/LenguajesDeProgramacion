#include <stdio.h>

//
// debe compilar utilizando
// gcc -w problemasC.c -o problemas
// si no el compilador da errores y warnings
//

#define PRINTX printf("%d\n", x)

void pregunta1() { // Aritmética básica
	int x;
	x = - 3 + 4 * 5 - 6; PRINTX;
	x = 3 + 4 % 5 - 6; PRINTX;
	x = - 3 * 4 % - 6 / 5; PRINTX;
	x = ( 7 + 6 ) % 5 / 2; PRINTX;
}

void pregunta2() { // Asignación
	int x = 2, y, z;

	x *= 3 + 2; PRINTX;
	x *= y = z = 4; PRINTX;
	x = y == z; PRINTX;
	x == (y = z); PRINTX;
}

#define PRINT(int) printf("int = %d\n", int)

void pregunta3() { // Lógica y operadores de incremento
	int x, y, z;

	x = 2; y = 1; z = 0;
	x = x && y || z; PRINT(x);

	x = y = 1;
	z = x ++ - 1; PRINT(x), PRINT(z);
	z += - x ++ + ++ y; PRINT(x); PRINT(z);
	z = x / ++x; PRINT(z);
}

void pregunta4() { // Operadores de bits
	int x, y, z;

	x = 03; y = 02; z = 01;
	PRINT( x | y & z );
	PRINT( x | y & - z );
	PRINT( x ^ y & - z );
	PRINT( x & y && z);

	x = 1; y = -1;
	PRINT( ! x | x );
	PRINT( - x | x );
	PRINT( x ^ x );
	x <<= 3; PRINT(x);
	y <<= 3; PRINT(y);
	y >>= 3; PRINT(y);
}

void pregunta5() { // Operadores relacionales y condicionales
	int x=1, y=1, z=1;

	x += y += z;
	PRINT( x < y ? y : x );

	PRINT( x < y ? x ++ : y ++ );
	PRINT(x); PRINT(y);

	PRINT( z += x < y ? x ++ : y ++ );
	PRINT(y); PRINT(z);

	x=3; y=z=4;
	PRINT( (z >= y >= x) ? 1 : 0);
	PRINT( z >= y && y >= x );
}

#define PRINT3(x,y,z) printf(#x "=%d\t" #y "=%d\t" #z "=%d\n",x,y,z)

void pregunta6() { // Precedencia de operadores y evaluación
	int x, y, z;

	x = y = z = 1;
	++x || ++y && ++z; PRINT3(x,y,z);

	x = y = z = 1;
	++x && ++y || ++z; PRINT3(x,y,z);

	x = y = z = 1;
	++x && ++y && ++z; PRINT3(x,y,z);

	x = y = z = -1;
	++x && ++y || ++z; PRINT3(x,y,z);

	x = y = z = -1;
	++x || ++y && ++z; PRINT3(x,y,z);

	x = y = z = -1;
	++x && ++y && ++z; PRINT3(x,y,z);
}

#define PR(format,value) printf(#value " = %" #format "\t",(value))
#define NL putchar('\n')
#define PR1(f,x1) PR(f,x1), NL
#define PR2(f,x1,x2) PR(f,x1), PR1(f,x2)
#define PR3(f,x1,x2,x3) PR(f,x1), PR2(f,x2,x3)
#define PR4(f,x1,x2,x3,x4) PR(f,x1), PR3(f,x2,x3,x4)

char input7[] = "SSSWILTECH1\1\11W\1WALLMP1";

void pregunta7() { // switch, break continue
	int i, c;

	for ( i=2; (c=input7[i])!='\0'; i++) {
		switch (c) {
			case 'a' : putchar('i'); continue;
			case '1' : break;
			case  1  : while( (c=input7[++i])!='\1' && c!='\0') ;
			case  9  : putchar('S');
			case 'E' : case 'L': continue;
			default: putchar(c); continue;
		}
		putchar(' ');
	}
	putchar('\n');
}

int a8[] = {0,1,2,3,4};

void pregunta8() { // Vectores y punteros simples
	int i, *p;

	for( i=0; i <=4; i++ ) PR(d,a8[i]);
	NL;
	for( p= &a8[0]; p<=&a8[4]; p++)
		PR(d,*p);
	NL; NL;

	for ( p=&a8[0],i=1; i <=5; i++ )
		PR(d,p[i]);
	NL;
	for( p=a8,i=0; p+1<=a8+4; p++,i++ )
		PR(d,*(p+i));
	NL; NL;

	for ( p=a8+4; p>=a8; p--) PR(d,*p);
	NL;
	for ( p=a8+4,i=0; i<=4; i++ ) PR(d,p[-i]);
	NL;
	for ( p=a8+4; p >=a8; p-- ) PR(d,a8[p-a8]);
	NL;
}

int a9[]={0,1,2,3,4};
int *p9[] = {a9,a9+1,a9+2,a9+3,a9+4};
int **pp9=p9;

void pregunta9() { // vectores de punteros
	PR2(d,a9,*a9);
	PR3(d,p9,*p9,**p9);
	PR3(d,pp9,*pp9,**pp9);
	NL;

	pp9++; PR3(d,pp9-p9,*pp9-a9,**pp9);
	*pp9++; PR3(d,pp9-p9,*pp9-a9,**pp9);
	*++pp9; PR3(d,pp9-p9,*pp9-a9,**pp9);
	++*pp9; PR3(d,pp9-p9,*pp9-a9,**pp9);

	pp9=p9;
	**pp9++; PR3(d,pp9-p9,*pp9-a9,**pp9);
	*++*pp9; PR3(d,pp9-p9,*pp9-a9,**pp9);
	++**pp9; PR3(d,pp9-p9,*pp9-a9,**pp9);
}

int a10[3][3] = {
	{ 1, 2, 3 },
	{ 4, 5, 6 },
	{ 7, 8, 9 }
};

int *pa[3] = { a10[0], a10[1], a10[2] };
int *p10 = a10[0];

void pregunta10() { // multiples dimensiones
	int i;

	for( i=0; i<3; i++ )
		PR3(d, a10[i][2-i], *a10[i], *(*(a10+i)+i) );
	NL;

	for ( i=0; i<3; i++ )
		PR2(d, *pa[i], p10[i]);
}

char *c[] = {
	"ENTER",
	"NEW",
	"POINT",
	"FIRST"
};
char **cp[] = { c+3, c+2, c+1, c };
char ***cpp = cp;

void pregunta11() { // sopa de punteros
	printf("%s", **++cpp );
	printf("%s ", *--*++cpp+3 );
	printf("%s", *cpp[-2]+3 );
	printf("%s\n", cpp[-1][-1]+1 );
}

int main() {
	// pregunta1();
	//pregunta2();
	//pregunta3();
	//pregunta4();
	//pregunta5();
	//pregunta6();
	//pregunta7();
	//pregunta8();
	//pregunta9();
	//pregunta10();
	pregunta11();

	return 0;
}
