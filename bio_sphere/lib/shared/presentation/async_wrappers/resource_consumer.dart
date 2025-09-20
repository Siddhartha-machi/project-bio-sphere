import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bio_sphere/state/notifier_root.dart';
import 'package:bio_sphere/models/interfaces/i_data_model.dart';
import 'package:bio_sphere/state/state_defs/resource_state.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/state/notifiers/resource_notifier.dart';
import 'package:bio_sphere/shared/presentation/ui_feedback/loaders.dart';
import 'package:bio_sphere/state/notifiers/resource_registry_notifier.dart';
import 'package:bio_sphere/shared/presentation/fallbacks/error_fallback.dart';

class ResourceConsumer<T extends IDataModel> extends ConsumerStatefulWidget {
  final Widget Function(ResourceState<T> state, ResourceNotifier<T> notifier)
  builder;
  final FutureOr<void> Function(ResourceNotifier<T> notifier)? onInit;

  const ResourceConsumer({super.key, this.onInit, required this.builder})
    : assert(
        T != IDataModel,
        'A model type that extends IDataModel must be provided.',
      );

  @override
  ConsumerState<ResourceConsumer<T>> createState() =>
      _ResourceConsumerState<T>();
}

class _ResourceConsumerState<T extends IDataModel>
    extends ConsumerState<ResourceConsumer<T>> {
  /// cache the provider instance so we don't call registry.use() multiple times
  late final ResourceProviderType<T> _provider;

  @override
  void initState() {
    super.initState();
    final registry = ref.read(Providers.resourceRegistryProvider);
    _provider = registry.use<T>();

    WidgetsBinding.instance.addPostFrameCallback((_) => _initFetch());
  }

  Future<void> _initFetch() async {
    final providerNotifier = ref.read(_provider.notifier);
    if (widget.onInit == null) return;

    try {
      await widget.onInit!(providerNotifier);
    } catch (e, st) {
      /// keep debug printing but don't crash the UI
      debugPrint("ResourceConsumer onInit error: $e\n$st");
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final theme = Theme.of(context).colorScheme;
    final notifier = ref.read(_provider.notifier);
    Widget child;

    if (state.error != null) {
      child = ErrorFallback(message: state.error!);
    } else if (state.list != null || state.data != null) {
      child = widget.builder(state, notifier);
    } else {
      child = const SizedBox.shrink();
    }

    return Column(
      children: [
        Expanded(child: child),

        if (state.isLoading)
          Container(
            width: double.infinity,
            color: theme.onPrimary.withAlpha(60),
            padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
            child: Row(
              spacing: 12,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Loaders.spinner(theme.primary),
                TextUI('Loading $T data...', color: theme.primary),
              ],
            ),
          ),
      ],
    );
  }
}
