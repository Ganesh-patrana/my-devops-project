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
    image: bitnami/kubectl:latest
    command: ["sleep"]
    args: ["99d"]
'''
        }
    }
    stages {
        stage('Build Image') {
            steps {
                container('kaniko') {
                    sh '/kaniko/executor --context `pwd` --dockerfile Dockerfile --destination my-python-app:latest --no-push'
                    echo 'Image built successfully (local only for now)'
                }
            }
        }
        stage('Deploy to K8s') {
            steps {
                container('kubectl') {
                    sh 'kubectl run ganesh-app --image=my-python-app:latest --image-pull-policy=Never --restart=Always'
                    echo 'Application deployed to cluster!'
                }
            }
        }
    }
}