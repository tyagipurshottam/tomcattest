FROM centos:centos7 
MAINTAINER kirillf # Install prepare infrastructure 
RUN yum -y update && \
 yum -y install wget && \
 yum -y install tar
# Prepare environment 
ENV JAVA_HOME /opt/java 
ENV CATALINA_HOME /opt/tomcat 
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$CATALINA_HOME/scripts # Install Oracle Java8 
ENV JAVA_VERSION 8u162 ENV JAVA_BUILD 8u162-b12
ENV JAVA_DL_HASH 0da788060d494f5095bf8624735fa2f1 RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
 http://download.oracle.com/otn-pub/java/jdk/${JAVA_BUILD}/${JAVA_DL_HASH}/jdk-${JAVA_VERSION}-linux-x64.tar.gz && \
 tar -xvf jdk-${JAVA_VERSION}-linux-x64.tar.gz && \
 rm jdk*.tar.gz && \
 mv jdk* ${JAVA_HOME}
# Install Tomcat 
ENV TOMCAT_MAJOR 8 
ENV TOMCAT_VERSION 8.0.51 
RUN wget http://mirror.linux-ia64.org/apache/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
 tar -xvf apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
 rm apache-tomcat*.tar.gz && \
 mv apache-tomcat* ${CATALINA_HOME}
RUN chmod +x ${CATALINA_HOME}/bin/*sh
# Create tomcat user 
RUN groupadd -r tomcat && \
 useradd -g tomcat -d ${CATALINA_HOME} -s /sbin/nologin  -c "Tomcat user" tomcat && \
 chown -R tomcat:tomcat ${CATALINA_HOME}
WORKDIR /opt/tomcat
COPY target/*.war /opt/tomcat/webapps/
EXPOSE 8080 
EXPOSE 8009 
USER tomcat 
CMD ["tomcat.sh"]
