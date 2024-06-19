namespace Calculator.Core.UnitTests
{
    public class AdditionBllTests
    {
        private readonly IAdditionBll _additionBll = new AdditionBll();

        [Fact]
        public void Add_Test1()
        {
            // Arrange
            const int a = 1;
            const int b = 2;
            const int expected = 3;

            // Act
            var actual = _additionBll.Add(a, b);

            // Assert
            Assert.Equal(expected, actual);

        }
    }
}