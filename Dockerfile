# curl https://www.qlcplus.org/downloads/5.3.0/qlcplus5_5.3.0_amd64.deb --output qlcplus5.deb
# docker image build -t qlcplus .

# //TODO the t64 dependencies do not work on ubuntu 26.04 (skill issue I am sure)
FROM ubuntu:24.04

#copy entrypoint script out of the dir
COPY entrypoint.sh /QLC/entrypoint.sh
COPY qlcplus5.deb /QLC/qlcplus5.deb

#install all pckgs needed for QLC+
ENV QLC_DEPENDS="\
                libasound2t64 \
                libfftw3-double3 \
                libftdi1-2 \
                libqt63dcore6 \
                libqt63dextras6 \
                libqt63dlogic6 \
                libqt63drender6 \
                libqt6core6 \
                libqt6gui6t64 \
                libqt6multimedia6 \
                libqt6network6t64 \
                libqt6printsupport6t64 \
                libqt6qml6 \
                libqt6quick6 \
                libqt6serialport6 \
                libqt6svg6 \
                libqt6websockets6 \
                libqt6widgets6t64 \
                qt6-websockets-abi \
                qlcplus-data \
                qml6-module-qtqml-workerscript \
                qml6-module-qtquick-controls \
                qml6-module-qtquick-dialogs \
                qml6-module-qtquick-layouts \
                qml6-module-qtquick-templates \
                qml6-module-qtquick-window \
                libusb-1.0-0 \
                libxcb-cursor0 \
                libxcb-xinerama0 \
                usbutils \
                udev \
                bash"

RUN apt update && apt upgrade -y
RUN apt install -y ${QLC_DEPENDS}
RUN apt clean

RUN adduser root dialout

RUN dpkg -i /QLC/qlcplus5.deb

#expose port for web interface
EXPOSE 9999

#work volume to bind the project in
VOLUME /QLC

#entrypoint bash script --> will be executed every time when a container of this image will be started
ENTRYPOINT ["bash" , "/QLC/entrypoint.sh"]
