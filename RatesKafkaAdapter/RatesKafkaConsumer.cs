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
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using RatesDto;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;

namespace RatesKafkaAdapter
{
    public class RatesKafkaConsumer : KafkaService, IDisposable
    {
        private readonly IConsumer<Null, string> _consumer;
        public RatesKafkaConsumer(IOptions<KafkaOptions> options, ILogger<KafkaService> logger) : base(options, logger)
        {
            var config = new ConsumerConfig
            {
                GroupId = "test-consumer-group",
                BootstrapServers = Options.BrokerList,
                AutoOffsetReset = AutoOffsetReset.Earliest
            };

            _consumer = new ConsumerBuilder<Null, string>(config).Build();
            Logger.LogInformation($"{_consumer.Name} consuming on {Options.RatesForCalculationTopicName}.");
        }

        protected Task ExecuteAsync(CancellationToken stoppingToken)
        {
            return Task.Run(() => StartConsumerLoop(stoppingToken), stoppingToken);
        }



        public static void Main(string[] args)
        {
            var conf = new ConsumerConfig
            {
                GroupId = "test-consumer-group",
                BootstrapServers = "localhost:9092",
                // Note: The AutoOffsetReset property determines the start offset in the event
                // there are not yet any committed offsets for the consumer group for the
                // topic/partitions of interest. By default, offsets are committed
                // automatically, so in this example, consumption will only start from the
                // earliest message in the topic 'my-topic' the first time you run the program.
                AutoOffsetReset = AutoOffsetReset.Earliest
            };

            using (var c = new ConsumerBuilder<Ignore, string>(conf).Build())
            {
                c.Subscribe("my-topic");

                CancellationTokenSource cts = new CancellationTokenSource();
                Console.CancelKeyPress += (_, e) => {
                    e.Cancel = true; // prevent the process from terminating.
                    cts.Cancel();
                };

                try
                {
                    while (true)
                    {
                        try
                        {
                            var cr = c.Consume(cts.Token);
                            Console.WriteLine($"Consumed message '{cr.Value}' at: '{cr.TopicPartitionOffset}'.");
                        }
                        catch (ConsumeException e)
                        {
                            Console.WriteLine($"Error occured: {e.Error.Reason}");
                        }
                    }
                }
                catch (OperationCanceledException)
                {
                    // Ensure the consumer leaves the group cleanly and final offsets are committed.
                    c.Close();
                }
            }
        }

       
            private readonly string topic;
           

          

           
            private void StartConsumerLoop(CancellationToken cancellationToken)
            {
                kafkaConsumer.Subscribe(this.topic);

                while (!cancellationToken.IsCancellationRequested)
                {
                    try
                    {
                        var cr = this.kafkaConsumer.Consume(cancellationToken);

                        // Handle message...
                        Console.WriteLine($"{cr.Message.Key}: {cr.Message.Value}ms");
                    }
                    catch (OperationCanceledException)
                    {
                        break;
                    }
                    catch (ConsumeException e)
                    {
                        // Consumer errors should generally be ignored (or logged) unless fatal.
                        Console.WriteLine($"Consume error: {e.Error.Reason}");

                        if (e.Error.IsFatal)
                        {
                            // https://github.com/edenhill/librdkafka/blob/master/INTRODUCTION.md#fatal-consumer-errors
                            break;
                        }
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine($"Unexpected error: {e}");
                        break;
                    }
                }
            }

            public  void Dispose()
            {
                this.kafkaConsumer.Close(); // Commit offsets and leave the group cleanly.
                this.kafkaConsumer.Dispose();

            }
        
}
