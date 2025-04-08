# Utilisation de l'image officielle WordPress
FROM wordpress:latest

# Définir les variables d’environnement
ENV WORDPRESS_DB_HOST=db
ENV WORDPRESS_DB_USER=wordpress
ENV WORDPRESS_DB_PASSWORD=wordpress
ENV WORDPRESS_DB_NAME=wordpress

# Exposer le port 80
EXPOSE 80

# Lancer Apache
CMD ["apache2-foreground"]
