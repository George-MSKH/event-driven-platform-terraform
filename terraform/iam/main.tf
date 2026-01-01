resource "aws_iam_policy" "app_policy" {
  name = "app-producer-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "sqs:SendMessage",
          "sqs:GetQueueUrl"
        ]
        Resource = "*" 
      },
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = "*" 
      },
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "worker_ec2_policy" {
  name = "worker-policy-ec2"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Action = [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes",
                "sqs:GetQueueUrl"
            ]
            Resource = "*"
        },
        {
            Effect = "Allow"
            Action = [
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket"
            ]
            Resource = "*"
        }
    ]
  })
}

# App EC2 role
resource "aws_iam_role" "ec2_app_role" {
  name = "ec2-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

# Worker EC2 role
resource "aws_iam_role" "ec2_worker_role" {
  name = "ec2-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_role_policy_attachment" "app_policy_attachment" {
  role = aws_iam_role.ec2_app_role.name
  policy_arn = aws_iam_policy.app_policy.arn
}

resource "aws_iam_role_policy_attachment" "worker_policy_attachment" {
  role = aws_iam_role.ec2_worker_role.name
  policy_arn = aws_iam_policy.worker_ec2_policy.arn
}

resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "app-instance-profile"
  role = aws_iam_role.ec2_app_role.name
}

resource "aws_iam_instance_profile" "worker_instance_profile" {
  name = "worker-instance-profile"
  role = aws_iam_role.ec2_worker_role.name
}