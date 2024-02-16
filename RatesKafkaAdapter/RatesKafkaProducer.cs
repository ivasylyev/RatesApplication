using RatesModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatesKafkaAdapter
{
    public class RatesKafkaProducer : IRatesKafkaProducer
    {
        public async Task SendRate(RateListItemDto rate)
        {
            await Task.Yield();
        }
    }
}
