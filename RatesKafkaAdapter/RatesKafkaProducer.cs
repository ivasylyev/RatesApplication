using Confluent.Kafka;
using Confluent.SchemaRegistry.Serdes;
using Confluent.SchemaRegistry;
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
        IProducer<string, RateListItemDto> producer;
        string topicName = "My_Topic";
        string bootstrapServers = "My_Server";
        public RatesKafkaProducer()
        {
        

           

            var producerConfig = new ProducerConfig
            {
                BootstrapServers = bootstrapServers
            };
            var schemaRegistryConfig = new SchemaRegistryConfig
            {
                // Note: you can specify more than one schema registry url using the
                // schema.registry.url property for redundancy (comma separated list). 
                // The property name is not plural to follow the convention set by
                // the Java implementation.
                Url = "http://json-schema.org/draft-07/schema#"
            };
            
            var schemaRegistry = new CachedSchemaRegistryClient(schemaRegistryConfig);
            producer =
                new ProducerBuilder<string, RateListItemDto>(producerConfig)
                    .SetValueSerializer(new JsonSerializer<RateListItemDto>(schemaRegistry))
                    .Build();


            Console.WriteLine($"{producer.Name} producing on {topicName}. Enter first names, q to exit.");

        }

        public async Task SendRate(RateListItemDto rate)
        {
            try
            {
                await producer.ProduceAsync(topicName, new Message<string, RateListItemDto> { Value = rate });
            }
            catch (Exception e)
            {
                Console.WriteLine($"error producing message: {e.Message}");
            }
            await Task.Yield();
        }

        
    }
}
