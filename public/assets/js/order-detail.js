/**
 * Order Detail Page Scripts
 */

function cancelOrder(orderId) {
    const reason = prompt("Vui lòng nhập lý do hủy đơn hàng:");
    if (reason && reason.trim()) {
        confirmDelete({
            title: "Hủy đơn hàng",
            message: "Bạn có chắc chắn muốn hủy đơn hàng này?",
            theme: "user",
            confirmText: "Hủy đơn hàng",
            cancelText: "Không",
            onConfirm: function () {
                // Call API to cancel order
                fetch(window.BASE_URL + "/orders/cancel", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded",
                        "X-Requested-With": "XMLHttpRequest",
                    },
                    body:
                        "order_id=" +
                        orderId +
                        "&reason=" +
                        encodeURIComponent(reason.trim()),
                })
                    .then((response) => response.json())
                    .then((data) => {
                        if (data.success) {
                            showToast("success", "Thành công!", data.message);
                            setTimeout(() => {
                                location.reload();
                            }, 1500);
                        } else {
                            showToast("error", "Lỗi!", data.message);
                        }
                    })
                    .catch((error) => {
                        console.error("Error:", error);
                        showToast(
                            "error",
                            "Lỗi!",
                            "Không thể kết nối đến server"
                        );
                    });
            },
        });
    }
}

// Toast notification function
function showToast(type, title, message) {
    // Check if toast container exists, if not create one
    let container = document.querySelector(".toast-container");
    if (!container) {
        container = document.createElement("div");
        container.className = "toast-container";
        container.style.cssText =
            "position: fixed; top: 20px; right: 20px; z-index: 9999;";
        document.body.appendChild(container);
    }

    const toast = document.createElement("div");
    toast.className = "toast " + type;
    toast.style.cssText =
        "background: white; padding: 15px 20px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); margin-bottom: 10px; display: flex; align-items: center; gap: 10px; min-width: 280px; transform: translateX(100%); transition: transform 0.3s ease;";

    const colors = {
        success: "#10b981",
        error: "#ef4444",
        warning: "#f59e0b",
        info: "#3b82f6",
    };

    toast.innerHTML = `
        <div style="color: ${colors[type]}; font-size: 20px;">
            ${
                type === "success"
                    ? "✓"
                    : type === "error"
                    ? "✕"
                    : type === "warning"
                    ? "⚠"
                    : "ℹ"
            }
        </div>
        <div style="flex: 1;">
            <div style="font-weight: 600; color: #1f2937;">${title}</div>
            <div style="color: #6b7280; font-size: 14px;">${message}</div>
        </div>
        <div style="cursor: pointer; color: #9ca3af;" onclick="this.parentElement.remove()">×</div>
    `;

    container.appendChild(toast);

    setTimeout(() => {
        toast.style.transform = "translateX(0)";
    }, 100);

    setTimeout(() => {
        toast.style.transform = "translateX(100%)";
        setTimeout(() => toast.remove(), 300);
    }, 4000);
}

// Print invoice function for user order detail
function printInvoice() {
    window.print();
}
