resource "aws_eks_cluster" "test-eks" {
    name = "test-cluster"
    role_arn = aws_iam_role.eks-iam-role.arn

    vpc_config {
        subnet_ids = [aws_subnet.private_subnets[1].id, aws_subnet.public_subnets[2].id]
    }

    depends_on = [
        aws_iam_role.eks-iam-role,
    ]
}

resource "aws_iam_openid_connect_provider" "cluster" {
    client_id_list  = ["sts.amazonaws.com"]
    thumbprint_list = []
    url             = aws_eks_cluster.test-eks.identity.0.oidc.0.issuer
}

resource "aws_iam_role" "workernodes" {
    name = "eks-node-group-example"
 
    assume_role_policy = jsonencode({
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
        Version = "2012-10-17"
    })
}
 
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role    = aws_iam_role.workernodes.name
}
 
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role    = aws_iam_role.workernodes.name
}
 
resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
    policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
    role    = aws_iam_role.workernodes.name
}
 
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role    = aws_iam_role.workernodes.name
}

resource "aws_eks_node_group" "worker-node-group" {
    cluster_name  = aws_eks_cluster.test-eks.name
    node_group_name = "test-workernodes"
    node_role_arn  = aws_iam_role.workernodes.arn
    subnet_ids   = [aws_subnet.private_subnets[1].id, aws_subnet.public_subnets[2].id]
    instance_types = ["t3.xlarge"]

    scaling_config {
        desired_size = 1
        max_size   = 1
        min_size   = 1
    }

    depends_on = [
        aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    ]
}