# include <stdio.h>
# include <stdlib.h>
int fib(int n);
int main()
{   
    int n;
    printf("input n:");
    while(scanf("%d", &n))
        printf("fib(n) = %d\n", fib(n));
    return 0;
}
int fib(int n)
{
    if(n <= 2)
    {
        return 1;
    }
    else
    {
        return fib(n-1)+fib(n-2);
    }
}