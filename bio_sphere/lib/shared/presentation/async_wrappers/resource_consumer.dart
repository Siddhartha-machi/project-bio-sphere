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
import 'package:bio_sphere/shared/presentation/fallbacks/no_data_fallback.dart';

class ResourceConsumer<T extends IDataModel> extends ConsumerStatefulWidget {
  final Widget Function(ResourceState<T> state, ResourceNotifier<T> notifier)
  builder;
  final FutureOr<void> Function(WidgetRef ref, ResourceNotifier<T> notifier)?
  onInit;

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
      await widget.onInit!(ref, providerNotifier);
    } catch (e, st) {
      /// keep debug printing but don't crash the UI
      debugPrint("ResourceConsumer onInit error: $e\n$st");
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final notifier = ref.read(_provider.notifier);

    if (state.isLoading) {
      return Column(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Loaders.appLoader(size: 40, Theme.of(context).colorScheme.primary),
          TextUI('Loading $T data...', color: Theme.of(context).primaryColor),
        ],
      );
    } else if (state.error != null) {
      return ErrorFallback(message: state.error!);
    } else if (state.list?.isNotEmpty == true || state.data != null) {
      return widget.builder(state, notifier);
    } else {
      return NoDataFallback(message: "No $T data available");
    }
  }
}
