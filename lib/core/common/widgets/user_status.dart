import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/user_status/app_user_cubit.dart';

class UserStatusWidget extends StatelessWidget {
  const UserStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserStatusCubit, UserStatusState>(
      builder: (context, state) {
        if (state is UserOnline) {
          return _buildStatusIndicator('Online', Colors.green);
        } else if (state is UserOffline) {
          return _buildStatusIndicator('Offline', Colors.red);
        } else if (state is UserAway) {
          return _buildStatusIndicator('Away', Colors.orange);
        } else {
          return _buildStatusIndicator('Loading...', Colors.grey);
        }
      },
    );
  }

  Widget _buildStatusIndicator(String status, Color color) {
    return Container(
      height: 100,
      width: 100,
      //make round container with text status and make it colour based on status
      decoration: BoxDecoration(
        color: color,
      ),
      child: Center(child: Text('Status')),
    );
  }
}
