kernel void add(
       int n,
       global const float *a,
       global const float *b,
       global float  *c
       )
{
    int i = get_global_id(0);
    if (i < n) {
       c[i] = a[i] + b[i];
    }
}
