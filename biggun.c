
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "biggun.h"


const int cell = sizeof(int);


int main (int argc, char* argv[]) {
    printf("\n");
    Biggun *x = newB(argv[1]);
    Biggun *y = newB(argv[2]);
    printf("%s\n%s\n\n", showB(x), showB(y));
    Biggun *z = Badd(x,y);
    Biggun *t = Bmul(x,y);
    printf("%s\n%s\n\n", showB(z), showB(t));
}


Biggun *newB (char *n) {
    Biggun *noob;

    noob = calloc(1, sizeof(Biggun));

    char *integral;
    char *fractional;

    // check for radix point
    if (strchr(n, '.')) {
	integral    = strtok(n, ".");
	fractional  = strtok(NULL, ".");
    }
    else {
	integral   = n;
	fractional = "";
    }

    noob->exp	 = (int)strlen(integral) - 1;
    noob->size	 = (int)strlen(integral) + (int)strlen(fractional);

    int sz	 = noob->size + 1;
    noob->digits = calloc(sz, cell);

    char cbuf[sz];
    int  ibuf[sz];

    snprintf(cbuf, sz, "%s%s", integral, fractional);

    for (int i = 0; i < sz; i++) {
	ibuf[i] = ctoi(cbuf[i]);
    }

    noob->digits = reverse(ibuf);

    return noob;
}


Biggun *mkB (int *digits) {
    Biggun *noob;

    noob = calloc(1, sizeof(Biggun));

    int sz = sizeof(digits) / cell;

    noob->size = sz;
    noob->exp  = sz - 1;
    noob->digits = digits;

    return noob;
}


char *showB (Biggun *x) {
    int  *tmp;
    char *output;

    int sz = x->size + 2;
    tmp = reverse(x->digits);

    output = calloc(sz, cell);

    int i;
    for (i = 0; i <= x->exp; i++) {
	output[i] = itoc(tmp[i]);
    }

    if (! (i == x->size)) {
	output[i] = '.';
	i++;

	for (int j = i - 1; j < x->size; j++) {
	    output[i] = itoc(tmp[j]);
	    i++;
	}
    }

    output[i] = '\0';

    return output;
}


Biggun *Badd(Biggun *x, Biggun *y) {
    int xe = x->exp;
    int ye = y->exp;
    int xs = x->size;
    int ys = y->size;

    int xleft  = xs - xe;
    int xright = xs - xleft;

    int yleft  = ys - ye;
    int yright = ys - yleft;

    int size  = bigger(xs, ys) + 1;

    int *xpad, *ypad, *rval;

    xpad = calloc(size, cell);
    ypad = calloc(size, cell);
    rval = calloc(size, cell);

    padchoose(xleft, xpad, yleft, ypad);

    append(xpad, x->digits, 0);
    append(ypad, y->digits, 0);

    padchoose(xright, xpad, yright, ypad);

    int exp  = bigger(xe, ye);
    int end  = sizeof(xpad) / cell;
    int rem  = 0;

    int i;
    for (i = 0; i < end; i++) {
	int xd  = xpad[i];
	int yd  = ypad[i];
	int ndig = xd + yd + rem;

	if (ndig > 9) {
	    ndig -= 10;
	    rem = 1;
	}
	else {
	    rem = 0;
	}

	*(rval + i) = ndig;
    }

    if (rem > 0) {
	rval[i] = 1;
	exp++;
    }

    Biggun *noob = mkB(rval);
    noob->exp = exp; // necessary because the string passed had no radix point.

    free(xpad);
    free(ypad);

    return noob;
}


Biggun *Bmul(Biggun *x, Biggun *y) {
    int xe = x->exp;
    int ye = y->exp;
    int xs = x->size;
    int ys = y->size;

    int xleft  = xs - xe;
    int xright = xs - xleft;

    int yleft  = ys - ye;
    int yright = ys - yleft;

    int size  = bigger(xs, ys) + 1;

    int *xpad, *ypad;

    xpad = calloc(size, cell);
    ypad = calloc(size, cell);

    padchoose(xleft, xpad, yleft, ypad);

    append(xpad, x->digits, 0);
    append(ypad, y->digits, 0);

    padchoose(xright, xpad, yright, ypad);

    int end = size - 1;
    int rem = 0;

    Biggun *noob = newB("0");
    Biggun *Bn   = newB("0");
    Bn->digits	 = calloc(xs + ys + 1, cell);

    for (int i = 0; i < end; i++) {
	rem = 0;

	Bn->exp	 = -1;
	Bn->size = 0;

	int k;
	for (k = 0; k < i; k++) {
	    Bn->exp++;
	    Bn->size++;
	    Bn->digits[k] = 0;
	}

	int j;
	for (j = 0; j < end; j++) {
	    int xij = xpad[i];
	    int yij = ypad[j];

	    if (xij == 0 || yij == 0) {
		j++;
		continue;
	    }

	    int n = xij * yij + rem;

	    if (n > 9) {
		rem = n / 10;
		n   = n % 10;
	    }

	    Bn->exp++;
	    Bn->size++;
	    Bn->digits[j + k] = n;
	}

	if (rem > 0) {
	    Bn->digits[ j + k ] = rem;
	}

	noob = Badd(noob, Bn);
    }

    free(xpad);
    free(ypad);

    return noob;
}


Biggun *Bdiv(Biggun *x, Biggun *y) {
    Biggun *noob = newB("0");
    return noob;
}


Biggun *Bpow (int n, int exp) {
    Biggun *rval = newB("1");

    for (int i = 1; i <= exp; i++) {
	rval = Bmul(rval, newB(itos(n)));
    }

    return rval;
}


char *itos (int x) {
    char *nstr; 
    nstr = calloc(x, cell);
    snprintf(nstr, x, "%d", x);
    return nstr;
}


char itoc (int n)  { return (char) ('0' + n  ); }
int  ctoi (char c) { return (int)  ( c - '0' ); }


Biggun *itoB (int n) {
    return newB(itos(n));
}


int *reverse (int *x) {
    int len = sizeof(x) / cell;
    int *noob;

    noob = calloc(len, cell);

    for (int i = 0; i < len; i++) {
	*(noob + len -i -1) = *(x + i);
    }

    return noob;
}


int *append (int *x, int *y, int start) {
    int xs = sizeof(x)/cell;
    int ys = sizeof(y)/cell;

    int *rval;
    rval = calloc(xs + ys, cell);

    int c;
    for (int i = 0; i < xs; i++) {
	rval[c] = x[i];
	c++; // lulz
    }

    c = start;
    for (int i = 0; i < ys; i++) {
	rval[c] = y[i];
	c++; // lulz
    }

    return rval; 
}


int bigger(int x, int y) {
    if (x >= y) {
	return x;
    }
    else {
	return y;
    }
}


void padchoose (int x, int *xbuf, int y, int *ybuf) {
    // return(void) makes me feel dirty.

    if (x > y) {
	padzero(x - y, ybuf);
    }
    else if (y > x) {
	padzero(y - x, xbuf);
    }
}


void padzero (int padding, int *buf) {
    int mark = sizeof(buf) / cell;

    for (int i = mark; i < padding + mark; i++) {
	buf[i] = 0;
    }
}



