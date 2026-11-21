# GSAP trong Blazor Admin

[← workcal-ui-ux](../SKILL.md)

GSAP là thư viện animation JavaScript. Trong WorkCal chỉ có thể dùng ở **WorkCal.Admin** (Blazor). WPF và MAUI dùng animation có sẵn của nền tảng ([stacks.md](stacks.md)).

## Trước khi dùng

- Repo **chưa có** GSAP. Thêm GSAP (gói npm hoặc file trong `wwwroot/lib/`) là thêm thư viện mới: phải hỏi chủ dự án trước (quy tắc 3), kèm lý do CSS transition và hiệu ứng của MudBlazor không đủ, và kiểm tra giấy phép phiên bản định dùng.
- Không tải GSAP từ CDN lúc chạy; đóng gói cùng ứng dụng để chạy được trong mạng nội bộ của khách.
- Ưu tiên CSS transition cho hiệu ứng đơn giản (hover, mở/đóng). GSAP chỉ đáng dùng cho chuỗi chuyển động nhiều bước hoặc phối hợp nhiều phần tử.

## Cách gắn vào component

1. Viết JS isolation module đặt cạnh component (`Ten.razor.js`), export hàm `init(element)` trả về một đối tượng có `dispose()`.
2. Trong `init`, gói mọi tween trong `gsap.context(() => { ... }, element)` để chỉ tác động phần tử của component; `dispose()` gọi `ctx.revert()`.
3. Bọc bằng `gsap.matchMedia()`: chỉ chạy chuyển động khi `(prefers-reduced-motion: no-preference)`; trường hợp còn lại đặt thẳng trạng thái cuối.
4. Component nạp module trong `OnAfterRenderAsync(firstRender)` bằng `IJSRuntime.InvokeAsync<IJSObjectReference>("import", "./Components/.../Ten.razor.js")`, gọi `init` với `ElementReference`.
5. Component implement `IAsyncDisposable`: gọi `dispose()` rồi `DisposeAsync()` module; bắt `JSDisconnectedException` vì mạch Interactive Server có thể đã ngắt.

## Quy tắc chuyển động

- Chỉ animate `transform` (x, y, scale) và `opacity`; không animate `width`, `height`, `top`, `left`.
- Thời lượng 150–300 ms cho phản hồi giao diện, tối đa khoảng 500 ms cho chuyển cảnh; dùng easing ra (`power2.out`) cho phần tử xuất hiện.
- Không chặn thao tác của người dùng trong lúc animation chạy; không lặp vô hạn trên trang quản trị.
- Không dùng animation thay cho thông báo trạng thái: kết quả thao tác vẫn hiện bằng `ISnackbar` hoặc chữ.
