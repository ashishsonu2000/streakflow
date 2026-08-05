abstract interface class Calculator<I, O> {
  const Calculator();

  O calculate(I input);
}
