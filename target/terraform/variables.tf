variable vpc_cidr_blocks {
    default = ["10.0.0.0/16"]
}
variable subnet_cidr_blocks {
    default = ["10.0.10.0/24"]
}
variable avail_zone {
    default = "ap-south-1a"
}
variable env_prefix {
    default = "dev"
}
variable my_ip {
    default = "114.79.142.150/32"
}
variable instance_type {
    default = "t2.micro"
}
variable region {
    default = "ap-south-1"
}