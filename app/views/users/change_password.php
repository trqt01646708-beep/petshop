<?php
$user = Session::getUser();
?>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi Mật Khẩu - Pet Shop</title>
    <?php include APP_PATH . '/views/layouts/favicon.php'; ?>
    <link rel="stylesheet" href="<?= ASSETS_URL ?>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .change-password-container {
            max-width: 500px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .password-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        
        .password-header {
            background: linear-gradient(135deg, #e91e63, #c2185b);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .password-header i {
            font-size: 48px;
            margin-bottom: 15px;
        }
        
        .password-header h1 {
            font-size: 24px;
            margin: 0;
        }
        
        .password-header p {
            opacity: 0.9;
            margin-top: 8px;
        }
        
        .password-form {
            padding: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        .form-group label .required {
            color: #e91e63;
        }
        
        .input-group {
            position: relative;
        }
        
        .input-group i.icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
        }
        
        .input-group input {
            width: 100%;
            padding: 14px 45px;
            border: 2px solid #eee;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s;
        }
        
        .input-group input:focus {
            outline: none;
            border-color: #e91e63;
            box-shadow: 0 0 0 3px rgba(233, 30, 99, 0.1);
        }
        
        .toggle-password {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
            cursor: pointer;
            transition: color 0.3s;
        }
        
        .toggle-password:hover {
            color: #e91e63;
        }
        
        .btn-submit {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #e91e63, #c2185b);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(233, 30, 99, 0.4);
        }
        
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #666;
            text-decoration: none;
            transition: color 0.3s;
        }
        
        .back-link:hover {
            color: #e91e63;
        }
        
        .password-tips {
            background: #fff8e1;
            border-radius: 10px;
            padding: 15px;
            margin-top: 20px;
        }
        
        .password-tips h4 {
            color: #f57c00;
            margin: 0 0 10px 0;
            font-size: 14px;
        }
        
        .password-tips ul {
            margin: 0;
            padding-left: 20px;
            color: #666;
            font-size: 13px;
        }
        
        .password-tips li {
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
    <?php include APP_PATH . '/views/layouts/header.php'; ?>

    <div class="change-password-container">
        <div class="password-card">
            <div class="password-header">
                <i class="fas fa-key"></i>
                <h1>Đổi Mật Khẩu</h1>
                <p>Cập nhật mật khẩu mới cho tài khoản của bạn</p>
            </div>
            
            <form class="password-form" method="POST" action="<?= BASE_URL ?>/user/change-password">
                <div class="form-group">
                    <label>
                        <i class="fas fa-lock"></i> Mật khẩu hiện tại <span class="required">*</span>
                    </label>
                    <div class="input-group">
                        <i class="fas fa-lock icon"></i>
                        <input type="password" name="current_password" id="current_password" placeholder="Nhập mật khẩu hiện tại" required>
                        <i class="fas fa-eye toggle-password" onclick="togglePassword('current_password')"></i>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>
                        <i class="fas fa-key"></i> Mật khẩu mới <span class="required">*</span>
                    </label>
                    <div class="input-group">
                        <i class="fas fa-key icon"></i>
                        <input type="password" name="new_password" id="new_password" placeholder="Nhập mật khẩu mới (ít nhất 6 ký tự)" required minlength="6">
                        <i class="fas fa-eye toggle-password" onclick="togglePassword('new_password')"></i>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>
                        <i class="fas fa-check-circle"></i> Xác nhận mật khẩu mới <span class="required">*</span>
                    </label>
                    <div class="input-group">
                        <i class="fas fa-check-circle icon"></i>
                        <input type="password" name="confirm_password" id="confirm_password" placeholder="Nhập lại mật khẩu mới" required>
                        <i class="fas fa-eye toggle-password" onclick="togglePassword('confirm_password')"></i>
                    </div>
                </div>
                
                <button type="submit" class="btn-submit">
                    <i class="fas fa-save"></i> Đổi Mật Khẩu
                </button>
                
                <a href="<?= BASE_URL ?>/user/profile" class="back-link">
                    <i class="fas fa-arrow-left"></i> Quay lại trang cá nhân
                </a>
                
                <div class="password-tips">
                    <h4><i class="fas fa-lightbulb"></i> Mẹo tạo mật khẩu an toàn</h4>
                    <ul>
                        <li>Sử dụng ít nhất 8 ký tự</li>
                        <li>Kết hợp chữ hoa, chữ thường và số</li>
                        <li>Thêm ký tự đặc biệt như @, #, $, %</li>
                        <li>Không sử dụng thông tin cá nhân</li>
                    </ul>
                </div>
            </form>
        </div>
    </div>

    <?php include APP_PATH . '/views/layouts/footer.php'; ?>
    <?php include APP_PATH . '/views/layouts/toast_notification.php'; ?>
    
    <script>
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const icon = field.parentElement.querySelector('.toggle-password');
            
            if (field.type === 'password') {
                field.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                field.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
        
        // Validate form before submit
        document.querySelector('.password-form').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('new_password').value;
            const confirmPassword = document.getElementById('confirm_password').value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
                return false;
            }
            
            if (newPassword.length < 6) {
                e.preventDefault();
                alert('Mật khẩu mới phải có ít nhất 6 ký tự!');
                return false;
            }
        });
    </script>
</body>
</html>
