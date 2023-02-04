#!/usr/bin/env groovy
library identifier: 'jenkins-shared-library@main', retriever: modernSCM(
         [$class: 'GitSCMSource',
         remote: 'https://github.com/zahranjamali/jenkins-shared-library.git',
         credentialsId: 'zahranGithub'
         ]
)
def gv

pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    stages {
        stage ("init") {
            steps {
                script {
                    gv = load "script.groovy"
                }
            }
        }
        stage ("build jar") {
            steps {
                script {
                    buildJar()
                }
            }
        }
        stage ("build images") {
            steps {
                script {
                    buildImage 'zahranjamali/my-repo:jma-3.0'
                }
            }
        }
            stage ("deployApp") {
            steps {
                script {
                    gv.deployApp()
                } 
            }
        }
    }
}
