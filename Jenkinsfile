pipeline {
  agent any
  stages {
    stage('Stage 1') {
      steps {
        build 'GSA-Search-ManufactureProducts'
      }
    }
    stage('') {
      steps {
        openTasks(asRegexp: true, canComputeNew: true, canRunOnFailed: true, ignoreCase: true)
        mail(subject: 'test', body: 'test', from: 'jenkins@govconsvcs.com', replyTo: 'jenkins@govconsvcs.com', to: 'brianpurgert@govconsvcs.com')
      }
    }
  }
}