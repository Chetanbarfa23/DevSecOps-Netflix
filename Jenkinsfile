pipeline {
    agent any

    tools {
        jdk 'jdk17'
        nodejs 'node20'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'

        DOCKER_IMAGE = 'chetan8889/netflix'
        IMAGE_TAG = "build-${BUILD_NUMBER}"
        GIT_REPO = 'https://github.com/Chetanbarfa23/DevSecOps-Netflix.git'
    }

    stages {

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout from Git') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-token',
                    url: "${GIT_REPO}"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh '''
                        $SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectKey=Netflix \
                        -Dsonar.projectName=Netflix \
                        -Dsonar.sources=.
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate(
                        abortPipeline: false,
                        credentialsId: 'sonar-token'
                    )
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('OWASP FS SCAN') {
            steps {
                dependencyCheck(
                    additionalArguments: '''
                        --scan ./
                        --disableYarnAudit
                        --disableNodeAudit
                        --nvdDatafeed "https://dependency-check.github.io/DependencyCheck_Builder/nvd_cache/nvdcve-{0}.json.gz"
                    ''',
                    odcInstallation: 'DP-Check'
                )

                dependencyCheckPublisher(
                    pattern: '**/dependency-check-report.xml',
                    skipNoReportFiles: true
                )
            }
        }

        stage('TRIVY FS SCAN') {
            steps {
                sh '''
                    trivy fs . > trivyfs.txt
                '''
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    withCredentials([
                        string(
                            credentialsId: 'tmdb-api-key',
                            variable: 'TMDB_V3_API_KEY'
                        )
                    ]) {

                        withDockerRegistry(
                            credentialsId: 'docker'
                        ) {

                            sh '''
                                echo "Building Docker image: ${DOCKER_IMAGE}:${IMAGE_TAG}"

                                docker build \
                                    --build-arg TMDB_V3_API_KEY="$TMDB_V3_API_KEY" \
                                    -t "${DOCKER_IMAGE}:${IMAGE_TAG}" \
                                    -t "${DOCKER_IMAGE}:latest" \
                                    .

                                docker push "${DOCKER_IMAGE}:${IMAGE_TAG}"
                                docker push "${DOCKER_IMAGE}:latest"
                            '''
                        }
                    }
                }
            }
        }

        stage('TRIVY Image Scan') {
            steps {
                sh '''
                    echo "Scanning image: ${DOCKER_IMAGE}:${IMAGE_TAG}"

                    trivy image \
                        "${DOCKER_IMAGE}:${IMAGE_TAG}" \
                        > trivyimage.txt
                '''
            }
        }

        stage('Update GitOps Manifest') {
            steps {
                sh '''
                    echo "===== BEFORE ====="
                    grep -n "image:" Kubernetes/deployment.yaml

                    echo
                    echo "===== UPDATE IMAGE ====="

                    sed -i "s|image: ${DOCKER_IMAGE}:.*|image: ${DOCKER_IMAGE}:${IMAGE_TAG}|" \
                        Kubernetes/deployment.yaml

                    echo
                    echo "===== AFTER ====="
                    grep -n "image:" Kubernetes/deployment.yaml
                '''
            }
        }

        stage('Commit & Push GitOps Change') {
            steps {
                script {

                    withCredentials([
                        usernamePassword(
                            credentialsId: 'github-token',
                            usernameVariable: 'GITHUB_USERNAME',
                            passwordVariable: 'GITHUB_TOKEN'
                        )
                    ]) {

                        sh '''
                            git config user.name "Jenkins"
                            git config user.email "jenkins@devsecops.local"

                            git add Kubernetes/deployment.yaml

                            git diff --cached --quiet || \
                                git commit -m "ci: deploy Netflix ${IMAGE_TAG}"

                            git remote set-url origin \
                                "https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@github.com/Chetanbarfa23/DevSecOps-Netflix.git"

                            git push origin HEAD:main
                        '''
                    }
                }
            }
        }
    }

    post {

        success {
            echo '=========================================='
            echo '   CI/CD + GITOPS PIPELINE SUCCESS'
            echo '=========================================='
            echo "Docker image: ${DOCKER_IMAGE}:${IMAGE_TAG}"
            echo 'GitOps manifest pushed to GitHub'
            echo 'Argo CD will deploy the new version'

            emailext(
                subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                    <h2>Netflix DevSecOps Pipeline Successful</h2>
                    <p><b>Job:</b> ${env.JOB_NAME}</p>
                    <p><b>Build:</b> #${env.BUILD_NUMBER}</p>
                    <p><b>Status:</b> SUCCESS</p>
                    <p><b>Docker Image:</b> ${DOCKER_IMAGE}:${IMAGE_TAG}</p>
                    <p>The CI/CD pipeline completed successfully.</p>
                    <p>The GitOps Kubernetes manifest was updated and pushed to GitHub.</p>
                    <p>Argo CD will synchronize the new version to Kubernetes.</p>
                    <p><b>Jenkins Build:</b> ${env.BUILD_URL}</p>
                """,
                to: 'barfachetan5@gmail.com'
            )
        }

        failure {
            echo '=========================================='
            echo '   PIPELINE FAILED'
            echo '=========================================='
            echo 'Check the failed stage above.'

            emailext(
                subject: "FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                    <h2>Netflix DevSecOps Pipeline Failed</h2>
                    <p><b>Job:</b> ${env.JOB_NAME}</p>
                    <p><b>Build:</b> #${env.BUILD_NUMBER}</p>
                    <p><b>Status:</b> FAILED</p>
                    <p>The Jenkins pipeline failed.</p>
                    <p>Please check the Jenkins console output to identify the failed stage.</p>
                    <p><b>Jenkins Build:</b> ${env.BUILD_URL}</p>
                """,
                to: 'barfachetan5@gmail.com'
            )
        }
    }
}
