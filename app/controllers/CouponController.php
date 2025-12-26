<?php
require_once APP_PATH . '/core/Controller.php';
require_once APP_PATH . '/models/Coupon.php';

class CouponController extends Controller {
    private $couponModel;
    
    public function __construct() {
        $this->couponModel = new Coupon();
    }
    
    /**
     * Danh sách mã giảm giá
     */
    public function index() {
        // Check admin authentication
        if (!Session::isAdmin()) {
            header('Location: ' . BASE_URL . '/admin/login');
            exit;
        }
        
        $filters = [
            'search' => $_GET['search'] ?? '',
            'is_active' => $_GET['status'] ?? ''
        ];
        
        $coupons = $this->couponModel->getAll($filters);
        $stats = $this->couponModel->getStatistics();
        
        $this->view('admin/manage_coupons', [
            'coupons' => $coupons,
            'stats' => $stats,
            'filters' => $filters
        ]);
    }
    
    /**
     * Form tạo mã mới
     */
    public function create() {
        if (!Session::isAdmin()) {
            header('Location: ' . BASE_URL . '/admin/login');
            exit;
        }
        
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $data = [
                'code' => trim($_POST['code']),
                'description' => trim($_POST['description']),
                'apply_to' => $_POST['apply_to'] ?? 'product',
                'discount_type' => $_POST['discount_type'],
                'discount_value' => floatval($_POST['discount_value']),
                'min_order_value' => floatval($_POST['min_order_value'] ?? 0),
                'max_discount' => !empty($_POST['max_discount']) ? floatval($_POST['max_discount']) : null,
                'usage_limit' => !empty($_POST['usage_limit']) ? intval($_POST['usage_limit']) : null,
                'start_date' => $_POST['start_date'],
                'end_date' => $_POST['end_date'],
                'is_active' => isset($_POST['is_active']) ? 1 : 0
            ];
            
            // Validation
            $errors = $this->validateCouponData($data);
            
            if (empty($errors)) {
                // Check if code exists
                $existing = $this->couponModel->getByCode($data['code']);
                if ($existing) {
                    Session::setFlash('error', 'Mã giảm giá đã tồn tại');
                } else {
                    if ($this->couponModel->create($data)) {
                        // Gửi thông báo cho tất cả users về mã giảm giá mới
                        require_once APP_PATH . '/models/Notification.php';
                        $notificationModel = new Notification();
                        $discountText = $data['discount_type'] == 'percentage' 
                            ? $data['discount_value'] . '%' 
                            : number_format($data['discount_value']) . 'đ';
                        $notificationModel->notifyAllUsersPromotion(
                            '🎁 Mã giảm giá mới: ' . $data['code'],
                            'Giảm ' . $discountText . '. Áp dụng từ ' . date('d/m/Y', strtotime($data['start_date'])) . ' đến ' . date('d/m/Y', strtotime($data['end_date'])),
                            '/orders/checkout'
                        );
                        
                        Session::setFlash('success', 'Tạo mã giảm giá thành công');
                        header('Location: ' . BASE_URL . '/coupons');
                        exit;
                    } else {
                        Session::setFlash('error', 'Có lỗi xảy ra khi tạo mã');
                    }
                }
            } else {
                Session::setFlash('error', implode('<br>', $errors));
            }
        }
        
        $this->view('admin/coupon_form', [
            'coupon' => null
        ]);
    }
    
    /**
     * Form sửa mã
     */
    public function edit($id) {
        if (!Session::isAdmin()) {
            header('Location: ' . BASE_URL . '/admin/login');
            exit;
        }
        
        $coupon = $this->couponModel->getById($id);
        
        if (!$coupon) {
            Session::setFlash('error', 'Mã giảm giá không tồn tại');
            header('Location: ' . BASE_URL . '/coupons');
            exit;
        }
        
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $data = [
                'code' => trim($_POST['code']),
                'description' => trim($_POST['description']),
                'apply_to' => $_POST['apply_to'] ?? 'product',
                'discount_type' => $_POST['discount_type'],
                'discount_value' => floatval($_POST['discount_value']),
                'min_order_value' => floatval($_POST['min_order_value'] ?? 0),
                'max_discount' => !empty($_POST['max_discount']) ? floatval($_POST['max_discount']) : null,
                'usage_limit' => !empty($_POST['usage_limit']) ? intval($_POST['usage_limit']) : null,
                'start_date' => $_POST['start_date'],
                'end_date' => $_POST['end_date'],
                'is_active' => isset($_POST['is_active']) ? 1 : 0
            ];
            
            // Validation
            $errors = $this->validateCouponData($data);
            
            if (empty($errors)) {
                // Check if code exists (except current coupon)
                $existing = $this->couponModel->getByCode($data['code']);
                if ($existing && $existing['id'] != $id) {
                    Session::setFlash('error', 'Mã giảm giá đã tồn tại');
                } else {
                    $result = $this->couponModel->update($id, $data);
                    
                    if ($result !== false) {
                        Session::setFlash('success', 'Cập nhật mã giảm giá thành công');
                        header('Location: ' . BASE_URL . '/coupons');
                        exit;
                    } else {
                        Session::setFlash('error', 'Có lỗi xảy ra khi cập nhật mã. Vui lòng kiểm tra lại dữ liệu.');
                    }
                }
            } else {
                Session::setFlash('error', implode('<br>', $errors));
            }
        }
        
        $this->view('admin/coupon_form', [
            'coupon' => $coupon
        ]);
    }
    
    /**
     * Xem chi tiết mã
     */
    public function detail($id) {
        if (!Session::isAdmin()) {
            header('Location: ' . BASE_URL . '/admin/login');
            exit;
        }
        
        $coupon = $this->couponModel->getById($id);
        
        if (!$coupon) {
            Session::setFlash('error', 'Mã giảm giá không tồn tại');
            header('Location: ' . BASE_URL . '/coupons');
            exit;
        }
        
        $usageHistory = $this->couponModel->getUsageHistory($id, 100);
        
        $this->view('admin/coupon_detail', [
            'coupon' => $coupon,
            'usageHistory' => $usageHistory
        ]);
    }
    
    /**
     * Bật/tắt mã
     */
    public function toggleActive($id) {
        if (!Session::isAdmin()) {
            header('Location: ' . BASE_URL . '/admin/login');
            exit;
        }
        
        // Ensure id is valid
        $id = intval($id);
        
        if ($id <= 0) {
            Session::setFlash('error', 'ID không hợp lệ');
            header('Location: ' . BASE_URL . '/coupons');
            exit;
        }

        // Check coupon exists
        $coupon = $this->couponModel->getById($id);
        
        if (!$coupon) {
            Session::setFlash('error', 'Mã giảm giá không tồn tại');
            header('Location: ' . BASE_URL . '/coupons');
            exit;
        }

        // Toggle and verify
        $result = $this->couponModel->toggleActive($id);
        
        // execute() returns rowCount or false
        // rowCount should be 1 if update succeeded, 0 if no rows matched, false on error
        if ($result === false) {
            Session::setFlash('error', 'Lỗi database khi cập nhật trạng thái');
        } elseif ($result === 0) {
            Session::setFlash('error', 'Không tìm thấy mã để cập nhật');
        } else {
            Session::setFlash('success', 'Đã thay đổi trạng thái mã giảm giá');
        }

        header('Location: ' . BASE_URL . '/coupons');
        exit;
    }
    
    /**
     * Xóa mã
     */
    public function delete($id) {
        if (!Session::isAdmin()) {
            header('Location: ' . BASE_URL . '/admin/login');
            exit;
        }
        
        if ($this->couponModel->delete($id)) {
            Session::setFlash('success', 'Đã xóa mã giảm giá');
        } else {
            Session::setFlash('error', 'Có lỗi xảy ra');
        }
        
        header('Location: ' . BASE_URL . '/coupons');
        exit;
    }
    
    /**
     * Validate dữ liệu
     */
    private function validateCouponData($data) {
        $errors = [];
        
        if (empty($data['code'])) {
            $errors[] = 'Mã giảm giá không được để trống';
        } elseif (!preg_match('/^[A-Z0-9]+$/', $data['code'])) {
            $errors[] = 'Mã chỉ chứa chữ in hoa và số, không có khoảng trắng';
        }
        
        if ($data['discount_value'] <= 0) {
            $errors[] = 'Giá trị giảm phải lớn hơn 0';
        }
        
        if ($data['discount_type'] === 'percentage' && $data['discount_value'] > 100) {
            $errors[] = 'Phần trăm giảm không được vượt quá 100%';
        }
        
        if (strtotime($data['start_date']) >= strtotime($data['end_date'])) {
            $errors[] = 'Ngày kết thúc phải sau ngày bắt đầu';
        }
        
        return $errors;
    }
    
    /**
     * API: Validate coupon code (for cart page)
     */
    public function validateCode() {
        header('Content-Type: application/json');
        
        $code = $_POST['code'] ?? '';
        $userId = Session::get('user_id');
        $orderValue = floatval($_POST['order_value'] ?? 0);
        
        if (empty($code)) {
            echo json_encode(['valid' => false, 'message' => 'Vui lòng nhập mã giảm giá']);
            exit;
        }
        
        $result = $this->couponModel->validateCoupon($code, $userId, $orderValue);
        
        if ($result['valid']) {
            $discount = $this->couponModel->calculateDiscount($result['coupon'], $orderValue);
            echo json_encode([
                'valid' => true,
                'coupon' => $result['coupon'],
                'discount' => $discount,
                'message' => 'Áp dụng mã thành công!'
            ]);
        } else {
            echo json_encode($result);
        }
        exit;
    }
}
