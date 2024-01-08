output "endpoint" {
  value = aws_eks_cluster.shah.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.shah.certificate_authority[0].data
}
output "cluster_id" {
  value = aws_eks_cluster.shah.id
}
output "cluster_endpoint" {
  value = aws_eks_cluster.shah.endpoint
}
output "cluster_name" {
  value = aws_eks_cluster.shah.name
}

output "eks_nodes_sg_id" {
  value = aws_security_group.node_group_one.id
}