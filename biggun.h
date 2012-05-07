
#ifndef BIGGUNS
#define BIGGUNS

typedef struct {
    int size;
    int exp;
    int *digits;
} Biggun;


Biggun	*newB(char *n);
char	*showB (Biggun *x);
Biggun	*Badd(Biggun *x, Biggun *y);
Biggun	*Bmul(Biggun *x, Biggun *y);
Biggun	*Bdiv(Biggun *x, Biggun *y);
Biggun	*Bmod(Biggun *x, Biggun *y);
Biggun	*Bpow(int n, int exp);
char	*itos (int n);
char	itoc (int n);
int	ctoi (char c);
Biggun  *itoB (int n);
int	*reverse (int *x);
int	*append  (int *x, int *y, int start);
int	bigger(int x, int y);
void	padchoose (int x, int *xbuf, int y, int *ybuf);
void	padzero (int padding, int *buf);


#endif
