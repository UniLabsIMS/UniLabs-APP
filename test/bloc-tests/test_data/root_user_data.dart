import 'package:unilabs_app/classes/api/user.dart';
import 'package:unilabs_app/root_bloc/root_state.dart';

RootState loggedInRootState = RootState(
  error: "",
  user: User(
    id: "",
    token: "",
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
