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
                        // Ensure that Maven is available and configured properly
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
                    // Ensure that the Docker Pipeline plugin is installed and configured
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Container Security Scan') {
            steps {
                script {
                    // Ensure that Anchore Engine is installed and configured
                    sh "anchore-cli image add ${DOCKER_IMAGE}"
                    sh "anchore-cli image wait ${DOCKER_IMAGE}"
                    sh "anchore-cli image vuln ${DOCKER_IMAGE} all"
                }
            }
        }

        stage('DAST') {
            steps {
                // Ensure that OWASP ZAP is installed and configured
                sh 'zap-baseline.py -t http://localhost:3000 -r zap-report.html'
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
    }

    post {
        always {
            // Ensure that the test report files and artifacts are archived correctly
            archiveArtifacts artifacts: 'reports/*, zap-report.html', allowEmptyArchive: true
            // Ensure that the JUnit test report file path is correct
            junit '**/test-reports/*.xml'
        }
    }
}
