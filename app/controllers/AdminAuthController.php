<?php
/**
 * AdminAuthController
 * Xử lý các chức năng xác thực cho admin
 * - Đăng nhập, đăng xuất
 * - Dashboard
 * - Đăng ký admin, OTP
 * - Phê duyệt admin
 */

require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../core/Session.php';
require_once __DIR__ . '/../helpers/validation.php';
require_once __DIR__ . '/../helpers/mail_helper.php';

class AdminAuthController extends Controller
{
    private $userModel;
    private $db;

    public function __construct()
    {
        $this->userModel = $this->model('User');
        $this->db = DB::getInstance();
    }

    /**
     * Trang đăng nhập admin
     */
    public function login()
    {
        // Nếu đã login và là admin thì redirect về dashboard
        if (Session::isLoggedIn() && Session::isAdmin()) {
            $this->redirect('/admin/dashboard');
            return;
        }

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $this->handleAdminLogin();
        } else {
            $this->view('admin/login');
        }
    }

    /**
     * Xử lý đăng nhập admin
     */
    private function handleAdminLogin()
    {
        $data = [
            'identifier' => sanitize($_POST['identifier'] ?? ''),
            'password' => $_POST['password'] ?? ''
        ];

        // Validation
        $validator = validate($data);
        $validator->required('identifier', 'Email hoặc tên đăng nhập không được để trống')
                  ->required('password', 'Mật khẩu không được để trống');

        if ($validator->fails()) {
            Session::setFlash('error', $validator->firstError());
            Session::setFlash('old', $data);
            $this->redirect('/admin/login');
            return;
        }

        // Đăng nhập
        $result = $this->userModel->login($data['identifier'], $data['password']);

        if ($result['success']) {
            $user = $result['user'];
            
            // Kiểm tra phải là admin hoặc superadmin
            if ($user['role'] !== 'admin' && $user['role'] !== 'superadmin') {
                Session::setFlash('error', 'Bạn không có quyền truy cập vào trang quản trị');
                $this->redirect('/admin/login');
                return;
            }

            // Đảm bảo SuperAdmin ID = 1 mới có thể là superadmin
            if ($user['role'] === 'superadmin' && $user['id'] !== 1) {
                // Sửa lỗi: user được set sai thành superadmin
                $this->db->execute("UPDATE users SET role = 'admin' WHERE id = ? AND id != 1", [$user['id']]);
                $user['role'] = 'admin';
            }

            Session::login($user);
            Session::setFlash('success', 'Đăng nhập thành công! Chào mừng ' . $user['full_name']);
            $this->redirect('/admin/dashboard');
        } else {
            // Kiểm tra nếu là admin chưa xác thực OTP
if (isset($result['pending']) && $result['pending'] === true) {
                // Chỉ xử lý nếu là admin
                if (isset($result['role']) && $result['role'] === 'admin') {
                    // Lưu thông tin để chuyển đến trang OTP admin
                    Session::set('register_email', $result['email']);
                    Session::set('register_role', 'admin');
                    Session::setFlash('info', 'Vui lòng xác thực OTP để hoàn tất đăng ký Admin.');
                    $this->redirect('/admin/verify-otp-admin');
                    return;
                }
            }
            
            Session::setFlash('error', $result['message']);
            Session::setFlash('old', $data);
            $this->redirect('/admin/login');
        }
    }

    /**
     * Đăng xuất
     */
    public function logout()
    {
        Session::logout();
        Session::setFlash('success', 'Đăng xuất thành công!');
        $this->redirect('/admin/login');
    }

    /**
     * Trang Dashboard admin - Quick Overview
     */
    public function dashboard()
    {
        $this->requireAdmin();
        
        $db = \DB::getInstance();
        
        // ============ THỐNG KÊ CƠ BẢN ============
        $totalUsers = $db->fetchOne("SELECT COUNT(*) as total FROM users WHERE role != 'admin' AND role != 'superadmin'")['total'] ?? 0;
        $totalOrders = $db->fetchOne("SELECT COUNT(*) as total FROM orders")['total'] ?? 0;
        $totalProducts = $db->fetchOne("SELECT COUNT(*) as total FROM products")['total'] ?? 0;
        $totalSuppliers = $db->fetchOne("SELECT COUNT(*) as total FROM suppliers WHERE deleted_at IS NULL")['total'] ?? 0;
        $totalRevenue = $db->fetchOne("SELECT COALESCE(SUM(total), 0) as total FROM orders WHERE order_status IN ('delivered')")['total'] ?? 0;
        
        // ============ SO SÁNH VỚI THÁNG TRƯỚC ============
        // Doanh thu tháng này
        $thisMonthRevenue = $db->fetchOne("
            SELECT COALESCE(SUM(total), 0) as total 
            FROM orders 
            WHERE order_status IN ('delivered') 
            AND MONTH(created_at) = MONTH(CURRENT_DATE()) 
            AND YEAR(created_at) = YEAR(CURRENT_DATE())
        ")['total'] ?? 0;
        
        // Doanh thu tháng trước
        $lastMonthRevenue = $db->fetchOne("
            SELECT COALESCE(SUM(total), 0) as total 
            FROM orders 
            WHERE order_status IN ('delivered') 
            AND MONTH(created_at) = MONTH(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH)) 
            AND YEAR(created_at) = YEAR(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))
        ")['total'] ?? 0;
        
        // % thay đổi doanh thu
        $revenueChange = $lastMonthRevenue > 0 ? (($thisMonthRevenue - $lastMonthRevenue) / $lastMonthRevenue) * 100 : 0;
        
        // Đơn hàng tháng này vs tháng trước
$thisMonthOrders = $db->fetchOne("
            SELECT COUNT(*) as total FROM orders 
            WHERE MONTH(created_at) = MONTH(CURRENT_DATE()) 
            AND YEAR(created_at) = YEAR(CURRENT_DATE())
        ")['total'] ?? 0;
        
        $lastMonthOrders = $db->fetchOne("
            SELECT COUNT(*) as total FROM orders 
            WHERE MONTH(created_at) = MONTH(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH)) 
            AND YEAR(created_at) = YEAR(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))
        ")['total'] ?? 0;
        
        $ordersChange = $lastMonthOrders > 0 ? (($thisMonthOrders - $lastMonthOrders) / $lastMonthOrders) * 100 : 0;
        
        // ============ CẢNH BÁO / ALERTS ============
        $alerts = [];
        
        // Sản phẩm sắp hết hàng (stock < 10)
        $lowStockCount = $db->fetchOne("SELECT COUNT(*) as total FROM products WHERE stock < 10 AND stock > 0")['total'] ?? 0;
        if ($lowStockCount > 0) {
            $alerts[] = ['type' => 'warning', 'icon' => 'fas fa-exclamation-triangle', 'message' => $lowStockCount . ' sản phẩm sắp hết hàng', 'link' => BASE_URL . '/admin/products?filter=low_stock'];
        }
        
        // Đơn hàng chờ xử lý
        $pendingOrders = $db->fetchOne("SELECT COUNT(*) as total FROM orders WHERE order_status = 'pending'")['total'] ?? 0;
        if ($pendingOrders > 0) {
            $alerts[] = ['type' => 'info', 'icon' => 'fas fa-clock', 'message' => $pendingOrders . ' đơn hàng chờ xử lý', 'link' => BASE_URL . '/admin/orders?status=pending'];
        }
        
        // Sản phẩm hết hàng
        $outOfStock = $db->fetchOne("SELECT COUNT(*) as total FROM products WHERE stock = 0")['total'] ?? 0;
        if ($outOfStock > 0) {
            $alerts[] = ['type' => 'danger', 'icon' => 'fas fa-times-circle', 'message' => $outOfStock . ' sản phẩm đã hết hàng', 'link' => BASE_URL . '/admin/products?filter=out_of_stock'];
        }
        
        // Góp ý mới
        $newFeedbackCount = $db->fetchOne("SELECT COUNT(*) as total FROM feedback WHERE status = 'new'")['total'] ?? 0;
        if ($newFeedbackCount > 0) {
            $alerts[] = ['type' => 'success', 'icon' => 'fas fa-comments', 'message' => $newFeedbackCount . ' góp ý mới cần xem', 'link' => BASE_URL . '/admin/feedback?status=new'];
        }
        
        // ============ ĐƠN HÀNG THEO TRẠNG THÁI ============
        $orderStats = $db->fetchAll("
            SELECT order_status, COUNT(*) as count 
            FROM orders 
            GROUP BY order_status
        ");
        
        $statusCounts = [
            'pending' => 0,
            'confirmed' => 0,
            'processing' => 0,
            'shipping' => 0,
            'delivered' => 0,
            'cancelled' => 0
        ];
        
        foreach ($orderStats as $stat) {
            if (isset($statusCounts[$stat['order_status']])) {
$statusCounts[$stat['order_status']] = $stat['count'];
            }
        }
        
        // ============ MINI CHART DATA (7 ngày gần nhất) ============
        $weeklyRevenue = $db->fetchAll("
            SELECT 
                DATE(created_at) as date,
                COALESCE(SUM(total), 0) as revenue
            FROM orders
            WHERE order_status IN ('delivered')
                AND created_at >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
            GROUP BY DATE(created_at)
            ORDER BY date ASC
        ");
        
        // ============ TOP 3 SẢN PHẨM (Compact) ============
        $topProducts = $db->fetchAll("
            SELECT p.id, p.name, p.image, 
                   COALESCE(SUM(oi.quantity), 0) as total_sold
            FROM products p
            LEFT JOIN order_items oi ON p.id = oi.product_id
            LEFT JOIN orders o ON oi.order_id = o.id AND o.order_status IN ('delivered')
            GROUP BY p.id, p.name, p.image
            HAVING total_sold > 0
            ORDER BY total_sold DESC
            LIMIT 3
        ");
        
        // ============ DOANH THU HÔM NAY ============
        $todayRevenue = $db->fetchOne("
            SELECT COALESCE(SUM(total), 0) as total 
            FROM orders 
            WHERE order_status IN ('delivered') 
            AND DATE(created_at) = CURRENT_DATE()
        ")['total'] ?? 0;
        
        $todayOrders = $db->fetchOne("
            SELECT COUNT(*) as total FROM orders 
            WHERE DATE(created_at) = CURRENT_DATE()
        ")['total'] ?? 0;
        
        $data = [
            'user' => Session::getUser(),
            'stats' => [
                'total_users' => $totalUsers,
                'total_orders' => $totalOrders,
                'total_products' => $totalProducts,
                'total_suppliers' => $totalSuppliers,
                'total_revenue' => $totalRevenue
            ],
            'comparison' => [
                'this_month_revenue' => $thisMonthRevenue,
                'last_month_revenue' => $lastMonthRevenue,
                'revenue_change' => round($revenueChange, 1),
                'this_month_orders' => $thisMonthOrders,
                'last_month_orders' => $lastMonthOrders,
                'orders_change' => round($ordersChange, 1),
                'today_revenue' => $todayRevenue,
                'today_orders' => $todayOrders
            ],
            'alerts' => $alerts,
            'orderStats' => $statusCounts,
            'topProducts' => $topProducts,
            'weeklyRevenue' => $weeklyRevenue,
            'newFeedbackCount' => $newFeedbackCount
        ];

        $this->view('admin/dashboard', $data);
    }

    /**
     * Đăng ký tài khoản admin mới
     */
    public function registerAdmin()
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
$this->view('admin/register_admin');
            return;
        }

        $username = sanitize($_POST['username'] ?? '');
        $fullName = sanitize($_POST['full_name'] ?? '');
        $email = sanitize($_POST['email'] ?? '');
        $phone = sanitize($_POST['phone'] ?? '');
        $password = $_POST['password'] ?? '';
        $confirmPassword = $_POST['confirm_password'] ?? '';

        // Validation
        $validator = validate([
            'username' => $username,
            'full_name' => $fullName,
            'email' => $email,
            'password' => $password,
            'confirm_password' => $confirmPassword
        ]);

        $validator->required('username', 'Tên đăng nhập không được để trống')
            ->required('full_name', 'Họ tên không được để trống')
            ->required('email', 'Email không được để trống')
            ->email('email', 'Email không hợp lệ')
            ->required('password', 'Mật khẩu không được để trống')
            ->minLength('password', 6, 'Mật khẩu phải có ít nhất 6 ký tự')
            ->match('password', 'confirm_password', 'Mật khẩu xác nhận không khớp');

        if ($validator->fails()) {
            Session::setFlash('error', $validator->firstError());
            $this->redirect('/admin/register-admin');
            return;
        }

        // Kiểm tra email đã tồn tại
        if ($this->userModel->findByEmail($email)) {
            Session::setFlash('error', 'Email này đã được sử dụng');
            $this->redirect('/admin/register-admin');
            return;
        }

        // Kiểm tra username đã tồn tại
        if ($this->userModel->findByUsername($username)) {
            Session::setFlash('error', 'Tên đăng nhập này đã được sử dụng');
            $this->redirect('/admin/register-admin');
            return;
        }

        // Đăng ký admin với OTP tự động được tạo trong model
        $userData = [
            'username' => $username,
            'email' => $email,
            'password' => $password,
            'full_name' => $fullName,
            'phone' => $phone
        ];

        $result = $this->userModel->registerAdmin($userData);
        $userId = $result['success'] ? $result['user_id'] : null;

        if ($result['success']) {
            // Lưu email vào session để verify
            Session::set('pending_admin_email', $email);
            
            if ($result['email_sent']) {
                Session::setFlash('success', 'Đăng ký thành công! Vui lòng kiểm tra email để xác thực.');
            } else {
                Session::setFlash('warning', 'Đăng ký thành công nhưng không thể gửi email. Vui lòng liên hệ quản trị viên.');
            }
            
            $this->redirect('/admin/verify-otp-admin');
        } else {
            Session::setFlash('error', 'Đăng ký thất bại. Vui lòng thử lại.');
$this->redirect('/admin/register-admin');
        }
    }

    /**
     * Xác thực OTP cho admin mới
     */
    public function verifyOTPAdmin()
    {
        $pendingEmail = Session::get('pending_admin_email');

        if (!$pendingEmail) {
            Session::setFlash('error', 'Phiên đăng ký đã hết hạn. Vui lòng đăng ký lại.');
            $this->redirect('/admin/register-admin');
            return;
        }

        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->view('admin/verify_otp_admin', ['email' => $pendingEmail]);
            return;
        }

        $otp = sanitize($_POST['otp'] ?? '');

        if (empty($otp)) {
            Session::setFlash('error', 'Vui lòng nhập mã OTP');
            $this->redirect('/admin/verify-otp-admin');
            return;
        }

        // Kiểm tra OTP
        $user = $this->userModel->findByEmail($pendingEmail);

        if (!$user) {
            Session::setFlash('error', 'Không tìm thấy tài khoản');
            $this->redirect('/admin/register-admin');
            return;
        }

        if ($user['otp_code'] !== $otp) {
            Session::setFlash('error', 'Mã OTP không chính xác');
            $this->redirect('/admin/verify-otp-admin');
            return;
        }

        if (strtotime($user['otp_expiry']) < time()) {
            Session::setFlash('error', 'Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới.');
            $this->redirect('/admin/verify-otp-admin');
            return;
        }

        // Xác thực thành công - cập nhật trạng thái
        $updateSql = "UPDATE users SET email_verified = 1, otp_code = NULL, otp_expiry = NULL WHERE id = ?";
        $this->db->execute($updateSql, [$user['id']]);

        // Xóa session
        Session::delete('pending_admin_email');

        Session::setFlash('success', 'Xác thực email thành công! Tài khoản của bạn đang chờ Super Admin phê duyệt.');
        $this->redirect('/admin/login');
    }

    /**
     * Gửi lại mã OTP cho admin
     */
    public function resendOTPAdmin()
    {
        // Sử dụng output buffering để ngăn chặn bất kỳ output ngoài ý muốn nào (warnings, notices) làm hỏng JSON
        ob_start();
        
        try {
            $pendingEmail = Session::get('pending_admin_email');

            if (!$pendingEmail) {
                ob_end_clean();
                $this->json(['success' => false, 'message' => 'Phiên đăng ký đã hết hạn. Vui lòng đăng ký lại.'], 400);
                return;
            }

            $user = $this->userModel->findByEmail($pendingEmail);

            if (!$user) {
                ob_end_clean();
                $this->json(['success' => false, 'message' => 'Không tìm thấy tài khoản'], 404);
                return;
            }

            // Tạo OTP mới
            $otp = sprintf('%06d', mt_rand(0, 999999));
            $otpExpiry = date('Y-m-d H:i:s', strtotime('+15 minutes'));

            // Cập nhật OTP
            $this->userModel->updateOTP($user['id'], $otp, $otpExpiry);

            // Gửi email
            $emailSent = sendOTPEmail($pendingEmail, $otp, $user['full_name']);

            // Dọn dẹp output buffer
            ob_end_clean();

            if ($emailSent) {
                $this->json(['success' => true, 'message' => 'Đã gửi lại mã OTP. Vui lòng kiểm tra email.']);
            } else {
                $this->json(['success' => false, 'message' => 'Không thể gửi email. Vui lòng thử lại.'], 500);
            }
        } catch (Exception $e) {
            ob_end_clean();
            $this->json(['success' => false, 'message' => 'Lỗi hệ thống: ' . $e->getMessage()], 500);
        }
    }
    
    /**
     * Trang đổi mật khẩu Admin
     */
    public function changePassword()
    {
        $this->requireAdmin();
        
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $this->handleChangePassword();
        } else {
            $this->view('admin/change_password');
        }
    }
    
    /**
     * Xử lý đổi mật khẩu Admin
     */
    private function handleChangePassword()
    {
        $currentUser = Session::getUser();
        $isSuperAdmin = $currentUser['role'] === 'superadmin';
        
        $currentPassword = $_POST['current_password'] ?? '';
        $newPassword = $_POST['new_password'] ?? '';
        $confirmPassword = $_POST['confirm_password'] ?? '';
        
        // SuperAdmin không cần nhập mật khẩu hiện tại
        if (!$isSuperAdmin && empty($currentPassword)) {
            Session::setFlash('error', 'Vui lòng nhập mật khẩu hiện tại');
            $this->redirect('/admin/change-password');
            return;
        }
        
        if (empty($newPassword)) {
            Session::setFlash('error', 'Vui lòng nhập mật khẩu mới');
            $this->redirect('/admin/change-password');
            return;
        }
        
        if (strlen($newPassword) < 6) {
            Session::setFlash('error', 'Mật khẩu mới phải có ít nhất 6 ký tự');
            $this->redirect('/admin/change-password');
            return;
        }
        
        if ($newPassword !== $confirmPassword) {
            Session::setFlash('error', 'Mật khẩu xác nhận không khớp');
            $this->redirect('/admin/change-password');
            return;
        }
        
        $userId = $currentUser['id'];
        
        // SuperAdmin không cần xác thực mật khẩu cũ
        if ($isSuperAdmin) {
            $result = $this->userModel->changePasswordSuperAdmin($userId, $newPassword);
        } else {
            $result = $this->userModel->changePassword($userId, $currentPassword, $newPassword);
        }
        
        if ($result['success']) {
            Session::setFlash('success', $result['message']);
            $this->redirect('/admin/dashboard');
        } else {
            Session::setFlash('error', $result['message']);
            $this->redirect('/admin/change-password');
        }
    }

    /**
     * Danh sách admin chờ phê duyệt
     */
    public function pendingAdmins()
    {
        $this->requireAdmin();

        // Chỉ super admin mới có quyền
        $currentUser = Session::getUser();
if (!$currentUser || $currentUser['role'] !== 'superadmin') {
            Session::setFlash('error', 'Chỉ SuperAdmin mới có quyền truy cập trang này');
            $this->redirect('/admin/dashboard');
            return;
        }

        $pendingAdmins = $this->userModel->getPendingAdmins();

        $this->view('admin/pending_admins', [
            'pendingAdmins' => $pendingAdmins
        ]);
    }

    /**
     * Phê duyệt admin
     */
    public function approveAdmin()
    {
        $this->requireAdmin();

        // Chỉ super admin mới có quyền
        $currentUser = Session::getUser();
        if (!$currentUser || $currentUser['role'] !== 'superadmin') {
            $this->json(['success' => false, 'message' => 'Chỉ SuperAdmin mới có quyền']);
            return;
        }

        // Chỉ super admin mới có quyền
        $currentUser = Session::getUser();
        if (!$currentUser || $currentUser['role'] !== 'superadmin') {
            Session::setFlash('error', 'Chỉ SuperAdmin mới có quyền thực hiện hành động này');
            $this->redirect('/admin/dashboard');
            return;
        }

        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            $this->redirect('/admin/pending-admins');
            return;
        }

        $adminId = intval($_POST['admin_id'] ?? 0);
        $action = $_POST['action'] ?? ''; // approve hoặc reject

        $user = $this->userModel->findById($adminId);

        if (!$user || $user['role'] !== 'admin') {
            Session::setFlash('error', 'Không tìm thấy tài khoản admin');
            $this->redirect('/admin/pending-admins');
            return;
        }

        if ($action === 'approve') {
            // Chỉ update status, giữ role='admin' không thay đổi
            $this->userModel->updateAdminStatus($adminId, 'active');
            
            // Đảm bảo role vẫn là 'admin', không phải 'superadmin'
            $this->db->execute("UPDATE users SET role = 'admin' WHERE id = ? AND role != 'superadmin'", [$adminId]);
            
            // TODO: Thêm function sendApprovalEmail() vào mail_helper.php nếu cần gửi email thông báo
            Session::setFlash('success', 'Đã phê duyệt tài khoản admin: ' . $user['full_name']);
        } elseif ($action === 'reject') {
            $this->userModel->updateAdminStatus($adminId, 'banned');
            // TODO: Thêm function sendApprovalEmail() vào mail_helper.php nếu cần gửi email thông báo
            Session::setFlash('success', 'Đã từ chối tài khoản admin: ' . $user['full_name']);
        }

        $this->redirect('/admin/pending-admins');
    }
}