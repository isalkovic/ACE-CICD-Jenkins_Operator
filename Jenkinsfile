
node () {

	stage ('ACE_APIS_Operator_Deployment - Checkout') {
   	 checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'jenkins-token', url: 'https://github.com/isalkovic/ACE-CICD-Jenkins_Operator.git']]])
	}

  stage ('ACE_APIS_Operator_Deployment - Build') {

    artifactResolver artifacts: [artifact(artifactId: '1', extension: 'bar', groupId: '1', version: '1')], targetDirectory: '/tmp'
    sh label: '', script: '''#!/bin/sh

    chmod 777 *
    ls -l
    cp 1-1.bar /var/lib/jenkins/jobs/${JOB_NAME}/workspace

    cd ${WORKSPACE}
    oc login --token=sha256~nuuItGLCo4_PDNSq7ArZb5JoyM7ebE730PEZ29lS2cA --server=https://c108-e.eu-gb.containers.cloud.ibm.com:31504

    oc project cp4i

    #####################

    Namespace=cp4i
    appname=ivoapp
    IntegrationServerName=ivoserver2
    DeploymentType=install

    chmod -R 777 *

    # Create CR for setdbparms
    setdbparms=$(base64 -w 0 initial-config/setdbparms/setdbparms2.txt)
    sed -e "s/replace-with-namespace/${Namespace}/" -e "s~replace-with-setdbparms-name~${appname}-setdbparms~" -e "s~replace-with-setdbparms-base64~${setdbparms}~" operator_resources_CRs/configuration_setdbparms.yaml > setdbparms-temp.yaml

    # Create CR for TrustStore
    #truststore=$(base64 -w 0 initial-config/truststore/es-cert.p12)
    #sed -e "s/replace-with-namespace/${Namespace}/" -e "s~replace-with-truststore-name~${appname}-truststore~" -e "s~replace-with-truststore-base64~${truststore}~" operator_resources_CRs/configuration_truststore.yaml > truststore-temp.yaml

    # Create CR for the policy project, zip policy files, exclude any old zip file and replace old zip file
    mkdir DefaultPolicies
    cp initial-config/policy/* DefaultPolicies
    zip -r - DefaultPolicies > policyFolder.zip
    policy=$(base64 -w 0 policyFolder.zip)
    sed -e "s/replace-with-namespace/${Namespace}/" -e "s~replace-with-policy-name~${appname}-policy~" -e "s~replace-with-policy-base64~${policy}~" operator_resources_CRs/configuration_policyProject.yaml > policyProject-temp.yaml

    # Create CR for server configuration
    serverconf=$(base64 -w 0 initial-config/serverconf/server.conf.yaml)
    sed -e "s/replace-with-namespace/${Namespace}/" -e "s~replace-with-serverconf-name~${appname}-serverconf~" -e "s~replace-with-serverconf-base64~${serverconf}~" operator_resources_CRs/configuration_serverconf.yaml > server.conf-temp.yaml

    # Create the Integration Server CR
    sed -e "s/replace-with-namespace/${Namespace}/" -e "s/replace-with-server-name/${IntegrationServerName}/" operator_resources_CRs/integrationServer.yaml > integrationServer-temp.yaml

    cat integrationServer-temp.yaml

    #####################

    if test ${DeploymentType} = \'install\'; then
      oc apply -f setdbparms-temp.yaml
#      oc apply -f truststore-temp.yaml
      oc apply -f policyProject-temp.yaml
      oc apply -f server.conf-temp.yaml
      oc apply -f integrationServer-temp.yaml
    else
      oc replace -f setdbparms-temp.yaml
#      oc replace -f truststore-temp.yaml
      oc replace -f policyProject-temp.yaml
      oc replace -f server.conf-temp.yaml
      oc replace -f integrationServer-temp.yaml
    fi

    '''
	  }
  }
