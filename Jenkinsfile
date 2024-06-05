pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-node-app'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/techsaber/my-node-app.git'
            }
        }

        stage('SAST') {
            steps {
                script {
                    // Example SAST tool integration (e.g., SonarQube)
                    withSonarQubeEnv('SonarQube') {
                        sh 'mvn clean verify sonar:sonar'
                    }
                }
            }
        }

        stage('SCA') {
            steps {
                // Dependency-Check example
                sh 'dependency-check --project "My Project" --scan . --format HTML --out reports/'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Container Security Scan') {
            steps {
                script {
                    // Anchore scan example
                    sh 'anchore-cli image add ${DOCKER_IMAGE}'
                    sh 'anchore-cli image wait ${DOCKER_IMAGE}'
                    sh 'anchore-cli image vuln ${DOCKER_IMAGE} all'
                }
            }
        }

        stage('DAST') {
            steps {
                // OWASP ZAP scan example
                zapAttack(target: 'http://localhost:3000', format: 'html', output: 'zap-report.html')
            }
        }

        stage('Deploy to Docker') {
            steps {
                script {
                    // Deploy to Docker
                    sh "docker run -d -p 3000:3000 ${DOCKER_IMAGE}"
                }
            }
        }


    post {
        always {
            archiveArtifacts artifacts: 'reports/*, zap-report.html', allowEmptyArchive: true
            junit 'reports/**/*.xml'
        }
    }
}
}