########### private ##########
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.example]
}

########### multi AZ ##########
# private
resource "aws_nat_gateway" "nat_gateway_0" {
  allocation_id = aws_eip.nat_gateway_0.id
  subnet_id     = aws_subnet.public_0.id
  depends_on    = [aws_internet_gateway.example]
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_1.id
  subnet_id     = aws_subnet.public_1.id
  depends_on    = [aws_internet_gateway.example]
}