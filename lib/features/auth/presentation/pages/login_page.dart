import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/error/failure_messages.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/core/utils/validators.dart';
import 'package:furniture_store/features/auth/presentation/cubit/login_cubit.dart';
import 'package:furniture_store/features/auth/presentation/cubit/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<LoginCubit>().submit(
      email: _email.text,
      password: _password.text,
      name: _name.text,
    );
  }

  void _forgotPassword() {
    if (!Validators.isEmail(_email.text)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(context.l10n.loginEnterEmailFirst)),
        );
      return;
    }
    context.read<LoginCubit>().resetPassword(_email.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final validators = Validators(l10n);
    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (a, b) =>
          a.resetEmailSent != b.resetEmailSent || a.failure != b.failure,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state.resetEmailSent) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(l10n.loginResetSent(_email.text.trim()))),
            );
          context.read<LoginCubit>().resetNoticeShown();
        } else if (state.failure != null) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.failure!.localized(l10n))),
            );
        }
      },
      builder: (context, state) {
        final register = state.mode == LoginMode.register;
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 64,
                            height: 64,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.chair_rounded,
                              color: theme.colorScheme.onPrimary,
                              size: 34,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          register ? l10n.loginCreateTitle : l10n.loginWelcome,
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          register
                              ? l10n.loginCreateText
                              : l10n.loginWelcomeText,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SegmentedButton<LoginMode>(
                          segments: [
                            ButtonSegment(
                              value: LoginMode.signIn,
                              label: Text(l10n.loginSignIn),
                            ),
                            ButtonSegment(
                              value: LoginMode.register,
                              label: Text(l10n.loginRegister),
                            ),
                          ],
                          selected: {state.mode},
                          onSelectionChanged: state.submitting
                              ? null
                              : (s) =>
                                    context.read<LoginCubit>().setMode(s.first),
                        ),
                        const SizedBox(height: 20),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          child: register
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: TextFormField(
                                    controller: _name,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    autofillHints: const [AutofillHints.name],
                                    decoration: InputDecoration(
                                      labelText: l10n.loginFullName,
                                      prefixIcon: const Icon(
                                        Icons.person_outline,
                                      ),
                                    ),
                                    validator: validators.name,
                                  ),
                                )
                              : const SizedBox(width: double.infinity),
                        ),
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            labelText: l10n.loginEmail,
                            prefixIcon: const Icon(Icons.mail_outline),
                          ),
                          validator: validators.email,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _password,
                          obscureText: _obscure,
                          autofillHints: [
                            register
                                ? AutofillHints.newPassword
                                : AutofillHints.password,
                          ],
                          onFieldSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            labelText: l10n.loginPassword,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              tooltip: _obscure
                                  ? l10n.loginShowPassword
                                  : l10n.loginHidePassword,
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                          validator: validators.password,
                        ),
                        if (!register)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: state.submitting
                                  ? null
                                  : _forgotPassword,
                              child: Text(l10n.loginForgot),
                            ),
                          )
                        else
                          const SizedBox(height: 10),
                        const SizedBox(height: 14),
                        FilledButton(
                          onPressed: state.submitting ? null : _submit,
                          child: state.submitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  register
                                      ? l10n.loginCreateButton
                                      : l10n.loginSignIn,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
