<<<<<<< HEAD
FROM google/dart
WORKDIR /app
ADD pubspec.* /app/
RUN pub get --no-precompile
ADD . /app/
RUN pub get --offline --no-precompile
WORKDIR /app
EXPOSE 80
ENTRYPOINT ["pub", "run", "aqueduct:aqueduct", "serve", "--port", "80"]
=======
FROM google/dart:latest

COPY ./ ./

# Install dependencies, pre-build
RUN pub get

# Optionally build generaed sources.
# RUN pub run build_runner build

# Set environment, start server
ENV ANGEL_ENV=production
EXPOSE 3000
CMD dart bin/prod.dart
>>>>>>> 486e6f4... init angel
