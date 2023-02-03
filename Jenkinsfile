#!/usr/bin/env groovy
@Location ('jenkins-shared-libs')
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
                    buildImage()
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
