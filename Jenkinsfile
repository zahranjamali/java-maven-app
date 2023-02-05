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
		stage('deploy'){
			steps {
				script {
					echo 'deploying docker image to ec2'
					def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME}"
					def ec2Instance = "ec2-user@65.0.81.107"
					sshagent(['ec2-server-key']) {
					   sh "scp -o StrictHostKeyChecking=no server-cmds.sh ${ec2Instance}:/home/ec2-user"
					   sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ${ec2Instance}:/home/ec2-user"
                       sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
                   }
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
                    sh 'git push origin HEAD:jenkins-jobs'
                    }
                 }
             }
        }
	}
}
