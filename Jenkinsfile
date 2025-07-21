pipeline {
    agent any

    environment {
        VENV_DIR = 'venv'
        GCP_PROJECT = "moonlit-text-465413-u6"
        GCLOUD_PATH = "/var/jenkins_home/google-cloud-sdk/bin"
    }

    stages {
        stage('Clone GitHub Repo') {
            steps {
                script {
                    echo 'Cloning GitHub repository...'
                    checkout scmGit(
                        branches: [[name: '*/main']],
                        extensions: [],
                        userRemoteConfigs: [[
                            credentialsId: 'github-token',
                            url: 'https://github.com/MinKhantNaing1999/Hotel-Reservation-Cancellation-Prediction.git'
                        ]]
                    )
                }
            }
        }

        stage('Install Python Dependencies') {
            steps {
                script {
                    echo 'Installing Python dependencies...'
                    sh """
                    python -m venv ${VENV_DIR}
                    . ${VENV_DIR}/bin/activate
                    pip install --upgrade pip
                    pip install -e .
                    """
                }
            }
        }

        stage('Build & Push Docker Image to GCR') {
            steps {
                withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    script {
                        echo 'Building and pushing Docker image to GCR (amd64)...'
                        sh """
                        export PATH=\$PATH:${GCLOUD_PATH}
                        gcloud auth activate-service-account --key-file=\${GOOGLE_APPLICATION_CREDENTIALS}
                        gcloud config set project ${GCP_PROJECT}
                        gcloud auth configure-docker --quiet

                        # Ensure buildx is initialized
                        docker buildx create --use || true

                        # Build for amd64 and push directly
                        docker buildx build --platform linux/amd64 -t gcr.io/${GCP_PROJECT}/hotel-reservation:latest --push .
                        """
                    }
                }
            }
        }


        stage('Deploy to Google Cloud Run') {
            steps {
                withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    script {
                        echo 'Deploying to Google Cloud Run...'
                        sh """
                        export PATH=\$PATH:${GCLOUD_PATH}
                        gcloud auth activate-service-account --key-file=\${GOOGLE_APPLICATION_CREDENTIALS}
                        gcloud config set project ${GCP_PROJECT}
                        gcloud run deploy hotel-reservation \
                        --image=gcr.io/${GCP_PROJECT}/hotel-reservation:latest \
                        --platform=managed \
                        --region=us-central1 \
                        --allow-unauthenticated
                        """
                    }
                }
            }
        }

    }
}
