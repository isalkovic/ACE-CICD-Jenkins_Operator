# set the namespace and prefix for CR names
Namespace=cp4i
appname=ivoapp
IntegrationServerName=ivoserver

chmod -R 777 server-config

# Create CR for setdbparms
setdbparms=$(base64 -w 0 server-config/initial-config/setdbparms/setdbparms.txt)
sed -e "s/replace-with-namespace/${Namespace}/" -e "s~replace-with-setdbparms-name~${appname}-setdbparms~" -e "s~replace-with-setdbparms-base64~${setdbparms}~" operator_resources_CRs/configuration_setdbparms.yaml > setdbparms-temp.yaml

# Create CR for TrustStore
#truststore=$(base64 -w 0 server-config/initial-config/truststore/es-cert.p12)
#sed -e "s/replace-with-namespace/${Namespace}/" -e "s~replace-with-truststore-name~${appname}-truststore~" -e "s~replace-with-truststore-base64~${truststore}~" operator_resources_CRs/configuration_truststore.yaml > truststore-temp.yaml

# Create CR for the policy project, zip policy files, exclude any old zip file and replace old zip file
zip -j - server-config/initial-config/policy/* > server-config/initial-config/policy/policy.zip -x '*.zip*'
policy=$(base64 -w 0 server-config/initial-config/policy/policy.zip)
sed -e "s/replace-with-namespace/${Namespace}/" -e "s~replace-with-policy-name~${appname}-policy~" -e "s~replace-with-policy-base64~${policy}~" operator_resources_CRs/configuration_policyProject.yaml > policyProject-temp.yaml

# Create CR for server configuration
serverconf=$(base64 -w 0 server-config/initial-config/serverconf/server.conf.yaml)
sed -e "s/replace-with-namespace/${Namespace}/" -e "s~replace-with-serverconf-name~${appname}-serverconf~" -e "s~replace-with-serverconf-base64~${serverconf}~" operator_resources_CRs/configuration_serverconf.yaml > server.conf-temp.yaml

# Create the Integration Server CR
sed -e "s/replace-with-namespace/${Namespace}/" -e "s/replace-with-server-name/${IntegrationServerName}/" operator_resources_CRs/integrationServer.yaml > integrationServer-temp.yaml
