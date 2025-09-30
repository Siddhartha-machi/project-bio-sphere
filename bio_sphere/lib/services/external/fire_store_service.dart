import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bio_sphere/models/interfaces/i_data_model.dart';
import 'package:bio_sphere/constants/api_service_constants.dart';
import 'package:bio_sphere/services/external/i_external_service.dart';
import 'package:bio_sphere/models/service_models/external/backend_service_models.dart';

/* 
|------------------------------|
  FirestoreService
    - Fallback centralized API-like wrapper for Firestore.
    - Exposes `request` which returns BackendResponse (success/error + pagination)
    - Supports simple cursor-based pagination via `limit` and `startAfter` queryParams
    - Performs connectivity check before queries and maps Firebase errors to BackendError
|------------------------------|
*/

class FirestoreService<T extends IDataModel> extends IExternalService<T> {
  final String collectionPath;

  final FirebaseFirestore _db;

  FirestoreService(this.collectionPath) : _db = FirebaseFirestore.instance;

  /// Central request method
  /// - method: use HttpMethod.get / post / put / delete
  /// - docId: optional document id (for single-doc operations)
  /// - data: payload for create/update
  /// - queryParams
  @override
  Future<BackendResponse> request({
    String path = '',
    Map<String, dynamic>? data,
    String method = HttpMethod.get,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      /// Route to the correct operation
      switch (method) {
        case HttpMethod.get:
          return await _getItemOrList(queryParams);
        case HttpMethod.post:
          return await _createItem(queryParams);
        case HttpMethod.put:
          return await _updateItem(queryParams);
        case HttpMethod.delete:
          return await _deleteItem(queryParams);
        default:
          return BackendResponse.error(
            BackendError(
              code: 'UNSUPPORTED_METHOD',
              message: 'Unsupported method $method',
            ),
          );
      }
    } on FirebaseException catch (fe) {
      return BackendResponse.error(_mapFirebaseError(fe));
    } catch (e) {
      return BackendResponse.error(
        BackendError(raw: e, code: 'UNKNOWN', message: e.toString()),
      );
    }
  }

  /// Convenience helpers
  String? _extractId(Map<String, dynamic>? qp) => qp?['id'];

  /// CRUD methods
  Future<BackendResponse> _getItemOrList(Map<String, dynamic>? qp) async {
    final docId = _extractId(qp);

    /// If doc id is present, do get item operation
    if (docId != null) {
      final docSnap = await _db.collection(collectionPath).doc(docId).get();

      if (!docSnap.exists) {
        return BackendResponse.error(
          BackendError(
            statusCode: 404,
            code: 'NOT_FOUND',
            message: 'Document not found',
          ),
        );
      }

      final result = {...docSnap.data()!, 'id': docSnap.id};

      return BackendResponse.success(result);
    } else {
      final startAfterId = qp?['startAfter'] as String?;
      final filters = qp?['filters'] as Map<String, dynamic>?;
      final limit = (qp?['limit'] is int) ? qp!['limit'] as int : 10;

      // Build a typed query that returns Map<String, dynamic> and includes the doc id
      Query<Map<String, dynamic>> q = _db
          .collection(collectionPath)
          .withConverter<Map<String, dynamic>>(
            // for each document snapshot, include its id in the resulting map
            fromFirestore: (snap, _) => {...snap.data()!, 'id': snap.id},
            // toFirestore is unused for reads; provide an empty implementation
            toFirestore: (_, __) => {},
          );

      // Apply simple equality filters if provided
      if (filters != null) {
        // Each entry becomes a `where(field, isEqualTo: value)` clause
        filters.forEach((k, v) {
          q = q.where(k, isEqualTo: v);
        });
      }

      // Ordering: supports 'orderBy' field and 'orderDesc' boolean
      if (qp?['orderBy'] is String) {
        final orderBy = qp!['orderBy'] as String;
        final descending = (qp['orderDesc'] as bool?) ?? false;

        // Apply orderBy; descending controls direction
        q = q.orderBy(orderBy, descending: descending);
      }

      // Apply page size limit
      q = q.limit(limit);

      // Cursor based pagination via startAfter document id
      if (startAfterId != null) {
        // Resolve the document referenced by startAfterId so we can startAfterDocument(...)
        final startDoc = await _db
            .collection(collectionPath)
            .doc(startAfterId)
            .get();

        // Only use the startAfterDocument if the referenced doc exists; otherwise ignore
        if (startDoc.exists) q = q.startAfterDocument(startDoc);
      }

      // Execute the query and map results to plain maps (converter already injects id)
      final snapshot = await q.get();
      final items = snapshot.docs.map((d) => d.data()).toList();

      // Build pagination metadata (nextCursor, hasMore) from the snapshot and applied limit
      final pagination = _extractPaginationFromSnapshot(snapshot, limit);

      return BackendResponse.success(items, pagination: pagination);
    }
  }

  Future<BackendResponse> _createItem(Map<String, dynamic>? data) async {
    if (data == null || data.isEmpty) {
      return BackendResponse.error(
        BackendError(
          code: 'INVALID_REQUEST',
          message: 'Payload required for create operation.',
        ),
      );
    }

    final ref = await _db.collection(collectionPath).add(data);
    final doc = await ref.get();

    return BackendResponse.success({...doc.data()!, 'id': doc.id});
  }

  Future<BackendResponse> _updateItem(Map<String, dynamic>? data) async {
    final docId = _extractId(data);

    if (docId == null || data == null || data.isEmpty) {
      return BackendResponse.error(
        BackendError(
          code: 'INVALID_REQUEST',
          message: 'Document data is required for update operation.',
        ),
      );
    }

    await _db.collection(collectionPath).doc(docId).update(data);
    final updated = await _db.collection(collectionPath).doc(docId).get();

    return BackendResponse.success({...updated.data()!, 'id': updated.id});
  }

  Future<BackendResponse> _deleteItem(Map<String, dynamic>? qp) async {
    final docId = _extractId(qp);

    if (docId == null) {
      return BackendResponse.error(
        BackendError(
          statusCode: null,
          code: 'INVALID_REQUEST',
          message: 'docId required for delete operations',
          raw: null,
        ),
      );
    }

    await _db.collection(collectionPath).doc(docId).delete();

    return BackendResponse.success(null);
  }

  BackendPagination? _extractPaginationFromSnapshot(
    QuerySnapshot<Map<String, dynamic>> snapshot,
    int? limit,
  ) {
    try {
      if (limit == null) return null;
      final docs = snapshot.docs;
      final hasMore = docs.length == limit;
      final nextCursor = hasMore ? docs.last.id : null;
      return BackendPagination(nextCursor: nextCursor, hasMore: hasMore);
    } catch (_) {
      return null;
    }
  }

  BackendError _mapFirebaseError(FirebaseException e) {
    return BackendError(
      statusCode: null,
      code: e.code,
      message: e.message ?? 'Firestore error',
      raw: e,
    );
  }
}
