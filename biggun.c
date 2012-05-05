
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "biggun.h"


int main (int argc, char* argv[]) {
    printf("\n");
    Biggun *x = newB(argv[1]);
    Biggun *y = newB(argv[2]);
    printf("%s\n\n", showB( Badd(x,y) ));
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
    noob->size	 = (int)strlen(integral) + (int)strlen(fractional) + 1; 
    noob->digits = calloc(noob->size, sizeof(char));
    char buf[noob->size + 2];
    snprintf(buf, noob->size, "%s%s", integral, fractional);
    noob->digits = reverse_s(buf);

    return noob;
}


char *showB (Biggun *x) {
    char *output;
    int sz = x->size + 2;
    char *tmp;
    tmp = reverse_s(x->digits);

    output = calloc(sz, sizeof(char));

    int i;
    for (i = 0; i <= x->exp; i++) {
	output[i] = tmp[i];
    }

    if (! (i+1 == x->size)) {
	output[i] = '.';
	i++;

	for (int j = i - 1; j < x->size; j++) {
	    output[i] = tmp[j];
	    i++;
	}
    }

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

    // 398000.01         exp 5 size 8
    //     30.010257924  exp 1 size 11

    int size  = bigger(xs, ys) + 1;

    char *xpad, *ypad, *rval;

    xpad = calloc(size, sizeof(char));
    ypad = calloc(size, sizeof(char));
    rval = calloc(size, sizeof(char));

    padchoose(xleft, xpad, yleft, ypad);

    strcat(xpad, x->digits);
    strcat(ypad, y->digits);

    padchoose(xright, xpad, yright, ypad);

    int exp  = bigger(xe, ye);
    int end  = strlen(xpad);
    int rem  = 0;

printf("xpad: %s\nypad: %s\n\n", xpad, ypad);

    int i;
    for (i = 0; i < end; i++) {
	char xd  = xpad[i];
	char yd  = ypad[i];
	int ndig = ctoi(xd) + ctoi(yd) + rem;

	if (ndig > 9) {
	    ndig -= 10;
	    rem = 1;
	}
	else {
	    rem = 0;
	}

	*(rval + i) = itoc(ndig);
    }

    if (rem > 0) {
	rval[i] = '1';
	exp++;
    }

    Biggun *noob = newB(reverse_s(rval));
    noob->exp = exp; // necessary because the string passed had no radix point.

    free(xpad);
    free(ypad);

    return noob;
}


Biggun *Bmul(Biggun *x, Biggun *y) {
    Biggun *noob = newB("0");
    return noob;
}


Biggun *Bdiv(Biggun *x, Biggun *y) {
    Biggun *noob = newB("0");
    return noob;
}


Biggun *Bpower (int n, int exp) {
    Biggun *rval = newB("1");

    char* nstr = itos(n);

    for (int i = 1; i <= exp; i++) {
	rval = Bmul(rval, newB(nstr));
    }

    return rval;
}


char *itos (int n) {
    char *nstr;
    nstr = calloc(n, sizeof(char));
    snprintf(nstr, n, "%d", n);
    return nstr;
}


char itoc (int n)  { return (char) ('0' + n  ); }
int  ctoi (char c) { return (int)  ( c - '0' ); }


char *reverse_s (char *s) {
    int len = strlen(s);
    char *noob;
    noob = calloc(len, sizeof(char));

    for (int i = 0; i < len; i++) {
	*(noob + len -i -1) = *(s + i);
    }

    *(noob + len) = '\0';

    return noob;
}


int bigger(int x, int y) {
    if (x >= y) {
	return x;
    }
    else {
	return y;
    }
}


void padchoose (int x, char *xbuf, int y, char *ybuf) {
    // return(void) makes me feel dirty.

    if (x >= y) {
	padzero(x - y, ybuf);
    }
    else {
	padzero(y - x, xbuf);
    }
}


void padzero (int padding, char *buf) {
    int mark = strlen(buf);

    for (int i = mark; i < padding + mark; i++) {
	buf[i] = '0';
    }
}



