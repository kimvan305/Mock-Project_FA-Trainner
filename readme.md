--upload csv to s3
aws --endpoint-url=http://localhost:4566 s3 cp C:\Users\WINDOW\Documents\GitHub\Mock-Project_FA-Trainner\test.csv  s3://bucket-csv
aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name -'count-row-csv'
aws --endpoint-url=http://localhost:4566 s3 ls s3://bucket-csv 

-- reference of boto3.client:  https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#client

-- install new library in Python: py -m pip install