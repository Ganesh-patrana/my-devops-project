# Start with a lightweight Python image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Install the Flask library
RUN pip install flask

# Copy our app.py into the container
COPY app.py .

# Tell the container to run our app
CMD ["python", "app.py"]