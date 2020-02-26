if [ -z "$1" ]; 
  then echo "PEM file name is blank. Provide a PEM file"; exit;
fi

echo "[iteso]"  > hosts_ansible
aws ec2 describe-instances --profile iteso --region=us-east-1 --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value|[0],State.Name,PublicDnsName,PublicIpAddress,PrivateIpAddress]' --filters Name=instance-state-name,Values=running --output table | grep ec2 | awk '{print $11 "  hostname="$3".example.com" }' >> hosts_ansible

echo "[iteso:vars]" >> hosts_ansible
echo "ansible_user=ec2-user" >> hosts_ansible
echo "ansible_ssh_private_key_file=/home/ec2-user/hadoop_ansible/$1" >> hosts_ansible

cat hosts_ansible
