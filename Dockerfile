FROM nginx:alpine

# Copy the static app files into the Nginx web root
COPY app/ /usr/share/nginx/html/

# Copy a custom nginx config to listen on port 8080
COPY nginx.conf /etc/nginx/nginx.conf

# Expose the application port
EXPOSE 8080

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
