//using Confluent.Kafka;
//using Confluent.SchemaRegistry.Serdes;
//using Confluent.SchemaRegistry;
//using RatesModels;
//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using System.Threading.Tasks;



//using Confluent.Kafka.SyncOverAsync;


//using System.ComponentModel.DataAnnotations;
//using System.Threading;
//using System.Threading.Tasks;
//using Newtonsoft.Json;

//namespace RatesKafkaAdapter
//{
//    public class RatesKafkaConsumer 
//    {
//        public async Task SendRate(RateListItemDto rate)
//        {
//            await Task.Yield();
//        }

        
//             async Task Main()
//            {
               

//                string bootstrapServers = "My_Server";
//                string schemaRegistryUrl = "http://json-schema.org/draft-07/schema#";
//                string topicName = "My_Topic";

//                var producerConfig = new ProducerConfig
//                {
//                    BootstrapServers = bootstrapServers
//                };

//                var schemaRegistryConfig = new SchemaRegistryConfig
//                {
//                    // Note: you can specify more than one schema registry url using the
//                    // schema.registry.url property for redundancy (comma separated list). 
//                    // The property name is not plural to follow the convention set by
//                    // the Java implementation.
//                    Url = schemaRegistryUrl
//                };

//                var consumerConfig = new ConsumerConfig
//                {
//                    BootstrapServers = bootstrapServers,
//                    GroupId = "json-example-consumer-group"
//                };

//                // Note: Specifying json serializer configuration is optional.
//                var jsonSerializerConfig = new JsonSerializerConfig
//                {
//                    BufferBytes = 100
//                };
            
//                CancellationTokenSource cts = new CancellationTokenSource();
//                var consumeTask = Task.Run(() =>
//                {
//                    using (var consumer =
//                        new ConsumerBuilder<string, RateListItemDto>(consumerConfig)
//                            .SetKeyDeserializer(Deserializers.Utf8)
//                            .SetValueDeserializer(new JsonDeserializer<RateListItemDto>().AsSyncOverAsync())
//                            .SetErrorHandler((_, e) => Console.WriteLine($"Error: {e.Reason}"))
//                            .Build())
//                    {
//                        consumer.Subscribe(topicName);

//                        try
//                        {
//                            while (true)
//                            {
//                                try
//                                {
//                                    var cr = consumer.Consume(cts.Token);
//                                    var user = cr.Message.Value;
//                                    //Console.WriteLine($"user name: {user.Name}, favorite number: {user.FavoriteNumber}, favorite color: {user.FavoriteColor}");
//                                }
//                                catch (ConsumeException e)
//                                {
//                                    Console.WriteLine($"Consume error: {e.Error.Reason}");
//                                }
//                            }
//                        }
//                        catch (OperationCanceledException)
//                        {
//                            consumer.Close();
//                        }
//                    }
//                });

                

               

//                using (var schemaRegistry = new CachedSchemaRegistryClient(schemaRegistryConfig))
//                {
//                    // Note: a subject name strategy was not configured, so the default "Topic" was used.
//                    var schema = await schemaRegistry.GetLatestSchemaAsync(SubjectNameStrategy.Topic.ConstructValueSubjectName(topicName));
//                    Console.WriteLine("\nThe JSON schema corresponding to the written data:");
//                    Console.WriteLine(schema.SchemaString);
//                }
//            }
        

//    }
//}
