<<<<<<< HEAD
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.layout.buildDirectory.set(layout.projectDirectory.dir("../build"))

subprojects {
    project.layout.buildDirectory.set(rootProject.layout.buildDirectory.dir(project.name))
}

subprojects {
    if (project.name != "app") {
        project.evaluationDependsOn(":app")
    }
=======
// Root build.gradle.kts
rootProject.layout.buildDirectory.value(rootProject.layout.projectDirectory.dir("../build"))

subprojects {
    project.layout.buildDirectory.value(rootProject.layout.buildDirectory.dir(project.name))
}

subprojects {
    project.evaluationDependsOn(":app")
>>>>>>> origin/wipsy
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
