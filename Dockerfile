FROM  mcr.microsoft.com/dotnet/aspnet:7.0 AS base 
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["Mis.Services.Finance.Api/Mis.Services.Finance.Api.csproj", "."]
RUN dotnet restore "./Mis.Services.Finance.Api.csproj"
COPY . .
WORKDIR "/src/Mis.Services.Finance.Api/."
RUN dotnet build "Mis.Services.Finance.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Mis.Services.Finance.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
# Enable Datadog automatic instrumentation
# App is being copied to /app, so Datadog assets are at /app/datadog
ENV COR_ENABLE_PROFILING=1
ENV COR_PROFILER={846F5F1C-F9AE-4B07-969E-05C26BC060D8}
ENV COR_PROFILER_PATH=/app/datadog/win-x64/Datadog.Trace.ClrProfiler.Native.dll
ENV DD_DOTNET_TRACER_HOME=/app/datadog
ENV DD_LOGS_INJECTION=true
ENV DD_RUNTIME_METRICS_ENABLED=true
ENTRYPOINT ["dotnet", "Mis.Services.Finance.Api.dll","--environment=Development"]
