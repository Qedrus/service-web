# Utilisation de l'image officielle NGINX
FROM nginx:latest

# Supprimer la config par défaut et ajouter la nôtre
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/

# Exposer le port 80
EXPOSE 80

# Démarrer NGINX
CMD ["nginx", "-g", "daemon off;"]
