-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th12 23, 2025 lúc 08:04 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `petshop`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action` varchar(100) NOT NULL,
  `entity_type` varchar(50) DEFAULT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `banners`
--

CREATE TABLE `banners` (
  `id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `image` varchar(255) NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `position` enum('home_slider','home_banner','sidebar') DEFAULT 'home_slider',
  `display_order` int(11) DEFAULT 0,
  `status` enum('active','inactive') DEFAULT 'active',
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `session_id` varchar(100) DEFAULT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT 1,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `display_order` int(11) DEFAULT 0,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `image`, `parent_id`, `display_order`, `status`, `created_at`, `updated_at`) VALUES
(13, 'Thú cưng', 'thu-cung', 'Danh mục thú cưng', NULL, NULL, 1, 'active', '2025-12-13 03:50:03', '2025-12-13 03:50:03'),
(14, 'Phụ kiện thú cưng', 'phu-kien-thu-cung', 'Phụ kiện cho thú cưng', NULL, NULL, 2, 'active', '2025-12-13 03:50:03', '2025-12-13 03:50:03'),
(15, 'Thức ăn thú cưng', 'thuc-an-thu-cung', 'Thức ăn cho thú cưng', NULL, NULL, 3, 'active', '2025-12-13 03:50:03', '2025-12-13 03:50:03'),
(33, 'mèo', 'meo', 'dễ thương', NULL, NULL, 0, 'active', '2025-12-13 05:18:03', '2025-12-13 05:18:03');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `contract_products`
--

CREATE TABLE `contract_products` (
  `id` int(11) NOT NULL,
  `contract_id` int(11) NOT NULL COMMENT 'ID hợp đồng',
  `product_id` int(11) NOT NULL COMMENT 'ID sản phẩm của shop',
  `committed_quantity` int(11) NOT NULL DEFAULT 0 COMMENT 'Số lượng cam kết cung cấp',
  `delivered_quantity` int(11) NOT NULL DEFAULT 0 COMMENT 'Số lượng đã giao thực tế',
  `allow_over_import` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Cho phép nhập vượt số lượng cam kết (0=Không, 1=Có)',
  `import_price` decimal(12,2) NOT NULL COMMENT 'Giá nhập theo hợp đồng',
  `unit` varchar(50) DEFAULT 'cái' COMMENT 'Đơn vị tính',
  `notes` text DEFAULT NULL COMMENT 'Ghi chú',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `coupons`
--

CREATE TABLE `coupons` (
  `id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `discount_type` enum('percent','fixed') DEFAULT 'percent',
  `apply_to` enum('product','shipping','all') NOT NULL DEFAULT 'product' COMMENT 'Áp dụng cho: product=Sản phẩm, shipping=Phí vận chuyển, all=Cả hai',
  `discount_value` decimal(10,2) NOT NULL,
  `min_order_value` decimal(10,2) DEFAULT 0.00,
  `max_discount` decimal(10,2) DEFAULT NULL,
  `usage_limit` int(11) DEFAULT 1,
  `used_count` int(11) DEFAULT 0,
  `valid_from` datetime NOT NULL,
  `valid_to` datetime NOT NULL,
  `status` enum('active','inactive','expired') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `coupons`
--

INSERT INTO `coupons` (`id`, `code`, `description`, `discount_type`, `apply_to`, `discount_value`, `min_order_value`, `max_discount`, `usage_limit`, `used_count`, `valid_from`, `valid_to`, `status`, `created_at`, `updated_at`) VALUES
(5, 'FREESHIP', '', 'percent', 'shipping', 10.00, 0.00, NULL, 1, 0, '2025-12-13 11:08:00', '2025-12-25 11:08:00', 'active', '2025-12-13 04:08:30', '2025-12-13 04:08:30');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `coupon_usage`
--

CREATE TABLE `coupon_usage` (
  `id` int(11) NOT NULL,
  `coupon_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `discount_amount` decimal(10,2) NOT NULL,
  `used_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `subject` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `type` enum('complaint','suggestion','question','product_inquiry','other') DEFAULT 'other',
  `status` enum('new','processing','resolved','closed') DEFAULT 'new',
  `admin_reply` text DEFAULT NULL,
  `replied_by` int(11) DEFAULT NULL,
  `replied_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `news`
--

CREATE TABLE `news` (
  `id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `excerpt` text DEFAULT NULL,
  `content` longtext NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `author_id` int(11) NOT NULL,
  `category` varchar(50) DEFAULT NULL,
  `views` int(11) DEFAULT 0,
  `status` enum('draft','published','archived') DEFAULT 'draft',
  `published_at` datetime DEFAULT NULL,
  `meta_title` varchar(200) DEFAULT NULL,
  `meta_description` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `news`
--

INSERT INTO `news` (`id`, `title`, `slug`, `excerpt`, `content`, `image`, `author_id`, `category`, `views`, `status`, `published_at`, `meta_title`, `meta_description`, `created_at`, `updated_at`) VALUES
(5, 'Hướng dẫn chăm sóc mèo cho người mới', 'huong-dan-cham-soc-meo', 'Những điều cần biết khi nuôi mèo lần đầu', 'Việc chăm sóc mèo cần chú ý đến chế độ ăn uống, vệ sinh và tiêm phòng đầy đủ...', NULL, 17, 'Chăm sóc thú cưng', 0, 'published', '2025-12-13 10:59:01', NULL, NULL, '2025-12-13 03:59:01', '2025-12-13 03:59:01');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `news_comments`
--

CREATE TABLE `news_comments` (
  `id` int(11) NOT NULL,
  `news_id` int(11) NOT NULL COMMENT 'ID tin tức',
  `user_id` int(11) NOT NULL COMMENT 'ID người dùng',
  `parent_id` int(11) DEFAULT NULL COMMENT 'ID bình luận cha (cho reply)',
  `content` text NOT NULL COMMENT 'Nội dung bình luận',
  `status` enum('visible','hidden','deleted') NOT NULL DEFAULT 'visible' COMMENT 'Trạng thái hiển thị',
  `is_spam` tinyint(1) DEFAULT 0 COMMENT 'Đánh dấu spam',
  `admin_reason` text DEFAULT NULL COMMENT 'Lý do ẩn/xóa từ admin',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bình luận tin tức';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `news_likes`
--

CREATE TABLE `news_likes` (
  `id` int(11) NOT NULL,
  `news_id` int(11) NOT NULL COMMENT 'ID tin tức',
  `user_id` int(11) NOT NULL COMMENT 'ID người dùng',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Yêu thích tin tức';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `type` enum('review_approved','review_rejected','order_status','promotion','system') NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `link` varchar(500) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `type`, `title`, `message`, `link`, `is_read`, `created_at`) VALUES
(55, 7, 'order_status', '🎉 Đặt hàng thành công #ORD202512131104491414', 'Đơn hàng của bạn đã được tiếp nhận. Chúng tôi sẽ xử lý trong thời gian sớm nhất.', '/orders/detail/53', 1, '2025-12-13 04:04:49'),
(56, 7, 'order_status', '❌ Đơn hàng #ORD202512131104491414 đã bị hủy', 'Đơn hàng của bạn đã được hủy thành công. Lý do: hết tiền', '/orders/detail/53', 0, '2025-12-13 04:06:16'),
(57, 7, 'promotion', '🎉 Khuyến mãi mới: sasds', 'Giảm 5%. Áp dụng từ 13/12/2025 đến 24/12/2025', '/products', 0, '2025-12-13 04:07:39'),
(58, 18, 'promotion', '🎉 Khuyến mãi mới: sasds', 'Giảm 5%. Áp dụng từ 13/12/2025 đến 24/12/2025', '/products', 0, '2025-12-13 04:07:39'),
(59, 20, 'promotion', '🎉 Khuyến mãi mới: sasds', 'Giảm 5%. Áp dụng từ 13/12/2025 đến 24/12/2025', '/products', 0, '2025-12-13 04:07:39'),
(60, 7, 'promotion', '🎁 Mã giảm giá mới: FREESHIP', 'Giảm 10%. Áp dụng từ 13/12/2025 đến 25/12/2025', '/orders/checkout', 1, '2025-12-13 04:08:30'),
(61, 18, 'promotion', '🎁 Mã giảm giá mới: FREESHIP', 'Giảm 10%. Áp dụng từ 13/12/2025 đến 25/12/2025', '/orders/checkout', 0, '2025-12-13 04:08:30'),
(62, 20, 'promotion', '🎁 Mã giảm giá mới: FREESHIP', 'Giảm 10%. Áp dụng từ 13/12/2025 đến 25/12/2025', '/orders/checkout', 0, '2025-12-13 04:08:30'),
(63, 7, 'order_status', '🎉 Đặt hàng thành công #ORD202512131210551227', 'Đơn hàng của bạn đã được tiếp nhận. Chúng tôi sẽ xử lý trong thời gian sớm nhất.', '/orders/detail/54', 0, '2025-12-13 05:10:55'),
(64, 7, 'order_status', 'Cập nhật đơn hàng #54', '✅ Đơn hàng đã được xác nhận', '/orders/detail/54', 0, '2025-12-13 05:14:46'),
(65, 7, 'order_status', 'Cập nhật đơn hàng #54', 'Đơn hàng có cập nhật mới', '/orders/detail/54', 0, '2025-12-13 05:15:09'),
(66, 7, 'order_status', 'Cập nhật đơn hàng #54', '🚚 Đơn hàng đang được giao', '/orders/detail/54', 0, '2025-12-13 05:15:25'),
(67, 7, 'order_status', 'Cập nhật đơn hàng #54', '📦 Đơn hàng đã giao thành công', '/orders/detail/54', 0, '2025-12-13 05:15:42'),
(68, 7, 'promotion', '🎉 Khuyến mãi mới: thien', 'Giảm 5%. Áp dụng từ 12/12/2025 đến 18/12/2025', '/products', 0, '2025-12-13 05:19:07'),
(69, 18, 'promotion', '🎉 Khuyến mãi mới: thien', 'Giảm 5%. Áp dụng từ 12/12/2025 đến 18/12/2025', '/products', 0, '2025-12-13 05:19:07'),
(70, 20, 'promotion', '🎉 Khuyến mãi mới: thien', 'Giảm 5%. Áp dụng từ 12/12/2025 đến 18/12/2025', '/products', 0, '2025-12-13 05:19:07'),
(71, 7, 'order_status', '🎉 Đặt hàng thành công #ORD202512131223115931', 'Đơn hàng của bạn đã được tiếp nhận. Chúng tôi sẽ xử lý trong thời gian sớm nhất.', '/orders/detail/55', 0, '2025-12-13 05:23:11'),
(72, 7, 'order_status', 'Cập nhật đơn hàng #55', '✅ Đơn hàng đã được xác nhận', '/orders/detail/55', 0, '2025-12-13 05:23:37'),
(73, 7, 'order_status', 'Cập nhật đơn hàng #55', 'Đơn hàng có cập nhật mới', '/orders/detail/55', 0, '2025-12-13 05:23:44'),
(74, 7, 'order_status', 'Cập nhật đơn hàng #55', '🚚 Đơn hàng đang được giao', '/orders/detail/55', 0, '2025-12-13 05:23:50'),
(75, 7, 'order_status', 'Cập nhật đơn hàng #55', '📦 Đơn hàng đã giao thành công', '/orders/detail/55', 0, '2025-12-13 05:23:56'),
(76, 7, 'order_status', '🎉 Đặt hàng thành công #ORD202512231328041101', 'Đơn hàng của bạn đã được tiếp nhận. Chúng tôi sẽ xử lý trong thời gian sớm nhất.', '/orders/detail/56', 0, '2025-12-23 06:28:04');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `order_code` varchar(50) NOT NULL,
  `customer_name` varchar(100) NOT NULL,
  `customer_email` varchar(100) NOT NULL,
  `customer_phone` varchar(20) NOT NULL,
  `shipping_address` text NOT NULL,
  `shipping_note` text DEFAULT NULL,
  `shipping_method` enum('standard','express','same_day','pickup') NOT NULL DEFAULT 'standard' COMMENT 'Hình thức giao hàng: standard=Tiêu chuẩn, express=Nhanh, same_day=Trong ngày, pickup=Nhận tại cửa hàng',
  `subtotal` decimal(10,2) NOT NULL,
  `shipping_fee` decimal(10,2) DEFAULT 0.00,
  `product_discount` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Số tiền giảm giá cho sản phẩm',
  `shipping_discount` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Số tiền giảm giá cho phí vận chuyển',
  `discount` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL,
  `payment_method` enum('cod','vnpay','bank_transfer') DEFAULT 'cod',
  `coupon_code` varchar(50) DEFAULT NULL COMMENT 'Mã giảm giá đã sử dụng',
  `coupon_discount` decimal(10,2) DEFAULT 0.00 COMMENT 'Số tiền giảm từ coupon',
  `payment_status` enum('pending','paid','failed','refunded') DEFAULT 'pending',
  `payment_info` text DEFAULT NULL,
  `order_status` enum('pending','confirmed','processing','shipping','delivered','cancelled') DEFAULT 'pending',
  `cancel_reason` text DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `delivered_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `order_code`, `customer_name`, `customer_email`, `customer_phone`, `shipping_address`, `shipping_note`, `shipping_method`, `subtotal`, `shipping_fee`, `product_discount`, `shipping_discount`, `discount`, `total`, `payment_method`, `coupon_code`, `coupon_discount`, `payment_status`, `payment_info`, `order_status`, `cancel_reason`, `cancelled_at`, `delivered_at`, `created_at`, `updated_at`) VALUES
(53, 7, 'ORD202512131104491414', 'Nguyễn Đình Tuấn', 'xmeo2612@gmail.com', '0987654321', '2B, ngõ 107 hữu hưng, Phường Tây Mỗ, Quận Nam Từ Liêm, Thành phố Hà Nội', '', 'standard', 42500000.00, 30000.00, 0.00, 0.00, 0.00, 42530000.00, 'vnpay', '', 0.00, 'failed', '{\"vnp_Amount\":\"4253000000\",\"vnp_BankCode\":\"VNPAY\",\"vnp_CardType\":\"QRCODE\",\"vnp_OrderInfo\":\"Thanh toan don hang ORD202512131104491414\",\"vnp_PayDate\":\"20251213110457\",\"vnp_ResponseCode\":\"24\",\"vnp_TmnCode\":\"H1OVTWIU\",\"vnp_TransactionNo\":\"0\",\"vnp_TransactionStatus\":\"02\",\"vnp_TxnRef\":\"ORD202512131104491414\",\"vnp_SecureHash\":\"38126901f0c9555cf4445a30ea4518690ed4ab84e5d8d367acb0e6e8b04b2a31e2d62b8a36bf989f16ebe3267619921e8ea8dfb92d2b6f1773b6f8479fa818a4\"}', 'cancelled', 'hết tiền', '2025-12-13 11:06:16', NULL, '2025-12-13 04:04:49', '2025-12-13 04:06:16'),
(54, 7, 'ORD202512131210551227', 'Nguyễn Công Thành', 'xmeo2612@gmail.com', '0987654321', 'abc, Xã Hoàng Kim, Huyện Mê Linh, Thành phố Hà Nội', '', 'standard', 8075000.00, 30000.00, 0.00, 0.00, 0.00, 8105000.00, 'vnpay', '', 0.00, 'paid', '{\"vnp_Amount\":\"810500000\",\"vnp_BankCode\":\"NCB\",\"vnp_BankTranNo\":\"VNP15338605\",\"vnp_CardType\":\"ATM\",\"vnp_OrderInfo\":\"Thanh toan don hang ORD202512131210551227\",\"vnp_PayDate\":\"20251213121323\",\"vnp_ResponseCode\":\"00\",\"vnp_TmnCode\":\"H1OVTWIU\",\"vnp_TransactionNo\":\"15338605\",\"vnp_TransactionStatus\":\"00\",\"vnp_TxnRef\":\"ORD202512131210551227\",\"vnp_SecureHash\":\"1346f162911b1d03ee4cd55aecbdf89a8b5531ad3e2f073378f909fb1ba1167a868fc3f283c17568bfbf7afa0a5ac6bc1950b783092779424c87db96442bf62d\"}', 'delivered', NULL, NULL, NULL, '2025-12-13 05:10:55', '2025-12-13 05:15:42'),
(55, 7, 'ORD202512131223115931', 'Nguyễn Công Thành', 'xmeo2612@gmail.com', '0987654321', 'abc, Xã Hoàng Kim, Huyện Mê Linh, Thành phố Hà Nội', '', 'standard', 11400000.00, 30000.00, 0.00, 0.00, 0.00, 11430000.00, 'cod', '', 0.00, 'paid', 'Auto-confirmed on delivery/pickup', 'delivered', NULL, NULL, NULL, '2025-12-13 05:23:11', '2025-12-13 05:23:56'),
(56, 7, 'ORD202512231328041101', 'Nguyễn Công Thành', 'xmeo2612@gmail.com', '0987654321', 'abc, Xã Hoàng Kim, Huyện Mê Linh, Thành phố Hà Nội', '', 'standard', 8075000.00, 30000.00, 0.00, 0.00, 0.00, 8105000.00, 'vnpay', '', 0.00, 'paid', '{\"vnp_Amount\":\"810500000\",\"vnp_BankCode\":\"NCB\",\"vnp_BankTranNo\":\"VNP15362879\",\"vnp_CardType\":\"ATM\",\"vnp_OrderInfo\":\"Thanh toan don hang ORD202512231328041101\",\"vnp_PayDate\":\"20251223132838\",\"vnp_ResponseCode\":\"00\",\"vnp_TmnCode\":\"VVKIM0SM\",\"vnp_TransactionNo\":\"15362879\",\"vnp_TransactionStatus\":\"00\",\"vnp_TxnRef\":\"ORD202512231328041101\",\"vnp_SecureHash\":\"7afe99b23e06873dc4b2d8f72df1ad26670162dc62396e9a3571899bbb507e4a75324aaa8ce56e57ff05a81056077c89738e13eea834ee05e60e17a9a012d95b\"}', 'pending', NULL, NULL, NULL, '2025-12-23 06:28:04', '2025-12-23 06:28:57');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(200) NOT NULL,
  `product_image` varchar(255) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `product_name`, `product_image`, `quantity`, `price`, `subtotal`, `created_at`) VALUES
(71, 53, 18, 'Chó Poodle nâu', '693ce556b7e3a_anh2.jpg', 5, 8500000.00, 42500000.00, '2025-12-13 04:04:49'),
(72, 54, 18, 'Chó Poodle nâu', '693ce556b7e3a_anh2.jpg', 1, 8075000.00, 8075000.00, '2025-12-13 05:10:55'),
(73, 55, 19, 'Mèo Anh lông ngắn', '693ce55ebff6e_anh-mo-ta.jfif', 1, 11400000.00, 11400000.00, '2025-12-13 05:23:11'),
(74, 56, 18, 'Chó Poodle nâu', '693ce556b7e3a_anh2.jpg', 1, 8075000.00, 8075000.00, '2025-12-23 06:28:04');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_tracking`
--

CREATE TABLE `order_tracking` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `status` varchar(50) NOT NULL,
  `note` text DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `short_description` varchar(500) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock_quantity` int(11) DEFAULT 0,
  `image` varchar(255) DEFAULT NULL,
  `gallery` text DEFAULT NULL,
  `sku` varchar(50) DEFAULT NULL,
  `views` int(11) DEFAULT 0,
  `status` enum('active','inactive','out_of_stock') DEFAULT 'active',
  `is_featured` tinyint(1) DEFAULT 0,
  `is_bestseller` tinyint(1) DEFAULT 0,
  `meta_title` varchar(200) DEFAULT NULL,
  `meta_description` varchar(500) DEFAULT NULL,
  `meta_keywords` varchar(200) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `products`
--

INSERT INTO `products` (`id`, `category_id`, `name`, `slug`, `description`, `short_description`, `price`, `stock_quantity`, `image`, `gallery`, `sku`, `views`, `status`, `is_featured`, `is_bestseller`, `meta_title`, `meta_description`, `meta_keywords`, `created_at`, `updated_at`) VALUES
(18, 13, 'Chó Poodle nâu', 'cho-poodle-nau', 'Chó Poodle thuần chủng, thân thiện và thông minh', 'Chó Poodle size nhỏ', 8500000.00, 1, 'uploads/products/693ce556b7e3a_anh2.jpg', NULL, 'DOG-PDL-01', 0, 'active', 1, 0, NULL, NULL, NULL, '2025-12-13 03:57:17', '2025-12-23 06:28:04'),
(19, 14, 'Mèo Anh lông ngắn', 'meo-anh-long-ngan', 'Mèo Anh lông ngắn thuần chủng, dễ nuôi', 'Mèo Anh ALN', 12000000.00, 1, 'uploads/products/693ce55ebff6e_anh-mo-ta.jfif', NULL, 'CAT-ALN-01', 0, 'active', 0, 0, NULL, NULL, NULL, '2025-12-13 03:57:17', '2025-12-13 05:23:11');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_overview`
--

CREATE TABLE `product_overview` (
  `id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `slug` varchar(200) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `short_description` varchar(500) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `stock_quantity` int(11) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `gallery` text DEFAULT NULL,
  `sku` varchar(50) DEFAULT NULL,
  `views` int(11) DEFAULT NULL,
  `status` enum('active','inactive','out_of_stock') DEFAULT NULL,
  `is_featured` tinyint(1) DEFAULT NULL,
  `is_bestseller` tinyint(1) DEFAULT NULL,
  `meta_title` varchar(200) DEFAULT NULL,
  `meta_description` varchar(500) DEFAULT NULL,
  `meta_keywords` varchar(200) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `category_name` varchar(100) DEFAULT NULL,
  `review_count` bigint(21) DEFAULT NULL,
  `avg_rating` decimal(14,4) DEFAULT NULL,
  `total_sold` bigint(21) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `promotions`
--

CREATE TABLE `promotions` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL COMMENT 'Tên chương trình khuyến mãi',
  `description` text DEFAULT NULL COMMENT 'Mô tả chi tiết',
  `discount_type` enum('percentage','fixed') NOT NULL DEFAULT 'percentage' COMMENT 'Loại giảm giá: phần trăm hoặc số tiền cố định',
  `discount_value` decimal(10,2) NOT NULL COMMENT 'Giá trị giảm (% hoặc số tiền)',
  `apply_to` enum('all','category','product') NOT NULL DEFAULT 'all' COMMENT 'Áp dụng cho: tất cả/danh mục/sản phẩm',
  `category_id` int(11) DEFAULT NULL COMMENT 'ID danh mục (nếu apply_to = category)',
  `start_date` datetime NOT NULL COMMENT 'Ngày bắt đầu',
  `end_date` datetime NOT NULL COMMENT 'Ngày kết thúc',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Trạng thái hoạt động',
  `max_discount_amount` decimal(10,2) DEFAULT NULL COMMENT 'Số tiền giảm tối đa (cho % discount)',
  `min_order_amount` decimal(10,2) DEFAULT 0.00 COMMENT 'Giá trị đơn hàng tối thiểu',
  `usage_limit` int(11) DEFAULT NULL COMMENT 'Số lần sử dụng tối đa (NULL = không giới hạn)',
  `used_count` int(11) DEFAULT 0 COMMENT 'Số lần đã sử dụng',
  `priority` int(11) DEFAULT 0 COMMENT 'Độ ưu tiên (số càng cao càng ưu tiên)',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `promotions`
--

INSERT INTO `promotions` (`id`, `name`, `description`, `discount_type`, `discount_value`, `apply_to`, `category_id`, `start_date`, `end_date`, `is_active`, `max_discount_amount`, `min_order_amount`, `usage_limit`, `used_count`, `priority`, `created_at`, `updated_at`) VALUES
(14, 'sasds', '', 'percentage', 5.00, 'all', NULL, '2025-12-13 11:07:00', '2025-12-24 11:07:00', 1, 1000000.00, 0.00, NULL, 0, 1, '2025-12-13 04:07:39', '2025-12-13 04:07:39'),
(15, 'thien', '', 'percentage', 5.00, 'product', NULL, '2025-12-12 12:18:00', '2025-12-18 12:19:00', 1, 100000.00, 0.00, NULL, 0, 1, '2025-12-13 05:19:07', '2025-12-13 05:19:07');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `promotion_products`
--

CREATE TABLE `promotion_products` (
  `id` int(11) NOT NULL,
  `promotion_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `promotion_products`
--

INSERT INTO `promotion_products` (`id`, `promotion_id`, `product_id`, `created_at`) VALUES
(8, 15, 18, '2025-12-13 05:19:07');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `purchase_orders`
--

CREATE TABLE `purchase_orders` (
  `id` int(11) NOT NULL,
  `po_code` varchar(50) NOT NULL COMMENT 'Mã đơn mua hàng',
  `supplier_id` int(11) NOT NULL COMMENT 'ID nhà cung cấp',
  `contract_id` int(11) DEFAULT NULL COMMENT 'ID hợp đồng',
  `order_date` date NOT NULL COMMENT 'Ngày đặt hàng',
  `expected_delivery_date` date DEFAULT NULL COMMENT 'Ngày dự kiến giao',
  `actual_delivery_date` date DEFAULT NULL COMMENT 'Ngày giao thực tế',
  `total_amount` decimal(15,2) NOT NULL COMMENT 'Tổng tiền',
  `paid_amount` decimal(15,2) DEFAULT 0.00 COMMENT 'Đã thanh toán',
  `payment_status` enum('unpaid','partial','paid') DEFAULT 'unpaid' COMMENT 'Trạng thái thanh toán',
  `order_status` enum('draft','pending','confirmed','shipping','completed','cancelled') DEFAULT 'draft' COMMENT 'Trạng thái đơn hàng',
  `notes` text DEFAULT NULL COMMENT 'Ghi chú',
  `created_by` int(11) DEFAULT NULL COMMENT 'Người tạo',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `purchase_order_items`
--

CREATE TABLE `purchase_order_items` (
  `id` int(11) NOT NULL,
  `purchase_order_id` int(11) NOT NULL COMMENT 'ID đơn mua hàng',
  `supplier_product_id` int(11) DEFAULT NULL COMMENT 'ID sản phẩm của nhà cung cấp',
  `product_id` int(11) DEFAULT NULL COMMENT 'ID sản phẩm trong hệ thống',
  `product_name` varchar(255) NOT NULL COMMENT 'Tên sản phẩm',
  `quantity` int(11) NOT NULL COMMENT 'Số lượng',
  `unit_price` decimal(10,2) NOT NULL COMMENT 'Đơn giá',
  `subtotal` decimal(15,2) NOT NULL COMMENT 'Thành tiền',
  `received_quantity` int(11) DEFAULT 0 COMMENT 'Số lượng đã nhận',
  `notes` text DEFAULT NULL COMMENT 'Ghi chú'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `rating` int(11) NOT NULL CHECK (`rating` between 1 and 5),
  `title` varchar(200) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `images` text DEFAULT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `admin_note` text DEFAULT NULL,
  `moderated_by` int(11) DEFAULT NULL,
  `moderated_at` datetime DEFAULT NULL,
  `admin_reply` text DEFAULT NULL,
  `replied_at` datetime DEFAULT NULL,
  `replied_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Bẫy `reviews`
--
DELIMITER $$
CREATE TRIGGER `after_review_approved` AFTER UPDATE ON `reviews` FOR EACH ROW BEGIN
    IF OLD.status = 'pending' AND NEW.status = 'approved' THEN
        INSERT INTO notifications (user_id, type, title, message, link)
        VALUES (
            NEW.user_id,
            'review_approved',
            'Đánh giá của bạn đã được duyệt',
            CONCAT('Đánh giá của bạn cho sản phẩm đã được phê duyệt và hiển thị công khai.'),
            CONCAT('/product/detail/', NEW.product_id)
        );
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_review_insert` AFTER INSERT ON `reviews` FOR EACH ROW BEGIN
    -- Có thể thêm logic cập nhật rating trung bình vào bảng products nếu cần
    -- Hoặc sử dụng view như đã tạo ở trên
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_review_rejected` AFTER UPDATE ON `reviews` FOR EACH ROW BEGIN
    IF OLD.status = 'pending' AND NEW.status = 'rejected' THEN
        INSERT INTO notifications (user_id, type, title, message, link)
        VALUES (
            NEW.user_id,
            'review_rejected',
            'Đánh giá của bạn đã bị từ chối',
            CONCAT('Lý do: ', IFNULL(NEW.admin_note, 'Không phù hợp với tiêu chuẩn cộng đồng')),
            NULL
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `review_reports`
--

CREATE TABLE `review_reports` (
  `id` int(11) NOT NULL,
  `review_id` int(11) NOT NULL,
  `reporter_id` int(11) NOT NULL,
  `reason` enum('spam','offensive_language','inappropriate_content','fake_review','personal_attack','other') NOT NULL,
  `description` text DEFAULT NULL,
  `status` enum('pending','reviewing','resolved','dismissed') DEFAULT 'pending',
  `admin_note` text DEFAULT NULL,
  `handled_by` int(11) DEFAULT NULL,
  `handled_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `setting_type` enum('text','number','boolean','json') DEFAULT 'text',
  `description` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `settings`
--

INSERT INTO `settings` (`id`, `setting_key`, `setting_value`, `setting_type`, `description`, `updated_at`) VALUES
(1, 'site_name', 'Pet Shop', 'text', 'Tên website', '2025-12-23 06:55:39'),
(2, 'site_email', 'contact@petshop.com', 'text', 'Email liên hệ', '2025-12-23 06:56:00'),
(3, 'site_phone', '0123456789', 'text', 'Số điện thoại', '2025-11-06 20:05:29'),
(4, 'site_address', '123 Đường ABC, Quận 1, TP.HCM', 'text', 'Địa chỉ', '2025-11-06 20:05:29'),
(5, 'shipping_fee', '30000', 'number', 'Phí ship mặc định', '2025-11-06 20:05:29'),
(6, 'free_ship_threshold', '500000', 'number', 'Miễn phí ship từ', '2025-11-06 20:05:29'),
(7, 'vnpay_enabled', '1', 'boolean', 'Bật VNPay', '2025-11-06 20:05:29'),
(8, 'email_notifications', '1', 'boolean', 'Gửi email thông báo', '2025-11-06 20:05:29');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sliders`
--

CREATE TABLE `sliders` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL COMMENT 'Tiêu đề slider',
  `description` text DEFAULT NULL COMMENT 'Mô tả ngắn',
  `image` varchar(500) NOT NULL COMMENT 'Đường dẫn ảnh slider',
  `link` varchar(500) DEFAULT NULL COMMENT 'Link khi click vào slider',
  `button_text` varchar(100) DEFAULT NULL COMMENT 'Text nút CTA',
  `display_order` int(11) NOT NULL DEFAULT 0 COMMENT 'Thứ tự hiển thị',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=Hiển thị, 0=Ẩn',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng quản lý slider/banner trang chủ';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `suppliers`
--

CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `tax_code` varchar(50) DEFAULT NULL COMMENT 'Mã số thuế',
  `contact_person` varchar(100) DEFAULT NULL COMMENT 'Người liên hệ',
  `contact_position` varchar(100) DEFAULT NULL COMMENT 'Chức vụ người liên hệ',
  `address` text DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL COMMENT 'Website',
  `bank_account` varchar(50) DEFAULT NULL COMMENT 'Số tài khoản',
  `bank_name` varchar(100) DEFAULT NULL COMMENT 'Ngân hàng',
  `status` enum('active','inactive') DEFAULT 'active' COMMENT 'Trạng thái',
  `rating` decimal(2,1) DEFAULT NULL COMMENT 'Đánh giá (1-5 sao)',
  `notes` text DEFAULT NULL COMMENT 'Ghi chú',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `suppliers`
--

INSERT INTO `suppliers` (`id`, `name`, `phone`, `email`, `tax_code`, `contact_person`, `contact_position`, `address`, `website`, `bank_account`, `bank_name`, `status`, `rating`, `notes`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Vườn hoa Đà Lạt', '0123456789', 'dalat@flowers.vn', NULL, NULL, NULL, 'Đà Lạt, Lâm Đồng', NULL, NULL, NULL, 'active', NULL, NULL, '2025-12-04 17:33:12', '2025-12-13 03:37:12', '2025-12-13 03:37:12'),
(2, 'Trang trại hoa Sài Gòn', '0987654321', 'saigon@flowers.vn', NULL, NULL, NULL, 'Quận 9, TP. Hồ Chí Minh', NULL, NULL, NULL, 'active', NULL, NULL, '2025-12-04 17:33:12', '2025-12-13 03:37:08', '2025-12-13 03:37:08'),
(3, 'Hoa nhập khẩu Hà Nội', '0369258147', 'hanoi@flowers.vn', NULL, NULL, NULL, 'Hoàn Kiếm, Hà Nội', NULL, NULL, NULL, 'active', NULL, NULL, '2025-12-04 17:33:12', '2025-12-13 03:37:01', '2025-12-13 03:37:01'),
(4, 'Vườn hoa Mỹ Tho', '0789456123', 'mytho@flowers.vn', NULL, NULL, NULL, 'Mỹ Tho, Tiền Giang', NULL, NULL, NULL, 'active', NULL, NULL, '2025-12-04 17:33:12', '2025-12-13 03:37:14', '2025-12-13 03:37:14'),
(5, 'abc', '0987654321', '1xss31@gmail.com', NULL, NULL, NULL, 'abc', NULL, NULL, NULL, 'active', NULL, NULL, '2025-12-11 07:14:06', '2025-12-13 03:36:57', '2025-12-13 03:36:57'),
(6, 'Trại thú cưng Happy Pet', '0912345678', 'happypet@gmail.com', NULL, NULL, NULL, 'Quận 7, TP.HCM', NULL, NULL, NULL, 'active', NULL, 'Chuyên cung cấp chó mèo thuần chủng', '2025-12-13 03:57:58', '2025-12-13 03:57:58', NULL),
(7, 'Pet Accessories VN', '0987654321', 'accessories@pet.vn', NULL, NULL, NULL, 'Hà Nội', NULL, NULL, NULL, 'active', NULL, 'Cung cấp phụ kiện thú cưng', '2025-12-13 03:57:58', '2025-12-13 03:57:58', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `supplier_contracts`
--

CREATE TABLE `supplier_contracts` (
  `id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL COMMENT 'ID nhà cung cấp',
  `contract_code` varchar(50) NOT NULL COMMENT 'Mã hợp đồng',
  `contract_name` varchar(255) NOT NULL COMMENT 'Tên hợp đồng',
  `contract_type` enum('purchase','exclusive','partnership') DEFAULT 'purchase' COMMENT 'Loại hợp đồng',
  `contract_value` decimal(15,2) DEFAULT NULL COMMENT 'Giá trị hợp đồng',
  `start_date` date NOT NULL COMMENT 'Ngày bắt đầu',
  `end_date` date DEFAULT NULL COMMENT 'Ngày kết thúc',
  `payment_terms` varchar(255) DEFAULT NULL COMMENT 'Điều khoản thanh toán',
  `delivery_terms` text DEFAULT NULL COMMENT 'Điều khoản giao hàng',
  `status` enum('draft','active','expired','terminated') DEFAULT 'draft' COMMENT 'Trạng thái',
  `file_path` varchar(500) DEFAULT NULL COMMENT 'Đường dẫn file hợp đồng',
  `notes` text DEFAULT NULL COMMENT 'Ghi chú',
  `created_by` int(11) DEFAULT NULL COMMENT 'Người tạo',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `supplier_contracts`
--

INSERT INTO `supplier_contracts` (`id`, `supplier_id`, `contract_code`, `contract_name`, `contract_type`, `contract_value`, `start_date`, `end_date`, `payment_terms`, `delivery_terms`, `status`, `file_path`, `notes`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 1, 'HD-2025-001', 'Hợp đồng cung cấp hoa Đà Lạt 2025', 'purchase', 500000000.00, '2025-01-01', '2025-12-31', 'Thanh toán trong 30 ngày', NULL, 'active', NULL, NULL, NULL, '2025-12-07 11:45:20', '2025-12-07 11:45:20'),
(2, 2, 'HD-2025-002', 'Hợp đồng độc quyền hoa Sài Gòn', 'exclusive', 800000000.00, '2025-01-01', '2026-12-31', 'Thanh toán trong 15 ngày', NULL, 'active', NULL, NULL, NULL, '2025-12-07 11:45:20', '2025-12-07 11:45:20'),
(3, 3, 'HD-2024-003', 'Hợp đồng hoa nhập khẩu 2024', 'purchase', 300000000.00, '2024-06-01', '2024-12-31', 'Thanh toán ngay', NULL, 'expired', NULL, NULL, NULL, '2025-12-07 11:45:20', '2025-12-07 11:45:20'),
(4, 3, 'HD-2025-004', 'ádasd', 'purchase', 20000000.00, '2025-11-12', '2030-12-12', NULL, NULL, 'active', NULL, 'ákdhjad', 16, '2025-12-10 21:56:49', '2025-12-10 21:56:49'),
(5, 5, 'HD-2025-006', 'Hợp đồng cung cấp hoa Đà Lạt 2025', 'purchase', 10000000.00, '2025-12-02', '2026-01-01', 'b', NULL, 'active', NULL, 'adasd', 16, '2025-12-11 07:15:21', '2025-12-11 07:31:42');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `avatar` varchar(255) DEFAULT 'default-avatar.png',
  `role` enum('superadmin','admin','user') DEFAULT 'user',
  `status` enum('pending','active','inactive','banned') DEFAULT 'pending',
  `otp_code` varchar(6) DEFAULT NULL,
  `otp_expiry` datetime DEFAULT NULL,
  `reset_token` varchar(100) DEFAULT NULL,
  `reset_token_expiry` datetime DEFAULT NULL,
  `email_verified` tinyint(1) DEFAULT 0,
  `admin_approved_by` int(11) DEFAULT NULL,
  `admin_approved_at` datetime DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `full_name`, `phone`, `address`, `avatar`, `role`, `status`, `otp_code`, `otp_expiry`, `reset_token`, `reset_token_expiry`, `email_verified`, `admin_approved_by`, `admin_approved_at`, `last_login`, `created_at`, `updated_at`) VALUES
(1, 'superadmin', 'superadmin@petshop.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Super Administrator', NULL, NULL, 'default-avatar.png', 'superadmin', 'active', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-12-23 13:39:46', '2025-11-06 20:05:28', '2025-12-23 06:58:20'),
(7, 'user1', 'xmeo2612@gmail.com', '$2y$10$1jy0y90wC6KILOfO5WYFa.MHtdH7efMstt7m.DrPXGbax8nUlwKg2', 'Nguyễn Công Thành', '0987654321', 'Ha Noi', 'uploads/avatars/avatar_7_1765184903.jpg', 'user', 'active', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-12-23 13:15:15', '2025-11-06 21:56:40', '2025-12-23 06:15:15'),
(16, 'phuonganh', 'zmeo2612@gmail.com', '$2y$10$4HRJvCANKTGtjF4PXQchy.AlS2FXX61CVeuWFpvdQ8v1ItDpiQyf6', 'Trịnh Phương Anh', '0147258369', '', 'default-avatar.png', 'admin', 'active', NULL, NULL, NULL, NULL, 1, 1, '2025-11-07 06:19:03', '2025-12-13 03:59:38', '2025-11-06 23:14:49', '2025-12-12 20:59:38'),
(17, 'pqtisme', 'phamquangtuan.contact@gmail.com', '$2y$10$wD8UF7e4Zyvz8tFDOjYQd.uHInXMTVLSfHPcVFRpigmvEWpzQuY2i', 'Phạm Quang Tuấn', '0369585104', NULL, 'default-avatar.png', 'admin', 'active', NULL, NULL, NULL, NULL, 1, 1, '2025-12-13 03:58:34', NULL, '2025-12-08 16:09:54', '2025-12-12 20:58:34'),
(18, 'admin2', 'ptuan2594@gmail.com', '$2y$10$e0JLOGXpCT5AnJNXGEeUS.iipBuU4JEjo1FzX7wJ7IJv1SUfNwyKW', 'Phạm Quang Tuấn', '0369585104', 'số 48 Cầu Gầm, Phú Xuyên, Hà Nội', 'uploads/avatars/avatar_18_1765563026.png', 'user', 'active', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-12-13 02:02:36', '2025-12-12 17:48:34', '2025-12-12 19:02:36'),
(19, '0ctiiuvt8@gmail.com', '0ctiiuvt8@gmail.com', '$2y$10$/YBtrRiLEfT2rxVIerK3aOgrlWaHBWc32Q94TDGH3GlzfZkYxcnBW', 'Nguyễn Đình Tuấn', '0987654322', NULL, 'default-avatar.png', 'admin', 'pending', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, '2025-12-12 20:19:19', '2025-12-12 20:24:19'),
(20, 'tuan04', 'xmeo26@gmail.com', '$2y$10$anypVn8eovJEVW9DcD4PY.sAs0BV5wjjbvrAJ3MQ8YUBdYckzujWq', 'Nguyễn Đình Tuấn', '0836998775', 'Thái Bình', 'uploads/avatars/avatar_20_1765588867.jpg', 'user', 'active', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-12-13 08:30:25', '2025-12-13 01:20:11', '2025-12-13 02:43:42'),
(21, 'xmeo2612x@gmail.com', 'xmeo2612x@gmail.com', '$2y$10$0COzMUi/3uBmyWU1qzLtYukWbe871r/GYagNNuKIOWH12jIiR.O9i', 'Nguyễn Đình Tuấn', '01472583623', NULL, 'default-avatar.png', 'admin', 'active', NULL, NULL, NULL, NULL, 1, 1, '2025-12-13 09:45:30', NULL, '2025-12-13 02:44:16', '2025-12-13 02:45:30'),
(22, 'thien1', 'trqt01646708@gmail.com', '$2y$10$ZbxBVY3TFDuQHQ3YkmwtfOs.B.vyzOcNhoSJxURYafe6bYHb.wenG', 'Thiện Trần', '0359039204', NULL, 'uploads/avatars/avatar_22_1766471777.webp', 'user', 'active', NULL, NULL, NULL, NULL, 1, NULL, NULL, '2025-12-23 13:42:17', '2025-12-23 06:29:56', '2025-12-23 06:42:17');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_addresses`
--

CREATE TABLE `user_addresses` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL COMMENT 'ID người dùng',
  `recipient_name` varchar(100) NOT NULL COMMENT 'Tên người nhận',
  `phone` varchar(20) NOT NULL COMMENT 'Số điện thoại người nhận',
  `province` varchar(100) NOT NULL COMMENT 'Tỉnh/Thành phố',
  `district` varchar(100) NOT NULL COMMENT 'Quận/Huyện',
  `ward` varchar(100) NOT NULL COMMENT 'Phường/Xã',
  `address_detail` text NOT NULL COMMENT 'Địa chỉ chi tiết (số nhà, tên đường)',
  `address_type` enum('home','office') DEFAULT 'home' COMMENT 'Loại địa chỉ: Nhà riêng, Cơ quan',
  `is_default` tinyint(1) DEFAULT 0 COMMENT '1 = Địa chỉ mặc định',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quản lý nhiều địa chỉ giao hàng cho mỗi user';

--
-- Đang đổ dữ liệu cho bảng `user_addresses`
--

INSERT INTO `user_addresses` (`id`, `user_id`, `recipient_name`, `phone`, `province`, `district`, `ward`, `address_detail`, `address_type`, `is_default`, `created_at`, `updated_at`) VALUES
(1, 7, 'Nguyễn Công Thành', '0987654321', 'Thành phố Hà Nội', 'Huyện Mê Linh', 'Xã Hoàng Kim', 'abc', 'home', 1, '2025-12-06 09:55:13', '2025-12-13 04:06:03'),
(3, 18, 'Phạm Quang Tuấn', '0369585104', 'Thành phố Hà Nội', 'Huyện Phú Xuyên', 'Xã Quang Hà', 'số 48, Cầu Gầm', 'home', 1, '2025-12-12 17:52:59', '2025-12-12 17:52:59'),
(4, 20, 'Nguyễn Đình Tuấn', '0836998775', 'Thành phố Hà Nội', 'Quận Nam Từ Liêm', 'Phường Tây Mỗ', '2B, ngõ 107 Hữu Hưng', 'home', 1, '2025-12-13 01:22:54', '2025-12-13 01:22:54');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `wishlists`
--

CREATE TABLE `wishlists` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_action` (`action`),
  ADD KEY `idx_entity` (`entity_type`,`entity_id`),
  ADD KEY `idx_created` (`created_at`);

--
-- Chỉ mục cho bảng `banners`
--
ALTER TABLE `banners`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_position` (`position`),
  ADD KEY `idx_status` (`status`);

--
-- Chỉ mục cho bảng `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_session` (`session_id`),
  ADD KEY `idx_product` (`product_id`);

--
-- Chỉ mục cho bảng `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `idx_slug` (`slug`),
  ADD KEY `idx_parent` (`parent_id`);

--
-- Chỉ mục cho bảng `contract_products`
--
ALTER TABLE `contract_products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_contract_product` (`contract_id`,`product_id`),
  ADD KEY `idx_contract_id` (`contract_id`),
  ADD KEY `idx_product_id` (`product_id`);

--
-- Chỉ mục cho bảng `coupons`
--
ALTER TABLE `coupons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_status` (`status`);

--
-- Chỉ mục cho bảng `coupon_usage`
--
ALTER TABLE `coupon_usage`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `idx_coupon` (`coupon_id`),
  ADD KEY `idx_user` (`user_id`);

--
-- Chỉ mục cho bảng `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `replied_by` (`replied_by`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_product_id` (`product_id`);

--
-- Chỉ mục cho bảng `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `author_id` (`author_id`),
  ADD KEY `idx_slug` (`slug`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_published` (`published_at`);

--
-- Chỉ mục cho bảng `news_comments`
--
ALTER TABLE `news_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `news_id` (`news_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `parent_id` (`parent_id`),
  ADD KEY `status` (`status`);

--
-- Chỉ mục cho bảng `news_likes`
--
ALTER TABLE `news_likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_like` (`news_id`,`user_id`),
  ADD KEY `news_id` (`news_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_is_read` (`is_read`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Chỉ mục cho bảng `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_code` (`order_code`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_order_code` (`order_code`),
  ADD KEY `idx_order_status` (`order_status`),
  ADD KEY `idx_payment_status` (`payment_status`),
  ADD KEY `idx_created` (`created_at`);

--
-- Chỉ mục cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order` (`order_id`),
  ADD KEY `idx_product` (`product_id`);

--
-- Chỉ mục cho bảng `order_tracking`
--
ALTER TABLE `order_tracking`
  ADD PRIMARY KEY (`id`),
  ADD KEY `updated_by` (`updated_by`),
  ADD KEY `idx_order` (`order_id`);

--
-- Chỉ mục cho bảng `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD KEY `idx_category` (`category_id`),
  ADD KEY `idx_slug` (`slug`),
  ADD KEY `idx_price` (`price`),
  ADD KEY `idx_featured` (`is_featured`),
  ADD KEY `idx_bestseller` (`is_bestseller`);

--
-- Chỉ mục cho bảng `promotions`
--
ALTER TABLE `promotions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_category_id` (`category_id`),
  ADD KEY `idx_apply_to` (`apply_to`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `idx_dates` (`start_date`,`end_date`);

--
-- Chỉ mục cho bảng `promotion_products`
--
ALTER TABLE `promotion_products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_promotion_product` (`promotion_id`,`product_id`),
  ADD KEY `idx_promotion_id` (`promotion_id`),
  ADD KEY `idx_product_id` (`product_id`);

--
-- Chỉ mục cho bảng `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `po_code` (`po_code`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `contract_id` (`contract_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Chỉ mục cho bảng `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `purchase_order_id` (`purchase_order_id`),
  ADD KEY `supplier_product_id` (`supplier_product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Chỉ mục cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `replied_by` (`replied_by`),
  ADD KEY `idx_product` (`product_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_rating` (`rating`),
  ADD KEY `idx_status` (`status`);

--
-- Chỉ mục cho bảng `review_reports`
--
ALTER TABLE `review_reports`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_report` (`review_id`,`reporter_id`),
  ADD KEY `idx_review_id` (`review_id`),
  ADD KEY `idx_reporter_id` (`reporter_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `handled_by` (`handled_by`);

--
-- Chỉ mục cho bảng `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`),
  ADD KEY `idx_key` (`setting_key`);

--
-- Chỉ mục cho bảng `sliders`
--
ALTER TABLE `sliders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `is_active` (`is_active`),
  ADD KEY `display_order` (`display_order`);

--
-- Chỉ mục cho bảng `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `supplier_contracts`
--
ALTER TABLE `supplier_contracts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `contract_code` (`contract_code`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `admin_approved_by` (`admin_approved_by`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_role` (`role`),
  ADD KEY `idx_status` (`status`);

--
-- Chỉ mục cho bảng `user_addresses`
--
ALTER TABLE `user_addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_is_default` (`is_default`);

--
-- Chỉ mục cho bảng `wishlists`
--
ALTER TABLE `wishlists`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_wishlist` (`user_id`,`product_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `banners`
--
ALTER TABLE `banners`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT cho bảng `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT cho bảng `contract_products`
--
ALTER TABLE `contract_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `coupons`
--
ALTER TABLE `coupons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `coupon_usage`
--
ALTER TABLE `coupon_usage`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `news`
--
ALTER TABLE `news`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `news_comments`
--
ALTER TABLE `news_comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT cho bảng `news_likes`
--
ALTER TABLE `news_likes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT cho bảng `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- AUTO_INCREMENT cho bảng `order_tracking`
--
ALTER TABLE `order_tracking`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `promotions`
--
ALTER TABLE `promotions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT cho bảng `promotion_products`
--
ALTER TABLE `promotion_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `purchase_orders`
--
ALTER TABLE `purchase_orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `review_reports`
--
ALTER TABLE `review_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `sliders`
--
ALTER TABLE `sliders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `supplier_contracts`
--
ALTER TABLE `supplier_contracts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT cho bảng `user_addresses`
--
ALTER TABLE `user_addresses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `wishlists`
--
ALTER TABLE `wishlists`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `activity_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `contract_products`
--
ALTER TABLE `contract_products`
  ADD CONSTRAINT `fk_contract_products_contract` FOREIGN KEY (`contract_id`) REFERENCES `supplier_contracts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_contract_products_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `coupon_usage`
--
ALTER TABLE `coupon_usage`
  ADD CONSTRAINT `coupon_usage_ibfk_1` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `coupon_usage_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `coupon_usage_ibfk_3` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`replied_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `news`
--
ALTER TABLE `news`
  ADD CONSTRAINT `news_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `news_comments`
--
ALTER TABLE `news_comments`
  ADD CONSTRAINT `fk_news_comments_news` FOREIGN KEY (`news_id`) REFERENCES `news` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_news_comments_parent` FOREIGN KEY (`parent_id`) REFERENCES `news_comments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_news_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `news_likes`
--
ALTER TABLE `news_likes`
  ADD CONSTRAINT `fk_news_likes_news` FOREIGN KEY (`news_id`) REFERENCES `news` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_news_likes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `order_tracking`
--
ALTER TABLE `order_tracking`
  ADD CONSTRAINT `order_tracking_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_tracking_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `promotions`
--
ALTER TABLE `promotions`
  ADD CONSTRAINT `fk_promotion_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `promotion_products`
--
ALTER TABLE `promotion_products`
  ADD CONSTRAINT `fk_promotion_products_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_promotion_products_promotion` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD CONSTRAINT `po_contract_fk` FOREIGN KEY (`contract_id`) REFERENCES `supplier_contracts` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `po_supplier_fk` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  ADD CONSTRAINT `po_user_fk` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `reviews_ibfk_4` FOREIGN KEY (`replied_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
