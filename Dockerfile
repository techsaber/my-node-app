# Use the official Node.js 14 image
FROM node:14

# Create and change to the app directory
WORKDIR /app

# Copy the application code
COPY . .

# Install dependencies
RUN npm install

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
