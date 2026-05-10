pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command: ["sleep"]
    args: ["99d"]
  - name: kubectl
    image: alpine:3.18
    command: ["sh"]
    args: ["-c", "apk add --no-cache kubectl && sleep 99d"]
'''
        }
    }

    environment {
        APP_NAME = "ganesh-app"
        NAMESPACE = "hyderabad-staging"
        IMAGE_NAME = "my-python-app:latest"
    }

    stages {
        stage('Build Image') {
            steps {
                container('kaniko') {
                    sh "/kaniko/executor --context `pwd` --dockerfile Dockerfile --destination ${IMAGE_NAME} --no-push"
                }
            }
        }

        stage('Deploy to K8s') {
            steps {
                container('kubectl') {
                    sh '/bin/sh -c "kubectl delete pod ${APP_NAME} -n ${NAMESPACE} --ignore-not-found || true"'
                    sh '/bin/sh -c "kubectl run ${APP_NAME} --image=${IMAGE_NAME} --image-pull-policy=Never -n ${NAMESPACE}"'
                    sh '/bin/sh -c "echo Deployment to ${NAMESPACE} complete"'
                }
            }
        }
    }
}