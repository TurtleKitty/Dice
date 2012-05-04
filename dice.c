
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct {
    int degree;
    int *coeffz;
} Poly;


Poly *mkpoly (int d);
Poly **mkroll (int n, int d);
Poly *poly_mul(Poly *x, Poly *y);
char *mkpounds(double n);
int  power(int n, int exp);


int main (int argc, char* argv[]) {
    int min = 0;
    int max = 0;
    int deg = 0;
    int cmb = 1;
    int constant = 0;
    int nrolls   = 0;
    int *rolls[argc];

    for (int i = 1; i < argc; i++) {
	if (strchr(argv[i], 'd')) {
	    int *roll;
	    int j = 0;

	    roll = calloc(2, sizeof(int));

	    for (
		char *token = strtok(argv[i], "d");
		token != NULL;
		token = strtok(NULL, "d")
	    ) {
		roll[j] = atoi(token);
		j++;
	    }

	    rolls[nrolls] = roll;
	    nrolls++;
	}
	else {
	    constant += atoi(argv[i]);
	}
    }

    for (int i = 0; i < nrolls; i++) {
	int n = rolls[i][0];
	int d = rolls[i][1];

	min += n;
	max += d;
	deg  = (deg >= d) ? deg : d;
	cmb *= power(d, n);
    }

    Poly **polys;
    polys = calloc(min, sizeof(int *));

    int k = 0;
    for (int i = 0; i < nrolls; i++) {
	int n = rolls[i][0];
	int d = rolls[i][1];

	Poly **list = mkroll(n,d);

	for (int j = 0; j < n; j++) {
	    polys[k] = list[j];
	    k++;
	}
    }

    Poly *biggie = polys[0];

    for (int i = 1; i < min; i++) {
	biggie = poly_mul(biggie, polys[i]);
    }

    for (int i = min; i <= biggie->degree; i++) {
	int n	 = i + constant;
	double p = (double) biggie->coeffz[i] / (double) cmb;
	char *hg = mkpounds(p);

	printf("%d\t\t%.5f\t\t%s\n", n, p, hg);
    }

    return 0;
}


Poly *mkpoly (int d) {
    Poly *p;

    p->degree = d;
    p->coeffz = calloc((d + 1), sizeof(int));

    for (int i = 1; i <= d; i++) {
	p->coeffz[i] = 1;
    }

    return p;
}


Poly **mkroll (int n, int d) {
    Poly **list;

    list = calloc(n, sizeof(Poly *));

    for (int i = 0; i < n; i++) {
	list[i] = mkpoly(d);
    }

    return list;
}


Poly *poly_mul (Poly *x, Poly *y) {
    Poly *noob;

    noob = calloc(1, sizeof(Poly));

    noob->degree = x->degree + y->degree;
    noob->coeffz = calloc(noob->degree + 1, sizeof(int *));

    for (int i = 0; i <= noob->degree; i++) {
	noob->coeffz[i] = 0;
    }

    for (int i = 1; i <= x->degree; i++) {
	for (int j = 1; j <= y->degree; j++) {
	    noob->coeffz[i+j] += x->coeffz[i] * y->coeffz[j];	    
	}
    }

    return noob;
}


int power (int n, int exp) {
    int result = 1;

    for (int i = 1; i <= exp; i++) {
	result *= n;
    }

    return result;
}


char *mkpounds (double n) {
    int num = (int) (0.5 + (500 * n));
    char *rv;
    rv = calloc(num + 1, sizeof(char));

    for (int i = 0; i < num; i++) {
	rv[i] = '#';	
    }

    rv[num] = '\0';

    return rv;
}





