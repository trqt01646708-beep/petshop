<?php
$user = Session::getUser();
$isSuperAdmin = $user['role'] === 'superadmin';
?>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi Mật Khẩu - Admin Panel</title>
    <?php include APP_PATH . '/views/layouts/favicon.php'; ?>
    <link rel="stylesheet" href="<?= ASSETS_URL ?>/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .change-password-wrapper {
            max-width: 500px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .password-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        
        .password-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
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
            font-size: 14px;
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
            box-sizing: border-box;
        }
        
        .input-group input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
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
            color: #667eea;
        }
        
        .btn-submit {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea, #764ba2);
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
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
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
            color: #667eea;
        }
        
        .superadmin-note {
            background: #e8f5e9;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            border-left: 4px solid #4caf50;
        }
        
        .superadmin-note p {
            margin: 0;
            color: #2e7d32;
            font-size: 14px;
        }
        
        .superadmin-note i {
            color: #4caf50;
            margin-right: 8px;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <?php require_once APP_PATH . '/views/layouts/admin_sidebar.php'; ?>
        
        <div class="main-content">
            <div class="topbar">
                <h2><i class="fas fa-key"></i> Đổi Mật Khẩu</h2>
                <div class="user-info">
                    <i class="fas fa-user-circle"></i>
                    <strong><?= htmlspecialchars($user['full_name']) ?></strong>
                </div>
            </div>
            
            <div class="change-password-wrapper">
                <div class="password-card">
                    <div class="password-header">
                        <i class="fas fa-shield-alt"></i>
                        <h1>Đổi Mật Khẩu</h1>
                        <p>Cập nhật mật khẩu mới cho tài khoản quản trị</p>
                    </div>
                    
                    <form class="password-form" method="POST" action="<?= BASE_URL ?>/admin/change-password">
                        <?php if ($isSuperAdmin): ?>
                            <div class="superadmin-note">
                                <p><i class="fas fa-crown"></i> <strong>SuperAdmin:</strong> Bạn không cần nhập mật khẩu hiện tại để đổi mật khẩu.</p>
                            </div>
                        <?php else: ?>
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
                        <?php endif; ?>
                        
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
                        
                        <a href="<?= BASE_URL ?>/admin/dashboard" class="back-link">
                            <i class="fas fa-arrow-left"></i> Quay lại Dashboard
                        </a>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
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
