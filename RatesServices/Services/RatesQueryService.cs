﻿using Microsoft.Extensions.Logging;
using RatesServices.Models;

namespace RatesServices.Services
{
    public class RatesQueryService : Service, IRatesQueryService
    {
        private readonly string[] _cities =
        {
            "Архангельск", "Астрахань", "Белгород", "Биробиджан", "Благовещенск", "Брянск", "Великий Новгород",
            "Владимир", "Волгоград", "Вологда", "Воронеж", "Гатчина", "Екатеринбург", "Иваново", "Иркутск",
            "Калининград", "Калуга", "Кемерово", "Киров", "Кострома", "Красногорск", "Курган", "Курск", "Липецк",
            "Магадан", "Москва", "Мурманск", "Нижний Новгород", "Новосибирск", "Омск", "Орёл", "Оренбург", "Пенза",
            "Псков", "Ростов-на-Дону", "Рязань", "Самара", "Санкт-Петербург", "Саратов", "Смоленск", "Тамбов", "Тверь",
            "Томск", "Тула", "Тюмень", "Ульяновск", "Челябинск", "Южно-Сахалинск", "Ярославль"
        };

        private readonly LocationNode[] _nodes;
        private readonly ProductGroup[] _groups;

        public RatesQueryService(ILogger<Service> logger) : base(logger)
        {
            _nodes = Enumerable.Range(1, _cities.Length)
                .Select(index => new LocationNode(index, "A" + index.ToString("0000"), _cities[index - 1]))
                .ToArray();
            _groups = new ProductGroup[]
            {
                new(1, "T01", "Каучуки"),
                new(2, "T02", "Полиолефины"),
                new(3, "T03", "Наливная химия")
            };
        }

        public async IAsyncEnumerable<Rate> GetRatesAsync(int take = int.MaxValue, int skip = 0)
        {
            // to remove warning
            await Task.CompletedTask;

            int rateId = skip;

            var nodeFromInitialIndex = skip / (_nodes.Length + _groups.Length);
            for (int nodeFromIndex = nodeFromInitialIndex; nodeFromIndex < _nodes.Length; nodeFromIndex++)
            {
                var nodeFrom = _nodes[nodeFromIndex];
                var initialNodeToIndex = nodeFromIndex == nodeFromInitialIndex
                    ? skip % (_nodes.Length + _groups.Length)
                    : 0;

                for (int nodeToIndex = initialNodeToIndex; nodeToIndex < _nodes.Length; nodeToIndex++)
                {
                    var initialGroupIndex = nodeFromIndex == nodeFromInitialIndex && nodeToIndex == initialNodeToIndex
                        ? skip % _nodes.Length
                        : 0;

                    for (int groupIndex = initialGroupIndex; groupIndex < _groups.Length; groupIndex++)
                    {
                        rateId++;
                        if (rateId > take + skip)
                        {
                            yield break;
                        }

                        var nodeTo = _nodes[nodeToIndex];
                        var group = _groups[groupIndex];
                        var rate = new Rate()
                        {
                            RateId = rateId,
                            StartDate = new DateOnly(2024, 01, 01),
                            EndDate = new DateOnly(2024, 12, 31),
                            NodeFrom = nodeFrom,
                            NodeTo = nodeTo,
                            ProductGroup = group,
                            Value = 100.5m + nodeToIndex + nodeToIndex
                        };
                        yield return rate;
                    }
                }
            }
        }

        public async Task<int> GetRateCountAsync()
        {
            int l = _nodes.Length;
            int g = _groups.Length;
            return await Task.FromResult(l * l * g);
        }
    }
}