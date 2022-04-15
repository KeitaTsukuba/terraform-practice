 resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
}

# デフォルトルートとgatewayをtableに追加する
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

# route table と subnet を関連付ける
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
