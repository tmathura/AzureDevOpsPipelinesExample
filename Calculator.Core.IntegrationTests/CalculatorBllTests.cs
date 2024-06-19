namespace Calculator.Core.IntegrationTests
{
    public class CalculatorBllTests
    {
        private readonly CalculatorBll _calculatorBll;

        public CalculatorBllTests()
        {
            var additionBll = new AdditionBll();
            _calculatorBll = new CalculatorBll(additionBll);
        }

        [Fact]
        public void Add_Test1()
        {
            // Arrange
            const int a = 1;
            const int b = 2;
            const int expected = 3;

            // Act
            var actual = _calculatorBll.Add(a, b);

            // Assert
            Assert.Equal(expected, actual);
        }
    }
}