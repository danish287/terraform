echo Updating and upgrading machine...
sudo apt-get update

echo Installing Docker...
# install docker 
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io

echo Joining swarm...
#joining the swarm 
sudo docker swarm join --token SWMTKN-1-38g0e9bdl1ylcxbjbm1miwd3pjaziqgw5u2qduvy0du9iwgmaa-5nxiemkmhsq3goucvmhupw4wq 172.31.43.70:2377

echo Downloading Images...
#pull each docker image for webApp, database, and controller
sudo docker pull felicianoej/arkcontroller
sudo docker pull codezipline/dbserver
sudo docker pull danish287/horsocoped