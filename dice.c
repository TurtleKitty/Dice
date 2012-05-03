
#include <stdio.h>
#include <string.h>


void spit (char* x) {
    printf("%s\n", x);
}


int main (int argc, char* argv[]) {
    int constant = 0;

    for (int i = 1; i < argc; i++) {
	if (strchr(argv[i], 'd')) {
	    spit(strtok(argv[i], "d"));
	}
	else {
	    constant += (int)argv[i];
	}
    }

    return 0;
}


int *mkroll (int n, int d) {
    int a[n];

    for (int i = 0; i < n; i++) {
	int b[d+1];

	b[0] = 0;

	for (int j = 1; j <= d; j++) {
	    b[j] = 1;
	}

	a[i] = b;
    }

    return *a;
}


