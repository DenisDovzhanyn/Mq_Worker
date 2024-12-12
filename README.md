### **Message Queue Worker**


# Message Queue Worker

The Message Queue Worker service processes messages from the RabbitMQ queue, stores them in the database, and communicates with the WebSocket Manager to ensure messages are broadcasted to the appropriate clients.

## Features

- **Message Queue Consumption**:
  - Retrieves messages from RabbitMQ queues.
  - Processes and validates messages.
- **Database Operations**: Inserts processed messages into the database.
- **WebSocket Manager Integration**:
  - Sends processed messages to the WebSocket Manager's API.
  - Ensures messages are broadcasted to all chat subscribers.

## Tech Stack

- **RabbitMQ**: Message queue for handling chat messages.
- **PostgreSQL**: Database for storing chat messages.
- **HTTP Client**: Communicates with the WebSocket Manager's API.

## Flow

1. A message is published to the RabbitMQ queue by the WebSocket Connections service.
2. The worker service retrieves the message.
3. The message is inserted into the PostgreSQL database.
4. The service makes an HTTP POST request to the WebSocket Manager API to broadcast the message.

