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
	stages {
	    stage('increment version') {
                steps {
                    script {
                        echo 'incrementing app version...'
                        sh 'mvn build-helper:parse-version versions:set \
                            -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                            versions:commit'
                        def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                        def version = matcher[0][1]
                        env.IMAGE_NAME = "$version-$BUILD_NUMBER"
                    }
                }
            }

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
				def imageName = "zahranjamali/my-repo:${IMAGE_NAME}"
					buildImage(imageName)
					dockerLogin()
					dockerPush(imageName)
				}
			}
		}
		 stage("deploy") {
                    environment {
                        AWS_ACCESS_KEY_ID = credentials('jenkins-aws-access-key-id')
                        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key-id')
                        APP_NAME = 'java-maven-app'
                    }
                    steps {
                        script {
                            echo "deploying"
                            sh 'envsubst < kubernetes/deployment.yaml | kubectl apply -f -'
                            sh 'envsubst < kubernetes/service.yaml | kubectl apply -f -'
                        }
                    }
                }
		stage('commit version update') {
             steps {
                 script {
                    withCredentials([usernamePassword(credentialsId: 'zahranGithub', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    // git config here for the first time run
                    sh 'git config --global user.email "jenkins@example.com"'
                    sh 'git config --global user.name "jenkins"'

                    sh "git remote set-url origin https://${USER}:${PASS}@github.com/zahranjamali/java-maven-app.git"
                    sh 'git add .'
                    sh 'git commit -m "ci: version bump"'
                    sh 'git push origin HEAD:feature/jenkinsfile-sshagent'
                    }
                 }
             }
        }
	}
}
