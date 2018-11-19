# ErllambdaElixirExample

Demonstrates a simple HTTP endpoint using API Gateway. You have full
access to the request and response payload, including headers and
status code.

To scan a DynamoDB table, make a GET request.
To put or delete an item, make a POST or DELETE request respectively,
passing in the query parameters as input for DynamoDB API.

## Usage

### Clone repository

    git clone git@github.com/alertlogic/erllambda_elixir_example
    cd erllambda_elixir_example

### Create package

To a package suitable for deployment, project should be compiled in an environment similar to an environment in which service is going to be started.

One of the options is to use docker. Docker image definitions with installed elixir can be found in [erllambda docker](https://github.com/alertlogic/erllambda_docker) repository.

If images are not yet available publicly in docker hub, they can be easily built locally:

    git clone git@github.com:alertlogic/erllambda_docker.git
    docker build -t erllambda:20.3 erllambda_docker/20
    docker build -t erllambda:20.3-elixir erllambda_docker/elixir

To create a zip package fetch all dependencies into the current directory and run erllambda release mix task in docker container:

    mix deps.get
    docker run -it --rm -v `pwd`:/buildroot -w /buildroot -e MIX_ENV=prod erllambda:20.3-elixir mix erllambda.release

This should create `erllambda_elixir_example.zip` package in release directory:

    _build/prod/rel/erllambda_elixir_example/releases/0.1.0/erllambda_elixir_example.zip

### Deploy AWS stack

#### Create bucket

    aws s3api create-bucket --bucket erllambda-elixir-example

#### Package artifacts

    aws cloudformation package \
        --template-file etc/template.yaml \
        --output-template-file packaged.yaml \
        --s3-bucket erllambda-elixir-example

#### Deploy stack

    aws cloudformation deploy --capabilities CAPABILITY_IAM \
        --template-file packaged.yaml \
        --stack-name erllambda-elixir-example


#### Call lambda

Once stack is successfully deployed it creates a publicly available API Gateway endpoint. To retrieve created endpoint value, describe stack and get the output value of the `ApiURL` endpoint:

    aws cloudformation describe-stacks \
        --stack-name erllambda-elixir-example \
            | jq -r .Stacks[].Outputs[].OutputValue

This should return URL similar to `https://fkwbu2l29x2.execute-api.us-east-1.amazonaws.com/Prod/MyResource/`


##### Create item

    http post https://fkwbu2l29x2.execute-api.us-east-1.amazonaws.com/Prod/MyResource \
        id==foo bar==quz

##### Get all items

    http https://fkwbu2l29x2.execute-api.us-east-1.amazonaws.com/Prod/MyResource

    [
        {
            "bar": "quz",
            "id": "foo"
        }
    ]

##### Delete an item

    http delete https://fkwbu2l29x2.execute-api.us-east-1.amazonaws.com/Prod/MyResource \
        id==foo
