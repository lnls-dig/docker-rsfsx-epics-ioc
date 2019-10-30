FROM lnls/epics-dist:base-3.15-synapps-lnls-R1-2-1-debian-9.5

ENV IOC_REPO rsfsx-epics-ioc
ENV BOOT_DIR iocrsfsx
ENV COMMIT v3.1.0-rc1

RUN git clone https://github.com/lnls-dig/${IOC_REPO}.git /opt/epics/${IOC_REPO} && \
    cd /opt/epics/${IOC_REPO} && \
    git checkout ${COMMIT} && \
    sed -i -e 's|^EPICS_BASE=.*$|EPICS_BASE=/opt/epics/base|' configure/RELEASE && \
    sed -i -e 's|^SUPPORT=.*$|SUPPORT=/opt/epics/synApps-lnls-R1-2-1/support|' configure/RELEASE && \
    sed -i -e 's|^STREAM=.*$|STREAM=$(SUPPORT)/stream-R2-8-8/StreamDevice-2-8-8|' configure/RELEASE && \
    sed -i -e 's|^SNCSEQ=.*$|SNCSEQ=$(SUPPORT)/seq-2-2-6|' configure/RELEASE && \
    sed -i -e 's|^CALC=.*$|CALC=$(SUPPORT)/calc-R3-7-2|' configure/RELEASE && \
    sed -i -e 's|^ASYN=.*$|ASYN=$(SUPPORT)/asyn-R4-35|' configure/RELEASE && \
    sed -i -e 's|^AUTOSAVE=.*$|AUTOSAVE=$(SUPPORT)/autosave-R5-9|' configure/RELEASE && \
    make && \
    make install && \
    make clean

# Source environment variables until we figure it out
# where to put system-wide env-vars on docker-debian
RUN . /root/.bashrc

WORKDIR /opt/epics/startup/ioc/${IOC_REPO}/iocBoot/${BOOT_DIR}

ENTRYPOINT ["./runProcServ.sh"]
