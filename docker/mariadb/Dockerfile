# Utiliser l'image officielle MariaDB comme base
FROM mariadb:10.8.2

# Définir des variables d’environnement par défaut (peuvent être surchargées dans docker-compose)
ENV MYSQL_ROOT_PASSWORD=password
ENV MYSQL_DATABASE=storedb
ENV MYSQL_USER=admin
ENV MYSQL_PASSWORD=password

# Exposer le port par défaut
EXPOSE 3306
