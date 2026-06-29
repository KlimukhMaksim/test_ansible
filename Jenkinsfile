pipeline {
    agent any

    environment {
        ANSIBLE_CONFIG = 'ansible/ansible.cfg'
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {
        stage('Flask application playbook') {
            steps {
                withCredentials([
                    string(
                        credentialsId: 'database_name',
                        variable: 'DB_NAME'
                    ),
                    usernamePassword(
                        credentialsId: 'database_credentials',
                        passwordVariable: 'DB_PASSWORD',
                        usernameVariable: 'DB_USER'
                    ),
                    string(
                        credentialsId: 'flask_secret_key',
                        variable: 'SECRET_KEY'
                    )
                ]) {
                    ansiblePlaybook(
                        credentialsId: 'vm_ssh_key',
                        extraVars: [
                            db_name: "$DB_NAME",
                            db_user: "$DB_USER",
                            db_password: "$DB_PASSWORD",
                            secret_key: "$SECRET_KEY"
                        ],
                        installation: 'Ansible',
                        playbook: 'ansible/webserver_play.yml'
                    )
                }
            }
        }
    }
}