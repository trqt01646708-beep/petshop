# 🐾 Pet Shop - Pet Store Management System

The Pet Shop project is a professional e-commerce web application dedicated to trading pets and accessories, built with MVC architecture using pure PHP.

## 🚀 Technologies Used

- **Language:** PHP 8.x
- **Database:** MySQL
- **Architecture:** Model-View-Controller (MVC)
- **Frontend:** HTML5, CSS3, JavaScript (Vanilla JS), Bootstrap
- **Libraries/Integrations:**
  - **PHPMailer:** Sending authentication emails, OTPs, and notifications.
  - **VNPay:** Integrated online payment gateway.
  - **Chatbot:** Automated customer support.
  - **ngrok:** Used to expose the website to the internet during development (especially needed for VNPay and Webhooks).

## ✨ Key Features

### 🛍️ For Customers
- **Browsing Products:** View lists of pets and accessories, filter by category and price.
- **Cart & Payment:** Add products to cart, pay via VNPay or COD.
- **Account Management:** Register, login, secure with OTP via email.
- **Wishlist:** Save desired products to a Wishlist.
- **Order Tracking:** Check the status of order processing.
- **News & Feedback:** View latest news and send feedback on products/services.
- **Chatbot Support:** Quickly answer questions through the chat interface.

### 🛡️ For Administrators (Admin)
- **Dashboard:** Revenue reports, order and user statistics.
- **Product Management:** Add, edit, delete pets and accessories.
- **Order Management:** Process orders, update shipping status.
- **User Management:** Manage customer lists and admin permissions.
- **Promotion Management:** Create discount codes (Coupons), promotional programs.
- **News & Slider:** Update content displayed on the home page.
- **Admin Approval:** A system where admin registrations need approval.

## 📂 Directory Structure

```text
petshop/
├── app/                # Application logic
│   ├── config/         # Database, Mail, URL configurations
│   ├── controllers/    # Handle user requests
│   ├── core/           # Core classes (DB, Session, Controller)
│   ├── helpers/        # Helper functions (Validation, Mail, etc.)
│   ├── models/         # Database interactions
│   ├── routers/        # Route definitions (Web & Admin)
│   └── views/          # Display interfaces (HTML/PHP)
├── database/           # Contains SQL export files (.sql)
├── public/             # Public directory (Entry point)
│   ├── assets/         # CSS, JS, Image, Font
│   ├── uploads/        # Product images, uploaded avatars
│   └── index.php       # Main bootstrap file
├── vendor/             # Third-party libraries (Composer)
├── vnpay_php/          # VNPay payment gateway integration code
└── README.md           # Documentation guide (This file)
```

## 🛠️ Installation Guide

1. **Clone/Download Project:** Place it in the `htdocs` directory of XAMPP.
2. **Import Database:**
   - Open PHPMyAdmin.
   - Create a database named `petshop`.
   - Import the file `database/petshop.sql`.
3. **Configuration:**
   - **Database & URL:** Edit in `app/config/config.php`. Note to update `BASE_URL` with your ngrok link.
   - **Mail Server:** Edit in `app/config/mail_config.php` for sending OTP/Notifications.
   - **VNPay:** Update Merchant information in `vnpay_php/config.php`.
4. **Running the Application:**
   - Open XAMPP and start Apache & MySQL.
   - Using ngrok: `ngrok http 80` (if public link is needed).
   - Access via the configured URL.

---
© 2025 Pet Shop Project.
