
#ifndef BIGGUNS
#define BIGGUNS

typedef struct {
    int size;
    int exp;
    char* digits;
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
char	*reverse_s (char *s);
int	bigger(int x, int y);
void	padchoose (int x, char *xbuf, int y, char *ybuf);
void	padzero (int padding, char *buf);


#endif
