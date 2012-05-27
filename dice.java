

import java.lang.Long;
import java.util.HashMap;
import java.util.LinkedList;


public class dice {
    private static String nl = "\n";
    private static String tt = "\t\t";

    public static void main(String[] args) {
        HashMap params = parse(args);

	long adder = (Long) params.get("constant");
	double combos = (Double) params.get("combos");
	LinkedList<Poly> polys = (LinkedList<Poly>) params.get("polys");

	Poly result = Poly.unit();

	for (Poly p : polys) {
	    result = result.mul(p);
	}

	result = result.div(combos);

	StringBuilder sob = new StringBuilder();

	sob.append(nl);

	for (int i = polys.size(); i <= result.degree; i++) {
	    sob.append(
		String.format(
		    "%d\t\t%.5f\t\t%s\n",
		    (long)i + adder,
		    result.coeffz[i],
		    histogram(result.coeffz[i])
		)
	    );
	}

	System.out.println(sob.toString());
    }

    public static class Poly {
	public int degree;
	public double[] coeffz;

	public Poly(double[] yarr) {
	    coeffz = yarr;
	    degree = yarr.length - 1;
	}

	public static Poly unit() {
	    double[] unit = { 1.0 };
	    return new Poly(unit);
	}

	public static Poly mkroll(int die) {
	    double[] yarr = new double[die + 1];

	    yarr[0] = 0;

	    for (int i = 1; i <= die; i++) {
		yarr[i] = 1.0;
	    }

	    return new Poly(yarr);
	}

	public Poly mul(double scalar) {
	    double[] yarr = new double[degree + 1];

	    for (int i = 0; i <= degree; i++) {
		yarr[i] = coeffz[i] * scalar;
	    }

	    return new Poly(yarr);
	}

	public Poly mul(Poly other) {
	    int newD = degree + other.degree;
	    double[] yarr = new double[newD + 1];

	    for (int i = 0; i <= degree; i++) {
		for (int j = 0; j <= other.degree; j++) {
		    yarr[i + j] += coeffz[i] * other.coeffz[j];
		}
	    }

	    return new Poly(yarr);
	}

	public Poly div(double scalar) {
	    return mul( 1/scalar );
	}
    }

    private static HashMap parse(String[] args) {
	Long constant = 0L;
	Double combos = 1.0;
	LinkedList<Poly> polys = new LinkedList<Poly>();

	for (String arg : args) {
	    if (arg.indexOf('d') > 0) {
		// die roll
		String[] tmp = arg.split("d");
		int n  = Integer.parseInt(tmp[0]);
		int d = Integer.parseInt(tmp[1]);
		combos *= Math.pow((double)d, (double)n);

		for (int i = 0; i < n; i++) {
		    polys.add(Poly.mkroll(d));
		}
	    }
	    else {
		// constant
		constant += Integer.parseInt(arg);
	    }
	}

	HashMap rval = new HashMap();
	rval.put("constant", constant);
	rval.put("combos", combos);
	rval.put("polys", polys);

	return rval;
    }

    private static String histogram(double n) {
	int num = (int) (0.5 + (500.0 * n));

	char[] hg = new char[num];

	for (int i = 0; i < num; i++) {
	    hg[i] = '#';
	}

	return new String(hg);
    }
}



