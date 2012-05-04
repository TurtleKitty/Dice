
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef unsigned long long int biggun;
typedef long double ldub;

typedef struct {
    int degree;
    biggun *coeffz;
} Poly;


Poly *mkpoly(int d);
Poly **mkroll(int n, int d);
Poly *poly_mul(Poly *x, Poly *y);
char *mkpounds(ldub n);
biggun power(int n, int exp);
void debug(int min, int max, biggun cmb, Poly *p);


int main (int argc, char* argv[]) {
    int min = 0;
    int max = 0;

    biggun cmb		= 1;
    long int constant	= 0;
    int nrolls		= 0;

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
	    constant += atol(argv[i]);
	}
    }

    for (int i = 0; i < nrolls; i++) {
	int n = rolls[i][0];
	int d = rolls[i][1];

	min += n;
	max += n*d;
	cmb *= power(d, n);
    }

    Poly **polys;
    polys = calloc(min, sizeof(Poly *));

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

    // debug(min, max, cmb, biggie); 

    for (int i = min; i <= biggie->degree; i++) {
	long n = i + constant;
	ldub p = (ldub) biggie->coeffz[i] / (ldub) cmb;
	char *hg = mkpounds(p);

	printf("%ld\t\t%.5Lf\t\t%s\n", n, p, hg);
    }

    return 0;
}


Poly *mkpoly (int d) {
    Poly *p;

    p = calloc(1, sizeof(Poly));
    p->degree = d;
    p->coeffz = calloc((d + 1), sizeof(biggun));

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
    noob->coeffz = calloc(noob->degree + 1, sizeof(biggun));

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


biggun power (int n, int exp) {
    biggun result = 1;

    for (int i = 1; i <= exp; i++) {
	result *= n;
    }

    return result;
}


char *mkpounds (ldub n) {
    int num = (int) (0.5 + (500 * n));
    char *rv;

    if (num == 0) return "";

    rv = calloc(num + 1, sizeof(char));

    for (int i = 0; i < num; i++) {
	rv[i] = '#';	
    }

    rv[num] = '\0';

    return rv;
}


void debug(int min, int max, biggun cmb, Poly *p) {
    printf("Range: %d - %d\tCombinations: %Lu | %Lf\n", min, max, cmb, (ldub) cmb);

    for (int i = min; i <= p->degree; i++) {
	printf("%d\t%Lu\n", i, p->coeffz[i]);
    }
}


