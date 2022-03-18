param name string
param location string
param containerAppEnvironmentId string
param repositoryImage string
param envVars array = []
param allowExternalIngress bool = false
param allowInternalIngress bool = false
param targetIngressPort int = 80
param registry string
param registryUsername string
@secure()
param registryPassword string
@secure()
param appInsightsConnectionString string

// Handle whether to use an authenticated container registry
var registrySecret = empty(registryUsername) ? [] : array({
  name: 'container-registry-password'
  value: registryPassword
})

// Set-up the mandatory secret
var appInsightsConnectionStringSecretRefName = 'appinsights-connection-string'
var defaultSecrets = [
  {
    name: appInsightsConnectionStringSecretRefName
    value: appInsightsConnectionString
  }
]
// When using a private container registry credentials must be provided
var registries = empty(registryUsername) ? [] : array({
  server: registry
  username: registryUsername
  passwordSecretRef: 'container-registry-password'
})
// Merge all the required secrets
var finalSecrets = union(defaultSecrets, registrySecret)

// Setup the mandatory environment variables
var defaultEnvVars = [
  {
    name: 'ApplicationInsights__ConnectionString'
    secretRef: appInsightsConnectionStringSecretRefName
  }
]
// Merge the mandatory and any optionally provided environment variables
var finalEnvVars = union(defaultEnvVars, envVars)


resource containerApp 'Microsoft.Web/containerApps@2021-03-01' = {
  name: name
  kind: 'containerapp'
  location: location
  properties: {
    kubeEnvironmentId: containerAppEnvironmentId
    configuration: {
      secrets: finalSecrets
      registries: registries
      ingress: {
        internal: allowInternalIngress
        external: allowExternalIngress
        targetPort: targetIngressPort
      }
    }
    template: {
      containers: [
        {
          image: repositoryImage
          name: name
          env: finalEnvVars
        }
      ]
      scale: {
        minReplicas: 0
      }
    }
  }
}

output fqdn string = containerApp.properties.configuration.ingress.fqdn
