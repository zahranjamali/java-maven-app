def buildJar () {
    echo "building the application"
    sh 'mvn package'
}

def buildImage(){
    echo "building the application"
                    withCredentials([usernamePassword(credentialsID: 'docker-hub-repo', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh 'docker build -t zahranjamali/my-repo:jma-1.0 .'
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh 'docker push zahranjamali/my-repo:jma-1.0'
                    }
                }
def deployApp(){
    echo "deploying the application"
}
return this 
