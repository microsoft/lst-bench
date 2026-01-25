FROM eclipse-temurin:17-jdk-jammy AS build

WORKDIR /workspace

COPY . .

ARG MAVEN_PROFILES=""

RUN if [ -n "${MAVEN_PROFILES}" ]; then \
      ./mvnw -pl core -am package -P"${MAVEN_PROFILES}"; \
    else \
      ./mvnw -pl core -am package; \
    fi

FROM eclipse-temurin:17-jre-jammy

ARG LST_BENCH_UID=10001
ARG LST_BENCH_GID=10001

RUN groupadd -g "${LST_BENCH_GID}" lstbench \
    && useradd -r -u "${LST_BENCH_UID}" -g lstbench -m -d /opt/lst-bench lstbench

WORKDIR /opt/lst-bench

COPY --from=build /workspace/core/target/ /opt/lst-bench/core/target/
COPY --from=build /workspace/launcher.sh /opt/lst-bench/launcher.sh

RUN chmod +x /opt/lst-bench/launcher.sh \
    && chown -R lstbench:lstbench /opt/lst-bench

USER lstbench

ENV LST_BENCH_HOME=/opt/lst-bench

ENTRYPOINT ["/opt/lst-bench/launcher.sh"]
