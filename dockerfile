FROM centos:latest
MAINTAINER lzx  lzx@lzxlinux.com

RUN yum install -y wget vim curl unzip iproute net-tools && \
    yum clean all && \
    rm -rf /var/cache/yum/*

ADD jdk-8u212-linux-x64.tar.gz /usr/local/
RUN mv /usr/local/jdk1.8.0_212/ /usr/local/jdk && \
    wget http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-8/v8.5.41/bin/apache-tomcat-8.5.41.tar.gz && \
    tar zxf apache-tomcat-8.5.41.tar.gz && \
    mv apache-tomcat-8.5.41 /usr/local/tomcat && \
    wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz && \
    tar zxf apache-maven-3.6.1-bin.tar.gz && \
    mv apache-maven-3.6.1 /usr/local/maven && \
    wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war && \
    rm -rf /usr/local/tomcat/webapps/* && \
    unzip jenkins.war -d /usr/local/tomcat/webapps/ROOT && \
    rm -rf jenkins.war jdk-* apache-*
ENV JAVA_HOME /usr/local/jdk
ENV JRE_HOME /usr/local/jdk/jre
ENV CATALINA_HOME /usr/local/tomcat
ENV MAVEN_HOME /usr/local/maven
ENV CLASSPATH $JAVA_HOME/lib:$JRE_HOME/lib:$JRE_HOME/lib/charsets.jar

ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$CATALINA_HOME/lib:$MAVEN_HOME/bin
WORKDIR /usr/local/tomcat
EXPOSE 8080
CMD ["catalina.sh","run"]
