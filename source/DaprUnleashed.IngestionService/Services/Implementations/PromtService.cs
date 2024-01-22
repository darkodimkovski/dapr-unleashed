using Dapr.Client;
using DaprUnleashed.API.Services.Interfaces;
using DaprUnleashed.DomainModel;

namespace DaprUnleashed.API.Services.Implementations
{
    public class PromtService : IPromtService
    {
        private readonly DaprClient _daprClient;

        public PromtService(DaprClient daprClient)
        {
            _daprClient = daprClient;
        }

        public async Task<Promt> GetPromtAsync(Guid id, string type)
        {
            var metadata = new Dictionary<string, string> { { "partitionKey", type } };
            return await _daprClient.GetStateAsync<Promt>("promptstore", id.ToString(), metadata: metadata);
        }

        public async Task ProcessAsync(Promt promt)
        {
            var queueRequest = new QueueRequest() { Id = promt.id, Type = promt.Type };
            promt.StateTransitions.Add(new StateTransition() { State = "1. Send to transform", DateTime = DateTime.UtcNow });
            promt.StateTransitions.Add(new StateTransition() { State = "2. Save to storage", DateTime = DateTime.UtcNow });
            var metadata = new Dictionary<string, string> { { "partitionKey", promt.Type } };
            await _daprClient.SaveStateAsync("promptstore", promt.id.ToString(), promt, metadata: metadata);
            await _daprClient.PublishEventAsync("pubsub", "transform", queueRequest);
        }
    }
}
