#!/usr/bin/env groovy

  library identifier: 'jenkins-shared-library@main', retriever: modernSCM(
	[$class: 'GitSCMSource',
	remote: 'https://github.com/zahranjamali/jenkins-shared-library.git',
	credentialsId: 'zahranGithub'
	]
)

pipeline {
	agent any
	tools {
		maven 'Maven'
	}
	environment {
		IMAGE_NAME = 'zahranjamali/my-repo:java-maven-2.0'
	}
	stages {
		stage('build app') {
			steps {
				script {
					buildJar()
				}
			}
		}
		stage('build image'){
			steps {
				script{
					buildImage(env.IMAGE_NAME)
					dockerLogin()
					dockerPush(env.IMAGE_NAME)
				}
			}
		}
		stage('deploy'){
			steps {
				script {
					echo 'deploying docker image to ec2'
					def dockerCmd = "docker run -d -p 8080:8080 ${imageName}"
					sshagent(['ec2-server-key']) {
                       sh "ssh -o StrictHostKeyChecking=no ec2-user@65.0.81.107 ${dockerCmd}"
                   }
				}
			}
		}
	}
}
