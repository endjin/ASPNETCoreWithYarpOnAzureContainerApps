# Log Analytics Queries

## All container app logs
```
ContainerAppConsoleLogs_CL
| where Message != ''
| project TimeGenerated, ContainerAppName_s, Message
| order by TimeGenerated desc
```

## Yarp logs
```
ContainerAppConsoleLogs_CL
| where ContainerAppName_s == 'yarp' and Message != ''
| project TimeGenerated, Yarp_Logs=Message
| order by TimeGenerated desc
```

## UI logs
```
ContainerAppConsoleLogs_CL
| where ContainerAppName_s == 'ui' and Message != ''
| project TimeGenerated, UI_Logs=Message
| order by TimeGenerated desc
```

## Catalog service logs
```
ContainerAppConsoleLogs_CL
| where ContainerAppName_s == 'catalog-api' and Message != ''
| project TimeGenerated, CatalogApi_Logs=Message
| order by TimeGenerated desc
```

## Orders service logs
```
ContainerAppConsoleLogs_CL
| where ContainerAppName_s == 'orders-api' and Message != ''
| project TimeGenerated, OrdersApi_Logs=Message
| order by TimeGenerated desc
```