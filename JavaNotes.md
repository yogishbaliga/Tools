## How to enable slf4j logging with log4j2 in Java

Include the following libraries in build.gradle
```
ext {
    slf4jVersion = "1.7.32"
    log4j2Version = "2.17.1"
}

dependencies {
    implementation("org.slf4j:slf4j-api:$slf4jVersion")
    implementation("org.apache.logging.log4j:log4j-slf4j-impl:$log4j2Version")
    implementation("org.apache.logging.log4j:log4j-api:$log4j2Version")
    implementation("org.apache.logging.log4j:log4j-core:$log4j2Version")
}
```
