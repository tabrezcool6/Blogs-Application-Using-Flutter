import 'package:blogs_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/core/common/entities/user.dart';
import 'package:blogs_app/features/auth/domain/usecases/current_user.dart';
import 'package:blogs_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blogs_app/features/auth/domain/usecases/user_sign_out.dart';
import 'package:blogs_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'auth_event.dart';
part 'auth_state.dart';

// TODO : STEP 10 - Create Auth Bloc for the feature
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final UserSignOut _userSignOut;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required UserSignOut userSignOut,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _userSignOut = userSignOut,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    // Default Loader State for all events
    on<AuthEvent>((_, emit) => emit(AuthLoading()));

    // Sign Up Bloc Implementation
    on<AuthSignUp>(_onAuthSignUp);

    // Sign In Bloc Implementation
    on<AuthSignIn>(_onAuthSignIn);

    // Sign Out Bloc Implementation
    on<AuthSignOut>(_onAuthSignOut);

    // Current User Bloc Implementation
    on<AuthIsUserLoggedIn>(_onAuthIsUserLoggedIn);
  }

  //
  // Custom Bloc Functions
  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit), // AuthSuccess(user),
    );
  }

  //
  void _onAuthSignIn(
    AuthSignIn event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _userSignIn(
      UserSignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit), // AuthSuccess(user),
    );
  }

  void _onAuthSignOut(
    AuthSignOut event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _userSignOut(NoParams());

    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (r) => emit(AuthSignOutSuccess()),
    );
  }

  //
  void _onAuthIsUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _currentUser(NoParams());
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  //
  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
