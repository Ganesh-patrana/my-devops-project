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
    volumeMounts:
    - name: registry-creds
      mountPath: /kaniko/.docker/
  - name: kubectl
    image: dtzar/helm-kubectl:latest
    command: ["cat"]
    tty: true
  volumes:
  - name: registry-creds
    secret:
      secretName: docker-creds
      items:
      - key: .dockerconfigjson
        path: config.json
'''
        }
    }

    environment {
        APP_NAME = "ganesh-app"
        NAMESPACE = "hyderabad-staging"
        // CHANGE THIS TO YOUR DOCKER HUB USERNAME
        IMAGE_NAME = "gpatrana/my-python-app:latest" 
    }

    stages {
        stage('Build & Push Image') {
            steps {
                container('kaniko') {
                    // Removed --no-push. Kaniko will now securely push to Docker Hub!
                    sh "/kaniko/executor --context `pwd` --dockerfile Dockerfile --destination ${IMAGE_NAME}"
                }
            }
        }

        stage('Deploy to K8s') {
            steps {
                container('kubectl') {
                    sh "kubectl delete pod ${APP_NAME} -n ${NAMESPACE} --ignore-not-found || true"
                    // Removed --image-pull-policy=Never. K8s will pull from Docker Hub!
                    sh "kubectl run ${APP_NAME} --image=${IMAGE_NAME} -n ${NAMESPACE}"
                }
            }
        }
    }
}