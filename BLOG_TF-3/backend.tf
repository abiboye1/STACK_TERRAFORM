terraform{
         backend "s3"{
                bucket= "stackbuckstateabib"
                key = "terraform.tfsate"
                region="us-east-1"
                dynamodb_table="statelock-tf"
                 }
 }