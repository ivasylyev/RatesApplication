using Confluent.Kafka;
using RatesModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;



using Confluent.Kafka.SyncOverAsync;


using System.ComponentModel.DataAnnotations;
using System.Threading;
using System.Threading.Tasks;
using Newtonsoft.Json;
using static Confluent.Kafka.ConfigPropertyNames;

namespace RatesKafkaAdapter
{
    public class RatesKafkaProducer : IRatesKafkaProducer
    {
        IProducer<string, string> producer;
        string topicName = "My_Topic";
        string brokerList = "brokerList";
        public RatesKafkaProducer()
        {
            var config = new ProducerConfig { BootstrapServers = brokerList };
             producer = new ProducerBuilder<string, string>(config).Build();
            Console.WriteLine($"{producer.Name} producing on {topicName}. Enter first names, q to exit.");

        }

        public async Task SendRate(RateListItemDto rate)
        {
            try
            {
                var value = JsonConvert.SerializeObject(rate);
                // TODO: uncomment
               // await producer.ProduceAsync(topicName, new Message<string, string> { Value = value });
            }
            catch (Exception e)
            {
                Console.WriteLine($"error producing message: {e.Message}");
            }
            await Task.Yield();
        }

        
    }
}
