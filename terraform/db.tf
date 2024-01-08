resource "aws_db_instance" "postgresql_db" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "16.1"
  instance_class       = "db.t3.micro"
  username             = "root"
  password             = "root"
  db_name              = "shah"
  parameter_group_name = "default.postgres16"
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  db_subnet_group_name = aws_db_subnet_group.shah_db_subnet_group.name
  port = 5432

  tags = {
    Name = "my-postgresql-db"
  }
}

resource "aws_db_subnet_group" "shah_db_subnet_group" {
  name = "shah_db_subnet_group"
  subnet_ids = [module.vpc.private_shah_subnet_id]
}

resource "aws_security_group" "rds_security_group" {
  vpc_id = module.vpc.vpc_id
  name        = "rds-sg"
  description = "Security group for RDS postgres"

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "kubernetes_secret" "postgresql-config" {
  metadata {
    name = "postgresql-config"
  }

  data = {
    POSTGRES_HOST = aws_db_instance.postgresql_db.address
    POSTGRES_PORT = aws_db_instance.postgresql_db.port
    POSTGRES_USER = aws_db_instance.postgresql_db.username
    POSTGRES_PASSWORD = aws_db_instance.postgresql_db.password
    POSTGRES_DB = aws_db_instance.postgresql_db.db_name
  }
}

resource "aws_elasticache_cluster" "redis_cache" {
  cluster_id           = "my-redis-cluster"
  engine               = "redis"
  engine_version       = "6.x"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  port                 = 6379
  parameter_group_name = "default.redis6.x"

  # Make the cluster publicly accessible
  apply_immediately = true
  security_group_ids = [aws_security_group.redis_cache_sg.id]
  subnet_group_name = aws_elasticache_subnet_group.shah_elasticache_subnet_group.name

  tags = {
    Name = "shah-redis-cluster"
  }
}

resource "aws_elasticache_subnet_group" "shah_elasticache_subnet_group" {
  name       = "shah_elasticache_subnet_group"
  subnet_ids = [module.vpc.private_shah_subnet_id]
}

resource "aws_security_group" "redis_cache_sg" {
  vpc_id = module.vpc.vpc_id
  name        = "redis-cache-sg"
  description = "Security group for Redis cache"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow access from any IP address
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redis-cache-sg"
  }
}

resource "kubernetes_secret" "redis-config" {
  metadata {
    name = "redis-config"
  }

  data = {
    REDIS_HOST = aws_elasticache_cluster.redis_cache.cache_nodes.0.address
    REDIS_PORT = aws_elasticache_cluster.redis_cache.cache_nodes.0.port
  }
}