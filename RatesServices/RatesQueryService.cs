using RatesModels;

namespace RatesServices
{
    public class RatesQueryService : IRatesQueryService
    {
        private string[] _cities =
            {

"Архангельск"
,"Астрахань"
,"Белгород"
,"Биробиджан"
,"Благовещенск"
,"Брянск"
,"Великий Новгород"
,"Владимир"
,"Волгоград"
,"Вологда"
,"Воронеж"
,"Гатчина"
,"Екатеринбург"
,"Иваново"
,"Иркутск"
,"Калининград"
,"Калуга"
,"Кемерово"
,"Киров"
,"Кострома"
,"Красногорск"
,"Курган"
,"Курск"
,"Липецк"
,"Магадан"
,"Москва"
,"Мурманск"
,"Нижний Новгород"
,"Новосибирск"
,"Омск"
,"Орёл"
,"Оренбург"
,"Пенза"
,"Псков"
,"Ростов-на-Дону"
,"Рязань"
,"Самара"
,"Санкт-Петербург"
,"Саратов"
,"Смоленск"
,"Тамбов"
,"Тверь"
,"Томск"
,"Тула"
,"Тюмень"
,"Ульяновск"
,"Челябинск"
,"Южно-Сахалинск"
,"Ярославль"
            };

        private LocationNodeDto[] _nodes;
        public RatesQueryService()
        {
            _nodes = Enumerable.Range(1, _cities.Length)
                    .Select(index => new LocationNodeDto(index, "A" + index.ToString("0000"), _cities[index - 1]))
                    .ToArray();

        }

        public async IAsyncEnumerable<RateListItemDto> GetRatesAsync(int take = int.MaxValue, int skip = 0)
        {

            int rateId = skip;

            var nodeFromInitialIndex = skip / _nodes.Length;
            for (int nodeFromIndex = nodeFromInitialIndex; nodeFromIndex < _nodes.Length; nodeFromIndex++)
            {
                var nodeFrom = _nodes[nodeFromIndex];
                var initialNodeToIndex = nodeFromIndex == nodeFromInitialIndex
                    ? skip % _nodes.Length
                    : 0;

                for (int nodeToIndex = initialNodeToIndex; nodeToIndex < _nodes.Length; nodeToIndex++)
                {
                    rateId++;
                    if (rateId > take + skip)
                    {
                        yield break;
                    }

                    var nodeTo = _nodes[nodeToIndex];
                    var rate = new RateListItemDto()
                    {
                        RateId = rateId,
                        StartDate = new DateOnly(2024, 01, 01),
                        EndDate = new DateOnly(2024, 12, 31),
                        NodeFrom = nodeFrom,
                        NodeTo = nodeTo,
                        Value = 100.5m + nodeToIndex + nodeToIndex
                    };
                    yield return rate;
                }
            }
        }

        public async Task<int> GetRateCountAsync()
        {
            int l = _nodes.Length;
            return await Task.FromResult(l * l);
        }
    }
}
