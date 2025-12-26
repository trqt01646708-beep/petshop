<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Về chúng tôi - Pet Shop</title>
    <?php include APP_PATH . '/views/layouts/favicon.php'; ?>
    <link rel="stylesheet" href="<?= ASSETS_URL ?>/css/home.css">
    <link rel="stylesheet" href="<?= BASE_URL ?>/assets/css/notifications.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<?= BASE_URL ?>/assets/css/page-about.css">
</head>
<body>
    <?php require_once __DIR__ . '/../layouts/header.php'; ?>
    
    <div class="about-container">
        <div class="about-header">
            <h1><i class="fas fa-paw"></i> Về Pet Shop</h1>
            <p>Mang niềm vui và tình yêu thú cưng đến mọi gia đình</p>
        </div>
        
        <div class="about-section">
            <h2><i class="fas fa-info-circle"></i> Giới thiệu về chúng tôi</h2>
            <p>
                <strong>Pet Shop</strong> là cửa hàng thú cưng và phụ kiện uy tín hàng đầu tại Việt Nam, được thành lập với sứ mệnh mang đến những người bạn đáng yêu nhất, 
                khỏe mạnh với giá cả hợp lý. Chúng tôi tự hào là địa chỉ tin cậy của hàng ngàn khách hàng trong suốt nhiều năm qua.
            </p>
            <p>
                Với đội ngũ chuyên gia chăm sóc thú cưng chuyên nghiệp, giàu kinh nghiệm và đầy tình yêu động vật, chúng tôi luôn đảm bảo sức khỏe và hạnh phúc cho thú cưng. 
                Mỗi thú cưng không chỉ là sản phẩm, mà còn là người bạn đồng hành, nguồn vui và tình cảm chân thành trong gia đình bạn.
            </p>
        </div>
        
        <div class="about-section">
            <h2><i class="fas fa-bullseye"></i> Sứ mệnh & Tầm nhìn</h2>
            <p>
                <strong>Sứ mệnh:</strong> Mang niềm vui của thú cưng đến gần hơn với cuộc sống hàng ngày, 
                giúp mọi người tìm được người bạn đồng hành hoàn hảo và chăm sóc thú cưng một cách tốt nhất.
            </p>
            <p>
                <strong>Tầm nhìn:</strong> Trở thành thương hiệu thú cưng hàng đầu Việt Nam, 
                được yêu thích và tin tưởng nhất bởi sức khỏe thú cưng đảm bảo, dịch vụ chu đáo và sự tận tâm không ngừng.
            </p>
        </div>
        
        <div class="about-section">
            <h2><i class="fas fa-gem"></i> Giá trị cốt lõi</h2>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-certificate"></i>
                    </div>
                    <h3>Sức khỏe đảm bảo</h3>
                    <p>Thú cưng khỏe mạnh 100%, đã tiêm phòng và được kiểm tra sức khỏe định kỳ</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-heart"></i>
                    </div>
                    <h3>Yêu thương</h3>
                    <p>Chăm sóc tận tình, yêu thương thú cưng như người bạn thân thiết</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-truck"></i>
                    </div>
                    <h3>Giao hàng nhanh</h3>
                    <p>Giao hàng trong 2-4h tại nội thành, toàn quốc trong 24h</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-headset"></i>
                    </div>
                    <h3>Hỗ trợ 24/7</h3>
                    <p>Đội ngũ tư vấn chăm sóc thú cưng nhiệt tình, sẵn sàng hỗ trợ mọi lúc</p>
                </div>
            </div>
        </div>
        
        <div class="about-section" style="background: linear-gradient(135deg, #e67e22 0%, #d35400 100%); color: white;">
            <h2 style="color: white; text-align: center;"><i class="fas fa-chart-line"></i> Thành tựu của chúng tôi</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number">10,000+</div>
                    <div class="stat-label">Khách hàng hài lòng</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">500+</div>
                    <div class="stat-label">Thú cưng đáng yêu</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">50+</div>
                    <div class="stat-label">Đối tác tin cậy</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">5 năm</div>
                    <div class="stat-label">Kinh nghiệm</div>
                </div>
            </div>
        </div>
        
        <div class="about-section">
            <h2><i class="fas fa-phone-alt"></i> Liên hệ với chúng tôi</h2>
            <p><strong><i class="fas fa-map-marker-alt"></i> Địa chỉ:</strong> 123 Đường ABC, Quận 1, TP. Hồ Chí Minh</p>
            <p><strong><i class="fas fa-phone"></i> Hotline:</strong> 1900 1234 (Hỗ trợ 24/7)</p>
            <p><strong><i class="fas fa-envelope"></i> Email:</strong> contact@petshop.vn</p>
            <p><strong><i class="fas fa-clock"></i> Giờ làm việc:</strong> 8:00 - 22:00 (Tất cả các ngày trong tuần)</p>
        </div>
    </div>
    
    <?php require_once __DIR__ . '/../layouts/footer.php'; ?>
</body>
</html>
