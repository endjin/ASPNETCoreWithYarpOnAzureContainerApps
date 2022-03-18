using DotNetOnContainerApps.Proxy;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddReverseProxy()
    .LoadFromConfig(builder.Configuration.GetSection("ReverseProxy"))
    .AddConfigFilter<CustomConfigFilter>();

builder.Services.AddApplicationInsightsTelemetry();
builder.Services.AddApplicationInsightsInstrumentationTelemetry();

var app = builder.Build();
app.MapReverseProxy();
app.Run();
