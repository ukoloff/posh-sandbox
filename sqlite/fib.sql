With Fib(a, b) As (
  Select 0, 1
  Union All
  Select b, a+b From Fib
  Where a < 1000
)
Select a From Fib
