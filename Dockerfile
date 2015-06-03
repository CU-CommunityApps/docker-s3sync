# Pull base image.
FROM docker.cucloud.net/awscli

# create and own sync directory
RUN mkdir /sync &&\
   chown daemon:daemon /sync

# copy the sync script and set permissions
COPY sync.rb /opt/sync.rb
RUN chown daemon:daemon /opt/sync.rb &&\
   chmod 775 /opt/sync.rb 

# set the working directory to /sync
WORKDIR /sync

# set the running user to deamon, dont run as root
USER daemon

# run the sync app
CMD /opt/sync.rb