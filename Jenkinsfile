pipeline {
    agent any

    environment {
        SONARQUBE_SCANNER_HOME = tool name: 'SonarQube Scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
        SONAR_TOKEN = credentials('sonarqube')
        DOCKER_IMAGE = 'my-node-app'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/techsaber/my-node-app.git'
            }
        }

        stage('Install Node.js') {
            steps {
                script {
                    def nodeHome = tool name: 'NodeJS 14', type: 'jenkins.plugins.nodejs.tools.NodeJSInstallation'
                    env.PATH = "${nodeHome}/bin:${env.PATH}"
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool 'SonarQube Scanner'
            }
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=my-node-app -Dsonar.sources=. -Dsonar.host.url=http://localhost:9000 -Dsonar.login=$SONAR_TOKEN"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'reports/*, zap-report.html', allowEmptyArchive: true
            junit '**/test-reports/*.xml' // Adjust to match your test report paths
        }
    }
}
