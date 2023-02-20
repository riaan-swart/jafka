# Build

```
gradle build
gradle shadowJar
```

# Prepare keystore
```
bash configure-certificates.sh
```
# Run
```
java -cp build/libs/kafka-java-getting-started-0.0.1.jar examples.ProducerExample datastreams.properties
java -cp build/libs/kafka-java-getting-started-0.0.1.jar examples.ConsumerExample datastreams.properties
```