IMAGE_REPO ?= ikyrannas/lst-bench
DOCKER ?= docker

PROFILES := base spark-jdbc spark-client trino-jdbc databricks-jdbc snowflake-jdbc microsoft-fabric-jdbc

.PHONY: help
help:
	@echo "Targets:"
	@echo "  build-<profile>  Build image for profile (e.g., build-spark-jdbc)"
	@echo "  push-<profile>   Push image for profile (e.g., push-spark-jdbc)"
	@echo "  build-all        Build all profile images"
	@echo "  push-all         Push all profile images"
	@echo ""
	@echo "Vars:"
	@echo "  IMAGE_REPO=ikyrannas/lst-bench  Docker image repo"
	@echo "  DOCKER=docker                  Docker binary"

.PHONY: build-all
build-all: $(addprefix build-,$(PROFILES))

.PHONY: push-all
push-all: $(addprefix push-,$(PROFILES))

.PHONY: build-base
build-base:
	$(DOCKER) build -t $(IMAGE_REPO):base .

.PHONY: build-spark-jdbc
build-spark-jdbc:
	$(DOCKER) build -t $(IMAGE_REPO):spark-jdbc --build-arg MAVEN_PROFILES=spark-jdbc .

.PHONY: build-spark-client
build-spark-client:
	$(DOCKER) build -t $(IMAGE_REPO):spark-client --build-arg MAVEN_PROFILES=spark-client .

.PHONY: build-trino-jdbc
build-trino-jdbc:
	$(DOCKER) build -t $(IMAGE_REPO):trino-jdbc --build-arg MAVEN_PROFILES=trino-jdbc .

.PHONY: build-databricks-jdbc
build-databricks-jdbc:
	$(DOCKER) build -t $(IMAGE_REPO):databricks-jdbc --build-arg MAVEN_PROFILES=databricks-jdbc .

.PHONY: build-snowflake-jdbc
build-snowflake-jdbc:
	$(DOCKER) build -t $(IMAGE_REPO):snowflake-jdbc --build-arg MAVEN_PROFILES=snowflake-jdbc .

.PHONY: build-microsoft-fabric-jdbc
build-microsoft-fabric-jdbc:
	$(DOCKER) build -t $(IMAGE_REPO):microsoft-fabric-jdbc --build-arg MAVEN_PROFILES=microsoft-fabric-jdbc .

.PHONY: push-base
push-base:
	$(DOCKER) push $(IMAGE_REPO):base

.PHONY: push-spark-jdbc
push-spark-jdbc:
	$(DOCKER) push $(IMAGE_REPO):spark-jdbc

.PHONY: push-spark-client
push-spark-client:
	$(DOCKER) push $(IMAGE_REPO):spark-client

.PHONY: push-trino-jdbc
push-trino-jdbc:
	$(DOCKER) push $(IMAGE_REPO):trino-jdbc

.PHONY: push-databricks-jdbc
push-databricks-jdbc:
	$(DOCKER) push $(IMAGE_REPO):databricks-jdbc

.PHONY: push-snowflake-jdbc
push-snowflake-jdbc:
	$(DOCKER) push $(IMAGE_REPO):snowflake-jdbc

.PHONY: push-microsoft-fabric-jdbc
push-microsoft-fabric-jdbc:
	$(DOCKER) push $(IMAGE_REPO):microsoft-fabric-jdbc
