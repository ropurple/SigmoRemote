pipeline {
  agent any
  stages {
    stage('Sonar') {
      steps {
        waitForQualityGate true
      }
    }
  }
}