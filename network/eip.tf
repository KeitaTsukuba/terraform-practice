########### private ##########
resource "aws_eip" "nat_gateway" {
  vpc        = true
  depends_on = [aws_internet_gateway.example]
}

########### multi AZ ##########
# private
resource "aws_eip" "nat_gateway_0" {
  vpc        = true
  depends_on = [aws_internet_gateway.example]
}

resource "aws_eip" "nat_gateway_1" {
  vpc        = true
  depends_on = [aws_internet_gateway.example]
}