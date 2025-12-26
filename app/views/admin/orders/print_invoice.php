<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa đơn #<?= htmlspecialchars($order['order_code'] ?? '') ?> - Pet Shop</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Arial', 'Helvetica Neue', sans-serif; 
            padding: 30px;
            background: white;
            color: #333;
            font-size: 14px;
            line-height: 1.5;
        }
        
        .invoice-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
        }
        
        /* Header */
        .company-header { 
            text-align: center; 
            margin-bottom: 25px; 
            padding-bottom: 20px; 
            border-bottom: 3px solid #e91e63;
        }
        
        .company-header h1 { 
            color: #e91e63; 
            font-size: 32px; 
            margin-bottom: 5px;
        }
        
        .company-header .tagline {
            color: #666;
            font-size: 14px;
            font-style: italic;
        }
        
        .company-header .contact {
            margin-top: 10px;
            color: #666;
            font-size: 13px;
        }
        
        /* Invoice Title */
        .invoice-title {
            text-align: center;
            margin: 25px 0;
        }
        
        .invoice-title h2 {
            color: #333;
            font-size: 24px;
            text-transform: uppercase;
            letter-spacing: 2px;
        }
        
        .invoice-title .invoice-number {
            color: #e91e63;
            font-size: 18px;
            margin-top: 5px;
        }
        
        .invoice-title .invoice-date {
            color: #666;
            font-size: 14px;
            margin-top: 5px;
        }
        
        /* Info Grid */
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        .info-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #e91e63;
        }
        
        .info-section h3 {
            color: #e91e63;
            font-size: 16px;
            margin-bottom: 15px;
            padding-bottom: 8px;
            border-bottom: 1px solid #ddd;
        }
        
        .info-row {
            display: flex;
            margin-bottom: 8px;
        }
        
        .info-label {
            width: 120px;
            color: #666;
            font-weight: 500;
        }
        
        .info-value {
            flex: 1;
            color: #333;
        }
        
        /* Products Table */
        .products-section {
            margin-bottom: 30px;
        }
        
        .products-section h3 {
            color: #e91e63;
            font-size: 16px;
            margin-bottom: 15px;
            padding-bottom: 8px;
            border-bottom: 2px solid #e91e63;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        table th {
            background: #e91e63;
            color: white;
            padding: 12px 15px;
            text-align: left;
            font-weight: 600;
        }
        
        table th:nth-child(2),
        table th:nth-child(3),
        table th:nth-child(4) {
            text-align: right;
        }
        
        table td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }
        
        table td:nth-child(2),
        table td:nth-child(3),
        table td:nth-child(4) {
            text-align: right;
        }
        
        table tr:hover {
            background: #fef7f9;
        }
        
        /* Summary */
        .summary-section {
            margin-top: 30px;
            border-top: 2px solid #eee;
            padding-top: 20px;
        }
        
        .summary-row {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 10px;
        }
        
        .summary-row .label {
            width: 150px;
            text-align: right;
            padding-right: 20px;
            color: #666;
        }
        
        .summary-row .value {
            width: 150px;
            text-align: right;
            font-weight: 500;
        }
        
        .summary-row.total {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 2px solid #e91e63;
        }
        
        .summary-row.total .label {
            font-size: 18px;
            font-weight: 700;
            color: #333;
        }
        
        .summary-row.total .value {
            font-size: 20px;
            font-weight: 700;
            color: #e91e63;
        }
        
        /* Footer */
        .invoice-footer {
            margin-top: 40px;
            text-align: center;
            color: #666;
            font-size: 13px;
            padding-top: 20px;
            border-top: 1px dashed #ddd;
        }
        
        .invoice-footer .thank-you {
            font-size: 18px;
            color: #e91e63;
            margin-bottom: 10px;
        }
        
        /* Print Button (hide on print) */
        .print-actions {
            text-align: center;
            margin-bottom: 30px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .btn-print {
            background: linear-gradient(135deg, #e91e63, #c2185b);
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            margin-right: 10px;
        }
        
        .btn-print:hover {
            opacity: 0.9;
        }
        
        .btn-back {
            background: #6c757d;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-back:hover {
            background: #5a6268;
        }
        
        @media print {
            .print-actions { display: none !important; }
            body { padding: 0; }
            .invoice-container { max-width: 100%; }
        }
    </style>
</head>
<body>
    <div class="invoice-container">
        <!-- Print Actions (hidden when printing) -->
        <div class="print-actions">
            <button class="btn-print" onclick="window.print()">
                <i class="fas fa-print"></i> In Hóa Đơn
            </button>
            <a href="<?= BASE_URL ?>/admin/orders" class="btn-back">
                ← Quay lại
            </a>
        </div>
        
        <!-- Company Header -->
        <div class="company-header">
            <h1>🐾 PET SHOP</h1>
            <p class="tagline">Nơi Tình Yêu Với Thú Cưng</p>
            <p class="contact">
                📍 123 Đường ABC, Quận 1, TP.HCM | 
                📞 0123 456 789 | 
                ✉️ contact@petshop.vn
            </p>
        </div>
        
        <!-- Invoice Title -->
        <div class="invoice-title">
            <h2>Hóa Đơn Bán Hàng</h2>
            <div class="invoice-number">#<?= htmlspecialchars($order['order_code'] ?? 'N/A') ?></div>
            <div class="invoice-date">
                Ngày: <?= !empty($order['created_at']) ? date('d/m/Y H:i', strtotime($order['created_at'])) : 'N/A' ?>
            </div>
        </div>
        
        <!-- Customer & Order Info -->
        <div class="info-grid">
            <div class="info-section">
                <h3>👤 Thông Tin Khách Hàng</h3>
                <div class="info-row">
                    <div class="info-label">Họ tên:</div>
                    <div class="info-value"><?= htmlspecialchars($order['customer_name'] ?? $order['full_name'] ?? 'N/A') ?></div>
                </div>
                <div class="info-row">
                    <div class="info-label">Email:</div>
                    <div class="info-value"><?= htmlspecialchars($order['customer_email'] ?? $order['email'] ?? 'N/A') ?></div>
                </div>
                <div class="info-row">
                    <div class="info-label">Điện thoại:</div>
                    <div class="info-value"><?= htmlspecialchars($order['customer_phone'] ?? $order['phone'] ?? 'N/A') ?></div>
                </div>
            </div>
            
            <div class="info-section">
                <h3>📦 Thông Tin Giao Hàng</h3>
                <?php if (($order['shipping_method'] ?? '') === 'pickup'): ?>
                    <div class="info-row">
                        <div class="info-label">Phương thức:</div>
                        <div class="info-value"><strong>Nhận tại cửa hàng</strong></div>
                    </div>
                <?php else: ?>
                    <div class="info-row">
                        <div class="info-label">Địa chỉ:</div>
                        <div class="info-value"><?= htmlspecialchars($order['shipping_address'] ?? 'N/A') ?></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Phương thức:</div>
                        <div class="info-value">
                            <?php
                            $shippingMethods = [
                                'standard' => 'Tiêu chuẩn',
                                'express' => 'Nhanh',
                                'same_day' => 'Trong ngày'
                            ];
                            echo $shippingMethods[$order['shipping_method'] ?? 'standard'] ?? $order['shipping_method'];
                            ?>
                        </div>
                    </div>
                <?php endif; ?>
                <div class="info-row">
                    <div class="info-label">Thanh toán:</div>
                    <div class="info-value"><?= strtoupper($order['payment_method'] ?? 'N/A') ?></div>
                </div>
            </div>
        </div>
        
        <!-- Products -->
        <div class="products-section">
            <h3>🛒 Sản Phẩm Đặt Hàng</h3>
            <table>
                <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Số lượng</th>
                        <th>Đơn giá</th>
                        <th>Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <?php 
                    $subtotal = 0;
                    foreach ($items as $item): 
                        $lineTotal = $item['quantity'] * $item['price'];
                        $subtotal += $lineTotal;
                    ?>
                    <tr>
                        <td><?= htmlspecialchars($item['product_name'] ?? 'N/A') ?></td>
                        <td><?= $item['quantity'] ?></td>
                        <td><?= number_format($item['price'], 0, ',', '.') ?>₫</td>
                        <td><?= number_format($lineTotal, 0, ',', '.') ?>₫</td>
                    </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
        
        <!-- Summary -->
        <div class="summary-section">
            <div class="summary-row">
                <span class="label">Tạm tính:</span>
                <span class="value"><?= number_format($subtotal, 0, ',', '.') ?>₫</span>
            </div>
            <div class="summary-row">
                <span class="label">Giảm giá:</span>
                <span class="value">-<?= number_format($order['discount_amount'] ?? $order['discount'] ?? 0, 0, ',', '.') ?>₫</span>
            </div>
            <div class="summary-row">
                <span class="label">Phí vận chuyển:</span>
                <span class="value"><?= number_format($order['shipping_fee'] ?? 0, 0, ',', '.') ?>₫</span>
            </div>
            <div class="summary-row total">
                <span class="label">TỔNG CỘNG:</span>
                <span class="value"><?= number_format($order['total'] ?? 0, 0, ',', '.') ?>₫</span>
            </div>
        </div>
        
        <!-- Footer -->
        <div class="invoice-footer">
            <p class="thank-you">❤️ Cảm ơn Quý khách đã mua hàng!</p>
            <p>Pet Shop - Nơi Tình Yêu Với Thú Cưng</p>
            <p>Hotline hỗ trợ: 0123 456 789</p>
        </div>
    </div>
    
    <script>
        // Auto print when page loads (optional)
        // window.onload = function() { window.print(); }
    </script>
</body>
</html>
