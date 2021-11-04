
timestamps {

node () {

	stage ('ACE_APIS_Operator_Deployment - Checkout') {
   	 checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'jenkins-token', url: 'https://github.ibm.com/isalkovic/ACE-CICD-Jenkins_Operator.git']]])
	}

  stage ('ACE_APIS_Operator_Deployment - Build') {

    artifactResolver artifacts: [artifact(artifactId: '1', extension: 'bar', groupId: '1', version: '1')], targetDirectory: '/tmp'
    sh label: '', script: '''#!/bin/sh

    chmod 777 *
    cp 1-1.bar /var/lib/jenkins/jobs/${JOB_NAME}/workspace
  
    cd ${WORKSPACE}
    oc login ${OCP_API_URL} -u ${OCP_USER} -p ${OCP_PASSWORD} --insecure-skip-tls-verify
    oc project ${Namespace}
    docker login ${OCP_Registry_External_URL} -u $(oc whoami) -p $(oc whoami -t)
    docker build -t ${imagename}:${BUILD_NUMBER} .
    docker tag ${imagename}:${BUILD_NUMBER} ${OCP_Registry_External_URL}/${Namespace}/${imagename}:${tag}
    docker push ${OCP_Registry_External_URL}/${Namespace}/${imagename}:${tag}

    #Create the IntegrationServer Configurations from CR yamls
    chmod 777 -R ConfigurationInputs
    chmod 777 -R ConfigurationResources

    # Create CR for setdbparms
    setdbparms=$(base64 -w 0 ConfigurationInputs/setdbparms.txt)
    sed -e "s/replace-with-namespace/${Namespace}/" -e "s~replace-with-setdbparms-bas64~${setdbparms}~" ConfigurationResources/setdbparms.yaml > setdbparms-temp.yaml
    # Create CR for TrustStore
    truststore=$(base64 -w 0 ConfigurationInputs/es-cert.p12)
    sed -e "s/replace-with-namespace/${Namespace}/" -e "s~replace-with-truststore-bas64~${truststore}~" ConfigurationResources/truststore.yaml > truststore-temp.yaml
    # Create CR for the policy project
    policy=$(base64 -w 0 ConfigurationInputs/kafka_policy.zip)
    sed -e "s/replace-with-namespace/${Namespace}/" -e "s~replace-with-policy-base64~${policy}~" ConfigurationResources/policyProject.yaml > policyProject-temp.yaml
    # Create CR for server configuration
    serverconf=$(base64 -w 0 ConfigurationInputs/server.conf.yaml)
    sed -e "s/replace-with-namespace/${Namespace}/" -e "s~replace-with-serverconf-bas64~${serverconf}~" ConfigurationResources/server.conf.yaml > server.conf-temp.yaml
    # Deploy the Integration Server
    sed -e "s/replaceIntServerName/${IntegrationServer}/" -e "s/replaceNamespace/${Namespace}/" -e "s/replaceWithBakedImage/${imagename}:${tag}/" Kafka_APIs_IS.yaml > Kafka_APIs-temp.yaml

    if test ${DeploymentType} = \'install\'; then
      oc apply -f setdbparms-temp.yaml
      oc apply -f truststore-temp.yaml
      oc apply -f policyProject-temp.yaml
      oc apply -f server.conf-temp.yaml
      oc apply -f Kafka_APIs-temp.yaml
    else
      oc replace -f setdbparms-temp.yaml
      oc replace -f truststore-temp.yaml
      oc replace -f policyProject-temp.yaml
      oc replace -f server.conf-temp.yaml
      oc replace -f Kafka_APIs-temp.yaml
    fi

    cd /var/icp-builds
    rm -rf ${ACE_APP1}
    rm -rf ${ACE_APP2}'''
	  }
  }

cleanWs()

}
