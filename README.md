# kinesis_terraform_pipeline
In the book **Data Engineering with AWS**, by _Gareth Eager_, in Chapter 6: Ingesting Batch and Streaming Data,
they propone the following excercise:
> Earlier in this chapter, we looked at two options for ingesting streaming data into AWS, namely Amazon Kinesis and Amazon MSK. In this section, we will use the serverless Amazon Kinesis service to ingest streaming data. To generate streaming data, we will use the open source Amazon Kinesis Data Generator (KDG) In this section:
>+ Configure Amazon Kinesis Data Firehose to ingest streaming data, and write the data out to Amazon S3.
>+ Configure Amazon KDG to create a fake source of streaming data.

>To get started, let's configure a new Kinesis Data Firehose to ingest streaming data and write it out to our Amazon S3 data lake. 

The aim of this repo is to do the same excercise but in Terraform.

