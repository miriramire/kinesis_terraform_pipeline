module "qa" {
    source = "../modules/kinesis"

    environment = {
        name = "qa"
    }
}