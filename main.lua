#include "imgui.h"
#include <vector>
#include <string>
#include <string.h>

// ========================================================
// 1. CẤU TRÚC DỮ LIỆU ĐỐI TƯỢNG (GAME ENGINE STRUCTURE)
// ========================================================
struct Vector2D {
    float x;
    float y;
};

struct GamePlayer {
    int id;
    std::string name;
    Vector2D position;
    float width;
    float height;
    bool isAlive;
};

// ========================================================
// 2. KHAI BÁO CÁC BIẾN TRẠNG THÁI HỆ THỐNG (STATES)
// ========================================================
// Quản lý bảo mật & Menu
static bool b_MenuOpen = true;
static bool b_Authenticated = false;
static char sz_KeyBuffer[64] = "";
const char* sz_ValidKey = "ADMIN-DEV-2026"; // Mã khóa kích hoạt mẫu

// Quản lý Phân Tab Giao diện
enum MenuTabs { TAB_OVERVIEW = 0, TAB_VISUALS, TAB_MOVEMENT };
static int i_SelectedTab = TAB_OVERVIEW;

// Cấu hình tính năng
static bool b_EnableESP = false;
static int i_TargetPlayerIndex = 0;

// ========================================================
// 3. DỮ LIỆU GIẢ LẬP VÀ LOGIC XỬ LÝ TRONG GAME
// ========================================================
// Giả định đây là đối tượng Nhân vật chính (Local Player) của bạn
static GamePlayer localPlayer = { 1, "Chủ Phòng (Dev)", {400.0f, 500.0f}, 40.0f, 60.0f, true };

// Hàm lấy danh sách tất cả người chơi khác từ Server/Engine về bộ nhớ tạm
std::vector<GamePlayer> FetchActivePlayers() 
{
    std::vector<GamePlayer> plist;
    // Thêm dữ liệu mẫu của các người chơi khác trong phòng để test
    plist.push_back({ 101, "Người chơi 1", {250.0f, 300.0f}, 40.0f, 60.0f, true });
    plist.push_back({ 102, "Người chơi 2", {650.0f, 450.0f}, 40.0f, 60.0f, true });
    plist.push_back({ 103, "Người chơi 3 (Đã chết)", {0.0f, 0.0f}, 40.0f, 60.0f, false });
    return plist;
}

// Hàm thực hiện chức năng Dịch Chuyển Tức Thời an toàn (Chống văng/Kẹt vật lý)
void ExecuteTeleport(GamePlayer& source, const GamePlayer& target) 
{
    // CHỐNG VĂNG: Kiểm tra xem mục tiêu có tồn tại hợp lệ và còn sống không
    if (!target.isAlive) return;

    // Thay đổi tọa độ nhân vật chính tới vị trí mục tiêu
    // Trừ đi một khoảng nhỏ ở trục Y (-10px) để nhân vật xuất hiện phía trên đầu, tránh kẹt va chạm (Collision)
    source.position.x = target.position.x;
    source.position.y = target.position.y - 10.0f;
}

// Hàm vẽ khung định vị ESP đè lên màn hình đồ họa
void RenderESPOverlay() 
{
    if (!b_EnableESP) return;

    // Lấy danh sách vẽ lớp trên cùng của ImGui
    ImDrawList* drawList = ImGui::GetForegroundDrawList();
    if (!drawList) return;

    std::vector<GamePlayer> players = FetchActivePlayers();ImU32 colorBox = IM_COL32(0, 255, 150, 255); // Màu xanh neon định vị

    for (const auto& player : players) 
    {
        // TỐI ƯU/CHỐNG VĂNG: Chỉ vẽ những đối tượng hợp lệ và còn sống
        if (!player.isAlive) continue;

        // Tính toán tọa độ 4 góc của khung Box từ tâm vị trí chân
        float t_Left = player.position.x - (player.width / 2);
        float t_Top = player.position.y - player.height;
        float t_Right = player.position.x + (player.width / 2);
        float t_Bottom = player.position.y;

        // Tiến hành vẽ Box ESP
        drawList->AddRect(ImVec2(t_Left, t_Top), ImVec2(t_Right, t_Bottom), colorBox, 0.0f, 0, 1.5f);

        // Hiển thị Tên người chơi phía trên khung chữ nhật
        std::string label = player.name;
        drawList->AddText(ImVec2(t_Left, t_Top - 15), IM_COL32(255, 255, 255, 255), label.c_str());
    }
}

// ========================================================
// 4. HÀM DỰNG GIAO DIỆN MENU CHÍNH
// ========================================================
void DrawEngineController() 
{
    if (!b_MenuOpen) return;

    // Đặt kích thước cố định cho khung cửa sổ xác thực và tính năng
    ImGui::SetNextWindowSize(ImVec2(550, 380), ImGuiCond_FirstUseEver);

    // MÀN HÌNH 1: YÊU CẦU XÁC THỰC MÃ KHÓA (KEY SYSTEM)
    if (!b_Authenticated) 
    {
        ImGui::Begin("Hệ Thống Kích Hoạt Quyền Dev", &b_MenuOpen, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize);
        ImGui::TextColored(ImVec4(1.0f, 0.4f, 0.4f, 1.0f), "Cảnh báo: Cần nhập mã bản quyền để truy cập các tính năng kiểm thử!");
        ImGui::Separator(); ImGui::Spacing();

        ImGui::Text("Mã kích hoạt (Key):");
        ImGui::InputText("##KeyInput", sz_KeyBuffer, IM_ARRAYSIZE(sz_KeyBuffer), ImGuiInputTextFlags_Password);
        ImGui::Spacing();

        if (ImGui::Button("XÁC NHẬN KÍCH HOẠT", ImVec2(-1, 35))) 
        {
            if (strcmp(sz_KeyBuffer, sz_ValidKey) == 0) {
                b_Authenticated = true; // Mở khóa menu
            } else {
                ImGui::OpenPopup("Mã Sai");
            }
        }

        // Popup cảnh báo khi gõ sai key
        if (ImGui::BeginPopupModal("Mã Sai", nullptr, ImGuiWindowFlags_AlwaysAutoResize)) {
            ImGui::Text("Mã kích hoạt bạn nhập không chính xác. Vui lòng thử lại!");
            if (ImGui::Button("Đóng", ImVec2(100, 0))) { ImGui::CloseCurrentPopup(); }
            ImGui::EndPopup();
        }
        ImGui::End();
        return; // Chặn không cho chạy xuống menu tính năng bên dưới
    }

    // MÀN HÌNH 2: GIAO DIỆN ĐIỀU KHIỂN CHỨC NĂNG CHÍNH (ĐÃ XÁC THỰC)
    ImGui::Begin("Developer Control Panel v1.0", &b_MenuOpen, ImGuiWindowFlags_NoCollapse);// Chia bố cục 2 cột bằng Table của ImGui (Thay thế cho cấu hình Columns cũ giúp tối ưu luồng hiển thị)
    if (ImGui::BeginTable("MenuLayoutTable", 2, ImGuiTableFlags_SizingFixedFit)) 
    {
        ImGui::TableSetupColumn("Sidebar", ImGuiTableColumnFlags_WidthFixed, 140.0f);
        ImGui::TableSetupColumn("Content", ImGuiTableColumnFlags_WidthStretch);
        ImGui::TableNextRow();

        // ----------------------------------------------------
        // CỘT TRÁI: DANH SÁCH TAB ĐIỀU HƯỚNG
        // ----------------------------------------------------
        ImGui::TableSetColumnIndex(0);
        ImGui::Text("Chức Năng");
        ImGui::Separator(); ImGui::Spacing();

        if (ImGui::Button("Tổng Quan", ImVec2(-1, 32)))  { i_SelectedTab = TAB_OVERVIEW; } ImGui::Spacing();
        if (ImGui::Button("Định Vị ESP", ImVec2(-1, 32))) { i_SelectedTab = TAB_VISUALS; } ImGui::Spacing();
        if (ImGui::Button("Dịch Chuyển", ImVec2(-1, 32))) { i_SelectedTab = TAB_MOVEMENT; }

        // ----------------------------------------------------
        // CỘT PHẢI: NỘI DUNG CHI TIẾT CỦA TỪNG TAB
        // ----------------------------------------------------
        ImGui::TableSetColumnIndex(1);
        
        if (i_SelectedTab == TAB_OVERVIEW) 
        {
            ImGui::Text("HỆ THỐNG KIỂM THỬ AN TOÀN TRÒ CHƠI");
            ImGui::Separator();
            ImGui::Text("Tài khoản: %s", localPlayer.name.c_str());
            ImGui::Text("Tọa độ hiện tại: X: %.1f | Y: %.1f", localPlayer.position.x, localPlayer.position.y);
            ImGui::Text("Hiệu năng hiển thị: %.1f FPS", ImGui::GetIO().Framerate);
        }
        else if (i_SelectedTab == TAB_VISUALS) 
        {
            ImGui::Text("CẤU HÌNH HIỂN THỊ ĐỒ HỌA (ESP)");
            ImGui::Separator(); ImGui::Spacing();
            
            // Công tắc bật/tắt chức năng vẽ khung định vị
            ImGui::Checkbox("Kích hoạt ESP Box", &b_EnableESP);
            ImGui::TextWrapped("Lưu ý: Tính năng này vẽ trực tiếp lên DrawList tầng cao nhất, tự động bỏ qua các thực thể không còn hoạt động để tránh hao tổn tài nguyên CPU.");
        }
        else if (i_SelectedTab == TAB_MOVEMENT) 
        {
            ImGui::Text("ĐIỀU HƯỚNG DỊCH CHUYỂN NHÂN VẬT");
            ImGui::Separator(); ImGui::Spacing();

            // Lấy danh sách người chơi mới nhất
            std::vector<GamePlayer> currentPlayers = FetchActivePlayers();
            
            // Xử lý giao diện danh sách cuộn (Combo Box) để chọn người chơi cần dịch chuyển tới
            if (ImGui::BeginCombo("Mục tiêu đến", currentPlayers[i_TargetPlayerIndex].name.c_str())) 
            {
                for (int n = 0; n < currentPlayers.size(); n++) 
                {bool isSelected = (i_TargetPlayerIndex == n);
                    std::string entryName = currentPlayers[n].name + (currentPlayers[n].isAlive ? "" : " (Chết)");
                    
                    if (ImGui::Selectable(entryName.c_str(), isSelected)) {
                        i_TargetPlayerIndex = n;
                    }
                    if (isSelected) {
                        ImGui::SetItemDefaultFocus();
                    }
                }
                ImGui::EndCombo();
            }

            ImGui::Spacing(); ImGui::Separator(); ImGui::Spacing();

            // Nút bấm thực hiện hành động dịch chuyển tức thời
            if (ImGui::Button("DỊCH CHUYỂN ĐẾN MỤC TIÊU", ImVec2(-1, 40))) 
            {
                ExecuteTeleport(localPlayer, currentPlayers[i_TargetPlayerIndex]);
            }
        }

        ImGui::EndTable();
    }
    ImGui::End();

    // Thực hiện vẽ đè ESP lên màn hình game song song nếu trạng thái Checkbox được bật
    RenderESPOverlay();
}
