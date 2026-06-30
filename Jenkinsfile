pipeline {
    agent any

    stages {
        stage('Webserver playbook') {
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
                        playbook: 'Ansible/app_playbook.yml',
                        inventory: 'Ansible/inventory.yml'
                    )
                }
            }
        }
    }
}