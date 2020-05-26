# Imager
Ruby application to resize images

## Description
Imager is a Ruby application to resize images, using S3 as a backend. It uses [Sinatra](http://sinatrarb.com/) to serve images via API request.

## Download source code
Make sure you have the git CLI installed, then execute the following command:
```
git clone https://github.com/leodamasceno/imager.git
```

## Configuration
You may need to change some files in order to get it working for you. <br/>
**config.yaml**<br/>
- Change the *auth type* if you want to use a role
- Set the *bucket_name*

Here's an example:
```
config:
  auth:
    type: credentials
  s3:
    bucket_name: bucket-test
    local_path: /tmp
```
If that's the case, you will need to pass the AWS variables as environment variables via *Dockerfile*. Here are the variables:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION

Also, an example using a role from AWS is provided:
```
config:
  auth:
    type: role
    arn: YOUR_ROLE_ARN
  s3:
    bucket_name: bucket-test
    local_path: /tmp
```

**IMPORTANT:**
- Make sure your role has the right policies that will allow the application to access your AWS S3 Bucket.
- We use *thin* as the web server, this is not what you want in a production scenario. Remove this gem from the *Gemfile*.  

## Running app
You can run it on your computer, server, or cloud. Follow the steps below to execute it with Docker.<br/><br/>
**Build the docker image**<br/>
Go into the git repository you cloned in the step above and run:
```
cd docker/imager
docker build . -t "imager:0.0.1"
```

Update the tag as you want. In the example above, we used ***0.0.1***.

Push it to your repository if you're deploying to production, such as Docker Hub, Jfrog Artifactory, AWS ECR, etc.

Then, run it locally with the following command:
```
docker run -p 80:4567 imager:0.0.1
```

You will be able to access it using the web browser, curl or wget. As an example:
```
curl http://127.0.0.1/image.png?200x200
```

In the example above, the application will look for the image named *image.png* in the bucket specified in the configuration file *config.yaml* and resize it to 200x200.

## Things to consider
- The AWS credentials need to be from the same region as the bucket, you will not be able to retrieve the image via application otherwise.
- The application only works with AWS S3 as backend to store images. We are aware we need to improve this and we will probably work to implement other backends from different cloud providers, such as Google Cloud and Azure.

## What else?
That's it for now, we hope to add more features in a near future. Please, feel free to open issues to help us to improve the application.
