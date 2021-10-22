import 'package:unilabs_app/classes/api/user.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';

RootState loggedInRootState = RootState(
  error: "",
  user: User(
    id: "33a59268-8b84-48fe-8b96-8ab221edd249",
    token: "367dd9e9f8d3eb6927d721ff44fcaedbbad9d33c74f66ef20be1474cf000422a",
    email: "test@example.com",
    firstName: "Test",
    lastName: "User",
    imageURL: null,
    role: "Lab_Assistant",
    department: "Computer Science and Engineering",
    lab: "Embedded Systems Laboratory",
    labId: "",
    contactNo: "0777546342",
    blocked: false,
  ),
  loginState: LoginStateType.LOGIN,
  checkStarted: false,
);
