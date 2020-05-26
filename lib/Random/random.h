#ifndef _RANDOM_H_
#define _RANDOM_H_
struct random {
	unsigned int (*rnd) ();
	double (*rnd_double_range) (double, double);
	int (*rnd_int_range) (int, int);
	unsigned int (*randomize_seed_xy) (int, int);
};

extern struct random Random;
#endif
