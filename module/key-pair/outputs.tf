output "key_pair_name" {
  description = "Key Pair Name"
  value       = aws_key_pair.key_pair.key_name
}