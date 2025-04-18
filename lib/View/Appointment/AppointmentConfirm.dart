import 'package:app_hm/Component/StepBook.dart';
import 'package:app_hm/Controller/Appointment/AppointmentController.dart';
import 'package:app_hm/Controller/DashboardController.dart';
import 'package:app_hm/Model/Car/CarModel.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class Appointmentconfirm extends StatelessWidget {
  const Appointmentconfirm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Appointmentcontroller());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D74FF),
        title: Text('book_service'.tr,
            style: const TextStyle(color: Colors.white)),
        elevation: 0,
        automaticallyImplyLeading: false, // Ẩn nút quay lại
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(DateFormat('HH:mm:ss').format(DateTime.now()),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepBook(currentStep: controller.currentStep.value),
              const SizedBox(height: 20),
              _buildTitle("BIỂN SỐ XE", onEdit: () {}),
              _buildCarBox(controller),
              const SizedBox(height: 20),
              _buildTitle("LIÊN HỆ", onEdit: () async {
                var result = await Get.toNamed(Routes.personaldetail);
                if (result == true) {
                  controller.getAccount();
                }
              }),
              _buildContactBox(controller),
              const SizedBox(height: 20),
              _buildTitle("DỊCH VỤ", editText: "Thay đổi", onEdit: () {
                controller.currentStep.value = 1;
                controller.resetService();
                controller.navigateToStep();
              }),
              _buildServiceBox(controller),
              const SizedBox(height: 20),
              _buildTitle("Địa điểm", editText: "Thay đổi", onEdit: () {
                controller.currentStep.value = 2;
                controller.resetService();
                controller.navigateToStep();
              }),
              _buildAddressBox(controller),
              const SizedBox(height: 20),
              _buildTitle("Thời gian", editText: "Thay đổi", onEdit: () {
                controller.currentStep.value = 3;
                controller.resetService();
                controller.navigateToStep();
              }),
              _buildTimeBox(controller),
              const SizedBox(height: 20),
              _buildButtons(controller),
            ],
          ),
        ),
      ),
    );
  }
}

// Tiêu đề
Widget _buildTitle(String title,
    {VoidCallback? onEdit, String editText = "Sửa"}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text('${title.toUpperCase()}*',
          style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold)),
      TextButton(
        onPressed: onEdit,
        child: Text(editText, style: const TextStyle(color: Colors.blue)),
      ),
    ],
  );
}

// Hiển thị xe
Widget _buildCarBox(Appointmentcontroller controller) {
  return Obx(
    () {
      if (controller.carList.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 231, 231, 231),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'no_car'.tr,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<CarModel>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            value: controller.selectedCar.value,
            items: controller.carList.map((car) {
              return DropdownMenuItem<CarModel>(
                value: car,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(car.license_plate ?? "---",
                        style: const TextStyle(color: Colors.black)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (car) {
              controller.selectedCar.value = car;
            },
          ),
        ],
      );
    },
  );
}

// Hiển thị thông tin liên hệ
Widget _buildContactBox(Appointmentcontroller controller) {
  return Obx(
    () => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 231, 231, 231),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Tên",
              style: TextStyle(
                  fontSize: 11, color: Color.fromARGB(255, 75, 75, 75))),
          Text(controller.account.value.fullname ?? "Chưa cập nhật",
              style: const TextStyle(fontSize: 13, color: Colors.black)),
          const SizedBox(height: 12),
          const Text("Số điện thoại",
              style: TextStyle(
                  fontSize: 11, color: Color.fromARGB(255, 75, 75, 75))),
          Text(controller.account.value.phonenum ?? "Chưa cập nhật",
              style: const TextStyle(fontSize: 13, color: Colors.black)),
          const SizedBox(height: 12),
          const Text("Địa chỉ email",
              style: TextStyle(
                  fontSize: 11, color: Color.fromARGB(255, 75, 75, 75))),
          Text(controller.account.value.email ?? "Chưa cập nhật",
              style: const TextStyle(fontSize: 13, color: Colors.black)),
        ],
      ),
    ),
  );
}

// Hiển thị thông tin dịch vụ
Widget _buildServiceBox(Appointmentcontroller controller) {
  return Obx(() {
    if (controller.selectedServices.isEmpty) {
      return const Text('Chưa có dịch vụ',
          style: TextStyle(color: Colors.grey));
    }

    // Lấy tên loại dịch vụ từ controller.selectedType
    final String typeName = controller.selectedType.value?.type_name ?? '---';

    // Nối danh sách tên dịch vụ thành chuỗi, ngăn cách bởi dấu phẩy
    final String servicesText = controller.selectedServices
        .map((service) => service.service_name ?? '')
        .where((name) => name.isNotEmpty)
        .join(', ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 231, 231, 231),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Loại dịch vụ:",
              style: TextStyle(
                  fontSize: 11, color: Color.fromARGB(255, 75, 75, 75))),
          Text(typeName,
              style: const TextStyle(fontSize: 13, color: Colors.black)),
          const SizedBox(height: 10),
          const Text("Dịch vụ:",
              style: TextStyle(
                  fontSize: 11, color: Color.fromARGB(255, 75, 75, 75))),
          Text(servicesText,
              style: const TextStyle(fontSize: 13, color: Colors.black)),
        ],
      ),
    );
  });
}

// Hiển thị thông tin địa điểm
Widget _buildAddressBox(Appointmentcontroller controller) {
  return Obx(() {
    final center = controller.selectedAddress.value;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 231, 231, 231),
        borderRadius: BorderRadius.circular(12),
      ),
      child: center == null
          ? const Text('Chưa có địa điểm', style: TextStyle(color: Colors.grey))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Tên trung tâm",
                    style: TextStyle(
                        fontSize: 11, color: Color.fromARGB(255, 75, 75, 75))),
                Text(center.gara_name ?? "Chưa có",
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 8),
                const Text("Địa chỉ",
                    style: TextStyle(
                        fontSize: 11, color: Color.fromARGB(255, 75, 75, 75))),
                Text(center.gara_address ?? "Chưa có",
                    style: const TextStyle(fontSize: 13)),
              ],
            ),
    );
  });
}

// Hiển thị thông tin thời gian
Widget _buildTimeBox(Appointmentcontroller controller) {
  return Obx(() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 231, 231, 231),
        borderRadius: BorderRadius.circular(12),
      ),
      child: controller.selectedTime.value == null
          ? const Text('Chưa chọn thời gian',
              style: TextStyle(color: Colors.grey))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Thời gian",
                        style: TextStyle(
                            fontSize: 11,
                            color: Color.fromARGB(255, 75, 75, 75))),
                    Text(controller.selectedTime.value ?? 'Chưa chọn thời gian',
                        style:
                            const TextStyle(fontSize: 13, color: Colors.black)),
                  ],
                ),
              ],
            ),
    );
  });
}

// Hiển thị nút
Widget _buildButtons(Appointmentcontroller controller) {
  return Row(
    children: [
      Expanded(
        child: SizedBox(
          height: 48,
          child: OutlinedButton(
            onPressed: () {
              controller.previousStep();
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minimumSize: const Size(double.infinity, 45),
            ),
            child:
                Text('cancel'.tr, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: controller.checkdetail
                ? () {
                    controller.nextStep();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child:
                const Text("Đặt lịch", style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    ],
  );
}

// Sửa thông tin liên hệ
// void bottomSheetEditContact({
//   required BuildContext context,
//   required Dashboardcontroller controller,
// }) {
//   final nameController = TextEditingController(text: controller.fullname.value);
//   final phoneController =
//       TextEditingController(text: controller.phoneNumber.value);
//   final emailController = TextEditingController(text: controller.email.value);

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//     builder: (context) {
//       return Padding(
//         padding: EdgeInsets.only(
//           left: 20,
//           right: 20,
//           top: 20,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text("Chỉnh sửa thông tin liên hệ",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                   labelText: "Tên", hintStyle: TextStyle(color: Colors.black)),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: phoneController,
//               decoration: const InputDecoration(
//                   labelText: "Số điện thoại",
//                   hintStyle: TextStyle(color: Colors.black)),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(
//                   labelText: "Email",
//                   hintStyle: TextStyle(color: Colors.black)),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 controller.fullname.value = nameController.text.trim();
//                 controller.phoneNumber.value = phoneController.text.trim();
//                 controller.email.value = emailController.text.trim();
//                 Navigator.pop(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 130, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text("Lưu", style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }