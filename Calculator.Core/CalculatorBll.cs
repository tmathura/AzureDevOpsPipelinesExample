namespace Calculator.Core
{
    public class CalculatorBll(IAdditionBll additionBll)
    {

        public int Add(int a, int b)
        {
            return additionBll.Add(a, b);
        }

    }
}
