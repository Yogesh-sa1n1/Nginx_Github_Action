# Use official Nginx image
FROM nginx:alpine

# Copy all HTML files to the default nginx public folder
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx (default CMD is already defined in the base image)
CMD ["nginx", "-g", "daemon off;"]
