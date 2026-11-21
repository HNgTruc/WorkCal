# Ghi chú theo nền tảng

[← workcal-ui-ux](../SKILL.md)

## WPF (WorkCal.Desktop)

- Bố cục và giao diện viết bằng XAML; code-behind chỉ cho việc thuần giao diện. Binding tới ViewModel trong `WorkCal.Client.Core` (CommunityToolkit.Mvvm).
- Màu, cỡ chữ, khoảng cách, style khai báo trong `ResourceDictionary` dưới `Resources/`, gộp ở `App.xaml`; control dùng `{DynamicResource ...}` để đổi theme sáng/tối lúc chạy.
- Định vị bằng `Grid` với `Grid.Row`/`Grid.Column` và `*`/`Auto`, không dùng `Margin` lớn để canh.
- Trợ năng: `AutomationProperties.Name` cho nút chỉ có icon; `AutomationProperties.HelpText` khi cần; `KeyboardNavigation.TabIndex` khi thứ tự mặc định sai; `FocusVisualStyle` không được tắt.
- Trạng thái control bằng `VisualStateManager`/`Trigger`; animation bằng `Storyboard` (`DoubleAnimation` trên `Opacity`, `RenderTransform`), kiểm tra `SystemParameters.ClientAreaAnimation` để tắt khi người dùng giảm hiệu ứng.
- Lệnh từ View gọi `ICommand` (`[RelayCommand]`), không gắn `Click` vào logic. Phím tắt bằng `InputBindings`.
- Danh sách dài dùng ảo hóa (`VirtualizingPanel.IsVirtualizing="True"`).

## .NET MAUI (WorkCal.Mobile)

- Style và màu khai báo trong resource dictionary của app, gộp ở `App.xaml`; sáng/tối bằng `AppThemeBinding`. Không đặt màu thẳng trên control.
- Trợ năng: `SemanticProperties.Description` cho nút icon và ảnh, `SemanticProperties.HeadingLevel` cho tiêu đề; kiểm tra bằng TalkBack và VoiceOver.
- Vùng chạm tối thiểu 44×44 (iOS) / 48×48 dp (Android); dùng `Padding` để mở rộng vùng chạm thay vì phóng to icon.
- Điều hướng bằng Shell; thanh tab dưới tối đa 5 mục. Tôn trọng safe area trên iOS.
- Danh sách dùng `CollectionView` với `EmptyView` cho trạng thái trống; kéo để làm mới bằng `RefreshView`.
- Animation bằng `ViewExtensions` (`FadeTo`, `TranslateTo`) 150–300 ms.
- Thông báo cục bộ tối đa 64 cái gần nhất ([offline-sync.md](../../../../docs/architecture/offline-sync.md)).
- iOS chỉ build được trên macOS; kiểm tra giao diện trên Android emulator trước.

## Blazor + MudBlazor (WorkCal.Admin)

- Theme khai báo một lần bằng `MudTheme` (`PaletteLight`, `PaletteDark`, `Typography`) trong layout; component dùng `Color.Primary`, `Color.Error`... thay vì mã màu.
- Bảng dùng `MudDataGrid` (phân trang phía server khớp `page`/`pageSize` của API), form dùng `MudForm` + validation hiển thị dưới ô nhập, hộp thoại dùng `IDialogService`, thông báo dùng `ISnackbar`.
- Mỗi trang có `<PageTitle>`; nút chỉ có icon (`MudIconButton`) có `aria-label`.
- Kiểm tra quyền bằng `[Authorize(Policy = ...)]` trên trang; ẩn menu chỉ là phụ.
- Logic gọi API và xử lý dữ liệu đặt trong `Services/`; component chỉ hiển thị và nhận sự kiện.
- Interactive Server cần kết nối liên tục: hiển thị trạng thái mất kết nối và thử lại rõ ràng.
- Animation đơn giản dùng CSS transition; cần chuyển động phức tạp hơn thì xem [gsap-blazor.md](gsap-blazor.md).
