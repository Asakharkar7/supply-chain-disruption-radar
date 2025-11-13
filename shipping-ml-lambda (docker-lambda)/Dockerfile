FROM public.ecr.aws/lambda/python:3.9

# Set working directory
WORKDIR ${LAMBDA_TASK_ROOT}

# Install dependencies
COPY requirements.txt ./
RUN pip install -r requirements.txt -t .

# Copy inference code
COPY app.py ./

# Copy ML models
COPY models ./models

# Set Lambda handler
CMD ["app.lambda_handler"]

