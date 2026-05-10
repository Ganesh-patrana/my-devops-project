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
    # CRITICAL FIX: Swapped to a CI/CD friendly image that avoids permission conflicts
    image: dtzar/helm-kubectl:latest
    command: ["cat"]
    tty: true
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
                    // Because we are using the right image, this will execute immediately
                    sh "kubectl delete pod ${APP_NAME} -n ${NAMESPACE} --ignore-not-found || true"
                    sh "kubectl run ${APP_NAME} --image=${IMAGE_NAME} --image-pull-policy=Never -n ${NAMESPACE}"
                }
            }
        }
    }
}