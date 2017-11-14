FROM kernsuite/base:3
RUN docker-apt-install prefactor
ENV PYTHONPATH /usr/lib/prefactor/scripts/
