resource "aws_db_instance" "postgresql_db" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "13.3"
  instance_class       = "db.t3.micro"
  username             = "root"
  password             = "root"
  db_name              = "shah"
  parameter_group_name = "default.postgres13"

  tags = {
    Name = "my-postgresql-db"
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

  tags = {
    Name = "shah-redis-cluster"
  }
}

resource "kubernetes_secret" "redis-config" {
  metadata {
    name = "redis-config"
  }

  data = {
    REDIS_HOST = aws_elasticache_cluster.redis_cache.configuration_endpoint.address
    REDIS_PORT = aws_elasticache_cluster.redis_cache.port
  }
}