## 🍄 Mushroom App API 🍄

Welcome to the repository of the Mushroom App API, a Rails application designed to power the [Mushroom Mobile App](https://github.com/emibotti/mushroom-mobile) by providing an API for managing mushroom cultivation operations.

### Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation & Usage](#installation--usage)
- [Testing](#testing)
- [Environment Variables Configuration](#environment-variables-configuration)

### Features

- **User Authentication**: Implements secure user authentication and authorization using Devise with JWT for token-based authentication.
- **API**: Provides a RESTful API for managing organizations and mushroom cultivation operations.
- **Serialization**: Utilizes JSONAPI Serializer and Blueprinter for efficient and customizable JSON output.
- **Internationalization**: Supports multiple languages with Rails I18N.
- **QR Code Generation**: Allows for generating QR codes for created mycelium.
- **PDF Generation**: Supports generating PDF documents for QR code delivery.

### Prerequisites

Before you begin, ensure you have the following installed:

- Ruby 3.2.1
- Rails 7.0.4.2
- PostgreSQL

### Installation & Usage

To get the backend up and running, follow these steps:

1. Clone the repository and move to the folder:

```bash
git clone git@github.com:emibotti/mushroom-backend.git
cd mushroom-backend
```

2. Install dependencies:

```bash
bundle install
```

3. Setup the database:

```bash
rails db:create db:migrate
```

4. Start the Rails server:

```bash
rails server
```

The API will now be accessible at `http://localhost:3000`.

### Testing

To run the tests, use the following command:

```bash
rspec
```

Ensure all tests pass to verify that your setup is correct.

### Environment Variables Configuration

For the Mushroom App API to function properly, the following environment variables must be configured in your `.env` file:

- `DEVISE_SECRET_KEY`: This key is used by Devise for encrypting passwords and other sensitive data.
- `POSTGRES_PORT`: The port on which your PostgreSQL database listens. Default is `5432`.
- `JWT_EXPIRATION_DAYS`: Defines the lifespan of a JWT token in days.
- `EXPIRATION_TIME`: Expiration time in minutes for invitation codes within the app.
- `CUSTOM_URL_SCHEME`: The custom URL scheme used for deep linking within the mobile app.
- `WKHTMLTOPDF_PATH`: The file system path to the wkhtmltopdf executable