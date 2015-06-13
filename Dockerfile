FROM stackbrew/ubuntu:14.04

RUN apt-get update
RUN apt-get -y install default-jre
RUN apt-get -y install wget
RUN apt-get -y clean

RUN wget -P /opt/torquebox-dist-3.1.1 http://d2t70pdxfgqbmq.cloudfront.net/release/org/torquebox/torquebox-dist/3.1.1/torquebox-dist-3.1.1-bin.zip 
 && unzip -q /opt/torquebox-dist-3.1.0-bin.zip -d /opt && mv /opt/torquebox-3.1.0 /opt/torquebox
RUN unzip -q torquebox-dist-3.1.0-bin.zip -d /opt
RUN mv /opt/torquebox-3.1.0 /opt/torquebox

RUN cd /opt && curl -L https://d2t70pdxfgqbmq.cloudfront.net/release/org/torquebox/torquebox-dist/$TORQUEBOX_VERSION/torquebox-dist-$TORQUEBOX_VERSION-bin.zip -o torquebox.zip && unzip -q torquebox.zip && rm torquebox.zip

# Verify if this is desired and done correctly
RUN useradd torquebox -c"Torquebox system user" -M -ptorquebox
# Verify this too
RUN adduser --disabled-password --home=/opt/leadpass --gecos "" leadpass

ENV TORQUEBOX_HOME /opt/torquebox
ENV JBOSS_HOME /opt/torquebox/jboss
ENV JRUBY_HOME /opt/torquebox/jruby
ENV PATH $JBOSS_HOME/bin:$JRUBY_HOME/bin:$PATH

ADD . /opt/leadpass
WORKDIR /opt/leadpass
RUN bundle install
RUN chown -R leadpass:leadpass /opt/leadpass

EXPOSE 8080
USER leadpass
