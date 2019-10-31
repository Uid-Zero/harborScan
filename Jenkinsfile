pipeline {
  agent any

options {
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '5'))
    disableConcurrentBuilds()
	}
    triggers{cron('10 7 1 * *')}

  // Global variables used in all deploy stages go here
  environment {
	DEV_NODE = ''
	TST_NODE = ''
	PRD_NODE = ''
	HRBR_NODE = ''
	WORK_DIR = 'harborScan'
}

stages {
	stage ('Prep') {
		options {
			timeout(time: 120, unit: 'SECONDS')
		}
	steps {
        cleanWs()
        dir("$WORK_DIR") {
          git branch: 'master', credentialsId: 's_ci_ssh', url: 'git@github.com:Uid-Zero/harborScan.git'
        }
		withCredentials([usernamePassword(credentialsId: 'admin', usernameVariable: 'HRBR_USR', passwordVariable: 'HRBR_PWD')]) {
        sh 'chmod 700 $WORK_DIR/getImage.sh $WORK_DIR/getVulnerabilities.sh $WORK_DIR/sendEmail.sh'
		sh 'echo "HRBR_USR=$HRBR_USR" > $WORK_DIR/config.properties && \
		echo "HRBR_PWD=$HRBR_PWD" >> $WORK_DIR/config.properties && \
		echo "HRBR_NODE=$HRBR_NODE" >> $WORK_DIR/config.properties && \
		echo "WORK_DIR=$WORK_DIR" >> $WORK_DIR/config.properties'
		}
	}
	}
	
	stage ('DEV') {
		options {
			timeout(time: 120, unit: 'SECONDS')
		}
	steps {
		sshagent (credentials: ['jenkins']) {
		sh 'scp -r ./$WORK_DIR jenkins@$DEV_NODE:/home/jenkins'
		sh 'ssh jenkins@$DEV_NODE < $WORK_DIR/getImage.sh'
		sh 'ssh jenkins@$DEV_NODE "/usr/bin/rm -rfv $WORK_DIR"'
		}
	}
	}
	
	stage ('TST') {
		options {
			timeout(time: 120, unit: 'SECONDS')
		}
	steps {
		sshagent (credentials: ['jenkins']) {
		sh 'scp -r ./$WORK_DIR jenkins@$TST_NODE:/home/jenkins'
		sh 'ssh jenkins@$TST_NODE < $WORK_DIR/getImage.sh'
		sh 'ssh jenkins@$TST_NODE "/usr/bin/rm -rfv $WORK_DIR"'
		}
	}
	}
	
	stage ('PRD') {
		options {
			timeout(time: 120, unit: 'SECONDS')
		}
	steps {
		sshagent (credentials: ['jenkins']) {
		sh 'scp -r ./$WORK_DIR jenkins@$PRD_NODE:/home/jenkins'
		sh 'ssh jenkins@$PRD_NODE < $WORK_DIR/getImage.sh'
		sh 'ssh jenkins@$PRD_NODE "/usr/bin/rm -rfv $WORK_DIR"'
		}
	}
	}
	
	stage('Cleanup') {
      steps {
        // don't fill the disk unnecessarily
        cleanWs()
      }
	}
}

}
