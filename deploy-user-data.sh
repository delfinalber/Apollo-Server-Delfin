# Variables básicas
AWS_REGION="us-east-1"
AMI_ID="ami-0b6c6ebed2801a5cb"      # Cambia por la AMI que quieras
INSTANCE_TYPE="t3.small"
KEY_NAME="tu-keypair"
SECURITY_GROUP_ID="sg-008d97994004da0a8"      # SG con puertos 22,80,443 abiertos
SUBNET_ID="subnet-055146c159e283bec"

aws ec2 run-instances \
  --region "$AWS_REGION" \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --security-group-ids "$SECURITY_GROUP_ID" \
  --subnet-id "$SUBNET_ID" \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Apollo-Server-Delfin}]' \
  --user-data file://deploy-user-data.sh
